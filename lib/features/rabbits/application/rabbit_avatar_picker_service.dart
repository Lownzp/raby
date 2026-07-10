import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final rabbitAvatarPickerServiceProvider = Provider<RabbitAvatarPickerService>((
  ref,
) {
  return RabbitAvatarPickerService();
});

class RabbitAvatarPickerService {
  RabbitAvatarPickerService({ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  Future<String?> pickAvatarPath() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 88,
    );
    return file?.path;
  }
}
