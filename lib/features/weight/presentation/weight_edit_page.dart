import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers/repository_providers.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/raby_colors.dart';
import '../../../app/theme/raby_tokens.dart';
import '../../../domain/domain_validation_exception.dart';
import '../../../domain/models/rabbit.dart';
import '../../../domain/models/weight_record.dart';
import '../../../shared/navigation/raby_shell.dart';
import '../../../shared/widgets/raby_card.dart';
import '../../../shared/widgets/raby_image_slot.dart';
import '../../../shared/widgets/raby_page.dart';
import '../../../shared/widgets/raby_sketch_icon.dart';
import '../../../shared/widgets/rabbit_avatar.dart';
import '../../rabbits/application/current_rabbit_providers.dart';
import '../application/weight_editor_controller.dart';
import '../application/weight_providers.dart';

class WeightEditPage extends ConsumerStatefulWidget {
  const WeightEditPage({this.recordId, super.key});

  final String? recordId;

  @override
  ConsumerState<WeightEditPage> createState() => _WeightEditPageState();
}

class _WeightEditPageState extends ConsumerState<WeightEditPage> {
  final _weightController = TextEditingController();
  final _noteController = TextEditingController();
  late DateTime _recordedAt;
  bool _initialized = false;
  bool _isHydrating = false;
  bool _isSaving = false;
  bool _hasTriedSubmit = false;

  bool get _isEditing => widget.recordId != null;
  bool get _canSave =>
      !_isSaving &&
      _weightController.text.trim().isNotEmpty &&
      _weightError == null;

  String? get _weightError {
    final rawValue = _weightController.text.trim();
    if (rawValue.isEmpty) {
      return _hasTriedSubmit ? '请输入体重' : null;
    }
    final value = int.tryParse(rawValue);
    if (value == null) {
      return '请输入整数克重';
    }
    if (value <= 0 || value > 20000) {
      return '体重需要在 1-20000g 之间';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _recordedAt = ref.read(clockProvider)();
    _weightController.addListener(_onInputChanged);
    _noteController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    _weightController
      ..removeListener(_onInputChanged)
      ..dispose();
    _noteController
      ..removeListener(_onInputChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rabbitState = ref.watch(currentRabbitProvider);
    final canPickDate = rabbitState.maybeWhen(
      data: (rabbit) => rabbit != null,
      orElse: () => false,
    );
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && !_isSaving) {
          context.go(AppRoutes.weight);
        }
      },
      child: Scaffold(
        bottomNavigationBar: const RabyBottomNavigation(
          currentPath: AppRoutes.weight,
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  RabySpacing.md,
                  RabySpacing.sm,
                  RabySpacing.md,
                  RabySpacing.lg,
                ),
                sliver: SliverList.list(
                  children: [
                    RabyTopBar(
                      title: _isEditing ? '编辑体重' : '记录体重',
                      onBack: () => context.go(AppRoutes.weight),
                      actionIcon: RabyIconKind.calendar,
                      actionTooltip: canPickDate ? '选择日期' : '请先建立兔兔档案',
                      onAction: canPickDate ? _pickDate : null,
                      enabled: !_isSaving,
                    ),
                    const SizedBox(height: RabySpacing.md),
                    rabbitState.when(
                      data: (rabbit) {
                        if (rabbit == null) {
                          return _NoRabbitCard(
                            onCreateRabbit: () =>
                                context.go(AppRoutes.onboardingRabbit),
                          );
                        }
                        if (_isEditing) {
                          return _buildEditState(rabbit);
                        }
                        final weightRecords = ref.watch(
                          weightRecordsProvider(rabbit.id),
                        );
                        final latestRecord = weightRecords.maybeWhen(
                          data: (records) =>
                              records.isEmpty ? null : records.first,
                          orElse: () => null,
                        );
                        _hydrateInitialWeight(
                          latestRecord?.weightGrams ??
                              rabbit.initialWeightGrams,
                        );
                        return _WeightEditorForm(
                          rabbit: rabbit,
                          previousRecord: latestRecord,
                          weightController: _weightController,
                          noteController: _noteController,
                          recordedAt: _recordedAt,
                          enabled: !_isSaving,
                          isSaving: _isSaving,
                          weightError: _weightError,
                          onPickDate: _pickDate,
                          onSubmit: _canSave ? _submit : null,
                        );
                      },
                      loading: () => const RabyCard(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (error, _) => RabyCard(
                        borderColor: RabyColors.danger,
                        child: Text('档案读取失败: $error'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditState(Rabbit rabbit) {
    final recordId = widget.recordId;
    if (recordId == null) {
      return const SizedBox.shrink();
    }

    final recordState = ref.watch(
      weightRecordProvider((rabbitId: rabbit.id, recordId: recordId)),
    );
    return recordState.when(
      data: (record) {
        if (record == null) {
          return _MissingWeightCard(onBack: () => context.go(AppRoutes.weight));
        }
        _hydrate(record);
        final previousRecord = ref
            .watch(weightRecordsProvider(rabbit.id))
            .maybeWhen(
              data: (records) {
                for (final item in records) {
                  if (item.id != record.id) {
                    return item;
                  }
                }
                return null;
              },
              orElse: () => null,
            );
        return _WeightEditorForm(
          rabbit: rabbit,
          previousRecord: previousRecord,
          weightController: _weightController,
          noteController: _noteController,
          recordedAt: _recordedAt,
          enabled: !_isSaving,
          isSaving: _isSaving,
          weightError: _weightError,
          onPickDate: _pickDate,
          onSubmit: _canSave ? () => _submit(existing: record) : null,
        );
      },
      loading: () =>
          const RabyCard(child: Center(child: CircularProgressIndicator())),
      error: (error, _) => RabyCard(
        borderColor: RabyColors.danger,
        child: Text('体重读取失败: $error'),
      ),
    );
  }

  void _hydrate(WeightRecord record) {
    if (_initialized) {
      return;
    }
    _isHydrating = true;
    _weightController.text = record.weightGrams.toString();
    _noteController.text = record.note ?? '';
    _recordedAt = record.recordedAt;
    _initialized = true;
    _isHydrating = false;
  }

  void _hydrateInitialWeight(int? weightGrams) {
    if (_initialized || weightGrams == null) {
      return;
    }
    _isHydrating = true;
    _weightController.text = weightGrams.toString();
    _initialized = true;
    _isHydrating = false;
  }

  void _onInputChanged() {
    if (!mounted || _isHydrating) {
      return;
    }
    setState(() {});
  }

  Future<void> _pickDate() async {
    final firstDate = DateTime(1990);
    final today = _today();
    final selected = await showDatePicker(
      context: context,
      locale: const Locale('zh', 'CN'),
      initialDate: _clampDate(_recordedAt.toLocal(), firstDate, today),
      firstDate: firstDate,
      lastDate: today,
    );
    if (selected == null || !mounted) {
      return;
    }
    setState(() {
      _recordedAt = DateTime(
        selected.year,
        selected.month,
        selected.day,
        12,
      ).toUtc();
    });
  }

  Future<void> _submit({WeightRecord? existing}) async {
    setState(() => _hasTriedSubmit = true);
    final weight = int.tryParse(_weightController.text.trim());
    if (weight == null || _weightError != null) {
      return;
    }

    final rabbit = ref
        .read(currentRabbitProvider)
        .maybeWhen(data: (rabbit) => rabbit, orElse: () => null);
    if (rabbit == null) {
      return;
    }

    final input = WeightEditorInput(
      rabbitId: rabbit.id,
      recordedAt: _recordedAt,
      weightGrams: weight,
      note: _noteController.text,
    );
    final controller = ref.read(weightEditorControllerProvider);

    setState(() => _isSaving = true);
    try {
      if (existing == null) {
        await controller.create(input);
      } else {
        await controller.update(existing: existing, input: input);
      }
      if (!mounted) {
        return;
      }
      context.go(AppRoutes.weight);
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_errorMessage(error))));
    }
  }

  DateTime _today() {
    final now = ref.read(clockProvider)().toLocal();
    return DateTime(now.year, now.month, now.day);
  }
}

class _WeightEditorForm extends StatelessWidget {
  const _WeightEditorForm({
    required this.rabbit,
    required this.previousRecord,
    required this.weightController,
    required this.noteController,
    required this.recordedAt,
    required this.enabled,
    required this.isSaving,
    required this.weightError,
    required this.onPickDate,
    required this.onSubmit,
  });

  final Rabbit rabbit;
  final WeightRecord? previousRecord;
  final TextEditingController weightController;
  final TextEditingController noteController;
  final DateTime recordedAt;
  final bool enabled;
  final bool isSaving;
  final String? weightError;
  final VoidCallback onPickDate;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    final currentWeight = int.tryParse(weightController.text.trim());
    final previousWeight = previousRecord?.weightGrams;
    final change = currentWeight == null || previousWeight == null
        ? null
        : currentWeight - previousWeight;
    final changeLabel = change == null
        ? '首次记录'
        : change == 0
        ? '与上次相同'
        : '比上次 ${change > 0 ? '+' : ''}${change}g';
    final statusLabel = change == null || change.abs() <= 20
        ? '平稳'
        : change > 0
        ? '上升'
        : '下降';
    final sliderValue = (currentWeight ?? 1800).clamp(1000, 2500).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RabyCard(
          color: RabyColors.surfaceSoft,
          borderColor: RabyColors.stickerBorder,
          radius: RabyRadius.lg,
          padding: const EdgeInsets.all(RabySpacing.ms),
          child: Row(
            children: [
              if (rabbit.avatarPath == null || rabbit.avatarPath!.isEmpty)
                const RabyImageSlot(
                  width: 58,
                  height: 58,
                  radius: RabyRadius.pill,
                  semanticLabel: '兔兔头像待替换',
                )
              else
                RabbitAvatar(
                  avatarPath: rabbit.avatarPath,
                  size: 58,
                  iconSize: 28,
                  borderWidth: 3,
                  borderColor: RabyColors.stickerBorder,
                ),
              const SizedBox(width: RabySpacing.ms),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rabbit.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: RabyColors.secondary,
                        fontFamily: 'RabyChillRoundM',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      previousRecord == null
                          ? '还没有上次记录'
                          : '上次记录：${_formatDate(previousRecord!.recordedAt)} · ${previousRecord!.weightGrams}g',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: RabyColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: RabySpacing.ms),
        RabyCard(
          radius: RabyRadius.lg,
          color: RabyColors.surfaceSoft,
          padding: const EdgeInsets.fromLTRB(12, 14, 12, 10),
          child: Column(
            children: [
              Text(
                '体重 (g)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: RabyColors.secondary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: RabySpacing.sm),
              Row(
                children: [
                  _RoundStepButton(
                    icon: RabyIconKind.minus,
                    enabled: enabled,
                    onTap: () => _adjustWeight(weightController, -10),
                  ),
                  Expanded(
                    child: TextField(
                      controller: weightController,
                      enabled: enabled,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: RabyColors.secondary,
                            fontSize: 58,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                      decoration: InputDecoration(
                        hintText: '1820',
                        suffixText: 'g',
                        suffixStyle: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: RabyColors.textSecondary),
                        errorText: weightError,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  _RoundStepButton(
                    icon: RabyIconKind.add,
                    enabled: enabled,
                    onTap: () => _adjustWeight(weightController, 10),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: RabyColors.primary,
                  inactiveTrackColor: RabyColors.borderWarm,
                  thumbColor: RabyColors.primaryDeep,
                  overlayColor: RabyColors.primary.withValues(alpha: 0.12),
                  trackHeight: 3,
                ),
                child: Slider(
                  value: sliderValue,
                  min: 1000,
                  max: 2500,
                  divisions: 150,
                  onChanged: enabled
                      ? (value) =>
                            weightController.text = value.round().toString()
                      : null,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('1000'),
                    Text('1500'),
                    Text('2000'),
                    Text('2500'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: RabySpacing.ms),
        RabyCard(
          padding: EdgeInsets.zero,
          child: ListTile(
            enabled: enabled,
            dense: true,
            minVerticalPadding: RabySpacing.sm,
            leading: const RabySketchIcon(
              kind: RabyIconKind.calendar,
              color: RabyColors.primary,
            ),
            title: Text('记录日期', style: Theme.of(context).textTheme.titleSmall),
            subtitle: Text(_formatDate(recordedAt)),
            trailing: const RabySketchIcon(kind: RabyIconKind.chevronRight),
            onTap: enabled ? onPickDate : null,
          ),
        ),
        const SizedBox(height: RabySpacing.ms),
        RabyCard(
          color: RabyColors.surfaceSoft,
          padding: const EdgeInsets.all(RabySpacing.ms),
          child: Row(
            children: [
              const RabySticker(
                icon: RabyIconKind.chart,
                size: 50,
                background: RabyColors.surfaceWarm,
              ),
              const SizedBox(width: RabySpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      changeLabel,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    const RabyMutedText('变化会自动同步到体重趋势。'),
                  ],
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: RabyColors.successSoft,
                  borderRadius: BorderRadius.circular(RabyRadius.pill),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  child: Text(
                    statusLabel,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: RabyColors.success,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: RabySpacing.ms),
        RabyCard(
          padding: const EdgeInsets.all(RabySpacing.ms),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '备注',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: RabyColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: RabySpacing.sm),
              TextField(
                controller: noteController,
                enabled: enabled,
                maxLength: 200,
                minLines: 2,
                maxLines: 3,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(
                  hintText: '今天食欲、精神状态怎么样？',
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: RabySpacing.md),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: FilledButton.icon(
            onPressed: onSubmit,
            style: FilledButton.styleFrom(
              foregroundColor: RabyColors.onPrimary,
              disabledForegroundColor: RabyColors.textTertiary,
            ),
            icon: isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const RabySketchIcon(
                    kind: RabyIconKind.check,
                    color: RabyColors.onPrimary,
                  ),
            label: Text(
              isSaving ? '保存中' : '保存记录',
              style: const TextStyle(color: RabyColors.onPrimary),
            ),
          ),
        ),
      ],
    );
  }
}

class _RoundStepButton extends StatelessWidget {
  const _RoundStepButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final RabyIconKind icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: RabyColors.paper,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: enabled ? onTap : null,
        child: SizedBox.square(
          dimension: 44,
          child: Center(
            child: RabySketchIcon(
              kind: icon,
              color: enabled ? RabyColors.primaryDeep : RabyColors.textTertiary,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

void _adjustWeight(TextEditingController controller, int delta) {
  final current = int.tryParse(controller.text.trim()) ?? 1800;
  final next = (current + delta).clamp(1, 20000);
  controller.text = next.toString();
  controller.selection = TextSelection.collapsed(
    offset: controller.text.length,
  );
}

class _NoRabbitCard extends StatelessWidget {
  const _NoRabbitCard({required this.onCreateRabbit});

  final VoidCallback onCreateRabbit;

  @override
  Widget build(BuildContext context) {
    return RabyCard(
      borderColor: RabyColors.warning,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('请先建立兔兔档案', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: RabySpacing.xs),
          const RabyMutedText('体重记录需要挂在一只兔兔档案下面。'),
          const SizedBox(height: RabySpacing.md),
          FilledButton.icon(
            onPressed: onCreateRabbit,
            icon: const RabySketchIcon(kind: RabyIconKind.add),
            label: const Text('建立兔兔档案'),
          ),
        ],
      ),
    );
  }
}

class _MissingWeightCard extends StatelessWidget {
  const _MissingWeightCard({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return RabyCard(
      borderColor: RabyColors.warning,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('体重记录不存在或已删除', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: RabySpacing.xs),
          const RabyMutedText('回到体重页后,列表会显示当前可用的记录。'),
          const SizedBox(height: RabySpacing.md),
          FilledButton.icon(
            onPressed: onBack,
            icon: const RabySketchIcon(kind: RabyIconKind.back),
            label: const Text('返回体重页'),
          ),
        ],
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

DateTime _dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

DateTime _clampDate(DateTime date, DateTime firstDate, DateTime lastDate) {
  final value = _dateOnly(date);
  if (value.isBefore(firstDate)) {
    return firstDate;
  }
  if (value.isAfter(lastDate)) {
    return lastDate;
  }
  return value;
}

String _errorMessage(Object error) {
  if (error is DomainValidationException) {
    return error.message;
  }
  return error.toString();
}
