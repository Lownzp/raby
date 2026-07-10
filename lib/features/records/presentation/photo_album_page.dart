import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers/repository_providers.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/raby_colors.dart';
import '../../../app/theme/raby_tokens.dart';
import '../../../data/media/media_storage_service.dart';
import '../../../domain/models/diary_entry.dart';
import '../../../domain/models/diary_media.dart';
import '../../../shared/widgets/raby_card.dart';
import '../../../shared/widgets/raby_page.dart';
import '../../../shared/widgets/raby_sketch_icon.dart';
import '../../../shared/widgets/raby_state_card.dart';
import '../../rabbits/application/current_rabbit_providers.dart';
import '../application/diary_timeline_providers.dart';
import 'photo_viewer_page.dart';

class PhotoAlbumPage extends ConsumerWidget {
  const PhotoAlbumPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rabbitState = ref.watch(currentRabbitProvider);
    return Scaffold(
      body: RabyPage(
        title: '照片相册',
        centerTitle: true,
        leading: RabyIconBubble(
          icon: RabyIconKind.back,
          tooltip: '返回',
          onTap: () => context.go(AppRoutes.me),
        ),
        bottomPadding: RabySpacing.xl,
        children: [
          rabbitState.when(
            data: (rabbit) {
              if (rabbit == null) {
                return RabyStateCard(
                  icon: RabyIconKind.rabbit,
                  title: '请先建立兔兔档案',
                  message: '有了兔兔档案后,日记照片会自动汇总到相册。',
                  actionLabel: '建立兔兔档案',
                  actionIcon: RabyIconKind.add,
                  tone: RabyStateTone.warm,
                  onAction: () => context.go(AppRoutes.onboardingRabbit),
                );
              }
              return _AlbumContent(rabbitId: rabbit.id);
            },
            loading: () => const RabyCard(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => RabyStateCard(
              icon: RabyIconKind.error,
              title: '档案读取失败',
              message: '本地档案暂时不可用,可以重试一次。',
              actionLabel: '重试',
              actionIcon: RabyIconKind.refresh,
              tone: RabyStateTone.danger,
              onAction: () => ref.invalidate(currentRabbitProvider),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlbumContent extends ConsumerWidget {
  const _AlbumContent({required this.rabbitId});

  final String rabbitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timelineState = ref.watch(diaryTimelineProvider(rabbitId));
    return timelineState.when(
      data: (entries) {
        final photos = _collectPhotos(entries);
        if (photos.isEmpty) {
          return RabyStateCard(
            icon: RabyIconKind.photo,
            title: '还没有生活照片',
            message: '写日记时添加照片,这里会自动整理成相册。',
            actionLabel: '写一条日记',
            actionIcon: RabyIconKind.add,
            tone: RabyStateTone.warm,
            onAction: () => context.go(AppRoutes.recordsNew),
          );
        }
        final media = photos
            .map((photo) => photo.media)
            .toList(growable: false);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RabyCard(
              softShadow: true,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [RabyColors.surfaceWarm, RabyColors.paper],
              ),
              child: Row(
                children: [
                  const RabySticker(icon: RabyIconKind.photo, size: 52),
                  const SizedBox(width: RabySpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${photos.length} 张生活照片',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '按日记时间自动汇总,点开可以查看大图。',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RabySpacing.md),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: photos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 9,
                mainAxisSpacing: 9,
              ),
              itemBuilder: (context, index) {
                return _AlbumTile(
                  index: index,
                  photo: photos[index],
                  onTap: () {
                    context.push(
                      AppRoutes.mediaPhotos,
                      extra: PhotoViewerArgs(
                        media: media,
                        initialIndex: index,
                        returnPath: AppRoutes.mediaAlbum,
                        returnTooltip: '返回相册',
                        returnLabel: '返回相册',
                      ),
                    );
                  },
                );
              },
            ),
          ],
        );
      },
      loading: () =>
          const RabyCard(child: Center(child: CircularProgressIndicator())),
      error: (error, _) => RabyStateCard(
        icon: RabyIconKind.error,
        title: '相册读取失败',
        message: '本地照片记录暂时不可用,可以重试一次。',
        actionLabel: '重试',
        actionIcon: RabyIconKind.refresh,
        tone: RabyStateTone.danger,
        onAction: () => ref.invalidate(diaryTimelineProvider(rabbitId)),
      ),
    );
  }
}

class _AlbumTile extends ConsumerWidget {
  const _AlbumTile({
    required this.index,
    required this.photo,
    required this.onTap,
  });

  final int index;
  final _AlbumPhoto photo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tooltip(
      message: '查看照片 ${index + 1} · ${_formatDate(photo.recordedAt)}',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(RabyRadius.md),
        child: Material(
          color: RabyColors.surfaceSoft,
          child: InkWell(
            onTap: onTap,
            child: FutureBuilder<File>(
              future: _loadPhotoFile(
                ref.watch(mediaStorageServiceProvider),
                photo.media.relativePath,
              ),
              builder: (context, snapshot) {
                final file = snapshot.data;
                if (file == null) {
                  return _AlbumPlaceholder(index: index);
                }
                return Image.file(
                  file,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                  errorBuilder: (context, error, stackTrace) =>
                      _AlbumPlaceholder(index: index),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

Future<File> _loadPhotoFile(MediaStorageService storage, String relativePath) =>
    storage.resolve(relativePath);

class _AlbumPlaceholder extends StatelessWidget {
  const _AlbumPlaceholder({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final accent = switch (index % 3) {
      0 => RabyColors.primary,
      1 => RabyColors.accent,
      _ => RabyColors.success,
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [RabyColors.surfaceWarm, RabyColors.surfaceSoft],
        ),
        border: Border.all(color: RabyColors.border),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 12,
            top: 10,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.24),
                shape: BoxShape.circle,
              ),
              child: const SizedBox.square(dimension: 24),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 34,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.18),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(RabyRadius.md),
                ),
              ),
            ),
          ),
          const Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: RabyColors.paper,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: RabySketchIcon(
                  kind: RabyIconKind.rabbit,
                  color: RabyColors.primaryDeep,
                  size: 36,
                ),
              ),
            ),
          ),
          Positioned(
            left: 10,
            bottom: 10,
            child: RabySketchIcon(
              kind: RabyIconKind.photo,
              color: accent,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlbumPhoto {
  const _AlbumPhoto({required this.media, required this.recordedAt});

  final DiaryMedia media;
  final DateTime recordedAt;
}

List<_AlbumPhoto> _collectPhotos(List<DiaryEntry> entries) {
  final photos = <_AlbumPhoto>[];
  for (final entry in entries) {
    for (final media in entry.media) {
      photos.add(_AlbumPhoto(media: media, recordedAt: entry.diary.recordedAt));
    }
  }
  photos.sort((a, b) {
    final dateCompare = b.recordedAt.compareTo(a.recordedAt);
    if (dateCompare != 0) {
      return dateCompare;
    }
    return a.media.sortOrder.compareTo(b.media.sortOrder);
  });
  return photos;
}

String _formatDate(DateTime date) {
  final local = date.toLocal();
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  return '${local.year}-$month-$day';
}
