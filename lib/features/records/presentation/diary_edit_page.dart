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
import '../../../shared/navigation/raby_shell.dart';
import '../../../shared/widgets/raby_card.dart';
import '../../../shared/widgets/raby_image_slot.dart';
import '../../../shared/widgets/raby_page.dart';
import '../../../shared/widgets/raby_sketch_icon.dart';
import '../../../shared/widgets/rabbit_avatar.dart';
import '../../rabbits/application/current_rabbit_providers.dart';
import '../application/diary_editor_controller.dart';
import '../application/diary_timeline_providers.dart';
import '../application/media_draft.dart';
import '../application/media_picker_service.dart';
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
  String _selectedCategory = 'system-daily';
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
        bottomNavigationBar: const RabyBottomNavigation(
          currentPath: AppRoutes.records,
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
                      title: _isEditing ? '编辑日记' : '写日记',
                      onBack: () => context.go(AppRoutes.records),
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
                        return _DiaryForm(
                          rabbit: rabbit,
                          contentController: _contentController,
                          recordedAt: _recordedAt,
                          selectedCategory: _selectedCategory,
                          selectedTagIds: _selectedTagIds,
                          mediaDrafts: _mediaDrafts,
                          enabled: !_isSaving,
                          onPickDate: _pickDate,
                          onCategoryChanged: _changeCategory,
                          onAddMedia: _pickImages,
                          onRemoveMedia: _removeMediaDraft,
                          onTagsChanged: (tagIds) =>
                              setState(() => _selectedTagIds = tagIds),
                          onOpenWeight: () =>
                              context.push(AppRoutes.weightNew, extra: true),
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
          selectedCategory: _selectedCategory,
          selectedTagIds: _selectedTagIds,
          mediaDrafts: _mediaDrafts,
          enabled: !_isSaving,
          onPickDate: _pickDate,
          onCategoryChanged: _changeCategory,
          onAddMedia: _pickImages,
          onRemoveMedia: _removeMediaDraft,
          onTagsChanged: (tagIds) => setState(() => _selectedTagIds = tagIds),
          onOpenWeight: () => context.push(AppRoutes.weightNew, extra: true),
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
    if (_selectedTagIds.contains('system-vet')) {
      _selectedCategory = 'system-vet';
    } else if (_selectedTagIds.contains('system-hay')) {
      _selectedCategory = 'system-hay';
    } else {
      _selectedCategory = 'system-daily';
    }
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

  void _changeCategory(String category) {
    const persistedCategoryIds = {'system-daily', 'system-hay', 'system-vet'};
    setState(() {
      _selectedCategory = category;
      _selectedTagIds = {..._selectedTagIds}
        ..removeAll(persistedCategoryIds)
        ..addAll(persistedCategoryIds.contains(category) ? [category] : []);
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

class _DiaryForm extends StatelessWidget {
  const _DiaryForm({
    required this.rabbit,
    required this.contentController,
    required this.recordedAt,
    required this.selectedCategory,
    required this.selectedTagIds,
    required this.mediaDrafts,
    required this.enabled,
    required this.onPickDate,
    required this.onCategoryChanged,
    required this.onAddMedia,
    required this.onRemoveMedia,
    required this.onTagsChanged,
    required this.onOpenWeight,
    required this.onSubmit,
    required this.isSaving,
  });

  final Rabbit rabbit;
  final TextEditingController contentController;
  final DateTime recordedAt;
  final String selectedCategory;
  final Set<String> selectedTagIds;
  final List<DiaryMediaDraft> mediaDrafts;
  final bool enabled;
  final VoidCallback onPickDate;
  final ValueChanged<String> onCategoryChanged;
  final VoidCallback onAddMedia;
  final ValueChanged<int> onRemoveMedia;
  final ValueChanged<Set<String>> onTagsChanged;
  final VoidCallback onOpenWeight;
  final VoidCallback? onSubmit;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RabyCard(
          radius: RabyRadius.lg,
          color: RabyColors.surfaceSoft,
          padding: const EdgeInsets.all(RabySpacing.ms),
          child: Row(
            children: [
              if (rabbit.avatarPath == null || rabbit.avatarPath!.isEmpty)
                const RabyImageSlot(
                  width: 52,
                  height: 52,
                  radius: RabyRadius.pill,
                  semanticLabel: '兔兔头像待替换',
                )
              else
                RabbitAvatar(
                  avatarPath: rabbit.avatarPath,
                  size: 52,
                  iconSize: 26,
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
                    const SizedBox(height: 3),
                    Text(
                      _formatDate(recordedAt),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: RabyColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              RabyIconBubble(
                icon: RabyIconKind.calendar,
                size: 42,
                iconSize: 20,
                tooltip: '选择日期',
                onTap: enabled ? onPickDate : null,
              ),
            ],
          ),
        ),
        const SizedBox(height: RabySpacing.ms),
        _DiaryCategorySelector(
          selected: selectedCategory,
          enabled: enabled,
          onChanged: onCategoryChanged,
        ),
        const SizedBox(height: RabySpacing.ms),
        RabyCard(
          radius: RabyRadius.lg,
          padding: const EdgeInsets.all(RabySpacing.ms),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '今天发生了什么？',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: RabyColors.textPrimary,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: RabySpacing.sm),
              TextField(
                controller: contentController,
                enabled: enabled,
                maxLength: 1000,
                minLines: 3,
                maxLines: 6,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: '记录${rabbit.name}今天的可爱瞬间吧～',
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: RabySpacing.ms),
        MediaPickerGrid(
          mediaDrafts: mediaDrafts,
          enabled: enabled,
          onAdd: onAddMedia,
          onRemove: onRemoveMedia,
        ),
        const SizedBox(height: RabySpacing.ms),
        TagPickerSection(
          rabbitId: rabbit.id,
          selectedTagIds: selectedTagIds,
          enabled: enabled,
          title: '今日状态',
          onChanged: onTagsChanged,
        ),
        const SizedBox(height: RabySpacing.ms),
        RabyCard(
          color: RabyColors.surfaceSoft,
          padding: EdgeInsets.zero,
          child: ListTile(
            dense: true,
            leading: const RabySketchIcon(
              kind: RabyIconKind.weight,
              color: RabyColors.primaryDeep,
            ),
            title: const Text('今天还没有记录体重'),
            subtitle: const Text('可以顺手补一条，日记会保留当前内容。'),
            trailing: TextButton(
              onPressed: enabled ? onOpenWeight : null,
              child: const Text('去记录'),
            ),
          ),
        ),
        const SizedBox(height: RabySpacing.md),
        SizedBox(
          width: double.infinity,
          height: 54,
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

class _DiaryCategorySelector extends StatelessWidget {
  const _DiaryCategorySelector({
    required this.selected,
    required this.enabled,
    required this.onChanged,
  });

  final String selected;
  final bool enabled;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<String>(
        showSelectedIcon: false,
        segments: const [
          ButtonSegment(
            value: 'system-daily',
            label: Text('日常', style: TextStyle(fontFamily: 'RabyChillRoundF')),
          ),
          ButtonSegment(
            value: 'system-hay',
            label: Text('饮食', style: TextStyle(fontFamily: 'RabyChillRoundF')),
          ),
          ButtonSegment(
            value: 'category-mood',
            label: Text('心情', style: TextStyle(fontFamily: 'RabyChillRoundF')),
          ),
          ButtonSegment(
            value: 'system-vet',
            label: Text('健康', style: TextStyle(fontFamily: 'RabyChillRoundF')),
          ),
        ],
        selected: {selected},
        onSelectionChanged: enabled
            ? (values) {
                if (values.isNotEmpty) {
                  onChanged(values.first);
                }
              }
            : null,
      ),
    );
  }
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
