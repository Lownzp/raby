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
import '../../../shared/widgets/raby_image_slot.dart';
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
        icon: RabyIconKind.calendar,
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
        if (records.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _WeightSummaryCard(
                records: records,
                analysisRecords: const [],
                rabbit: widget.rabbit,
                range: _selectedRange,
              ),
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
            _WeightSummaryCard(
              records: records,
              analysisRecords: rangedChartRecords,
              rabbit: widget.rabbit,
              range: _selectedRange,
            ),
            const SizedBox(height: RabySpacing.md),
            _RangeSelector(
              selected: _selectedRange,
              onChanged: (range) => setState(() => _selectedRange = range),
            ),
            const SizedBox(height: RabySpacing.md),
            _WeightChartCard(records: rangedChartRecords),
            const SizedBox(height: RabySpacing.md),
            _WeightAnalysisCard(
              records: rangedChartRecords,
              range: _selectedRange,
            ),
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
  const _WeightSummaryCard({
    required this.records,
    required this.analysisRecords,
    required this.rabbit,
    required this.range,
  });

  final List<WeightRecord> records;
  final List<WeightRecord> analysisRecords;
  final Rabbit rabbit;
  final _WeightRange range;

  @override
  Widget build(BuildContext context) {
    final latest = records.isEmpty ? null : records.first;
    final rangeDelta = analysisRecords.length < 2
        ? null
        : analysisRecords.last.weightGrams - analysisRecords.first.weightGrams;

    return RabyCard(
      radius: RabyRadius.lg,
      color: RabyColors.surfaceSoft,
      borderColor: RabyColors.borderWarm,
      child: Row(
        children: [
          if (rabbit.avatarPath == null || rabbit.avatarPath!.isEmpty)
            const RabyImageSlot(
              width: 68,
              height: 68,
              radius: RabyRadius.md,
              semanticLabel: '待替换兔兔头像',
            )
          else
            RabbitAvatar(
              avatarPath: rabbit.avatarPath,
              size: 68,
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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontFamily: 'RabyChillRoundM',
                  ),
                ),
                const SizedBox(height: 2),
                if (latest == null)
                  Text('暂无体重数据', style: Theme.of(context).textTheme.titleLarge)
                else
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${latest.weightGrams}',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        TextSpan(
                          text: ' g',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 2),
                Text(
                  latest == null
                      ? '${rabbit.name} 还没有称重记录。'
                      : _rangeSummary(
                          range,
                          analysisRecords.length,
                          rangeDelta,
                        ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: RabyColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: RabySpacing.sm),
          const RabyImageSlot(
            width: 54,
            height: 54,
            radius: RabyRadius.md,
            placeholderColor: RabyColors.surfaceWarm,
            semanticLabel: '待替换体重秤插图',
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
      radius: RabyRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '体重趋势 (g)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: RabyColors.secondary,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 22,
                    height: 3,
                    decoration: BoxDecoration(
                      color: RabyColors.chartLine,
                      borderRadius: BorderRadius.circular(RabyRadius.pill),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    records.length < 2 ? '至少2条' : '${records.length}次称重',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: RabyColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: RabySpacing.ms),
          SizedBox(
            height: 220,
            child: records.length < 2
                ? const Center(child: RabyMutedText('记录两次体重后，这里会显示趋势线。'))
                : LineChart(_chartData(context, records)),
          ),
          if (records.length >= 2) ...[
            const SizedBox(height: RabySpacing.ms),
            const Divider(height: 1),
            const SizedBox(height: RabySpacing.ms),
            _WeightStats(records: records),
          ],
        ],
      ),
    );
  }

  LineChartData _chartData(BuildContext context, List<WeightRecord> records) {
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
        : math.max(span * 0.18, 20).toDouble();
    final rawInterval = math.max(span / 4, 20).toDouble();
    final verticalInterval = (rawInterval / 10).ceil() * 10.0;
    final minY = math
        .max(
          0,
          ((minWeight - padding) / verticalInterval).floor() * verticalInterval,
        )
        .toDouble();
    final maxY =
        ((maxWeight + padding) / verticalInterval).ceil() * verticalInterval;
    final horizontalInterval = records.length <= 4
        ? 1.0
        : (records.length - 1) / 3;
    final axisStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
      color: RabyColors.textSecondary,
      fontSize: 10,
    );

    return LineChartData(
      minX: 0,
      maxX: (records.length - 1).toDouble(),
      minY: minY,
      maxY: maxY,
      clipData: const FlClipData.none(),
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => RabyColors.surfaceSoft,
          tooltipBorder: const BorderSide(color: RabyColors.borderWarm),
          tooltipBorderRadius: BorderRadius.circular(RabyRadius.sm),
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          getTooltipItems: (spots) => [
            for (final spot in spots)
              LineTooltipItem(
                '${spot.y.round()}g',
                const TextStyle(
                  color: RabyColors.secondary,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
      gridData: FlGridData(
        drawVerticalLine: false,
        horizontalInterval: verticalInterval,
        getDrawingHorizontalLine: (_) =>
            const FlLine(color: RabyColors.border, strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 38,
            interval: verticalInterval,
            getTitlesWidget: (value, meta) => SideTitleWidget(
              meta: meta,
              space: 6,
              child: Text('${value.round()}', style: axisStyle),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 26,
            interval: horizontalInterval,
            getTitlesWidget: (value, meta) {
              final index = value.round();
              if (index < 0 ||
                  index >= records.length ||
                  (value - index).abs() > 0.01) {
                return const SizedBox.shrink();
              }
              return SideTitleWidget(
                meta: meta,
                space: 7,
                child: Text(
                  _formatMonthDay(records[index].recordedAt),
                  style: axisStyle,
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          curveSmoothness: 0.28,
          color: RabyColors.primary,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: records.length <= 16,
            getDotPainter: (spot, percent, barData, index) =>
                FlDotCirclePainter(
                  radius: index == records.length - 1 ? 5 : 3,
                  color: RabyColors.surface,
                  strokeWidth: 2,
                  strokeColor: RabyColors.chartLine,
                ),
          ),
          belowBarData: BarAreaData(
            show: true,
            color: RabyColors.primary.withValues(alpha: 0.14),
          ),
        ),
      ],
    );
  }
}

class _WeightStats extends StatelessWidget {
  const _WeightStats({required this.records});

  final List<WeightRecord> records;

  @override
  Widget build(BuildContext context) {
    final highest = records.reduce(
      (current, record) =>
          record.weightGrams > current.weightGrams ? record : current,
    );
    final lowest = records.reduce(
      (current, record) =>
          record.weightGrams < current.weightGrams ? record : current,
    );
    final average =
        records.fold<int>(0, (sum, record) => sum + record.weightGrams) ~/
        records.length;

    return Row(
      children: [
        Expanded(
          child: _WeightMetric(
            label: '最高',
            value: '${highest.weightGrams}g',
            caption: _formatMonthDay(highest.recordedAt),
          ),
        ),
        const SizedBox(height: 54, child: VerticalDivider(width: 1)),
        Expanded(
          child: _WeightMetric(
            label: '最低',
            value: '${lowest.weightGrams}g',
            caption: _formatMonthDay(lowest.recordedAt),
          ),
        ),
        const SizedBox(height: 54, child: VerticalDivider(width: 1)),
        Expanded(
          child: _WeightMetric(
            label: '平均',
            value: '${average}g',
            caption: '${records.length} 条记录',
          ),
        ),
      ],
    );
  }
}

class _WeightMetric extends StatelessWidget {
  const _WeightMetric({
    required this.label,
    required this.value,
    required this.caption,
  });

  final String label;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: RabyColors.textSecondary),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(value, style: Theme.of(context).textTheme.titleMedium),
        ),
        const SizedBox(height: 2),
        Text(
          caption,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: RabyColors.textSecondary),
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
    return SegmentedButton<_WeightRange>(
      segments: [
        for (final range in _WeightRange.values)
          ButtonSegment(
            value: range,
            label: Text(
              range.label,
              style: const TextStyle(fontFamily: 'RabyChillRoundF'),
            ),
          ),
      ],
      selected: {selected},
      showSelectedIcon: false,
      expandedInsets: EdgeInsets.zero,
      onSelectionChanged: (values) => onChanged(values.single),
    );
  }
}

class _WeightAnalysisCard extends StatelessWidget {
  const _WeightAnalysisCard({required this.records, required this.range});

  final List<WeightRecord> records;
  final _WeightRange range;

  @override
  Widget build(BuildContext context) {
    final delta = records.length > 1
        ? records.last.weightGrams - records.first.weightGrams
        : 0;
    final sign = delta > 0 ? '+' : '';
    final tone = delta.abs() <= 80 ? '变化平缓' : '变化明显';

    return RabyCard(
      color: RabyColors.surfaceSoft,
      borderColor: RabyColors.borderWarm,
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
                      : '${range.analysisLabel} $sign${delta}g',
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
                records.length < 2 ? '继续记录' : tone,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: RabyColors.success,
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

    return RabyCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              RabySpacing.md,
              RabySpacing.md,
              RabySpacing.md,
              RabySpacing.ms,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '记录明细',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(
                  '共 ${records.length} 条记录',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: RabyColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          for (var i = 0; i < records.length; i += 1) ...[
            _WeightRecordTile(
              record: records[i],
              delta: i == records.length - 1
                  ? null
                  : records[i].weightGrams - records[i + 1].weightGrams,
              onEdit: () => onEdit(records[i]),
              onDelete: () => onDelete(records[i]),
            ),
            if (i != records.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}

class _WeightRecordTile extends StatelessWidget {
  const _WeightRecordTile({
    required this.record,
    required this.delta,
    required this.onEdit,
    required this.onDelete,
  });

  final WeightRecord record;
  final int? delta;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
          child: Row(
            children: [
              SizedBox(
                width: 62,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatMonthDay(record.recordedAt),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(
                      '${record.recordedAt.toLocal().year}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: RabyColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: RabySpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _formatGrams(record.weightGrams),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(width: RabySpacing.sm),
                        Text(
                          _compactDelta(delta),
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: delta == null
                                    ? RabyColors.textSecondary
                                    : RabyColors.accent,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      record.note == null || record.note!.trim().isEmpty
                          ? '没有备注'
                          : record.note!.trim(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
                padding: EdgeInsets.zero,
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
      message: '先记录一次称重，后续就能看到趋势变化。',
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
      color: RabyColors.surfaceSoft,
      borderColor: RabyColors.borderWarm,
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
                  '记录两次以上体重后，这里会显示变化曲线和稳定性分析。',
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
  quarter('90天', 90),
  all('全部', null);

  const _WeightRange(this.label, this.days);

  final String label;
  final int? days;

  String get analysisLabel => switch (this) {
    _WeightRange.week => '近7天',
    _WeightRange.month => '近30天',
    _WeightRange.quarter => '近90天',
    _WeightRange.all => '全部记录',
  };

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

String _formatGrams(int grams) => '$grams g';

String _formatMonthDay(DateTime date) {
  final local = date.toLocal();
  return '${local.month}/${local.day}';
}

String _compactDelta(int? delta) {
  if (delta == null) {
    return '首条';
  }
  if (delta == 0) {
    return '持平';
  }
  final sign = delta > 0 ? '+' : '';
  return '$sign${delta}g';
}

String _rangeSummary(_WeightRange range, int recordCount, int? delta) {
  if (recordCount < 2 || delta == null) {
    return '${range.analysisLabel}记录不足';
  }
  if (delta.abs() <= 80) {
    return '${range.analysisLabel}变化平缓';
  }
  final sign = delta > 0 ? '+' : '';
  return '${range.analysisLabel} $sign${delta}g';
}
