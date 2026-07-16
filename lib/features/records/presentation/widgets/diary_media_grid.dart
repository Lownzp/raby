import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/repository_providers.dart';
import '../../../../app/theme/raby_colors.dart';
import '../../../../app/theme/raby_tokens.dart';
import '../../../../domain/models/diary_media.dart';
import '../../../../shared/widgets/raby_image_slot.dart';

class DiaryMediaGrid extends StatelessWidget {
  const DiaryMediaGrid({required this.media, this.onMediaTap, super.key});

  final List<DiaryMedia> media;
  final ValueChanged<int>? onMediaTap;

  @override
  Widget build(BuildContext context) {
    if (media.isEmpty) {
      return const SizedBox.shrink();
    }

    final columns = media.length == 1 ? 1 : (media.length <= 4 ? 2 : 3);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: media.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: media.length == 1 ? 1.35 : 1,
      ),
      itemBuilder: (context, index) {
        return _DiaryMediaTile(
          media: media[index],
          index: index,
          onTap: onMediaTap == null ? null : () => onMediaTap!(index),
        );
      },
    );
  }
}

class _DiaryMediaTile extends ConsumerWidget {
  const _DiaryMediaTile({
    required this.media,
    required this.index,
    required this.onTap,
  });

  final DiaryMedia media;
  final int index;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Semantics(
      button: onTap != null,
      label: '照片 ${index + 1}',
      child: Tooltip(
        message: '查看照片 ${index + 1}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(RabyRadius.md),
          child: Material(
            color: RabyColors.surfaceSoft,
            child: InkWell(
              onTap: onTap,
              child: FutureBuilder<File>(
                future: ref
                    .watch(mediaStorageServiceProvider)
                    .resolve(media.relativePath),
                builder: (context, snapshot) {
                  final file = snapshot.data;
                  if (file == null) {
                    return const _ImagePlaceholder();
                  }
                  return Image.file(
                    file,
                    fit: BoxFit.cover,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                          if (wasSynchronouslyLoaded || frame != null) {
                            return child;
                          }
                          return const _ImagePlaceholder();
                        },
                    errorBuilder: (context, error, stackTrace) =>
                        const _ImagePlaceholder(),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const RabyImageSlot(radius: 0, semanticLabel: '待替换日记图片');
  }
}
