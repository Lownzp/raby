import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/raby_colors.dart';
import '../../../../app/theme/raby_tokens.dart';
import '../../../../domain/domain_validation_exception.dart';
import '../../../../domain/models/raby_enums.dart';
import '../../../../domain/models/tag.dart';
import '../../../../shared/widgets/raby_card.dart';
import '../../../../shared/widgets/raby_page.dart';
import '../../../../shared/widgets/raby_sketch_icon.dart';
import '../../application/diary_editor_controller.dart';
import '../../application/tag_picker_providers.dart';

class TagPickerSection extends ConsumerStatefulWidget {
  const TagPickerSection({
    required this.rabbitId,
    required this.selectedTagIds,
    required this.onChanged,
    this.enabled = true,
    super.key,
  });

  final String rabbitId;
  final Set<String> selectedTagIds;
  final ValueChanged<Set<String>> onChanged;
  final bool enabled;

  @override
  ConsumerState<TagPickerSection> createState() => _TagPickerSectionState();
}

class _TagPickerSectionState extends ConsumerState<TagPickerSection> {
  @override
  Widget build(BuildContext context) {
    final tagsState = ref.watch(availableTagsProvider(widget.rabbitId));

    return RabyCard(
      softShadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '标签',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: RabyColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: widget.enabled ? _createCustomTag : null,
                icon: const RabySketchIcon(kind: RabyIconKind.add, size: 18),
                label: const Text('新增标签'),
              ),
            ],
          ),
          const SizedBox(height: RabySpacing.sm),
          tagsState.when(
            data: (tags) {
              if (tags.isEmpty) {
                return const RabyMutedText('暂无可选标签。');
              }
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tag in tags)
                    _SelectableTagChip(
                      tag: tag,
                      selected: widget.selectedTagIds.contains(tag.id),
                      enabled: widget.enabled,
                      onSelected: (selected) {
                        final next = {...widget.selectedTagIds};
                        if (selected) {
                          next.add(tag.id);
                        } else {
                          next.remove(tag.id);
                        }
                        widget.onChanged(next);
                      },
                    ),
                ],
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: RabySpacing.sm),
              child: LinearProgressIndicator(minHeight: 3),
            ),
            error: (error, _) => Text(
              '标签读取失败: $error',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: RabyColors.danger),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createCustomTag() async {
    final tag = await showDialog<Tag>(
      context: context,
      builder: (dialogContext) {
        final controller = TextEditingController();
        var isSaving = false;
        String? errorText;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> submit() async {
              final name = controller.text.trim();
              if (name.isEmpty || name.length > 12) {
                setDialogState(() => errorText = '标签名需要是 1-12 个字符');
                return;
              }
              setDialogState(() {
                isSaving = true;
                errorText = null;
              });
              try {
                final tag = await ref
                    .read(diaryEditorControllerProvider)
                    .createCustomTag(rabbitId: widget.rabbitId, name: name);
                if (!dialogContext.mounted) {
                  return;
                }
                Navigator.of(dialogContext).pop(tag);
              } catch (error) {
                if (!dialogContext.mounted) {
                  return;
                }
                setDialogState(() {
                  isSaving = false;
                  errorText = _errorMessage(error);
                });
              }
            }

            return AlertDialog(
              title: const Text('新增标签'),
              content: TextField(
                controller: controller,
                autofocus: true,
                enabled: !isSaving,
                maxLength: 12,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => isSaving ? null : submit(),
                decoration: InputDecoration(
                  labelText: '标签名',
                  hintText: '例如 满月',
                  errorText: errorText,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSaving
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text('取消'),
                ),
                FilledButton.icon(
                  onPressed: isSaving ? null : submit,
                  icon: isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const RabySketchIcon(kind: RabyIconKind.check),
                  label: Text(isSaving ? '保存中' : '保存'),
                ),
              ],
            );
          },
        );
      },
    );

    if (tag == null || !mounted) {
      return;
    }
    widget.onChanged({...widget.selectedTagIds, tag.id});
  }
}

class _SelectableTagChip extends StatelessWidget {
  const _SelectableTagChip({
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
    return FilterChip(
      selected: selected,
      onSelected: enabled ? onSelected : null,
      showCheckmark: true,
      avatar: RabySketchIcon(
        kind: selected ? RabyIconKind.check : RabyIconKind.circle,
        size: 18,
      ),
      label: Text(tag.name),
      backgroundColor: isMilestone
          ? RabyColors.surfaceWarm
          : RabyColors.surface,
      selectedColor: isMilestone
          ? RabyColors.surfaceWarm
          : RabyColors.surfaceSoft,
      side: BorderSide(
        color: selected
            ? (isMilestone ? RabyColors.secondary : RabyColors.primary)
            : RabyColors.border,
        width: selected ? 1.5 : 1,
      ),
      labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: isMilestone ? RabyColors.secondary : RabyColors.primary,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

String _errorMessage(Object error) {
  if (error is DomainValidationException) {
    return error.message;
  }
  return error.toString();
}
