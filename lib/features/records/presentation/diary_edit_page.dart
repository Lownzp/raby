import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers/repository_providers.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/raby_colors.dart';
import '../../../app/theme/raby_tokens.dart';
import '../../../domain/domain_validation_exception.dart';
import '../../../domain/models/diary_entry.dart';
import '../../../domain/models/rabbit.dart';
import '../../../domain/models/raby_enums.dart';
import '../../../domain/models/tag.dart';
import '../../../shared/widgets/raby_card.dart';
import '../../../shared/widgets/raby_page.dart';
import '../../../shared/widgets/raby_sketch_icon.dart';
import '../../../shared/widgets/rabbit_avatar.dart';
import '../../rabbits/application/current_rabbit_providers.dart';
import '../application/diary_editor_controller.dart';
import '../application/diary_timeline_providers.dart';
import '../application/media_draft.dart';
import '../application/media_picker_service.dart';
import '../application/tag_picker_providers.dart';
import 'widgets/media_picker_grid.dart';
import 'widgets/tag_picker_section.dart';

class DiaryEditPage extends ConsumerStatefulWidget {
  const DiaryEditPage({this.diaryId, super.key});

  final String? diaryId;

  @override
  ConsumerState<DiaryEditPage> createState() => _DiaryEditPageState();
}

class _DiaryEditPageState extends ConsumerState<DiaryEditPage> {
  final _contentController = TextEditingController();
  late DateTime _recordedAt;
  Set<String> _selectedTagIds = {};
  List<DiaryMediaDraft> _mediaDrafts = [];
  bool _initialized = false;
  bool _isSaving = false;

  bool get _isEditing => widget.diaryId != null;
  bool get _canSave =>
      (_contentController.text.trim().isNotEmpty || _mediaDrafts.isNotEmpty) &&
      !_isSaving;

  @override
  void initState() {
    super.initState();
    _recordedAt = ref.read(clockProvider)();
    _contentController.addListener(_onContentChanged);
  }

  @override
  void dispose() {
    _contentController
      ..removeListener(_onContentChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rabbitState = ref.watch(currentRabbitProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && !_isSaving) {
          context.go(AppRoutes.records);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  RabySpacing.md,
                  RabySpacing.sm,
                  RabySpacing.md,
                  RabySpacing.xl,
                ),
                sliver: SliverList.list(
                  children: [
                    _EditorTopBar(
                      title: _isEditing ? '编辑日记' : '写生活日记',
                      canSave: _canSave,
                      isSaving: _isSaving,
                      onBack: () => context.go(AppRoutes.records),
                      onSave: () => _submit(),
                    ),
                    const SizedBox(height: RabySpacing.lg),
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
                        return _DiaryForm(
                          rabbit: rabbit,
                          contentController: _contentController,
                          recordedAt: _recordedAt,
                          selectedTagIds: _selectedTagIds,
                          mediaDrafts: _mediaDrafts,
                          enabled: !_isSaving,
                          onPickDate: _pickDate,
                          onAddMedia: _pickImages,
                          onRemoveMedia: _removeMediaDraft,
                          onTagsChanged: (tagIds) =>
                              setState(() => _selectedTagIds = tagIds),
                          onSubmit: _canSave ? () => _submit() : null,
                          isSaving: _isSaving,
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
    final diaryId = widget.diaryId;
    if (diaryId == null) {
      return const SizedBox.shrink();
    }

    final entryState = ref.watch(diaryEntryProvider(diaryId));
    return entryState.when(
      data: (entry) {
        if (entry == null) {
          return _MissingDiaryCard(onBack: () => context.go(AppRoutes.records));
        }
        if (entry.diary.rabbitId != rabbit.id) {
          return RabyCard(
            borderColor: RabyColors.warning,
            child: const RabyMutedText('这条日记不属于当前兔兔档案。'),
          );
        }
        _hydrate(entry);
        return _DiaryForm(
          rabbit: rabbit,
          contentController: _contentController,
          recordedAt: _recordedAt,
          selectedTagIds: _selectedTagIds,
          mediaDrafts: _mediaDrafts,
          enabled: !_isSaving,
          onPickDate: _pickDate,
          onAddMedia: _pickImages,
          onRemoveMedia: _removeMediaDraft,
          onTagsChanged: (tagIds) => setState(() => _selectedTagIds = tagIds),
          onSubmit: _canSave ? () => _submit(existing: entry) : null,
          isSaving: _isSaving,
        );
      },
      loading: () =>
          const RabyCard(child: Center(child: CircularProgressIndicator())),
      error: (error, _) => RabyCard(
        borderColor: RabyColors.danger,
        child: Text('日记读取失败: $error'),
      ),
    );
  }

  void _hydrate(DiaryEntry entry) {
    if (_initialized) {
      return;
    }
    _contentController.text = entry.diary.content ?? '';
    _recordedAt = entry.diary.recordedAt;
    _selectedTagIds = entry.tags.map((tag) => tag.id).toSet();
    _mediaDrafts = entry.media
        .map((media) => ExistingDiaryMediaDraft(media))
        .toList(growable: false);
    _initialized = true;
  }

  void _onContentChanged() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _pickDate() async {
    final current = _recordedAt.toLocal();
    final firstDate = DateTime(1990);
    final today = _today();
    final selected = await showDatePicker(
      context: context,
      locale: const Locale('zh', 'CN'),
      initialDate: _clampDate(current, firstDate, today),
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

  Future<void> _pickImages() async {
    if (_isSaving) {
      return;
    }

    final remainingSlots = 9 - _mediaDrafts.length;
    if (remainingSlots <= 0) {
      _showSnackBar('单条日记最多支持 9 张照片');
      return;
    }

    try {
      final picked = await ref
          .read(mediaPickerServiceProvider)
          .pickImages(remainingSlots: remainingSlots);
      if (!mounted || picked.drafts.isEmpty) {
        return;
      }
      setState(() {
        _mediaDrafts = [..._mediaDrafts, ...picked.drafts];
      });
      if (picked.truncated) {
        _showSnackBar('单条日记最多支持 9 张照片，已只保留前 $remainingSlots 张');
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      _showSnackBar('照片选择失败: ${_errorMessage(error)}');
    }
  }

  void _removeMediaDraft(int index) {
    if (_isSaving || index < 0 || index >= _mediaDrafts.length) {
      return;
    }
    setState(() {
      _mediaDrafts = [..._mediaDrafts]..removeAt(index);
    });
  }

  Future<void> _submit({DiaryEntry? existing}) async {
    if (!_canSave) {
      return;
    }

    final rabbit = ref
        .read(currentRabbitProvider)
        .maybeWhen(data: (rabbit) => rabbit, orElse: () => null);
    if (rabbit == null) {
      return;
    }

    final input = DiaryEditorInput(
      rabbitId: rabbit.id,
      content: _contentController.text,
      recordedAt: _recordedAt,
      tagIds: _selectedTagIds.toList(growable: false),
      mediaDrafts: _mediaDrafts,
    );
    final controller = ref.read(diaryEditorControllerProvider);

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
      context.go(AppRoutes.records);
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() => _isSaving = false);
      _showSnackBar(_errorMessage(error));
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  DateTime _today() {
    final now = ref.read(clockProvider)().toLocal();
    return DateTime(now.year, now.month, now.day);
  }
}

class _EditorTopBar extends StatelessWidget {
  const _EditorTopBar({
    required this.title,
    required this.canSave,
    required this.isSaving,
    required this.onBack,
    required this.onSave,
  });

  final String title;
  final bool canSave;
  final bool isSaving;
  final VoidCallback onBack;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RabyIconBubble(
          icon: RabyIconKind.back,
          tooltip: '返回',
          onTap: isSaving ? null : onBack,
        ),
        const SizedBox(width: RabySpacing.sm),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 28,
              color: RabyColors.secondary,
            ),
          ),
        ),
        RabyIconBubble(
          icon: RabyIconKind.more,
          tooltip: isSaving ? '保存中' : '保存',
          iconColor: canSave ? RabyColors.secondary : RabyColors.textTertiary,
          onTap: canSave ? onSave : null,
        ),
      ],
    );
  }
}

class _DiaryForm extends StatelessWidget {
  const _DiaryForm({
    required this.rabbit,
    required this.contentController,
    required this.recordedAt,
    required this.selectedTagIds,
    required this.mediaDrafts,
    required this.enabled,
    required this.onPickDate,
    required this.onAddMedia,
    required this.onRemoveMedia,
    required this.onTagsChanged,
    required this.onSubmit,
    required this.isSaving,
  });

  final Rabbit rabbit;
  final TextEditingController contentController;
  final DateTime recordedAt;
  final Set<String> selectedTagIds;
  final List<DiaryMediaDraft> mediaDrafts;
  final bool enabled;
  final VoidCallback onPickDate;
  final VoidCallback onAddMedia;
  final ValueChanged<int> onRemoveMedia;
  final ValueChanged<Set<String>> onTagsChanged;
  final VoidCallback? onSubmit;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
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
              RabbitAvatar(
                avatarPath: rabbit.avatarPath,
                size: 64,
                iconSize: 34,
                borderWidth: 4,
                borderColor: RabyColors.stickerBorder,
              ),
              const SizedBox(width: RabySpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rabbit.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: RabyColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _formatDate(recordedAt),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: RabyColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              RabyIconBubble(
                icon: RabyIconKind.calendar,
                size: 48,
                iconSize: 22,
                tooltip: '选择日期',
                onTap: enabled ? onPickDate : null,
              ),
            ],
          ),
        ),
        const SizedBox(height: RabySpacing.md),
        _QuickTagCard(
          rabbitId: rabbit.id,
          selectedTagIds: selectedTagIds,
          enabled: enabled,
          onChanged: onTagsChanged,
        ),
        const SizedBox(height: RabySpacing.md),
        RabyCard(
          softShadow: true,
          radius: RabyRadius.xl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '今天发生了什么？',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: RabyColors.textPrimary,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: RabySpacing.sm),
              TextField(
                controller: contentController,
                enabled: enabled,
                maxLength: 1000,
                minLines: 6,
                maxLines: 10,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: '记录${rabbit.name}今天的可爱瞬间吧～',
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: RabySpacing.md),
        MediaPickerGrid(
          mediaDrafts: mediaDrafts,
          enabled: enabled,
          onAdd: onAddMedia,
          onRemove: onRemoveMedia,
        ),
        const SizedBox(height: RabySpacing.md),
        RabyCard(
          softShadow: true,
          padding: EdgeInsets.zero,
          child: ListTile(
            enabled: enabled,
            minVerticalPadding: RabySpacing.md,
            leading: const RabySketchIcon(
              kind: RabyIconKind.calendar,
              color: RabyColors.primaryDeep,
            ),
            title: Text('记录日期', style: Theme.of(context).textTheme.titleSmall),
            subtitle: Text(_formatDate(recordedAt)),
            trailing: const RabySketchIcon(kind: RabyIconKind.chevronRight),
            onTap: enabled ? onPickDate : null,
          ),
        ),
        const SizedBox(height: RabySpacing.md),
        TagPickerSection(
          rabbitId: rabbit.id,
          selectedTagIds: selectedTagIds,
          enabled: enabled,
          onChanged: onTagsChanged,
        ),
        const SizedBox(height: RabySpacing.lg),
        SizedBox(
          width: double.infinity,
          height: 62,
          child: FilledButton.icon(
            onPressed: onSubmit,
            icon: isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const RabySketchIcon(kind: RabyIconKind.check),
            label: Text(isSaving ? '保存中' : '保存日记'),
          ),
        ),
      ],
    );
  }
}

class _QuickTagCard extends ConsumerWidget {
  const _QuickTagCard({
    required this.rabbitId,
    required this.selectedTagIds,
    required this.enabled,
    required this.onChanged,
  });

  final String rabbitId;
  final Set<String> selectedTagIds;
  final bool enabled;
  final ValueChanged<Set<String>> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsState = ref.watch(availableTagsProvider(rabbitId));

    return RabyCard(
      radius: RabyRadius.xl,
      softShadow: true,
      child: tagsState.when(
        data: (tags) {
          final systemTags = tags.where((tag) => tag.isSystem).toList();
          if (systemTags.isEmpty) {
            return const RabyMutedText('系统标签暂时不可用。');
          }
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final tag in systemTags)
                _QuickTagChip(
                  tag: tag,
                  selected: selectedTagIds.contains(tag.id),
                  enabled: enabled,
                  onSelected: (selected) {
                    final next = {...selectedTagIds};
                    if (selected) {
                      next.add(tag.id);
                    } else {
                      next.remove(tag.id);
                    }
                    onChanged(next);
                  },
                ),
            ],
          );
        },
        loading: () => const RabyMutedText('标签加载中...'),
        error: (error, _) => Text('标签读取失败: ${_errorMessage(error)}'),
      ),
    );
  }
}

class _QuickTagChip extends StatelessWidget {
  const _QuickTagChip({
    required this.tag,
    required this.selected,
    required this.enabled,
    required this.onSelected,
  });

  final Tag tag;
  final bool selected;
  final bool enabled;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    final isMilestone = tag.tagKind == TagKind.milestone;
    return InkWell(
      key: ValueKey('quick-tag-${tag.id}'),
      borderRadius: BorderRadius.circular(RabyRadius.pill),
      onTap: enabled ? () => onSelected(!selected) : null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected
              ? RabyColors.surfaceWarm
              : (isMilestone ? RabyColors.paper : RabyColors.surface),
          borderRadius: BorderRadius.circular(RabyRadius.pill),
          border: Border.all(
            color: selected
                ? (isMilestone ? RabyColors.secondary : RabyColors.primary)
                : RabyColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RabySketchIcon(
                kind: selected ? RabyIconKind.check : _quickTagIcon(tag.name),
                size: 18,
                color: selected
                    ? (isMilestone
                          ? RabyColors.secondary
                          : RabyColors.primaryDeep)
                    : RabyColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                tag.name,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isMilestone
                      ? RabyColors.secondary
                      : RabyColors.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

RabyIconKind _quickTagIcon(String name) {
  return switch (name) {
    '日常' => RabyIconKind.diary,
    '吃草' => RabyIconKind.rabbit,
    '看兽医' => RabyIconKind.check,
    '里程碑' => RabyIconKind.check,
    _ => RabyIconKind.circle,
  };
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
          const RabyMutedText('日记需要挂在一只兔兔档案下面。'),
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

class _MissingDiaryCard extends StatelessWidget {
  const _MissingDiaryCard({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return RabyCard(
      borderColor: RabyColors.warning,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('日记不存在或已删除', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: RabySpacing.xs),
          const RabyMutedText('回到记录页后,时间轴会显示当前可用的记录。'),
          const SizedBox(height: RabySpacing.md),
          FilledButton.icon(
            onPressed: onBack,
            icon: const RabySketchIcon(kind: RabyIconKind.back),
            label: const Text('返回记录页'),
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
