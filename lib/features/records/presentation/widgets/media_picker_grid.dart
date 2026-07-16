import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/repository_providers.dart';
import '../../../../app/theme/raby_colors.dart';
import '../../../../app/theme/raby_tokens.dart';
import '../../../../shared/widgets/raby_card.dart';
import '../../../../shared/widgets/raby_image_slot.dart';
import '../../../../shared/widgets/raby_sketch_icon.dart';
import '../../application/media_draft.dart';

class MediaPickerGrid extends ConsumerWidget {
  const MediaPickerGrid({
    required this.mediaDrafts,
    required this.enabled,
    required this.onAdd,
    required this.onRemove,
    super.key,
  });

  final List<DiaryMediaDraft> mediaDrafts;
  final bool enabled;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canAdd = enabled && mediaDrafts.length < 9;

    return RabyCard(
      softShadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '照片',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: RabyColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '${mediaDrafts.length}/9',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: RabyColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: RabySpacing.sm),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: math.max(3, mediaDrafts.length + (canAdd ? 1 : 0)),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.32,
            ),
            itemBuilder: (context, index) {
              if (index >= mediaDrafts.length) {
                return _AddPhotoTile(
                  enabled: canAdd,
                  onTap: onAdd,
                  compact: true,
                  label: '添加',
                );
              }
              return _MediaDraftTile(
                draft: mediaDrafts[index],
                enabled: enabled,
                onRemove: () => onRemove(index),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AddPhotoTile extends StatelessWidget {
  const _AddPhotoTile({
    required this.enabled,
    required this.onTap,
    required this.label,
    this.compact = false,
  });

  final bool enabled;
  final VoidCallback onTap;
  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled ? RabyColors.surfaceWarm : RabyColors.surfaceSoft,
      borderRadius: BorderRadius.circular(RabyRadius.md),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(RabyRadius.md),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RabyRadius.md),
            border: Border.all(
              color: enabled ? RabyColors.borderWarm : RabyColors.border,
            ),
          ),
          child: SizedBox(
            height: compact ? null : 112,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RabySketchIcon(
                    kind: RabyIconKind.photo,
                    color: enabled
                        ? RabyColors.secondary
                        : RabyColors.textSecondary,
                  ),
                  const SizedBox(height: RabySpacing.xs),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: enabled
                          ? RabyColors.secondary
                          : RabyColors.textSecondary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MediaDraftTile extends ConsumerWidget {
  const _MediaDraftTile({
    required this.draft,
    required this.enabled,
    required this.onRemove,
  });

  final DiaryMediaDraft draft;
  final bool enabled;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(RabyRadius.md),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _DraftImage(draft: draft),
          Positioned(
            right: 2,
            top: 2,
            child: SizedBox.square(
              dimension: 44,
              child: Center(
                child: Material(
                  color: RabyColors.textPrimary.withValues(alpha: 0.66),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: enabled ? onRemove : null,
                    child: const Tooltip(
                      message: '移除照片',
                      child: SizedBox.square(
                        dimension: 28,
                        child: RabySketchIcon(
                          kind: RabyIconKind.close,
                          size: 16,
                          color: RabyColors.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DraftImage extends ConsumerWidget {
  const _DraftImage({required this.draft});

  final DiaryMediaDraft draft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (draft) {
      LocalDiaryMediaDraft(:final localPath) => _FileImageBox(
        file: File(localPath),
      ),
      ExistingDiaryMediaDraft(:final media) => FutureBuilder<File>(
        future: ref
            .watch(mediaStorageServiceProvider)
            .resolve(media.relativePath),
        builder: (context, snapshot) {
          final file = snapshot.data;
          if (file == null) {
            return const _ImagePlaceholder();
          }
          return _FileImageBox(file: file);
        },
      ),
    };
  }
}

class _FileImageBox extends StatelessWidget {
  const _FileImageBox({required this.file});

  final File file;

  @override
  Widget build(BuildContext context) {
    return Image.file(
      file,
      fit: BoxFit.cover,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return child;
        }
        return const _ImagePlaceholder();
      },
      errorBuilder: (context, error, stackTrace) => const _ImagePlaceholder(),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const RabyImageSlot(
      radius: RabyRadius.md,
      semanticLabel: '日记照片加载占位',
    );
  }
}
