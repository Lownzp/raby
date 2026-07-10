# Raby Preview Design Spec

本文档集用于把 8 张 GPT 预览图收敛为可开发、可验收的 UI 规格。当前阶段先定页面、组件、素材和还原规则，再进入 Flutter 开发。

## 预览图范围

| 页面 | 来源 | 用途 |
| --- | --- | --- |
| 首页 | [01-home.png](previews/01-home.png) | 确定整体风格、主视觉卡、快捷入口、动态列表、底部 Tab |
| 记体重 | [02-weight-edit.png](previews/02-weight-edit.png) | 确定数值输入、日期选择、备注、保存动作 |
| 写日记 | [03-diary-edit.png](previews/03-diary-edit.png) | 确定长文本、照片上传、状态标签、草稿和保存 |
| 我的 | [04-profile.png](previews/04-profile.png) | 确定个人中心、宠物资料卡、统计卡、设置列表 |
| 日记详情 | [05-diary-detail.png](previews/05-diary-detail.png) | 确定图文详情、多图排版、状态摘要、后续动作 |
| 体重趋势 | [06-weight-trend.png](previews/06-weight-trend.png) | 确定图表、周期筛选、统计摘要、记录明细 |
| 建档/首次使用 | [07-onboarding.png](previews/07-onboarding.png) | 确定首次流程、档案表单、无 Tab 的启动体验 |
| 照片相册 | [08-album.png](previews/08-album.png) | 确定相册入口、分类筛选、三列照片网格 |

## 核心方向

Raby 是一个温暖、轻量、可爱但不幼稚的宠物兔记录 App。视觉重点是「真实兔子照片 + 柔软奶油卡片 + 少量重点贴纸」，而不是大量碎装饰。

必须保留：

- 暖白到奶油黄的背景。
- 真实白色垂耳兔照片作为主视觉。
- 深棕色标题和正文，橙黄色作为主行动色。
- 大圆角卡片、柔和阴影、浅描边。
- 贴纸感插画，但只作为重点物件。
- 底部 3 Tab：`首页`、`体重`、`我的`。

必须克制：

- 小星星、小爱心、碎花等装饰每页最多 0-2 处。
- 每页重点贴纸最多 1-3 个。
- 功能图标使用统一线性图标，不贴纸化。
- 列表页和设置页减少装饰，优先清晰可扫读。

## 文档索引

- [01-page-spec.md](01-page-spec.md)：逐页页面结构和状态。
- [02-component-system.md](02-component-system.md)：通用组件库和组件规则。
- [03-asset-plan.md](03-asset-plan.md)：图片、贴纸、图标、图表素材策略。
- [04-implementation-handoff.md](04-implementation-handoff.md)：开发顺序、验收标准和截图 QA。
- [05-development-checklist.md](05-development-checklist.md)：进入实现时使用的任务清单和验收勾选项。

## 当前决策

1. 预览图已足够进入开发前规格固化，不再继续扩散生成页面。
2. 开发时先做组件系统，再逐页还原。
3. 以首页、记体重、写日记、我的、趋势作为第一轮高保真页面。
4. 相册、日记详情、建档作为第二轮补齐页面。
5. 设置、搜索、宠物资料编辑、通知设置从组件系统推导，不再单独生成预览图。

## 预览图归档规则

预览图只从 Raby 项目内或本对话中用户明确指定的 Raby 文件导入，不能引用其他项目目录。

推荐归档目录：

```text
docs/design/raby-preview-spec/previews/
```

推荐命名：

```text
01-home.png
02-weight-edit.png
03-diary-edit.png
04-profile.png
05-diary-detail.png
06-weight-trend.png
07-onboarding.png
08-album.png
```

当前已生成总览图：

[preview-contact-sheet.png](previews/preview-contact-sheet.png)
