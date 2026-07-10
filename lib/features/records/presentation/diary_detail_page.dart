import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/raby_colors.dart';
import '../../../app/theme/raby_tokens.dart';
import '../../../domain/models/diary_entry.dart';
import '../../../domain/models/weight_record.dart';
import '../../../shared/widgets/raby_card.dart';
import '../../../shared/widgets/raby_page.dart';
import '../../../shared/widgets/raby_sketch_icon.dart';
import '../../../shared/widgets/raby_state_card.dart';
import '../../rabbits/application/current_rabbit_providers.dart';
import '../../weight/application/weight_providers.dart';
import '../application/diary_editor_controller.dart';
import '../application/diary_timeline_providers.dart';
import 'photo_viewer_page.dart';
import 'widgets/diary_media_grid.dart';

class DiaryDetailPage extends ConsumerWidget {
  const DiaryDetailPage({required this.diaryId, super.key});

  final String diaryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entryState = ref.watch(diaryEntryProvider(diaryId));
    final rabbitState = ref.watch(currentRabbitProvider);
    final canEdit = entryState.maybeWhen(
      data: (entry) =>
          entry != null &&
          rabbitState.maybeWhen(
            data: (rabbit) => rabbit?.id == entry.diary.rabbitId,
            orElse: () => false,
          ),
      orElse: () => false,
    );
    return Scaffold(
      body: RabyPage(
        title: '日记详情',
        centerTitle: true,
        leading: RabyIconBubble(
          icon: RabyIconKind.back,
          tooltip: '返回',
          onTap: () => context.go(AppRoutes.records),
        ),
        trailing: canEdit
            ? RabyIconBubble(
                icon: RabyIconKind.edit,
                tooltip: '编辑',
                onTap: () => context.go(AppRoutes.recordEdit(diaryId)),
              )
            : null,
        bottomPadding: RabySpacing.xl,
        children: [
          entryState.when(
            data: (entry) {
              if (entry == null) {
                return RabyStateCard(
                  icon: RabyIconKind.error,
                  title: '日记不存在',
                  message: '这条日记可能已经被删除。',
                  actionLabel: '返回首页',
                  actionIcon: RabyIconKind.back,
                  onAction: () => context.go(AppRoutes.records),
                );
              }
              return _DiaryDetailContent(entry: entry);
            },
            loading: () => const RabyCard(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => RabyStateCard(
              icon: RabyIconKind.error,
              title: '日记读取失败',
              message: '本地日记暂时不可用,可以稍后重试。',
              actionLabel: '重试',
              actionIcon: RabyIconKind.refresh,
              tone: RabyStateTone.danger,
              onAction: () => ref.invalidate(diaryEntryProvider(diaryId)),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiaryDetailContent extends ConsumerWidget {
  const _DiaryDetailContent({required this.entry});

  final DiaryEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rabbit = ref
        .watch(currentRabbitProvider)
        .maybeWhen(data: (rabbit) => rabbit, orElse: () => null);
    final hasMatchingRabbit = rabbit?.id == entry.diary.rabbitId;
    final weight = ref
        .watch(weightRecordsProvider(entry.diary.rabbitId))
        .maybeWhen(
          data: (records) => _sameDayWeight(records, entry.diary.recordedAt),
          orElse: () => null,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RabyCard(
          radius: RabyRadius.xl,
          softShadow: true,
          gradient: const LinearGradient(
            colors: [RabyColors.surfaceWarm, RabyColors.paper],
          ),
          child: Row(
            children: [
              const RabySticker(
                icon: RabyIconKind.diary,
                size: 54,
                background: RabyColors.surface,
              ),
              const SizedBox(width: RabySpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasMatchingRabbit ? rabbit!.name : '兔兔日记',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: RabyColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(entry.diary.recordedAt),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              if (entry.tags.isNotEmpty)
                _SoftBadge(label: entry.tags.first.name),
            ],
          ),
        ),
        const SizedBox(height: RabySpacing.md),
        RabyCard(
          radius: RabyRadius.xl,
          softShadow: true,
          child: Text(
            entry.diary.content?.trim().isNotEmpty == true
                ? entry.diary.content!.trim()
                : '这一天只留下了照片,没有写正文。',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: RabyColors.secondary,
              fontSize: 17,
              height: 1.65,
            ),
          ),
        ),
        if (entry.media.isNotEmpty) ...[
          const SizedBox(height: RabySpacing.md),
          RabyCard(
            radius: RabyRadius.xl,
            softShadow: true,
            child: DiaryMediaGrid(
              media: entry.media,
              onMediaTap: (index) {
                context.push(
                  AppRoutes.mediaPhotos,
                  extra: PhotoViewerArgs(
                    media: entry.media,
                    initialIndex: index,
                    returnPath: AppRoutes.recordDetail(entry.diary.id),
                    returnTooltip: '返回详情',
                    returnLabel: '返回详情',
                  ),
                );
              },
            ),
          ),
        ],
        const SizedBox(height: RabySpacing.md),
        RabyCard(
          softShadow: true,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (entry.tags.isEmpty)
                const _SoftBadge(label: '日常')
              else
                for (final tag in entry.tags) _SoftBadge(label: tag.name),
            ],
          ),
        ),
        if (hasMatchingRabbit) ...[
          const SizedBox(height: RabySpacing.md),
          RabyCard(
            softShadow: true,
            child: Row(
              children: [
                const RabySticker(icon: RabyIconKind.weight, size: 48),
                const SizedBox(width: RabySpacing.md),
                Expanded(
                  child: Text(
                    weight == null
                        ? '当天还没有记录体重'
                        : '当天体重：${weight.weightGrams}g',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => context.go(AppRoutes.weight),
                  icon: const RabySketchIcon(
                    kind: RabyIconKind.chevronRight,
                    size: 16,
                  ),
                  label: const Text('查看趋势'),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: RabySpacing.lg),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => context.go(
              hasMatchingRabbit
                  ? AppRoutes.recordsNew
                  : AppRoutes.onboardingRabbit,
            ),
            icon: RabySketchIcon(
              kind: hasMatchingRabbit ? RabyIconKind.diary : RabyIconKind.add,
            ),
            label: Text(hasMatchingRabbit ? '再写一篇' : '建立兔兔档案'),
          ),
        ),
        const SizedBox(height: RabySpacing.sm),
        if (hasMatchingRabbit)
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      context.go(AppRoutes.recordEdit(entry.diary.id)),
                  icon: const RabySketchIcon(kind: RabyIconKind.edit),
                  label: const Text('编辑'),
                ),
              ),
              const SizedBox(width: RabySpacing.md),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: RabyColors.danger,
                    side: const BorderSide(color: RabyColors.danger),
                  ),
                  onPressed: () => _confirmDelete(context, ref, entry),
                  icon: const RabySketchIcon(kind: RabyIconKind.delete),
                  label: const Text('删除'),
                ),
              ),
            ],
          )
        else
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: RabyColors.danger,
                side: const BorderSide(color: RabyColors.danger),
              ),
              onPressed: () => _confirmDelete(context, ref, entry),
              icon: const RabySketchIcon(kind: RabyIconKind.delete),
              label: const Text('删除这条日记'),
            ),
          ),
      ],
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    DiaryEntry entry,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('删除这条日记?'),
        content: const Text('删除后会从时间轴隐藏,这个操作需要确认。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('取消'),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: RabyColors.danger,
              foregroundColor: RabyColors.onPrimary,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            icon: const RabySketchIcon(kind: RabyIconKind.delete),
            label: const Text('删除'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    try {
      await ref.read(diaryEditorControllerProvider).delete(entry.diary.id);
      if (!context.mounted) {
        return;
      }
      context.go(AppRoutes.records);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('日记已删除')));
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('删除失败: $error')));
    }
  }
}

class _SoftBadge extends StatelessWidget {
  const _SoftBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: RabyColors.surfaceWarm,
        borderRadius: BorderRadius.circular(RabyRadius.pill),
        border: Border.all(color: RabyColors.borderWarm),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: RabyColors.secondary,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

WeightRecord? _sameDayWeight(List<WeightRecord> records, DateTime date) {
  final target = date.toLocal();
  for (final record in records) {
    final value = record.recordedAt.toLocal();
    if (value.year == target.year &&
        value.month == target.month &&
        value.day == target.day) {
      return record;
    }
  }
  return null;
}

String _formatDate(DateTime date) {
  final local = date.toLocal();
  return '${local.year} 年 ${local.month} 月 ${local.day} 日';
}
