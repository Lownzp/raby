# Draft A：深技术版

## 开场

Raby 是一个 Flutter 本地优先兔子档案 App。它的需求表面很轻：建档、写日记、加照片、记体重。但从工程角度看，它很快会遇到几个硬问题：本地数据如何长期可信，媒体文件如何和数据库保持一致，未来多兔、导入导出、同步如何不推翻重来。

这版文档关注实现边界：代码依赖、Domain 纯度、Drift 隔离、事务写入和本地文件策略。

## 1. 分层结构

当前代码分为五个主要区域：

```text
lib/
├── app/
├── data/
├── domain/
├── features/
└── shared/
```

`app` 负责应用装配，包含 `MaterialApp.router`、go_router 路由表、主题和全局 Provider。

`features` 按用户功能组织，例如 `records`、`weight`、`rabbits`、`startup`、`profile`、`settings`。每个 feature 内部继续拆成 `presentation` 和 `application`。

`domain` 是纯 Dart 业务层，放模型、枚举、Repository 接口和业务异常。

`data` 是基础设施层，包含 Drift 数据库、DAO、Repository 实现、row mapper 和媒体文件服务。

`shared` 只放跨功能复用 UI，不承载业务流程。

## 2. 依赖方向

Raby 的关键不是目录本身，而是依赖方向。

推荐方向：

```text
features/presentation -> features/application
features/application -> domain
app/providers -> data/repositories
data/repositories -> domain
```

禁止方向：

```text
domain -> flutter / riverpod / drift
features/presentation -> data/database
data -> features
```

这条边界的价值在于：页面可以改，数据库实现可以改，但业务对象和业务接口不被框架细节污染。

## 3. Provider 装配

依赖装配集中在 `lib/app/providers/repository_providers.dart`：

```dart
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  return DriftDiaryRepository(
    ref.watch(appDatabaseProvider),
    uuid: ref.watch(uuidProvider),
  );
});
```

页面和 Controller 依赖的是 `DiaryRepository`、`RabbitRepository` 这样的领域接口，而不是 Drift DAO。这让测试替换、未来同步实现和导入导出服务都有空间。

## 4. Drift 数据库

`AppDatabase` 使用 Drift 管理六张核心表：

- `rabbits`
- `diaries`
- `diary_media`
- `tags`
- `diary_tags`
- `weight_records`

schema version 当前为 1。建库时创建索引，打开数据库时启用外键：

```dart
@override
MigrationStrategy get migration => MigrationStrategy(
  beforeOpen: (details) async {
    await customStatement('PRAGMA foreign_keys = ON;');
  },
  onCreate: (m) async {
    await m.createAll();
    await _createIndexes();
  },
);
```

索引围绕常用查询设计，例如日记时间线按 `rabbit_id` 和 `recorded_at` 查询，体重趋势按 `rabbit_id` 和 `recorded_at` 查询。

## 5. 日记保存链路

日记保存是当前项目最能说明架构价值的流程。

页面收集输入后交给 `DiaryEditorController`。Controller 负责：

1. 修剪正文
2. 校验正文和照片至少有一个
3. 限制单条日记最多 9 张照片
4. 生成 UUID 和时间戳
5. 复制本地图片到 App 私有目录
6. 构造 Domain 实体
7. 调用 Repository 事务写入
8. 失败时清理已经复制的媒体文件

核心规则在应用层，而不是散落在按钮回调里：

```dart
void _validateContentAndMedia({
  required String? content,
  required List<DiaryMediaDraft> mediaDrafts,
}) {
  if (content == null && mediaDrafts.isEmpty) {
    throw const DomainValidationException('日记正文和照片至少需要一个');
  }
  if (mediaDrafts.length > 9) {
    throw const DomainValidationException('单条日记最多支持 9 张照片');
  }
}
```

## 6. 本地优先的数据策略

所有业务主表使用 UUID v4，不使用自增 ID。所有主表保留：

- `createdAt`
- `updatedAt`
- `deletedAt`

这不是过度设计，而是为 v0.2/v1.0 的导入导出、覆盖恢复、基础合并和未来同步预留条件。

媒体文件不进入 SQLite。数据库只保存相对路径，例如：

```text
media/diaries/{diaryId}/{mediaId}.jpg
media/rabbits/{rabbitId}/avatar/{mediaId}.jpg
```

这样可以降低数据库体积，也让 ZIP 导出更直接：数据库、媒体目录、manifest 元数据可以分开打包。

## 7. 技术结论

Raby 的架构适合它当前的规模：没有重型 UseCase 层，没有复杂状态机，但已经守住了三条关键边界：

1. UI 不触碰 Drift。
2. Domain 不依赖 Flutter。
3. 本地文件和数据库通过应用层命令保持一致。

这三条边界会决定 Raby 能否从 v0.1 的可记录内测版，顺滑演进到带导入导出、多兔和迁移策略的 v1.0。
