import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/raby_colors.dart';
import '../../../app/theme/raby_tokens.dart';
import '../../../domain/models/rabbit.dart';
import '../../../domain/models/weight_record.dart';
import '../../../shared/widgets/raby_card.dart';
import '../../../shared/widgets/raby_page.dart';
import '../../../shared/widgets/raby_sketch_icon.dart';
import '../../../shared/widgets/raby_state_card.dart';
import '../../../shared/widgets/rabbit_avatar.dart';
import '../../rabbits/application/current_rabbit_providers.dart';
import '../application/weight_editor_controller.dart';
import '../application/weight_providers.dart';

class WeightPage extends ConsumerWidget {
  const WeightPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rabbitState = ref.watch(currentRabbitProvider);
    final rabbit = rabbitState.maybeWhen(
      data: (rabbit) => rabbit,
      orElse: () => null,
    );

    return RabyPage(
      title: '体重趋势',
      centerTitle: true,
      trailing: RabyIconBubble(
        icon: RabyIconKind.add,
        tooltip: rabbit == null ? '建立兔兔档案' : '新增体重',
        onTap: rabbit == null
            ? () => context.go(AppRoutes.onboardingRabbit)
            : () => context.go(AppRoutes.weightNew),
      ),
      children: [
        rabbitState.when(
          data: (rabbit) {
            if (rabbit == null) {
              return _NoRabbitWeightCard(
                onCreateRabbit: () => context.go(AppRoutes.onboardingRabbit),
              );
            }
            return _WeightContent(
              rabbit: rabbit,
              onCreate: () => context.go(AppRoutes.weightNew),
              onEdit: (record) => context.go(AppRoutes.weightEdit(record.id)),
              onDelete: (record) => _confirmDelete(context, ref, record),
            );
          },
          loading: () =>
              const RabyCard(child: Center(child: CircularProgressIndicator())),
          error: (error, _) => RabyStateCard(
            icon: RabyIconKind.error,
            title: '体重数据读取失败',
            message: '本地数据暂时不可用,可以重试一次。',
            actionLabel: '重试',
            actionIcon: RabyIconKind.refresh,
            tone: RabyStateTone.danger,
            onAction: () => ref.invalidate(currentRabbitProvider),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    WeightRecord record,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('删除这条体重记录?'),
        content: const Text('删除后会从趋势和历史列表隐藏,这个操作需要确认。'),
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
      await ref.read(weightEditorControllerProvider).delete(record.id);
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('体重记录已删除')));
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

class _WeightContent extends ConsumerStatefulWidget {
  const _WeightContent({
    required this.rabbit,
    required this.onCreate,
    required this.onEdit,
    required this.onDelete,
  });

  final Rabbit rabbit;
  final VoidCallback onCreate;
  final ValueChanged<WeightRecord> onEdit;
  final ValueChanged<WeightRecord> onDelete;

  @override
  ConsumerState<_WeightContent> createState() => _WeightContentState();
}

class _WeightContentState extends ConsumerState<_WeightContent> {
  _WeightRange _selectedRange = _WeightRange.month;

  @override
  Widget build(BuildContext context) {
    final recordsState = ref.watch(weightRecordsProvider(widget.rabbit.id));
    final chartState = ref.watch(weightChartRecordsProvider(widget.rabbit.id));
    return recordsState.when(
      data: (records) {
        final chartRecords = chartState.maybeWhen(
          data: (records) => records,
          orElse: () => _ascending(records),
        );
        final rangedChartRecords = _selectedRange.filter(chartRecords);
        final rangedAnalysisRecords = _descending(rangedChartRecords);
        if (records.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _WeightSummaryCard(records: records, rabbit: widget.rabbit),
              const SizedBox(height: RabySpacing.md),
              _WeightEmptyCard(onCreate: widget.onCreate),
              const SizedBox(height: RabySpacing.md),
              const _WeightFirstRecordTipsCard(),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _WeightSummaryCard(records: records, rabbit: widget.rabbit),
            const SizedBox(height: RabySpacing.md),
            _RangeSelector(
              selected: _selectedRange,
              onChanged: (range) => setState(() => _selectedRange = range),
            ),
            const SizedBox(height: RabySpacing.md),
            _WeightChartCard(records: rangedChartRecords),
            const SizedBox(height: RabySpacing.md),
            _WeightAnalysisCard(records: rangedAnalysisRecords),
            const SizedBox(height: RabySpacing.md),
            _WeightHistorySection(
              records: records,
              onCreate: widget.onCreate,
              onEdit: widget.onEdit,
              onDelete: widget.onDelete,
            ),
          ],
        );
      },
      loading: () =>
          const RabyCard(child: Center(child: CircularProgressIndicator())),
      error: (error, _) => RabyStateCard(
        icon: RabyIconKind.error,
        title: '体重数据读取失败',
        message: '本地体重记录暂时不可用,可以重试一次。',
        actionLabel: '重试',
        actionIcon: RabyIconKind.refresh,
        tone: RabyStateTone.danger,
        onAction: () {
          ref
            ..invalidate(weightRecordsProvider(widget.rabbit.id))
            ..invalidate(weightChartRecordsProvider(widget.rabbit.id));
        },
      ),
    );
  }
}

class _WeightSummaryCard extends StatelessWidget {
  const _WeightSummaryCard({required this.records, required this.rabbit});

  final List<WeightRecord> records;
  final Rabbit rabbit;

  @override
  Widget build(BuildContext context) {
    final latest = records.isEmpty ? null : records.first;
    final previous = records.length > 1 ? records[1] : null;
    final delta = latest == null || previous == null
        ? null
        : latest.weightGrams - previous.weightGrams;

    return RabyCard(
      radius: RabyRadius.hero,
      softShadow: true,
      gradient: const LinearGradient(
        colors: [RabyColors.surfaceWarm, RabyColors.paper],
      ),
      child: Row(
        children: [
          RabbitAvatar(
            avatarPath: rabbit.avatarPath,
            size: 68,
            iconSize: 36,
            borderWidth: 4,
            borderColor: RabyColors.stickerBorder,
          ),
          const SizedBox(width: RabySpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  latest == null ? '暂无体重数据' : _formatGrams(latest.weightGrams),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: RabySpacing.xs),
                Text(
                  latest == null
                      ? '${rabbit.name} 还没有称重记录。'
                      : '${_formatDate(latest.recordedAt)} · ${_deltaText(delta)}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: RabyColors.secondary),
                ),
              ],
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: RabyColors.surfaceWarm,
              borderRadius: BorderRadius.circular(RabyRadius.pill),
              border: Border.all(color: RabyColors.borderWarm),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text(
                '${records.length}条',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: RabyColors.primaryDeep,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeightChartCard extends StatelessWidget {
  const _WeightChartCard({required this.records});

  final List<WeightRecord> records;

  @override
  Widget build(BuildContext context) {
    return RabyCard(
      radius: RabyRadius.hero,
      softShadow: true,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [RabyColors.paper, RabyColors.surfaceWarm],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '趋势',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: RabyColors.secondary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                records.length < 2 ? '至少2条' : '${records.length}次称重',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: RabyColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: RabySpacing.md),
          SizedBox(
            height: 230,
            child: records.length < 2
                ? const Center(child: RabyMutedText('记录两次体重后,这里会显示趋势线。'))
                : LineChart(_chartData(records)),
          ),
          if (records.length >= 2) ...[
            const SizedBox(height: RabySpacing.sm),
            Row(
              children: [
                Text(
                  _formatDate(records.first.recordedAt),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: RabyColors.textSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(records.last.recordedAt),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: RabyColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  LineChartData _chartData(List<WeightRecord> records) {
    final spots = [
      for (var i = 0; i < records.length; i += 1)
        FlSpot(i.toDouble(), records[i].weightGrams.toDouble()),
    ];
    final weights = records.map((record) => record.weightGrams.toDouble());
    final minWeight = weights.reduce(math.min);
    final maxWeight = weights.reduce(math.max);
    final span = maxWeight - minWeight;
    final padding = span == 0
        ? math.max(maxWeight * 0.04, 30).toDouble()
        : math.max(span * 0.22, 30).toDouble();

    return LineChartData(
      minX: 0,
      maxX: (records.length - 1).toDouble(),
      minY: math.max(0, minWeight - padding).toDouble(),
      maxY: maxWeight + padding,
      lineTouchData: const LineTouchData(enabled: true),
      gridData: FlGridData(
        drawVerticalLine: false,
        getDrawingHorizontalLine: (_) =>
            const FlLine(color: RabyColors.border, strokeWidth: 1),
      ),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          curveSmoothness: 0.28,
          color: RabyColors.primary,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(show: records.length <= 10),
          belowBarData: BarAreaData(
            show: true,
            color: RabyColors.primary.withValues(alpha: 0.16),
          ),
        ),
      ],
    );
  }
}

class _RangeSelector extends StatelessWidget {
  const _RangeSelector({required this.selected, required this.onChanged});

  final _WeightRange selected;
  final ValueChanged<_WeightRange> onChanged;

  @override
  Widget build(BuildContext context) {
    return RabyCard(
      padding: const EdgeInsets.all(6),
      radius: RabyRadius.pill,
      softShadow: true,
      child: Row(
        children: [
          for (final range in _WeightRange.values)
            Expanded(
              child: Semantics(
                button: true,
                selected: selected == range,
                child: InkWell(
                  borderRadius: BorderRadius.circular(RabyRadius.pill),
                  onTap: () => onChanged(range),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: selected == range
                          ? RabyColors.surfaceWarm
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(RabyRadius.pill),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        range.label,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: RabyColors.secondary,
                          fontWeight: FontWeight.w900,
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

class _WeightAnalysisCard extends StatelessWidget {
  const _WeightAnalysisCard({required this.records});

  final List<WeightRecord> records;

  @override
  Widget build(BuildContext context) {
    final delta = records.length > 1
        ? records.first.weightGrams - records.last.weightGrams
        : 0;
    final sign = delta > 0 ? '+' : '';
    final tone = delta.abs() <= 80 ? '整体变化平稳' : '变化较明显';

    return RabyCard(
      softShadow: true,
      child: Row(
        children: [
          const RabySticker(icon: RabyIconKind.chart, size: 52),
          const SizedBox(width: RabySpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('变化分析', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  records.length < 2
                      ? '记录两次后生成分析'
                      : '本周期 $sign${delta}g · $tone',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: RabyColors.successSoft,
              borderRadius: BorderRadius.circular(RabyRadius.pill),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              child: Text(
                '健康范围',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: RabyColors.success,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeightHistorySection extends StatelessWidget {
  const _WeightHistorySection({
    required this.records,
    required this.onCreate,
    required this.onEdit,
    required this.onDelete,
  });

  final List<WeightRecord> records;
  final VoidCallback onCreate;
  final ValueChanged<WeightRecord> onEdit;
  final ValueChanged<WeightRecord> onDelete;

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return _WeightEmptyCard(onCreate: onCreate);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 2, 2, 10),
          child: Text('记录明细', style: Theme.of(context).textTheme.titleMedium),
        ),
        for (var i = 0; i < records.length; i += 1) ...[
          _WeightRecordTile(
            record: records[i],
            onEdit: () => onEdit(records[i]),
            onDelete: () => onDelete(records[i]),
          ),
          if (i != records.length - 1) const SizedBox(height: RabySpacing.sm),
        ],
      ],
    );
  }
}

class _WeightRecordTile extends StatelessWidget {
  const _WeightRecordTile({
    required this.record,
    required this.onEdit,
    required this.onDelete,
  });

  final WeightRecord record;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return RabyCard(
      padding: EdgeInsets.zero,
      softShadow: true,
      child: InkWell(
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: RabyColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(RabyRadius.md),
                ),
                child: const SizedBox.square(
                  dimension: 42,
                  child: Center(
                    child: RabySketchIcon(
                      kind: RabyIconKind.weight,
                      size: 22,
                      color: RabyColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: RabySpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatGrams(record.weightGrams),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      record.note == null || record.note!.trim().isEmpty
                          ? _formatDate(record.recordedAt)
                          : '${_formatDate(record.recordedAt)} · ${record.note!.trim()}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: RabyColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<_WeightRecordAction>(
                tooltip: '更多操作',
                onSelected: (action) {
                  switch (action) {
                    case _WeightRecordAction.edit:
                      onEdit();
                      break;
                    case _WeightRecordAction.delete:
                      onDelete();
                      break;
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: _WeightRecordAction.edit,
                    child: Text('编辑'),
                  ),
                  PopupMenuItem(
                    value: _WeightRecordAction.delete,
                    child: Text('删除'),
                  ),
                ],
                icon: const RabySketchIcon(kind: RabyIconKind.more),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeightEmptyCard extends StatelessWidget {
  const _WeightEmptyCard({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return RabyStateCard(
      icon: RabyIconKind.weight,
      title: '还没有体重记录',
      message: '先记录一次称重,后续就能看到趋势变化。',
      actionLabel: '记录第一次体重',
      actionIcon: RabyIconKind.add,
      tone: RabyStateTone.warm,
      onAction: onCreate,
    );
  }
}

class _WeightFirstRecordTipsCard extends StatelessWidget {
  const _WeightFirstRecordTipsCard();

  @override
  Widget build(BuildContext context) {
    return RabyCard(
      softShadow: true,
      borderColor: RabyColors.borderWarm,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [RabyColors.paper, RabyColors.surfaceWarm],
      ),
      child: Row(
        children: [
          const RabySticker(icon: RabyIconKind.chart, size: 52),
          const SizedBox(width: RabySpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('趋势会自动生成', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  '记录两次以上体重后,这里会显示变化曲线和稳定性分析。',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: RabyColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NoRabbitWeightCard extends StatelessWidget {
  const _NoRabbitWeightCard({required this.onCreateRabbit});

  final VoidCallback onCreateRabbit;

  @override
  Widget build(BuildContext context) {
    return RabyStateCard(
      icon: RabyIconKind.rabbit,
      title: '请先建立兔兔档案',
      message: '体重趋势需要挂在一只兔兔档案下面。',
      actionLabel: '建立兔兔档案',
      actionIcon: RabyIconKind.add,
      tone: RabyStateTone.warm,
      onAction: onCreateRabbit,
    );
  }
}

enum _WeightRecordAction { edit, delete }

enum _WeightRange {
  week('7天', 7),
  month('30天', 30),
  year('1年', 365),
  all('全部', null);

  const _WeightRange(this.label, this.days);

  final String label;
  final int? days;

  List<WeightRecord> filter(List<WeightRecord> records) {
    final days = this.days;
    if (days == null || records.isEmpty) {
      return records;
    }
    final latestRecordedAt = records.last.recordedAt;
    final cutoff = latestRecordedAt.subtract(Duration(days: days - 1));
    return records
        .where((record) => !record.recordedAt.isBefore(cutoff))
        .toList(growable: false);
  }
}

List<WeightRecord> _ascending(List<WeightRecord> records) {
  return [...records]..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
}

List<WeightRecord> _descending(List<WeightRecord> records) {
  return [...records]..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
}

String _formatGrams(int grams) => '$grams g';

String _formatDate(DateTime date) {
  final local = date.toLocal();
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  return '${local.year}-$month-$day';
}

String _deltaText(int? delta) {
  if (delta == null) {
    return '第一条记录';
  }
  if (delta == 0) {
    return '与上次持平';
  }
  final sign = delta > 0 ? '+' : '';
  return '$sign${delta}g 较上次';
}
