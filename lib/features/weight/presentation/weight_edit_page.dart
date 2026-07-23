import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ruler_scale_picker/ruler_scale_picker.dart';

import '../../../app/providers/repository_providers.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/raby_colors.dart';
import '../../../app/theme/raby_tokens.dart';
import '../../../domain/domain_validation_exception.dart';
import '../../../domain/models/rabbit.dart';
import '../../../domain/models/weight_record.dart';
import '../../../shared/navigation/raby_shell.dart';
import '../../../shared/widgets/raby_card.dart';
import '../../../shared/widgets/raby_page.dart';
import '../../../shared/widgets/raby_sketch_icon.dart';
import '../../rabbits/application/current_rabbit_providers.dart';
import '../application/weight_editor_controller.dart';
import '../application/weight_providers.dart';

class WeightEditPage extends ConsumerStatefulWidget {
  const WeightEditPage({
    this.recordId,
    this.returnToPrevious = false,
    super.key,
  });

  final String? recordId;
  final bool returnToPrevious;

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
          _leaveEditor();
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
                      onBack: _leaveEditor,
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
          return _MissingWeightCard(onBack: _leaveEditor);
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
      _leaveEditor();
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

  void _leaveEditor() {
    if (widget.returnToPrevious && context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutes.weight);
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
    final weightTextStyle = Theme.of(context).textTheme.headlineMedium
        ?.copyWith(
          color: RabyColors.secondary,
          fontSize: 58,
          fontWeight: FontWeight.w900,
          height: 1,
        );
    final weightText = weightController.text.trim().isEmpty
        ? '1820'
        : weightController.text.trim();
    final weightTextPainter = TextPainter(
      text: TextSpan(text: weightText, style: weightTextStyle),
      textDirection: Directionality.of(context),
      maxLines: 1,
    )..layout();
    final weightInputWidth = (weightTextPainter.width + 3).clamp(80.0, 168.0);
    const supportingCardColor = RabyColors.surface;
    const saveButtonShadow = [
      BoxShadow(
        color: Color(0x20FFAB1A),
        blurRadius: 20,
        spreadRadius: 0.5,
        offset: Offset(0, 5),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RabyCard(
          color: supportingCardColor,
          borderColor: RabyColors.stickerBorder,
          borderWidth: 0,
          radius: RabyRadius.lg,
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
          child: Row(
            children: [
              _RabbitProfileSticker(name: rabbit.name),
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
                        fontSize: 20,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      previousRecord == null
                          ? '还没有上次记录'
                          : '上次记录 · ${_formatMonthDay(previousRecord!.recordedAt)} · ${previousRecord!.weightGrams}g',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: RabyColors.textSecondary,
                        fontSize: 14,
                        height: 1.3,
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
          color: const Color(0xFFFCEDCF),
          borderColor: RabyColors.stickerBorder,
          borderWidth: 4,
          padding: const EdgeInsets.fromLTRB(12, 18, 12, 18),
          child: Column(
            children: [
              Text(
                '体重',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: RabyColors.secondary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    _RoundStepButton(
                      icon: RabyIconKind.minus,
                      enabled: enabled,
                      onTap: () => _adjustWeight(weightController, -10),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: weightInputWidth,
                            child: TextField(
                              controller: weightController,
                              enabled: enabled,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: weightTextStyle,
                              decoration: InputDecoration(
                                hintText: '1820',
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
                          const SizedBox(width: 4),
                          Padding(
                            padding: const EdgeInsets.only(top: 18),
                            child: Text(
                              'g',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: RabyColors.textSecondary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _RoundStepButton(
                      icon: RabyIconKind.add,
                      enabled: enabled,
                      onTap: () => _adjustWeight(weightController, 10),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _WeightRuler(
                weightController: weightController,
                enabled: enabled,
              ),
            ],
          ),
        ),
        const SizedBox(height: RabySpacing.ms),
        RabyCard(
          color: supportingCardColor,
          borderWidth: 0,
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
          color: supportingCardColor,
          borderWidth: 0,
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
          color: supportingCardColor,
          borderWidth: 0,
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
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RabyRadius.pill),
            boxShadow: saveButtonShadow,
          ),
          child: SizedBox(
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
        ),
      ],
    );
  }
}

class _RabbitProfileSticker extends StatelessWidget {
  const _RabbitProfileSticker({required this.name});

  static const _asset = 'assets/images/rabbits/home/rabbit_home_sticker_01.png';
  static const _outlineOffsets = [
    Offset(-3, 0),
    Offset(3, 0),
    Offset(0, -3),
    Offset(0, 3),
    Offset(-2.2, -2.2),
    Offset(2.2, -2.2),
    Offset(-2.2, 2.2),
    Offset(2.2, 2.2),
  ];

  final String name;

  @override
  Widget build(BuildContext context) {
    Widget image({Color? color}) => Image.asset(
      _asset,
      width: 76,
      height: 76,
      fit: BoxFit.contain,
      color: color,
      colorBlendMode: color == null ? null : BlendMode.srcIn,
    );

    return Semantics(
      image: true,
      label: '$name兔兔贴纸',
      child: SizedBox.square(
        dimension: 82,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Transform.translate(
              offset: const Offset(0, 4),
              child: ImageFiltered(
                imageFilter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    Color(0x295A2A16),
                    BlendMode.srcIn,
                  ),
                  child: image(),
                ),
              ),
            ),
            for (final offset in _outlineOffsets)
              Transform.translate(
                offset: offset,
                child: image(color: Colors.white),
              ),
            image(),
          ],
        ),
      ),
    );
  }
}

class _WeightRuler extends StatefulWidget {
  const _WeightRuler({required this.weightController, required this.enabled});

  final TextEditingController weightController;
  final bool enabled;

  @override
  State<_WeightRuler> createState() => _WeightRulerState();
}

class _WeightRulerState extends State<_WeightRuler> {
  late final NumericRulerScalePickerController _rulerController;
  bool _syncingFromText = false;

  @override
  void initState() {
    super.initState();
    final initialValue =
        (int.tryParse(widget.weightController.text.trim()) ?? 1800).clamp(
          1000,
          2500,
        );
    _rulerController = NumericRulerScalePickerController(
      firstValue: 1000,
      lastValue: 2500,
      interval: 10,
      initialValue: initialValue,
    )..addListener(_onRulerChanged);
    widget.weightController.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(_WeightRuler oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.weightController != widget.weightController) {
      oldWidget.weightController.removeListener(_onTextChanged);
      widget.weightController.addListener(_onTextChanged);
      _onTextChanged();
    }
  }

  @override
  void dispose() {
    widget.weightController.removeListener(_onTextChanged);
    _rulerController
      ..removeListener(_onRulerChanged)
      ..dispose();
    super.dispose();
  }

  void _onRulerChanged() {
    if (_syncingFromText) {
      return;
    }
    final value = _rulerController.value;
    if (widget.weightController.text != value.toString()) {
      widget.weightController
        ..text = value.toString()
        ..selection = TextSelection.collapsed(offset: value.toString().length);
    }
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      HapticFeedback.selectionClick();
    }
  }

  void _onTextChanged() {
    final value = int.tryParse(widget.weightController.text.trim());
    if (value == null || value < 1000 || value > 2500) {
      return;
    }
    final snappedValue = ((value / 10).round() * 10).clamp(1000, 2500);
    if (_rulerController.value == snappedValue) {
      return;
    }
    _syncingFromText = true;
    _rulerController.setValue(snappedValue);
    _syncingFromText = false;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 78,
      child: NumericRulerScalePicker(
        key: const ValueKey('weight-ruler'),
        controller: _rulerController,
        options: RulerScalePickerOptions(
          isEnabled: widget.enabled,
          showControls: false,
          majorIndicatorInterval: 10,
          indicatorExtend: 8,
        ),
        scaleMarkerBuilder: (_, _) => const SizedBox.shrink(),
        scaleIndicatorBuilder:
            (context, _, value, {required isMajorIndicator}) {
              final isSelected = value == _rulerController.value;
              return OverflowBox(
                minWidth: 8,
                maxWidth: 56,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: isSelected
                          ? 5
                          : isMajorIndicator
                          ? 2
                          : 1,
                      height: isSelected
                          ? 30
                          : isMajorIndicator
                          ? 24
                          : 13,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? RabyColors.primaryDeep
                            : isMajorIndicator
                            ? RabyColors.primaryDeep
                            : RabyColors.borderWarm,
                        borderRadius: BorderRadius.circular(RabyRadius.pill),
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      height: 18,
                      child: isMajorIndicator
                          ? Text(
                              '$value',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: RabyColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            )
                          : null,
                    ),
                  ],
                ),
              );
            },
      ),
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
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: enabled ? RabyColors.surfaceWarm : RabyColors.paper,
        border: Border.all(
          color: enabled ? RabyColors.primary : RabyColors.borderWarm,
          width: 0.6,
        ),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: RabyColors.primary.withValues(alpha: 0.14),
                  blurRadius: 16,
                  spreadRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ]
            : const [],
      ),
      child: Material(
        type: MaterialType.transparency,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          customBorder: const CircleBorder(),
          splashColor: RabyColors.primary.withValues(alpha: 0.16),
          highlightColor: RabyColors.primary.withValues(alpha: 0.08),
          onTap: enabled ? onTap : null,
          child: SizedBox.square(
            dimension: 44,
            child: Center(
              child: _StepGlyph(
                kind: icon,
                color: enabled
                    ? RabyColors.primaryDeep
                    : RabyColors.textTertiary,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StepGlyph extends StatelessWidget {
  const _StepGlyph({
    required this.kind,
    required this.color,
    required this.size,
  });

  final RabyIconKind kind;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    const strokeWidth = 3.0;
    final lineDecoration = BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(strokeWidth),
    );
    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: strokeWidth,
            child: DecoratedBox(decoration: lineDecoration),
          ),
          if (kind == RabyIconKind.add)
            SizedBox(
              width: strokeWidth,
              height: size,
              child: DecoratedBox(decoration: lineDecoration),
            ),
        ],
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

String _formatMonthDay(DateTime date) {
  final local = date.toLocal();
  return '${local.month}月${local.day}日';
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
