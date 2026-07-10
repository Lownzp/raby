# Asset Plan

## 素材原则

Raby 的素材分为真实照片、贴纸插画、功能图标、图表绘制和空状态插画。开发时必须分层管理，避免把所有视觉元素都做成贴纸。

## 真实兔子照片

用途：

- 首页主视觉。
- 宠物头像。
- 最近动态缩略图。
- 日记详情图片。
- 相册网格。

要求：

- 真实白色垂耳兔照片优先。
- 光线温暖、柔和、清晰。
- 避免强 AI 感、塑料感、过度磨皮。
- 相册图片可以有不同姿态和场景，但色温要接近。

建议数量：

- 首批至少 8-12 张。
- 首页主视觉 1 张。
- 头像 1 张。
- 动态/详情/相册共用 6-10 张。

裁切规则：

- 头像：1:1，主体居中，脸部完整。
- 首页主图：横向或方图裁切，兔子脸部不可被卡片遮挡。
- 相册缩略图：1:1 或 4:5，统一圆角。
- 详情拼贴：1 张大图 + 2 张小图，裁切比例保持一致。

## 贴纸插画

用途：

- 建立品牌记忆点。
- 辅助表达记录场景。
- 空状态引导。

首批贴纸清单：

| 贴纸 | 用途 | 使用页面 |
| --- | --- | --- |
| 胡萝卜 | 宠物、饮食、建档辅助 | 首页、建档、我的 |
| 体重秤 | 体重记录、趋势 | 记体重、体重趋势、首页快捷入口 |
| 日记本 | 日记记录 | 首页快捷入口、写日记、详情 |
| 相机 | 相册、上传照片 | 相册、写日记 |
| 小兔头像 | 头像占位、空状态 | 建档、空状态 |
| 花朵 | 温柔装饰 | 我的、详情 |
| 叶子 | 健康、自然状态 | 趋势、状态标签 |

当前首页试点贴纸已生成并处理为 Flutter 可用 PNG：

| 贴纸 | 开发文件 |
| --- | --- |
| 胡萝卜 | `assets/images/stickers/sticker_carrot.png` |
| 黄色花朵 | `assets/images/stickers/sticker_flower.png` |
| 体重秤 | `assets/images/stickers/sticker_scale.png` |
| 日记本 | `assets/images/stickers/sticker_diary.png` |
| 小爱心 | `assets/images/stickers/sticker_heart.png` |

注意：当前开发素材已替换为无阴影纯色背景版本，并用本地 `rembg` 生成透明 PNG。源图仍不是原生透明 PNG，但 `rembg` 版本保留了更自然的边缘半透明过渡，作为首页试点素材质量更高。线性图标需要在 `rembg` 后额外清理内部镂空区域，否则房子、体重秤、兔脸、搜索、加号、设置等图标内部会残留绿色背景。

## 首页试点完整素材包

首页高保真还原素材已归档：

| 类型 | 文件 |
| --- | --- |
| Logo | `assets/images/brand/logo_raby.png` |
| 首页主图 | `assets/images/rabbits/home/rabbit_home_hero.png` |
| 动态图 1 | `assets/images/rabbits/home/rabbit_timeline_01.png` |
| 动态图 2 | `assets/images/rabbits/home/rabbit_timeline_02.png` |
| 动态图 3 | `assets/images/rabbits/home/rabbit_timeline_03.png` |
| Tab 首页 normal | `assets/images/icons/home/icon_tab_home.png` |
| Tab 首页 active | `assets/images/icons/home/icon_tab_home_active.png` |
| Tab 体重 normal | `assets/images/icons/home/icon_tab_weight.png` |
| Tab 体重 active | `assets/images/icons/home/icon_tab_weight_active.png` |
| Tab 我的 normal | `assets/images/icons/home/icon_tab_profile.png` |
| Tab 我的 active | `assets/images/icons/home/icon_tab_profile_active.png` |
| 搜索图标 | `assets/images/icons/home/icon_search.png` |
| 添加图标 | `assets/images/icons/home/icon_add.png` |
| 设置图标 | `assets/images/icons/home/icon_settings.png` |

本批 logo、图标、贴纸均由纯色背景源图通过本地 `rembg` 抠出为透明 PNG；其中线性图标又做了内部镂空透明修复；兔子照片保留 RGB。

规则：

- 贴纸要有白边、轻阴影、手绘感。
- 贴纸大小分为主贴纸、辅助贴纸两档。
- 主贴纸用于页面视觉锚点。
- 辅助贴纸只在卡片角落使用。
- 禁止把贴纸作为普通列表图标。

## 功能图标

用途：

- 导航。
- 表单操作。
- 列表入口。
- 状态标签。

建议实现：

- 使用统一线性图标库或 Flutter 自绘 Icon。
- 线宽一致。
- 颜色以深棕、浅棕、橙黄为主。
- 选中态可以使用橙黄色底，不改变图标风格。

图标清单：

- home。
- scale。
- rabbit/profile。
- search。
- plus。
- settings。
- back。
- calendar。
- more。
- camera。
- edit。
- heart。
- bell。
- download/export。
- info。
- chevron right。

## 图表素材

体重趋势图不使用图片素材，使用代码绘制。

要求：

- 折线颜色为橙黄色。
- 数据点有白色描边。
- 当前值有气泡标注。
- 网格线低对比。
- 支持 7 天、30 天、90 天、全部四种周期。

## 空状态插画

需要覆盖：

- 无宠物档案。
- 无体重记录。
- 无日记。
- 无照片。
- 搜索无结果。

构成：

- 小兔贴纸或兔子头像。
- 一个功能相关物件：体重秤、日记本、相机。
- 一句说明。
- 一个主动作按钮。

规则：

- 空状态要指导下一步。
- 不使用大面积复杂插画。
- 不加过多碎装饰。

## 素材落地建议

Flutter 工程建议目录：

```text
assets/
  images/
    rabbits/
    stickers/
    empty_states/
```

命名建议：

```text
rabbit_avatar_nuomi.png
rabbit_hero_nuomi.png
rabbit_album_01.png
sticker_carrot.png
sticker_scale.png
sticker_diary.png
sticker_camera.png
empty_album.png
empty_weight.png
```

## GPT 生成素材注意

如果继续让 GPT 生成独立素材，提示词要强调：

- 透明背景。
- 白色贴纸描边。
- 柔和阴影。
- 不包含文字。
- 单个物件居中。
- 风格参考 Raby 预览图。

不要让 GPT 一次生成整套复杂素材拼图，容易风格不一致。优先逐个物件生成，再人工筛选。
