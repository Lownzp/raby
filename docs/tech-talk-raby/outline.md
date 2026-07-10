# Raby 技术文档提纲

## 开场 Hook

养兔记录看起来像一个温柔的小需求：写日记、存照片、记体重。但一旦用户真的长期使用，问题会变成工程问题：照片不能丢，体重趋势要可信，换手机要能迁移，未来多只兔不能串档。Raby 的架构目标，就是让这个“生活记录 App”从第一版开始具备长期生长的骨架。

## 主线结构

### 1. 产品边界：先做可记录内测版

- 目标用户：家里养 1-5 只宠物兔的个人用户
- v0.1 闭环：建档、日记、照片、标签、体重、图表
- 明确不做：账号、云同步、社交、完整医疗管理
- 成功标准：无网络可用，退出重进数据不丢，删除/编辑不留下脏展示

### 2. 代码结构：Feature-first + 清晰依赖方向

- `app`：路由、主题、依赖装配
- `features`：页面、表单、Controller、局部 Provider
- `domain`：实体、枚举、Repository 接口、业务异常
- `data`：Drift 数据库、DAO、Repository 实现、媒体文件服务
- `shared`：跨页面复用 UI

### 3. 本地数据：SQLite 保存事实，私有目录保存媒体

- 主表使用 UUID v4
- `createdAt`、`updatedAt`、`deletedAt` 支持同步和软删除
- 日期和时间分开处理，避免时区陷阱
- 媒体文件放 App 私有目录，数据库只保存相对路径
- 核心表：`rabbits`、`diaries`、`diary_media`、`tags`、`diary_tags`、`weight_records`

### 4. 关键流程：从页面输入到事务写入

- 启动：seed 系统标签 -> 判断默认兔 -> 跳转 onboarding 或记录页
- 写日记：校验 -> 复制媒体 -> 构造 Domain -> 事务写入日记、媒体、标签连接
- 体重：按兔输出记录列表和图表数据
- 图片浏览：页面只拿展示参数，不直接触碰存储细节

### 5. 工程护栏：让小项目不失控

- Domain 不 import Flutter/Riverpod/Drift
- Presentation 不 import DAO/Table/Companion
- Data 不依赖 Features
- Repository 不处理导航
- 表单级校验和跨字段业务校验分层处理

### 6. 下一步演进

- v0.2：热力图、大事记、体重异常、提醒、ZIP 导出
- v1.0：多兔管理、ZIP 导入、迁移策略、基础日志、关键流程集成测试
- 风险重点：导入合并、媒体文件丢失、软删除冲突、数据库迁移

## 需要展示的代码例子

- `lib/main.dart`：ProviderScope 启动
- `lib/app/raby_app.dart`：`MaterialApp.router`
- `lib/app/providers/repository_providers.dart`：依赖装配
- `lib/features/startup/application/startup_controller.dart`：启动决策
- `lib/features/records/application/diary_editor_controller.dart`：日记保存命令
- `lib/data/database/app_database.dart`：Drift schema、索引、事务

## 实用收尾

用一句话总结：Raby 的当前架构不追求“企业级复杂”，它追求的是在 MVP 阶段就守住数据边界、业务边界和未来演进边界。
