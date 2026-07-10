# Raby 项目技术文档

> 基于 `tech-talk-writer` skill 生成。默认采用混合稿：故事版开场、平衡版主线、深技术版架构边界。

## 1. 项目一句话

Raby 是一个本地优先的兔兔档案 Flutter App，帮助个人养兔用户在无网络环境下建立兔子档案、记录日记照片、管理标签、记录体重，并通过时间轴和图表回看成长状态。

## 2. 为什么它不是“几个页面”这么简单

Raby 的产品语气很轻：记录兔子的生活。可一旦用户持续使用，这些记录就会变成真实的个人资产。照片不能丢，体重趋势要可信，删除和编辑不能留下脏数据，未来换手机时还要能导出导入。

所以 Raby v0.1 的架构目标不是堆功能，而是在最小闭环里立住几个边界：

- UI 不直接依赖 Drift、SQLite row、数据库表。
- 业务对象和业务规则集中在 Domain 与 Application 层。
- 本地存储实现可以替换或扩展。
- 页面状态、异步操作和错误处理有统一方式。
- 为 v0.2/v1.0 的导入导出、多兔和同步预留空间。

## 3. v0.1 的产品闭环

Raby 当前版本聚焦“可记录内测版”：

```text
创建兔子档案 -> 写日记和照片 -> 打标签 -> 记录体重 -> 查看时间轴和趋势
```

当前必须能力：

- 兔子档案新建、编辑、查看
- 日记新建、编辑、删除、时间轴列表
- 日记支持文本和最多 9 张照片
- 系统标签和自定义标签
- 体重记录新建、编辑、删除、历史列表
- 体重折线图
- 设置页基础入口

明确不做：

- 云同步、账号系统、登录注册
- 社交 feed、关注、点赞、评论
- 完整宠物医疗管理
- 多人协作
- v0.1 阶段的视频、导入导出、热力图和提醒

## 4. 代码结构

当前项目采用 feature-first 的轻量分层：

```text
lib/
├── app/
│   ├── providers/
│   ├── router/
│   └── theme/
├── data/
│   ├── database/
│   ├── media/
│   └── repositories/
├── domain/
│   ├── models/
│   └── repositories/
├── features/
│   ├── profile/
│   ├── rabbits/
│   ├── records/
│   ├── settings/
│   ├── startup/
│   └── weight/
└── shared/
    ├── navigation/
    └── widgets/
```

各层职责：

| 层 | 职责 |
|---|---|
| `app` | `MaterialApp.router`、go_router、主题、Repository Provider、启动装配 |
| `features/*/presentation` | 页面布局、表单、列表、loading/empty/error/success 展示 |
| `features/*/application` | Riverpod Provider、Controller、异步命令、输入到 Domain 的转换 |
| `domain` | 实体、枚举、Repository 接口、业务异常、纯业务规则 |
| `data` | Drift 表/DAO、Repository 实现、mapper、媒体文件服务 |
| `shared` | 跨页面复用的纯 UI 组件 |

## 5. 依赖边界

推荐方向：

```text
app -> features -> domain
app -> data -> domain
features/application -> domain
features/presentation -> features/application + shared + app/router
data -> domain
shared -> app/theme
```

禁止方向：

```text
domain -> flutter / riverpod / drift / app / features / data
features/presentation -> drift / app_database.g.dart / tables
features/presentation -> data/database
data -> features
shared -> features
```

这条边界的意义是：页面可以改，Drift 实现可以换，但 Domain 实体和 Repository 接口保持稳定。

## 6. 应用启动和路由

入口很薄：

```dart
void main() {
  runApp(const ProviderScope(child: RabyApp()));
}
```

`RabyApp` 创建 `MaterialApp.router`，使用 go_router 管理页面：

- `/splash`
- `/onboarding/rabbit`
- `/diaries`
- `/diaries/edit/:id?`
- `/media/photos`
- `/weights`
- `/weights/edit/:id?`
- `/me`
- `/me/rabbit`
- `/me/rabbit/edit`
- `/settings`

启动流程由 `startupProvider` 控制：

```dart
final startupProvider = FutureProvider<StartupDestination>((ref) async {
  await ref.watch(tagRepositoryProvider).ensureSystemTagsSeeded();
  final rabbit = await ref.watch(rabbitRepositoryProvider).getDefaultRabbit();
  return rabbit == null
      ? StartupDestination.onboarding
      : StartupDestination.records;
});
```

这段逻辑表达了 v0.1 的启动约束：先确保系统标签存在，再判断有没有默认兔子，没有就建档，有就进入记录页。

## 7. Repository 装配

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

页面和 Controller 只依赖 `DiaryRepository`、`RabbitRepository`、`TagRepository`、`WeightRepository` 这些领域接口。Drift DAO 和 row 留在 Data 层内部。

## 8. 数据模型

v0.1 核心表：

| 表 | 作用 |
|---|---|
| `rabbits` | 兔子基础档案 |
| `diaries` | 日记主表 |
| `diary_media` | 日记图片和未来视频媒体 |
| `tags` | 系统标签和自定义标签 |
| `diary_tags` | 日记与标签的多对多关系 |
| `weight_records` | 体重记录 |

关键原则：

- 主键使用 UUID v4 字符串。
- 所有业务主表保留 `createdAt`、`updatedAt`、`deletedAt`。
- `deletedAt == null` 表示有效数据。
- 创建、更新、删除时间使用 UTC epoch milliseconds。
- 生日、领养日等纯日期使用 `yyyy-MM-dd` 文本，避免时区偏移。
- 媒体文件放 App 私有目录，数据库只保存相对路径。

媒体路径示例：

```text
media/diaries/{diaryId}/{mediaId}.jpg
media/rabbits/{rabbitId}/avatar/{mediaId}.jpg
```

## 9. 日记保存链路

日记保存是最能说明 Raby 架构的流程：

```text
DiaryEditPage
  -> DiaryEditorController
  -> MediaStorageService
  -> DiaryRepository
  -> Drift DAO transaction
  -> SQLite + App 私有媒体目录
```

Controller 做跨字段业务校验：

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

保存时：

1. 生成 `diaryId`。
2. 修剪正文并校验。
3. 为每张新图片生成 `mediaId`。
4. 调用 `MediaStorageService` 复制图片到私有目录。
5. 构造 `Diary` 和 `DiaryMedia`。
6. 去重 `tagIds`。
7. 调用 `DiaryRepository.createDiary` 或 `updateDiary`。
8. Repository 内部用事务写入日记、媒体和标签连接。
9. 如果失败，Controller 尝试清理已经复制的媒体文件。

这个设计避免了页面直接处理数据库和文件系统。

## 10. Drift 与事务

`AppDatabase` 使用 Drift 管理 schema：

```dart
@DriftDatabase(
  tables: [Rabbits, Diaries, DiaryMediaItems, Tags, DiaryTags, WeightRecords],
  daos: [RabbitDao, DiaryDao, TagDao, WeightDao],
)
class AppDatabase extends _$AppDatabase {
  @override
  int get schemaVersion => 1;
}
```

建库时创建索引，打开时启用外键：

```dart
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

常用索引围绕查询路径设计：

- 日记时间线：`rabbit_id`, `recorded_at`
- 体重趋势：`rabbit_id`, `recorded_at`
- 软删除过滤：`deleted_at`
- 同步/导出预留：`updated_at`

## 11. UI 与视觉系统

Raby 的 UI 目标是温柔、轻量、有记录欲。主题集中在 `lib/app/theme`：

- `raby_colors.dart`
- `raby_tokens.dart`
- `raby_theme.dart`

跨页面组件放在 `shared/widgets`：

- `RabyPage`
- `RabyCard`
- `RabyStateCard`
- `RabbitAvatar`
- `RabySketchIcon`

这些组件帮助页面保持一致的视觉语言，同时避免每个 feature 重复写基础 UI。

## 12. 测试和验收

当前项目包含：

- `test/data/database/app_database_test.dart`
- `test/data/repositories/drift_repositories_test.dart`
- `test/features/rabbits/rabbit_form_controller_test.dart`
- `test/features/records/diary_editor_controller_test.dart`
- `test/features/weight/weight_editor_controller_test.dart`

验收命令：

```powershell
. .\tooling\env.ps1
flutter pub get
flutter test
```

发布 APK 脚本：

```powershell
.\tooling\publish-public-apk.ps1 -ReleaseName raby-v0.1.0
```

## 13. 下一步演进

v0.2 重点：

- 记录热力图
- 兔生大事记
- 体重异常提示
- BCS 体况评分
- 自定义提醒
- ZIP 数据导出
- 短视频记录初版

v1.0 重点：

- 多兔档案管理和切换
- ZIP 导入，支持覆盖和基础合并
- 媒体文件丢失和导入失败提示
- 数据库迁移策略
- 基础异常日志
- 关键流程集成测试

## 14. 总结

Raby 是一个温柔的产品，但它背后的工程原则很硬：

- 数据要可信。
- 边界要清楚。
- 失败要能恢复。
- 未来要有余地。

它当前的架构不追求企业级复杂，而是在 MVP 阶段守住最重要的三件事：UI 不碰数据库细节，Domain 不被框架污染，本地数据为长期使用做好准备。
