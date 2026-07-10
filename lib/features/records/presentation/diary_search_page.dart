import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/raby_colors.dart';
import '../../../app/theme/raby_tokens.dart';
import '../../../domain/models/diary_entry.dart';
import '../../../shared/widgets/raby_card.dart';
import '../../../shared/widgets/raby_page.dart';
import '../../../shared/widgets/raby_sketch_icon.dart';
import '../../../shared/widgets/raby_state_card.dart';
import '../../rabbits/application/current_rabbit_providers.dart';
import '../application/diary_timeline_providers.dart';
import 'widgets/diary_card.dart';

class DiarySearchPage extends ConsumerStatefulWidget {
  const DiarySearchPage({super.key});

  @override
  ConsumerState<DiarySearchPage> createState() => _DiarySearchPageState();
}

class _DiarySearchPageState extends ConsumerState<DiarySearchPage> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rabbitState = ref.watch(currentRabbitProvider);

    return Scaffold(
      body: RabyPage(
        title: '搜索日记',
        centerTitle: true,
        leading: RabyIconBubble(
          icon: RabyIconKind.back,
          tooltip: '返回',
          onTap: () => context.go(AppRoutes.records),
        ),
        bottomPadding: RabySpacing.xl,
        children: [
          RabyCard(
            softShadow: true,
            child: TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: '搜索正文、标签或日期',
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(12),
                  child: RabySketchIcon(
                    kind: RabyIconKind.search,
                    color: RabyColors.primary,
                  ),
                ),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        tooltip: '清空搜索',
                        onPressed: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                        icon: const RabySketchIcon(kind: RabyIconKind.close),
                      ),
              ),
              onChanged: (value) => setState(() => _query = value.trim()),
            ),
          ),
          const SizedBox(height: RabySpacing.md),
          rabbitState.when(
            data: (rabbit) {
              if (rabbit == null) {
                return RabyStateCard(
                  icon: RabyIconKind.rabbit,
                  title: '请先建立兔兔档案',
                  message: '有了兔兔档案后,日记会自动进入搜索范围。',
                  actionLabel: '建立兔兔档案',
                  actionIcon: RabyIconKind.add,
                  tone: RabyStateTone.warm,
                  onAction: () => context.go(AppRoutes.onboardingRabbit),
                );
              }
              return _SearchResults(rabbitId: rabbit.id, query: _query);
            },
            loading: () => const RabyCard(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => RabyStateCard(
              icon: RabyIconKind.error,
              title: '档案读取失败',
              message: '本地数据暂时不可用,可以稍后重试。',
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

class _SearchResults extends ConsumerWidget {
  const _SearchResults({required this.rabbitId, required this.query});

  final String rabbitId;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timelineState = ref.watch(diaryTimelineProvider(rabbitId));
    return timelineState.when(
      data: (entries) {
        final results = _filter(entries, query);
        if (entries.isEmpty) {
          return RabyStateCard(
            icon: RabyIconKind.diary,
            title: '还没有生活记录',
            message: '先写一条日记,之后就可以按关键词快速找到它。',
            actionLabel: '写第一条日记',
            actionIcon: RabyIconKind.add,
            tone: RabyStateTone.warm,
            onAction: () => context.go(AppRoutes.recordsNew),
          );
        }
        if (query.isEmpty) {
          return _SearchHint(total: entries.length);
        }
        if (results.isEmpty) {
          return RabyStateCard(
            icon: RabyIconKind.search,
            title: '没有找到相关日记',
            message: '换个关键词试试,比如标签、日期或当天发生的事。',
            tone: RabyStateTone.neutral,
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 0, 2, 10),
              child: Text(
                '找到 ${results.length} 条',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            for (var i = 0; i < results.length; i += 1) ...[
              DiaryCard(
                entry: results[i],
                onView: () =>
                    context.go(AppRoutes.recordDetail(results[i].diary.id)),
                onEdit: () =>
                    context.go(AppRoutes.recordEdit(results[i].diary.id)),
                onDelete: null,
              ),
              if (i != results.length - 1)
                const SizedBox(height: RabySpacing.md),
            ],
          ],
        );
      },
      loading: () =>
          const RabyCard(child: Center(child: CircularProgressIndicator())),
      error: (error, _) => RabyStateCard(
        icon: RabyIconKind.error,
        title: '日记读取失败',
        message: '本地生活记录暂时不可用,可以重试一次。',
        actionLabel: '重试',
        actionIcon: RabyIconKind.refresh,
        tone: RabyStateTone.danger,
        onAction: () => ref.invalidate(diaryTimelineProvider(rabbitId)),
      ),
    );
  }
}

class _SearchHint extends StatelessWidget {
  const _SearchHint({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return RabyCard(
      softShadow: true,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [RabyColors.paper, RabyColors.surfaceWarm],
      ),
      child: Row(
        children: [
          const RabySticker(icon: RabyIconKind.search, size: 52),
          const SizedBox(width: RabySpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '可搜索 $total 条日记',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '输入「吃草」「日常」或日期片段,就能快速回到那一天。',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<DiaryEntry> _filter(List<DiaryEntry> entries, String query) {
  final terms = query
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .where((term) => term.isNotEmpty)
      .toList();
  if (terms.isEmpty) {
    return const [];
  }
  return entries
      .where((entry) {
        final haystack = [
          entry.diary.content ?? '',
          _formatDate(entry.diary.recordedAt),
          _formatLooseDate(entry.diary.recordedAt),
          for (final tag in entry.tags) tag.name,
        ].join(' ').toLowerCase();
        return terms.every(haystack.contains);
      })
      .toList(growable: false);
}

String _formatDate(DateTime date) {
  final local = date.toLocal();
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  return '${local.year}-$month-$day';
}

String _formatLooseDate(DateTime date) {
  final local = date.toLocal();
  return '${local.year}年${local.month}月${local.day}日';
}
