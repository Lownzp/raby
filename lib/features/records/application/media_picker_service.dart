import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'media_draft.dart';

final mediaPickerServiceProvider = Provider<MediaPickerService>((ref) {
  return MediaPickerService();
});

class MediaPickerService {
  MediaPickerService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  Future<PickedDiaryMediaDrafts> pickImages({
    required int remainingSlots,
  }) async {
    if (remainingSlots <= 0) {
      return const PickedDiaryMediaDrafts.empty();
    }

    final selected = await _picker.pickMultiImage(
      imageQuality: 88,
      limit: remainingSlots,
    );
    if (selected.isEmpty) {
      return const PickedDiaryMediaDrafts.empty();
    }

    final drafts = <LocalDiaryMediaDraft>[];
    for (final file in selected.take(remainingSlots)) {
      drafts.add(
        LocalDiaryMediaDraft(
          localPath: file.path,
          mimeType: file.mimeType,
          fileSizeBytes: await file.length(),
        ),
      );
    }
    return PickedDiaryMediaDrafts(
      drafts: drafts,
      truncated: selected.length > remainingSlots,
    );
  }
}

class PickedDiaryMediaDrafts {
  const PickedDiaryMediaDrafts({required this.drafts, required this.truncated});

  const PickedDiaryMediaDrafts.empty() : drafts = const [], truncated = false;

  final List<LocalDiaryMediaDraft> drafts;
  final bool truncated;
}
