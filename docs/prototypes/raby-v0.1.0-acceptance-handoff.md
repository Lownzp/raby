# Raby v0.1.0 验收交接

更新时间：2026-07-08 09:10（Asia/Shanghai）

## 当前结论

当前代码已形成 v0.1.0 可验收包，主流程覆盖建档、日记、照片、标签、体重、趋势、搜索、相册、图片预览、档案编辑、删除确认、设置和本地持久化。仍需在真机上按手工脚本完成最终验收。

## 最新产物

- Release APK：`D:\work\proj\raby\build\app\outputs\flutter-apk\app-arm64-v8a-release.apk`
- 本地分发副本：`D:\work\proj\raby\dist\apk\raby-v0.1.0-arm64-release-20260708-090404.apk`
- APK SHA256：`99A41A6CD283C24C32DD08AAFF18BA96CEE352654A9501E11A55CD988BF1DCDF`
- APK 校验文件：`D:\work\proj\raby\dist\apk\raby-v0.1.0-arm64-release-20260708-090404.apk.sha256`
- 验收 Bundle：`D:\work\proj\raby\dist\raby-v0.1.0-acceptance-bundle-20260708-0438.zip`
- Bundle 校验文件：`D:\work\proj\raby\dist\raby-v0.1.0-acceptance-bundle-20260708-0438.zip.sha256`
- 机器可读清单：`D:\work\proj\raby\docs\prototypes\raby-v0.1.0-acceptance-manifest.json`
- 需求覆盖审计：`D:\work\proj\raby\docs\prototypes\raby-v0.1.0-requirement-audit.md`
- 截图总览：`D:\work\proj\raby\docs\prototypes\screenshots\raby-contact-sheet.png`
- 验收 Bundle 内置截图：`screenshots\` 目录包含 14 张单页截图
- 截图样张来源说明：`D:\work\proj\raby\tooling\screenshot_harness\assets\PHOTO_CREDITS.md`
- ADB 安装启动烟测截图：`D:\work\proj\raby\docs\prototypes\screenshots\raby-adb-install-smoke.png`
- 图片浏览页截图：`D:\work\proj\raby\docs\prototypes\screenshots\raby-photo-viewer.png`
- 体重录入页截图：`D:\work\proj\raby\docs\prototypes\screenshots\raby-weight-edit.png`

## 版本一致性

- `pubspec.yaml`：`version: 0.1.0+1`
- `android/local.properties`：`flutter.versionName=0.1.0`，`flutter.versionCode=1`
- 最终 arm64 split APK manifest：`versionName=0.1.0`，`versionCode=2001`
- APK 签名：Android Debug 证书，仅用于内测安装验收，不作为应用商店发布签名
- 设置页显示：`v0.1.0 本地优先内测版`
- 发布脚本默认名：`raby-v0.1.0`

## 自动验证状态

最终守门检查已通过（2026-07-08 09:10，Asia/Shanghai）：

```powershell
. D:\work\proj\raby\tooling\env.ps1; flutter analyze
. D:\work\proj\raby\tooling\env.ps1; flutter test
. D:\work\proj\raby\tooling\env.ps1; flutter build apk --release --target-platform android-arm64 --split-per-abi
```

结果：

- `flutter analyze`：No issues found
- `flutter test`：48/48 passed
- `flutter build apk --release --target-platform android-arm64 --split-per-abi`：成功生成 20.5MB arm64 release APK

验收材料自检：

```powershell
.\tooling\verify-acceptance-artifacts.ps1
```

该脚本会检查 APK、SHA256、验收 Bundle、机器可读清单、截图总览、14 张单页截图、截图样张来源说明、版本号、README 入口和交付脚本清单。

重打验收 Bundle 并自动自检：

```powershell
.\tooling\create-acceptance-bundle.ps1
```

最近一次自检结果（2026-07-08 09:10）：

- Acceptance artifact verification passed
- APK size：21450980 bytes
- SHA256：`99A41A6CD283C24C32DD08AAFF18BA96CEE352654A9501E11A55CD988BF1DCDF`
- APK native-code：`arm64-v8a`
- Screenshots checked：14 + contact sheet

ADB 安装启动烟测（2026-07-08 09:10，Asia/Shanghai）：

- `adb install -r dist\apk\raby-v0.1.0-arm64-release-20260708-090404.apk`：Success
- `adb shell am start -W -n com.raby.raby/.MainActivity`：Status ok，LaunchState COLD，TotalTime 6874ms
- `dumpsys window`：焦点位于 `com.raby.raby/com.raby.raby.MainActivity`
- `logcat`：未发现 Raby `FATAL EXCEPTION` 或 `ANR`
- 启动截图：`raby-adb-install-smoke.png`，进入首次建档页

测试覆盖的关键闭环包括：

- 无兔档案时进入首次建档
- 无兔档案边界下，首页顶部加号会直接进入建档而不是进入空日记编辑器
- 无兔档案边界下，首页快捷卡片不再无响应，会引导建立档案
- 无兔档案边界下，体重页顶部加号会直接进入建档
- 无兔档案边界下，“我的”页不展示假兔兔名字，并提供明确建档入口
- 无兔档案边界下，兔兔档案详情页顶部动作会进入建档而不是编辑空档案
- 无兔档案边界下，编辑档案页提供明确建档入口
- 无兔档案边界下，体重编辑页顶部日期按钮不会打开无意义的日期选择
- 无兔档案边界下，日记详情页不展示假兔兔名字
- 无匹配档案边界下，日记详情页会隐藏编辑入口，并将主操作引导到建档
- 创建兔兔档案后进入记录页
- 日记新建、编辑、删除
- 写日记顶部快捷标签是真实标签入口，不再是静态装饰
- 小屏首页快捷入口保持单行可读，避免窄屏下“记体重 / 写日记”被挤成竖排
- 日记系统标签和里程碑标签选择，并在时间轴展示
- 日记照片选择最多 9 张，超量选择会截断并保留提示
- 图片预览页打开与返回
- 搜索日记并进入结果
- 相册进入图片预览并返回
- 体重新建、编辑、删除
- 体重趋势范围筛选，以及 10 条体重记录的趋势展示
- 数据库文件关闭后重新打开，兔兔、日记、照片路径、标签和体重仍可读取

## 截图覆盖

截图目录：`D:\work\proj\raby\docs\prototypes\screenshots`

截图总览已在 2026-07-08 09:10 由最新单页截图重新生成；首页、日记详情、相册、图片浏览和档案页已使用真实兔兔生活照样张渲染，贴纸/手绘元素控制在图标和空状态层级，不再把小装饰铺满画面。

当前覆盖页面：

- 首页有数据：`raby-home.png`
- 首页空状态：`raby-home-empty.png`
- 体重趋势：`raby-weight.png`
- 体重空状态：`raby-weight-empty.png`
- 体重录入：`raby-weight-edit.png`
- 写日记：`raby-diary-edit.png`
- 日记详情：`raby-diary-detail.png`
- 搜索日记：`raby-search.png`
- 照片相册：`raby-album.png`
- 图片浏览：`raby-photo-viewer.png`
- 我的：`raby-profile.png`
- 设置：`raby-settings.png`
- 首次建档：`raby-onboarding.png`
- 兔兔档案：`raby-rabbit-detail.png`

重新生成单页截图：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File D:\work\proj\raby\tooling\capture-screenshot.ps1 -Page weight-edit -Width 430 -Height 932 -PixelRatio 1
```

重新生成总览图：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File D:\work\proj\raby\tooling\build-screenshot-contact-sheet.ps1
```

## 手工验收脚本

建议真机从清空应用数据开始：

1. 清空本地数据后启动 App。
2. 确认进入首次建档流程。
3. 创建一只兔兔，填写名字、性别、生日或领养日、品种、毛色。
4. 进入记录页空状态。
5. 新建日记，添加正文、2 张照片和至少 1 个标签。
6. 返回时间轴，确认日记倒序出现。
7. 点开照片缩略图，确认进入图片浏览页，并可返回时间轴。
8. 编辑日记正文、日期和标签，确认时间轴更新。
9. 删除日记，确认时间轴不再展示该记录。
10. 进入体重页空状态。
11. 新增多条体重记录，确认列表和折线图展示正确。
12. 编辑其中一条体重记录，确认列表和图表同步更新。
13. 删除其中一条体重记录。
14. 退出 App 后重新进入，确认兔兔档案、日记、照片和体重仍存在。

## 注意事项

- v0.1.0 是本地优先内测版，不包含云同步、导入导出、通知提醒、热力图、视频和多兔完整切换。
- 测试截图环境使用 Unsplash 免费兔兔生活照作为演示样张，来源见 `PHOTO_CREDITS.md`；真机加载到真实图片后会显示用户自己的本地照片。
- 当前工作目录不是 git 仓库，交接以本地文件、截图、测试输出和 APK 产物为准。


