# Raby

Raby is a local-first rabbit archive app built with Flutter.

## Acceptance

Current v0.1.0 acceptance handoff:

- Checklist and evidence: `docs\prototypes\raby-v0.1.0-acceptance-handoff.md`
- Requirement audit: `docs\prototypes\raby-v0.1.0-requirement-audit.md`
- Machine-readable manifest: `docs\prototypes\raby-v0.1.0-acceptance-manifest.json`
- Screenshot overview: `docs\prototypes\screenshots\raby-contact-sheet.png`
- Latest local APK copy: `dist\apk\raby-v0.1.0-arm64-release-20260708-090404.apk`
- APK SHA256 file: `dist\apk\raby-v0.1.0-arm64-release-20260708-090404.apk.sha256`
- Acceptance bundle: `dist\raby-v0.1.0-acceptance-bundle-20260708-0438.zip`
- Bundle SHA256 file: `dist\raby-v0.1.0-acceptance-bundle-20260708-0438.zip.sha256`

Verify the acceptance artifacts:

```powershell
.\tooling\verify-acceptance-artifacts.ps1
```

Rebuild the acceptance bundle and verify it:

```powershell
.\tooling\create-acceptance-bundle.ps1
```

## Development

Load the project toolchain in PowerShell:

```powershell
. .\tooling\env.ps1
flutter pub get
flutter test
```

Start the configured Android emulator:

```powershell
.\tooling\start-emulator.ps1
flutter run
```

## Release APK

Build a small Android arm64 release APK, copy it to `dist\apk`, upload it to the public file server, and verify the remote file size. The current v0.1.0 acceptance APK is debug-signed for internal install testing, not store submission.

```powershell
.\tooling\publish-public-apk.ps1 -ReleaseName raby-v0.1.0
```

Useful options:

```powershell
# Reuse the existing build\app\outputs\flutter-apk\app-arm64-v8a-release.apk
.\tooling\publish-public-apk.ps1 -SkipBuild

# Only build/copy the APK locally; do not upload
.\tooling\publish-public-apk.ps1 -NoUpload
```

