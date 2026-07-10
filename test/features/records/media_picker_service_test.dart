import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:raby/features/records/application/media_picker_service.dart';

void main() {
  test(
    'limits picked images to remaining slots and reports truncation',
    () async {
      final tempDir = await Directory.systemTemp.createTemp(
        'raby-picker-test-',
      );
      addTearDown(() => tempDir.delete(recursive: true));

      final files = <XFile>[];
      for (var index = 0; index < 3; index += 1) {
        final file = File('${tempDir.path}${Platform.pathSeparator}$index.jpg');
        await file.writeAsBytes([index, index + 1, index + 2]);
        files.add(XFile(file.path, mimeType: 'image/jpeg'));
      }

      final picker = _FakeImagePicker(files);
      final service = MediaPickerService(picker: picker);

      final result = await service.pickImages(remainingSlots: 2);

      expect(picker.lastLimit, 2);
      expect(result.truncated, isTrue);
      expect(result.drafts, hasLength(2));
      expect(result.drafts.first.localPath, files.first.path);
      expect(result.drafts.first.mimeType, 'image/jpeg');
      expect(result.drafts.first.fileSizeBytes, 3);
    },
  );

  test('does not open picker when no slots remain', () async {
    final picker = _FakeImagePicker(const []);
    final service = MediaPickerService(picker: picker);

    final result = await service.pickImages(remainingSlots: 0);

    expect(picker.callCount, 0);
    expect(result.truncated, isFalse);
    expect(result.drafts, isEmpty);
  });
}

class _FakeImagePicker extends ImagePicker {
  _FakeImagePicker(this.files);

  final List<XFile> files;
  int callCount = 0;
  int? lastLimit;

  @override
  Future<List<XFile>> pickMultiImage({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    int? limit,
    bool requestFullMetadata = true,
  }) async {
    callCount += 1;
    lastLimit = limit;
    return files;
  }
}
