# Raby 预览页面验收记录

验收日期：2026-07-17

## 完成范围

除首页外的 7 个预览页面均已延续首页的配色、圆角、字体和 Lucide 图标体系完成开发。页面优先使用 Flutter/Material 与现有成熟组件，预制图片使用 `RabyImageSlot` 空白槽位，用户实际选择的头像和日记照片仍正常显示。

| 页面 | 提交 | 430 主验收图 | 390 / 360 验证 |
| --- | --- | --- | --- |
| 记体重 | `05f7268` | `docs/prototypes/screenshots/raby-weight-edit.png` | 通过 |
| 写日记 | `7a4ccfb` | `docs/prototypes/screenshots/raby-diary-edit.png` | 通过 |
| 体重趋势 | `4e9270e` | `docs/prototypes/screenshots/raby-weight.png` | 通过 |
| 日记详情 | `d8d3faa` | `docs/prototypes/screenshots/raby-diary-detail.png` | 通过 |
| 照片相册 | `8eb63d3` | `docs/prototypes/screenshots/raby-album.png` | 通过 |
| 我的 | `3fddd78` | `docs/prototypes/screenshots/raby-profile.png` | 通过 |
| 首次建档 | `00ef8bf` | `docs/prototypes/screenshots/raby-onboarding.png` | 通过 |

共享组件、主题和占位素材基础提交：`5fbbf0e`。

## 功能验证

- `flutter analyze --no-pub`：通过，0 个问题。
- `flutter test --no-pub`：通过，共 52 条测试。
- `verify-pubspec-assets.ps1 -RequireTracked`：通过，24 个声明资源均存在且已被 Git 跟踪。
- 日记草稿临时进入体重页后返回：内容保留。
- 体重趋势 7 / 30 / 90 天及全部筛选：通过。
- 日记详情编辑、删除、看图返回：通过。
- 相册分类空态、恢复全部、看图返回：通过。
- 建档初始体重持久化及 1-20000g 边界校验：通过。

## APK

- 构建命令：`flutter build apk --release --no-pub`
- 本机路径：`build/app/outputs/flutter-apk/app-release.apk`
- 文件大小：85.93 MB（90,106,235 bytes）
- SHA-256：`C055EA855C3EBAE8392EF0628638D6ABEB6D9A43134DA1A429ABF27AC1CA59F5`
- 安装目标：`Raby_QA_API_36`（`emulator-5554`）
- 安装、冷启动和 release 截图：通过；未发现 `FATAL EXCEPTION`。
- 当前 release 使用 Android 工程已有的 debug 签名，仅用于内部验收。正式分发前需要配置发布 keystore。

## 另一台电脑

```powershell
git pull origin main
$env:PUB_HOSTED_URL='https://pub.flutter-io.cn'
$env:FLUTTER_STORAGE_BASE_URL='https://storage.flutter-io.cn'
flutter pub get
flutter run
```

重新打包：

```powershell
flutter build apk --release --no-pub
```

待替换图片槽位见 `docs/design/raby-preview-spec/pending-assets.md`。替换时保持槽位比例、圆角和外层约束不变。

## 明早确认

1. “心情”目前是视觉分类，映射为 `category-mood`；现有数据模型没有独立日记分类字段，也没有内置心情标签。请确认是新增系统标签，还是新增独立分类字段。
2. 体重趋势没有品种健康区间数据，因此页面使用“变化平缓 / 变化明显”，没有直接声称“健康范围”。请确认后续是否建立品种与年龄段的健康阈值模型。
3. 原 `Raby_API_36` 的 Quick Boot 快照损坏，未擦除以保留原模拟器和讯飞输入法；本轮另建 `Raby_QA_API_36` 完成验证。若继续使用新模拟器，需要单独安装中文输入法。
4. 预制主视觉、主人头像、装饰插图和演示照片仍是空白槽位，等统一素材到位后一次替换。
