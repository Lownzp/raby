import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../../../app/providers/repository_providers.dart';
import '../../../domain/models/rabbit.dart';
import '../../../domain/models/raby_enums.dart';

class RabbitFormInput {
  const RabbitFormInput({
    required this.name,
    required this.sex,
    required this.birthDate,
    required this.adoptedDate,
    required this.breed,
    required this.furColor,
    required this.initialWeightGrams,
    this.avatarPath,
    this.avatarLocalPath,
  });

  final String name;
  final RabbitSex sex;
  final String birthDate;
  final String adoptedDate;
  final String breed;
  final String furColor;
  final int? initialWeightGrams;
  final String? avatarPath;
  final String? avatarLocalPath;
}

final rabbitFormControllerProvider = Provider<RabbitFormController>((ref) {
  return RabbitFormController(ref);
});

class RabbitFormController {
  const RabbitFormController(this._ref);

  final Ref _ref;

  Future<void> create(RabbitFormInput input) async {
    final now = _ref.read(clockProvider)();
    final rabbitId = _ref.read(uuidProvider).v4();
    final copiedRelativePaths = <String>[];
    try {
      final avatarPath = await _resolveAvatarPath(
        rabbitId: rabbitId,
        input: input,
        existingAvatarPath: null,
        copiedRelativePaths: copiedRelativePaths,
      );

      final rabbit = Rabbit(
        id: rabbitId,
        name: input.name.trim(),
        sex: input.sex,
        birthDate: _blankToNull(input.birthDate),
        adoptedDate: _blankToNull(input.adoptedDate),
        breed: input.breed.trim(),
        furColor: input.furColor.trim(),
        avatarPath: avatarPath,
        initialWeightGrams: input.initialWeightGrams,
        createdAt: now,
        updatedAt: now,
      );
      await _ref.read(rabbitRepositoryProvider).createRabbit(rabbit);
    } catch (_) {
      await _cleanupCopiedMedia(copiedRelativePaths);
      rethrow;
    }
  }

  Future<void> updateRabbit({
    required Rabbit existing,
    required RabbitFormInput input,
  }) async {
    final now = _ref.read(clockProvider)();
    final copiedRelativePaths = <String>[];
    try {
      final avatarPath = await _resolveAvatarPath(
        rabbitId: existing.id,
        input: input,
        existingAvatarPath: existing.avatarPath,
        copiedRelativePaths: copiedRelativePaths,
      );

      final rabbit = Rabbit(
        id: existing.id,
        name: input.name.trim(),
        sex: input.sex,
        birthDate: _blankToNull(input.birthDate),
        adoptedDate: _blankToNull(input.adoptedDate),
        breed: input.breed.trim(),
        furColor: input.furColor.trim(),
        avatarPath: avatarPath,
        source: existing.source,
        neuteredStatus: existing.neuteredStatus,
        neuteredDate: existing.neuteredDate,
        chipNumber: existing.chipNumber,
        initialWeightGrams: input.initialWeightGrams,
        personalityTags: existing.personalityTags,
        favoriteFoods: existing.favoriteFoods,
        favoriteToys: existing.favoriteToys,
        passedAwayDate: existing.passedAwayDate,
        createdAt: existing.createdAt,
        updatedAt: now,
        deletedAt: existing.deletedAt,
      );
      await _ref.read(rabbitRepositoryProvider).updateRabbit(rabbit);
    } catch (_) {
      await _cleanupCopiedMedia(copiedRelativePaths);
      rethrow;
    }
  }

  Future<String?> _resolveAvatarPath({
    required String rabbitId,
    required RabbitFormInput input,
    required String? existingAvatarPath,
    required List<String> copiedRelativePaths,
  }) async {
    final localPath = input.avatarLocalPath;
    if (localPath == null || localPath.isEmpty) {
      return input.avatarPath ?? existingAvatarPath;
    }

    final mediaId = _ref.read(uuidProvider).v4();
    final storage = _ref.read(mediaStorageServiceProvider);
    final relativePath = await storage.rabbitAvatarRelativePath(
      rabbitId: rabbitId,
      mediaId: mediaId,
      extension: _extensionFromPath(localPath),
    );
    await storage.copyToRelativePath(
      source: File(localPath),
      relativePath: relativePath,
    );
    copiedRelativePaths.add(relativePath);
    return relativePath;
  }

  Future<void> _cleanupCopiedMedia(List<String> copiedRelativePaths) async {
    if (copiedRelativePaths.isEmpty) {
      return;
    }

    final storage = _ref.read(mediaStorageServiceProvider);
    for (final relativePath in copiedRelativePaths.reversed) {
      try {
        await storage.deleteRelativePath(relativePath);
      } catch (_) {}
    }
  }
}

String _extensionFromPath(String path) {
  final extension = p.extension(path).replaceFirst(RegExp(r'^\.'), '').trim();
  return extension.isEmpty ? 'jpg' : extension.toLowerCase();
}

String? _blankToNull(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
