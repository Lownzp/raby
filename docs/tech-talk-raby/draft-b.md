# Draft B：平衡版

## 开场

Raby 的目标很朴素：帮养兔用户长期记录一只兔子的档案、日记、照片和体重。真正难的地方不在“做几个页面”，而在于这些记录会变成用户真实的生活资产。

所以 Raby 的 v0.1 选择了本地优先：没有账号、没有云同步、没有社交 feed，先把可记录、可回看、可长期演进的基础打稳。

## 1. 产品闭环

v0.1 的核心闭环是：

```text
创建兔子档案 -> 写日记和照片 -> 打标签 -> 记录体重 -> 查看时间轴和趋势
```

这条闭环决定了当前代码里最重要的几个模块：

- `rabbits`：兔子档案
- `records`：日记、照片、标签、时间轴
- `weight`：体重录入、列表和图表
- `startup`：初始化和首次建档判断
- `profile/settings`：档案和设置入口

## 2. 架构分层

项目采用轻量分层：

```text
app      应用装配：路由、主题、全局 Provider
features 用户功能：页面、表单、Controller、局部状态
domain   业务模型：实体、枚举、Repository 接口、业务异常
data     本地实现：Drift、SQLite、Repository 实现、媒体文件
shared   跨页面 UI：卡片、壳、头像、状态组件
```

这个结构的核心目标不是“看起来专业”，而是避免几个常见失控点：

- 页面直接操作数据库
- 数据库 row 穿透到 UI
- 业务规则散落在 `onPressed`
- 媒体文件复制和数据库写入没有统一失败处理

## 3. 状态和依赖

Raby 使用 Riverpod 做状态管理和依赖装配。启动入口很薄：

```dart
void main() {
  runApp(const ProviderScope(child: RabyApp()));
}
```

`RabyApp` 负责创建 `MaterialApp.router`，路由由 go_router 管理。Repository 和服务通过 `app/providers` 装配：

```dart
final rabbitRepositoryProvider = Provider<RabbitRepository>((ref) {
  return DriftRabbitRepository(ref.watch(appDatabaseProvider));
});
```

这种写法让页面只关心“我要一个兔子仓库”，不关心它背后是 Drift、SQLite，还是未来某种同步仓库。

## 4. 数据模型

Raby 当前的本地数据围绕六张表：

- `rabbits`
- `diaries`
- `diary_media`
- `tags`
- `diary_tags`
- `weight_records`

所有业务主表都使用 UUID v4，并保留 `createdAt`、`updatedAt`、`deletedAt`。这让项目从第一版开始就能支持软删除、导入导出和未来冲突合并。

照片不直接进数据库。数据库保存相对路径，文件放在 App 私有目录。这样既能保持数据库轻量，也能让导出 ZIP 时结构更清楚。

## 5. 关键流程：写日记

写日记流程体现了这套架构的协作方式：

1. 页面收集正文、时间、标签、照片草稿。
2. `DiaryEditorController` 做跨字段校验。
3. Controller 生成 `diaryId`、`mediaId` 和时间戳。
4. `MediaStorageService` 把图片复制到私有目录。
5. Controller 构造 `Diary` 和 `DiaryMedia`。
6. `DiaryRepository` 用事务写入 `diaries`、`diary_media`、`diary_tags`。
7. 如果中途失败，Controller 清理已复制的媒体文件。

这个流程有一个很重要的边界：页面不直接知道 Drift，也不直接处理媒体复制。

## 6. 关键流程：启动

启动页做两件事：

1. 调用 `TagRepository.ensureSystemTagsSeeded()` 初始化系统标签。
2. 调用 `RabbitRepository.getDefaultRabbit()` 判断是否已有未删除兔子。

如果没有兔子，进入首次建档；如果已有兔子，进入记录页。

```dart
final startupProvider = FutureProvider<StartupDestination>((ref) async {
  await ref.watch(tagRepositoryProvider).ensureSystemTagsSeeded();
  final rabbit = await ref.watch(rabbitRepositoryProvider).getDefaultRabbit();
  return rabbit == null
      ? StartupDestination.onboarding
      : StartupDestination.records;
});
```

## 7. 当前状态和下一步

当前项目已经形成 v0.1 的主要骨架：Flutter 工程、路由、主题、Drift 数据库、Repository、日记、兔子档案、体重和基础测试。

后续 v0.2/v1.0 会继续向长期使用能力演进：

- 记录热力图
- 兔生大事记
- 体重异常提示
- ZIP 导出/导入
- 多兔管理
- 数据库迁移
- 关键流程集成测试

## 结尾

Raby 的技术重点不是炫技，而是“克制地把边界立住”。它是一套适合小型本地优先 App 的架构：足够简单，能快速迭代；也足够清楚，不会在数据和业务变复杂后立刻崩掉。
