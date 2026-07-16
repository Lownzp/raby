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
import '../../../domain/models/rabbit.dart';
import '../../../shared/navigation/raby_shell.dart';
import '../../../shared/widgets/raby_card.dart';
import '../../../shared/widgets/raby_image_slot.dart';
import '../../../shared/widgets/raby_page.dart';
import '../../../shared/widgets/raby_sketch_icon.dart';
import '../../../shared/widgets/raby_state_card.dart';
import '../../../shared/widgets/rabbit_avatar.dart';
import '../../rabbits/application/current_rabbit_providers.dart';
import '../application/diary_timeline_providers.dart';
import 'photo_viewer_page.dart';

class PhotoAlbumPage extends ConsumerWidget {
  const PhotoAlbumPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rabbitState = ref.watch(currentRabbitProvider);
    final rabbit = rabbitState.maybeWhen(
      data: (rabbit) => rabbit,
      orElse: () => null,
    );
    return Scaffold(
      bottomNavigationBar: const RabyBottomNavigation(
        currentPath: AppRoutes.me,
      ),
      body: RabyPage(
        title: '照片相册',
        centerTitle: true,
        leading: RabyIconBubble(
          icon: RabyIconKind.back,
          tooltip: '返回',
          onTap: () => context.go(AppRoutes.me),
        ),
        trailing: RabyIconBubble(
          icon: RabyIconKind.add,
          tooltip: rabbit == null ? '建立兔兔档案' : '写日记添加照片',
          onTap: () => context.go(
            rabbit == null ? AppRoutes.onboardingRabbit : AppRoutes.recordsNew,
          ),
        ),
        bottomPadding: RabySpacing.lg,
        children: [
          rabbitState.when(
            data: (rabbit) {
              if (rabbit == null) {
                return RabyStateCard(
                  icon: RabyIconKind.rabbit,
                  title: '请先建立兔兔档案',
                  message: '有了兔兔档案后，日记照片会自动汇总到相册。',
                  actionLabel: '建立兔兔档案',
                  actionIcon: RabyIconKind.add,
                  tone: RabyStateTone.warm,
                  onAction: () => context.go(AppRoutes.onboardingRabbit),
                );
              }
              return _AlbumContent(rabbit: rabbit);
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

class _AlbumContent extends ConsumerStatefulWidget {
  const _AlbumContent({required this.rabbit});

  final Rabbit rabbit;

  @override
  ConsumerState<_AlbumContent> createState() => _AlbumContentState();
}

class _AlbumContentState extends ConsumerState<_AlbumContent> {
  _AlbumCategory _selectedCategory = _AlbumCategory.all;

  @override
  Widget build(BuildContext context) {
    final timelineState = ref.watch(diaryTimelineProvider(widget.rabbit.id));
    return timelineState.when(
      data: (entries) {
        final photos = _collectPhotos(entries);
        final filteredPhotos = photos
            .where(_selectedCategory.matches)
            .toList(growable: false);
        final media = filteredPhotos
            .map((photo) => photo.media)
            .toList(growable: false);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AlbumSummaryCard(rabbit: widget.rabbit, photoCount: photos.length),
            const SizedBox(height: RabySpacing.md),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var i = 0; i < _AlbumCategory.values.length; i += 1) ...[
                    ChoiceChip(
                      key: ValueKey(
                        'album-filter-${_AlbumCategory.values[i].name}',
                      ),
                      label: Text(_AlbumCategory.values[i].label),
                      selected: _selectedCategory == _AlbumCategory.values[i],
                      showCheckmark: false,
                      onSelected: (_) => setState(
                        () => _selectedCategory = _AlbumCategory.values[i],
                      ),
                    ),
                    if (i != _AlbumCategory.values.length - 1)
                      const SizedBox(width: RabySpacing.sm),
                  ],
                ],
              ),
            ),
            const SizedBox(height: RabySpacing.md),
            if (photos.isEmpty)
              RabyStateCard(
                icon: RabyIconKind.photo,
                title: '还没有生活照片',
                message: '写日记时添加照片，这里会自动整理成相册。',
                actionLabel: '写一条日记',
                actionIcon: RabyIconKind.add,
                tone: RabyStateTone.warm,
                onAction: () => context.go(AppRoutes.recordsNew),
              )
            else if (filteredPhotos.isEmpty)
              RabyStateCard(
                icon: RabyIconKind.photo,
                title: '这个分类还没有照片',
                message: '切换到其他分类，或者写日记添加一张。',
                actionLabel: '查看全部',
                actionIcon: RabyIconKind.refresh,
                tone: RabyStateTone.warm,
                onAction: () =>
                    setState(() => _selectedCategory = _AlbumCategory.all),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredPhotos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.82,
                ),
                itemBuilder: (context, index) {
                  return _AlbumTile(
                    index: index,
                    photo: filteredPhotos[index],
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
        message: '本地照片记录暂时不可用，可以重试一次。',
        actionLabel: '重试',
        actionIcon: RabyIconKind.refresh,
        tone: RabyStateTone.danger,
        onAction: () => ref.invalidate(diaryTimelineProvider(widget.rabbit.id)),
      ),
    );
  }
}

class _AlbumSummaryCard extends StatelessWidget {
  const _AlbumSummaryCard({required this.rabbit, required this.photoCount});

  final Rabbit rabbit;
  final int photoCount;

  @override
  Widget build(BuildContext context) {
    return RabyCard(
      color: RabyColors.surfaceSoft,
      borderColor: RabyColors.borderWarm,
      child: Row(
        children: [
          if (rabbit.avatarPath == null || rabbit.avatarPath!.isEmpty)
            const RabyImageSlot(
              width: 72,
              height: 72,
              radius: RabyRadius.md,
              semanticLabel: '待替换兔兔头像',
            )
          else
            RabbitAvatar(
              avatarPath: rabbit.avatarPath,
              size: 72,
              iconSize: 36,
              borderWidth: 3,
              borderColor: RabyColors.stickerBorder,
            ),
          const SizedBox(width: RabySpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rabbit.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontFamily: 'RabyChillRoundM',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$photoCount 张照片',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  '记录${rabbit.name}的可爱瞬间',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: RabyColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: RabySpacing.sm),
          const RabyImageSlot(
            width: 58,
            height: 58,
            radius: RabyRadius.md,
            placeholderColor: RabyColors.surfaceWarm,
            semanticLabel: '待替换相机插图',
          ),
        ],
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
            child: Stack(
              fit: StackFit.expand,
              children: [
                FutureBuilder<File>(
                  future: _loadPhotoFile(
                    ref.watch(mediaStorageServiceProvider),
                    photo.media.relativePath,
                  ),
                  builder: (context, snapshot) {
                    final file = snapshot.data;
                    if (file == null) {
                      return const _AlbumPlaceholder();
                    }
                    return Image.file(
                      file,
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                      errorBuilder: (context, error, stackTrace) =>
                          const _AlbumPlaceholder(),
                    );
                  },
                ),
                Positioned(
                  left: 6,
                  bottom: 6,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: RabyColors.surface.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(RabyRadius.sm),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text(
                        _formatShortDate(photo.recordedAt),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ),
                ),
              ],
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
  const _AlbumPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const RabyImageSlot(radius: 0, semanticLabel: '待替换相册照片');
  }
}

class _AlbumPhoto {
  const _AlbumPhoto({
    required this.media,
    required this.recordedAt,
    required this.tagIds,
  });

  final DiaryMedia media;
  final DateTime recordedAt;
  final Set<String> tagIds;
}

List<_AlbumPhoto> _collectPhotos(List<DiaryEntry> entries) {
  final photos = <_AlbumPhoto>[];
  for (final entry in entries) {
    for (final media in entry.media) {
      photos.add(
        _AlbumPhoto(
          media: media,
          recordedAt: entry.diary.recordedAt,
          tagIds: entry.tags.map((tag) => tag.id).toSet(),
        ),
      );
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

enum _AlbumCategory {
  all('全部', {}),
  daily('日常', {'system-daily'}),
  food('饮食', {'system-hay'}),
  mood('心情', {'category-mood'}),
  health('健康', {'system-vet'});

  const _AlbumCategory(this.label, this.tagIds);

  final String label;
  final Set<String> tagIds;

  bool matches(_AlbumPhoto photo) {
    return this == _AlbumCategory.all || photo.tagIds.any(tagIds.contains);
  }
}

String _formatDate(DateTime date) {
  final local = date.toLocal();
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  return '${local.year}-$month-$day';
}

String _formatShortDate(DateTime date) {
  final local = date.toLocal();
  return '${local.month}/${local.day}';
}
