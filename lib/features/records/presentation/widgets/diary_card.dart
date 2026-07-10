import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/raby_colors.dart';
import '../../../../app/theme/raby_tokens.dart';
import '../../../../domain/models/diary_entry.dart';
import '../../../../domain/models/raby_enums.dart';
import '../../../../domain/models/tag.dart';
import '../../../../shared/widgets/raby_card.dart';
import '../../../../shared/widgets/raby_sketch_icon.dart';
import '../photo_viewer_page.dart';
import 'diary_media_grid.dart';

class DiaryCard extends StatelessWidget {
  const DiaryCard({
    required this.entry,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final DiaryEntry entry;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final content = entry.diary.content?.trim();

    return RabyCard(
      padding: EdgeInsets.zero,
      softShadow: true,
      child: InkWell(
        onTap: onView,
        borderRadius: BorderRadius.circular(RabyRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(RabySpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: RabyColors.surfaceWarm,
                      borderRadius: BorderRadius.circular(RabyRadius.pill),
                      border: Border.all(color: RabyColors.borderWarm),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const RabySketchIcon(
                            kind: RabyIconKind.calendar,
                            size: 15,
                            color: RabyColors.secondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _formatDate(entry.diary.recordedAt),
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: RabyColors.secondary,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<_DiaryAction>(
                    tooltip: '更多操作',
                    onSelected: (action) {
                      switch (action) {
                        case _DiaryAction.edit:
                          onEdit();
                        case _DiaryAction.delete:
                          onDelete?.call();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: _DiaryAction.edit,
                        child: Row(
                          children: [
                            RabySketchIcon(kind: RabyIconKind.edit, size: 18),
                            SizedBox(width: 8),
                            Text('编辑'),
                          ],
                        ),
                      ),
                      if (onDelete != null)
                        PopupMenuItem(
                          value: _DiaryAction.delete,
                          child: Row(
                            children: [
                              const RabySketchIcon(
                                kind: RabyIconKind.delete,
                                size: 18,
                                color: RabyColors.danger,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '删除',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: RabyColors.danger),
                              ),
                            ],
                          ),
                        ),
                    ],
                    icon: const RabySketchIcon(kind: RabyIconKind.more),
                  ),
                ],
              ),
              if (entry.tags.isNotEmpty) ...[
                const SizedBox(height: RabySpacing.sm),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final tag in entry.tags) _DiaryTagChip(tag: tag),
                  ],
                ),
              ],
              if (content != null && content.isNotEmpty) ...[
                const SizedBox(height: RabySpacing.md),
                Text(
                  content,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ] else if (entry.media.isEmpty) ...[
                const SizedBox(height: RabySpacing.md),
                Text(
                  '这条日记没有正文。',
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
              if (entry.media.isNotEmpty) ...[
                const SizedBox(height: RabySpacing.md),
                DiaryMediaGrid(
                  media: entry.media,
                  onMediaTap: (index) {
                    context.push(
                      AppRoutes.mediaPhotos,
                      extra: PhotoViewerArgs(
                        media: entry.media,
                        initialIndex: index,
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

enum _DiaryAction { edit, delete }

class _DiaryTagChip extends StatelessWidget {
  const _DiaryTagChip({required this.tag});

  final Tag tag;

  @override
  Widget build(BuildContext context) {
    final isMilestone = tag.tagKind == TagKind.milestone;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isMilestone ? RabyColors.surfaceWarm : RabyColors.surfaceSoft,
        borderRadius: BorderRadius.circular(RabyRadius.pill),
        border: Border.all(
          color: isMilestone ? RabyColors.borderWarm : RabyColors.border,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          tag.name,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: isMilestone ? RabyColors.secondary : RabyColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  final local = date.toLocal();
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  return '${local.year}-$month-$day';
}
