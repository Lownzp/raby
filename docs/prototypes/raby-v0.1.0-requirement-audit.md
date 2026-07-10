# Raby v0.1.0 需求覆盖审计

审计时间：2026-07-08 09:10（Asia/Shanghai）

## 审计口径

本表按 v0.1「可记录内测版」验收，不把云同步、导入导出、通知提醒、热力图、兔生大事记、视频、多兔完整切换计入本次必须项。这些能力在现有规格中属于 v0.2/v1.0 或后续演进。

## 覆盖结论

| 需求 | 状态 | 证据 |
| --- | --- | --- |
| 首次无兔档案时进入建档 | 已覆盖 | Widget 测试 `starts onboarding when no rabbit exists`；截图 `raby-onboarding.png` |
| 无档案状态下入口和标题不误导 | 已覆盖 | Widget 测试 `records top add opens onboarding when no rabbit exists`、`records empty quick actions open onboarding`、`weight top add opens onboarding when no rabbit exists`、`profile empty state does not show a fake rabbit name`、`rabbit detail empty state opens onboarding from top action`、`rabbit edit empty state offers onboarding action`、`weight editor empty state disables date picker action`、`diary detail does not show a fake rabbit name without profile` |
| 创建兔兔档案并进入记录页 | 已覆盖 | Widget 测试 `creates first rabbit and shows it on records page`；截图 `raby-home.png` / `raby-home-empty.png` |
| 首页快捷入口在窄屏保持可读 | 已覆盖 | Widget 测试 `home quick actions stay single-line on narrow phones`；临时小屏截图目录 `docs\prototypes\responsive-smoke` |
| 查看、编辑、删除兔兔档案 | 已覆盖 | Widget 测试 `opens rabbit detail and saves profile edits`、`deletes rabbit profile after confirmation`；截图 `raby-rabbit-detail.png` |
| 日记新建、编辑、删除 | 已覆盖 | Widget 测试 `creates edits and deletes a diary from records timeline`；截图 `raby-diary-edit.png` / `raby-diary-detail.png` |
| 日记正文或照片至少一个 | 已覆盖 | Controller 测试 `rejects empty diary without text or photos` |
| 日记照片最多 9 张 | 已覆盖 | Repository/controller 校验；`media_picker_service_test.dart` 验证剩余槽位、超量截断和空槽位不打开选择器 |
| 日记支持系统标签、自定义标签、里程碑标签 | 已覆盖 | Repository 测试系统标签 seed 和 milestone tag；Widget 测试写日记选择 `日常`、`吃草`、`里程碑` 并在时间轴展示 |
| 写日记顶部快捷标签是真实入口 | 已覆盖 | Widget 测试点击 `quick-tag-system-hay` 后保存，时间轴展示 `吃草` |
| 照片缩略图、相册、图片浏览返回 | 已覆盖 | Widget 测试 `opens photo from diary detail and returns to detail`、`opens photo album from profile and returns from viewer`、`opens timeline photo viewer and returns to records page`；截图 `raby-album.png` / `raby-photo-viewer.png` |
| 搜索日记并进入结果 | 已覆盖 | Widget 测试 `searches diary timeline and opens a matching result`；截图 `raby-search.png` |
| 体重新建、编辑、删除 | 已覆盖 | Widget 测试 `creates edits and deletes a weight record`；截图 `raby-weight-edit.png` |
| 体重趋势支持 7 天、30 天、1 年、全部 | 已覆盖 | Widget 测试 `weight range selector filters trend chart`；截图 `raby-weight.png` |
| 至少 10 条体重记录能展示趋势 | 已覆盖 | Widget 测试 `weight chart renders ten records in the default range` |
| 本地持久化，退出重进核心数据仍在 | 已覆盖 | Repository 测试 `persists records after reopening the database file` |
| 设置页基础信息且不展示未实现入口 | 已覆盖 | Widget 测试 `opens settings and hides unavailable v0.1.0 entries`；截图 `raby-settings.png` |
| 固定视口 UI 视觉证据 | 已覆盖 | 14 张页面截图和 `raby-contact-sheet.png`；真实兔兔生活照样张覆盖首页、日记详情、相册、图片浏览和档案页；样张来源见 `tooling\screenshot_harness\assets\PHOTO_CREDITS.md` |
| Release APK 可验收 | 已覆盖 | `dist\apk\raby-v0.1.0-arm64-release-20260708-090404.apk`；SHA256 `99A41A6CD283C24C32DD08AAFF18BA96CEE352654A9501E11A55CD988BF1DCDF`；`aapt dump badging` 确认 `native-code: 'arm64-v8a'`；`apksigner verify --print-certs` 确认为 Android Debug 内测签名；ADB 安装启动烟测进入首次建档页 |

## 自动 Gate

最近一次守门检查：

```powershell
. D:\work\proj\raby\tooling\env.ps1; flutter analyze
. D:\work\proj\raby\tooling\env.ps1; flutter test
.\tooling\verify-acceptance-artifacts.ps1
```

结果：

- `flutter analyze`：No issues found
- `flutter test`：48/48 passed
- `verify-acceptance-artifacts.ps1`：Acceptance artifact verification passed

## 后续版本不计入 v0.1 验收

- 云同步、账户、多端协作
- 导入导出、备份恢复
- 通知提醒
- 热力图、兔生大事记独立页、异常预警
- 视频
- 多兔完整切换和多兔管理


