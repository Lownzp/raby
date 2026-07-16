import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/repository_providers.dart';
import '../../../../app/theme/raby_colors.dart';
import '../../../../app/theme/raby_tokens.dart';
import '../../../../domain/models/rabbit.dart';
import '../../../../domain/models/raby_enums.dart';
import '../../../../shared/widgets/raby_card.dart';
import '../../../../shared/widgets/raby_image_slot.dart';
import '../../../../shared/widgets/raby_sketch_icon.dart';
import '../../../../shared/widgets/rabbit_avatar.dart';
import '../../application/rabbit_avatar_picker_service.dart';
import '../../application/rabbit_form_controller.dart';

class RabbitForm extends ConsumerStatefulWidget {
  const RabbitForm({
    required this.submitLabel,
    required this.onSaved,
    this.existing,
    super.key,
  });

  final Rabbit? existing;
  final String submitLabel;
  final VoidCallback onSaved;

  @override
  ConsumerState<RabbitForm> createState() => _RabbitFormState();
}

class _RabbitFormState extends ConsumerState<RabbitForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _birthDateController;
  late final TextEditingController _adoptedDateController;
  late final TextEditingController _breedController;
  late final TextEditingController _furColorController;
  late final TextEditingController _initialWeightController;
  late RabbitSex _sex;
  late String? _avatarPath;
  String? _avatarLocalPath;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final rabbit = widget.existing;
    _nameController = TextEditingController(text: rabbit?.name ?? '');
    _birthDateController = TextEditingController(text: rabbit?.birthDate ?? '');
    _adoptedDateController = TextEditingController(
      text: rabbit?.adoptedDate ?? '',
    );
    _breedController = TextEditingController(text: rabbit?.breed ?? '');
    _furColorController = TextEditingController(text: rabbit?.furColor ?? '');
    _initialWeightController = TextEditingController(
      text: rabbit?.initialWeightGrams?.toString() ?? '',
    );
    _sex = rabbit?.sex ?? RabbitSex.unknown;
    _avatarPath = rabbit?.avatarPath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _adoptedDateController.dispose();
    _breedController.dispose();
    _furColorController.dispose();
    _initialWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AvatarField(
            avatarPath: _avatarPath,
            localPath: _avatarLocalPath,
            enabled: !_isSaving,
            onPick: _pickAvatar,
          ),
          const SizedBox(height: RabySpacing.md),
          RabyCard(
            radius: RabyRadius.lg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FieldLabel('基础信息'),
                const SizedBox(height: RabySpacing.md),
                TextFormField(
                  controller: _nameController,
                  maxLength: 20,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: '名字',
                    hintText: '例如 米粒',
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) {
                      return '请填写兔兔名字';
                    }
                    if (text.length > 20) {
                      return '名字最多 20 个字符';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: RabySpacing.sm),
                _FieldLabel('性别'),
                const SizedBox(height: RabySpacing.sm),
                SegmentedButton<RabbitSex>(
                  segments: const [
                    ButtonSegment(
                      value: RabbitSex.unknown,
                      label: Text(
                        '未知',
                        style: TextStyle(fontFamily: 'RabyChillRoundF'),
                      ),
                      icon: RabySketchIcon(kind: RabyIconKind.unknown),
                    ),
                    ButtonSegment(
                      value: RabbitSex.female,
                      label: Text(
                        '女孩',
                        style: TextStyle(fontFamily: 'RabyChillRoundF'),
                      ),
                      icon: RabySketchIcon(kind: RabyIconKind.female),
                    ),
                    ButtonSegment(
                      value: RabbitSex.male,
                      label: Text(
                        '男孩',
                        style: TextStyle(fontFamily: 'RabyChillRoundF'),
                      ),
                      icon: RabySketchIcon(kind: RabyIconKind.male),
                    ),
                  ],
                  selected: {_sex},
                  showSelectedIcon: false,
                  expandedInsets: EdgeInsets.zero,
                  onSelectionChanged: _isSaving
                      ? null
                      : (values) => setState(() => _sex = values.single),
                ),
              ],
            ),
          ),
          const SizedBox(height: RabySpacing.md),
          RabyCard(
            radius: RabyRadius.lg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FieldLabel('时间和外观'),
                const SizedBox(height: RabySpacing.md),
                TextFormField(
                  controller: _birthDateController,
                  keyboardType: TextInputType.datetime,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: '生日',
                    hintText: 'yyyy-MM-dd',
                    suffixIcon: IconButton(
                      tooltip: '选择生日',
                      onPressed: _isSaving
                          ? null
                          : () => _pickDate(_birthDateController),
                      icon: const RabySketchIcon(kind: RabyIconKind.calendar),
                    ),
                  ),
                  validator: (value) => _validateDateGroup(value),
                ),
                const SizedBox(height: RabySpacing.sm),
                TextFormField(
                  controller: _adoptedDateController,
                  keyboardType: TextInputType.datetime,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: '领养日',
                    hintText: 'yyyy-MM-dd',
                    suffixIcon: IconButton(
                      tooltip: '选择领养日',
                      onPressed: _isSaving
                          ? null
                          : () => _pickDate(_adoptedDateController),
                      icon: const RabySketchIcon(kind: RabyIconKind.calendar),
                    ),
                  ),
                  validator: _validateOptionalDate,
                ),
                const SizedBox(height: RabySpacing.sm),
                TextFormField(
                  controller: _breedController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: '品种',
                    hintText: '例如 垂耳兔',
                  ),
                  validator: (value) =>
                      (value?.trim().isEmpty ?? true) ? '请填写品种' : null,
                ),
                const SizedBox(height: RabySpacing.sm),
                TextFormField(
                  controller: _furColorController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: '毛色',
                    hintText: '例如 奶油白',
                  ),
                  validator: (value) =>
                      (value?.trim().isEmpty ?? true) ? '请填写毛色' : null,
                ),
                const SizedBox(height: RabySpacing.sm),
                TextFormField(
                  controller: _initialWeightController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: '初始体重',
                    hintText: '例如 1820',
                    suffixText: 'g',
                  ),
                  validator: _validateInitialWeight,
                ),
              ],
            ),
          ),
          const SizedBox(height: RabySpacing.lg),
          SizedBox(
            width: double.infinity,
            height: 62,
            child: FilledButton.icon(
              onPressed: _isSaving ? null : _submit,
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const RabySketchIcon(kind: RabyIconKind.check),
              label: Text(_isSaving ? '保存中' : widget.submitLabel),
            ),
          ),
        ],
      ),
    );
  }

  String? _validateDateGroup(String? value) {
    final currentError = _validateOptionalDate(value);
    if (currentError != null) {
      return currentError;
    }
    if (_birthDateController.text.trim().isEmpty &&
        _adoptedDateController.text.trim().isEmpty) {
      return '生日和领养日至少填写一个';
    }
    return null;
  }

  String? _validateOptionalDate(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return null;
    }
    final datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!datePattern.hasMatch(text) || _parseDate(text) == null) {
      return '请使用 yyyy-MM-dd 格式';
    }
    final parsed = _parseDate(text)!;
    if (_dateOnly(parsed).isAfter(_today())) {
      return '日期不能晚于今天';
    }
    return null;
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final today = _today();
    final firstDate = DateTime(1990);
    final selected = await showDatePicker(
      context: context,
      locale: const Locale('zh', 'CN'),
      initialDate: _clampDate(
        _parseDate(controller.text) ?? today,
        firstDate,
        today,
      ),
      firstDate: firstDate,
      lastDate: today,
    );
    if (selected == null) {
      return;
    }
    controller.text = _formatDate(selected);
  }

  Future<void> _pickAvatar() async {
    if (_isSaving) {
      return;
    }
    try {
      final path = await ref
          .read(rabbitAvatarPickerServiceProvider)
          .pickAvatarPath();
      if (!mounted || path == null) {
        return;
      }
      setState(() => _avatarLocalPath = path);
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('头像选择失败: $error')));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final input = RabbitFormInput(
      name: _nameController.text,
      sex: _sex,
      birthDate: _birthDateController.text,
      adoptedDate: _adoptedDateController.text,
      breed: _breedController.text,
      furColor: _furColorController.text,
      initialWeightGrams: _initialWeightController.text.trim().isEmpty
          ? null
          : int.parse(_initialWeightController.text),
      avatarPath: _avatarPath,
      avatarLocalPath: _avatarLocalPath,
    );

    final controller = ref.read(rabbitFormControllerProvider);
    setState(() => _isSaving = true);
    try {
      if (widget.existing == null) {
        await controller.create(input);
      } else {
        await controller.updateRabbit(existing: widget.existing!, input: input);
      }
      if (!mounted) {
        return;
      }
      widget.onSaved();
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  DateTime _today() {
    final now = ref.read(clockProvider)().toLocal();
    return DateTime(now.year, now.month, now.day);
  }

  String? _validateInitialWeight(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return null;
    }
    final grams = int.tryParse(text);
    if (grams == null || grams < 1 || grams > 20000) {
      return '初始体重需要在 1-20000g 之间';
    }
    return null;
  }
}

class _AvatarField extends StatelessWidget {
  const _AvatarField({
    required this.avatarPath,
    required this.localPath,
    required this.enabled,
    required this.onPick,
  });

  final String? avatarPath;
  final String? localPath;
  final bool enabled;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    return RabyCard(
      radius: RabyRadius.lg,
      color: RabyColors.surfaceSoft,
      borderColor: RabyColors.borderWarm,
      child: InkWell(
        onTap: enabled ? onPick : null,
        borderRadius: BorderRadius.circular(RabyRadius.hero),
        child: Row(
          children: [
            if (localPath == null &&
                (avatarPath == null || avatarPath!.isEmpty))
              const RabyImageSlot(
                width: 78,
                height: 78,
                radius: RabyRadius.md,
                placeholderColor: RabyColors.surfaceWarm,
                semanticLabel: '待替换兔兔头像',
              )
            else
              RabbitAvatar(
                avatarPath: avatarPath,
                localPath: localPath,
                size: 78,
                iconSize: 38,
                borderWidth: 4,
                borderColor: RabyColors.stickerBorder,
              ),
            const SizedBox(width: RabySpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('头像', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: RabySpacing.xs),
                  Text(
                    localPath == null &&
                            (avatarPath == null || avatarPath!.isEmpty)
                        ? '选择一张正脸或日常照片作为档案头像。'
                        : '已选择头像，保存后会同步到档案。',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: RabyColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: enabled ? onPick : null,
              icon: const RabySketchIcon(kind: RabyIconKind.photo),
              label: const Text('选择'),
            ),
          ],
        ),
      ),
    );
  }
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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: RabyColors.secondary,
        fontWeight: FontWeight.w900,
        fontSize: 16,
      ),
    );
  }
}

DateTime? _parseDate(String value) {
  final text = value.trim();
  if (text.isEmpty) {
    return null;
  }
  try {
    final parts = text.split('-');
    if (parts.length != 3) {
      return null;
    }
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);
    final parsed = DateTime(year, month, day);
    if (parsed.year != year || parsed.month != month || parsed.day != day) {
      return null;
    }
    return parsed;
  } on FormatException {
    return null;
  }
}

String _formatDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}
