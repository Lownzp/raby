# Raby 技术文档选题分析

## 主题

Raby：一个本地优先的兔兔档案 Flutter App 如何组织产品闭环、分层架构与本地数据。

## 目标受众

- 即将接手 Raby 的 Flutter / Dart 开发者
- 需要评审项目可维护性的技术负责人
- 关心 MVP 边界、数据安全和长期演进的产品同学

默认分享时长：30-45 分钟。

## 核心概念

1. 本地优先：核心记录、照片、体重数据不依赖网络，存放在 App 私有目录和 SQLite 中。
2. Feature-first：以 `features/*` 承载用户可见功能，用 `application` 和 `presentation` 分离状态命令与界面。
3. 纯 Domain 边界：业务对象、Repository 接口和校验异常不依赖 Flutter、Riverpod、Drift。
4. Repository 隔离：UI 只看领域接口，Drift row、DAO、Companion 不穿透到页面。
5. 数据可演进：UUID、软删除、`updatedAt`、相对媒体路径为导入导出、多兔、未来同步预留空间。

## 项目定位

Raby 的 MVP 不是完整宠物医疗系统，也不是社交产品，而是一个可长期自用的个人兔子档案应用。v0.1 的最小闭环是：

创建兔子档案 -> 写日记和照片 -> 打标签 -> 记录体重 -> 查看时间轴和体重趋势。

## 关键取舍

- 不上账号和云同步，先保证无网络可用和本地数据可信。
- 不引入过重 UseCase 层，简单读取用 Riverpod Provider，复杂命令用小型 Controller。
- 不把媒体文件写进数据库，数据库只保存相对路径和元数据。
- v0.1 支持单只兔默认体验，但数据模型保留多兔关系。

## 3-5 个关键收获

1. 一个小型 App 也需要清晰依赖方向，否则 UI、数据库和业务规则会迅速缠在一起。
2. Drift/SQLite 的实现细节应该留在 Data 层，页面只消费 Domain 实体。
3. 本地优先不是只建一张表，而是要提前设计 ID、时间、软删除和媒体路径。
4. Riverpod 在这里主要承担状态和依赖装配，不应该变成业务规则散落的地方。
5. 好的 MVP 架构不是“做全”，而是给后续导入导出、多兔和同步留下明确接口。

## 现有参考材料

- `README.md`
- `docs/superpowers/specs/2026-06-08-raby-mvp-prd.md`
- `docs/superpowers/specs/2026-06-08-raby-v0.1-data-model.md`
- `docs/superpowers/specs/2026-06-08-raby-v0.1-interaction-flows.md`
- `docs/superpowers/specs/2026-06-09-raby-v0.1-architecture-design.md`
- `docs/architecture/raby-architecture-svg-deck.html`
- `docs/architecture/raby-architecture-infographic.html`
