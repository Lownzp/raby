import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers/repository_providers.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/raby_colors.dart';
import '../../../app/theme/raby_tokens.dart';
import '../../../domain/models/rabbit.dart';
import '../../../shared/widgets/raby_card.dart';
import '../../../shared/widgets/raby_page.dart';
import '../../../shared/widgets/raby_sketch_icon.dart';
import '../../../shared/widgets/raby_state_card.dart';
import '../../../shared/widgets/rabbit_avatar.dart';
import '../application/current_rabbit_providers.dart';

class RabbitDetailPage extends ConsumerWidget {
  const RabbitDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rabbitState = ref.watch(currentRabbitProvider);
    final hasRabbit = rabbitState.maybeWhen(
      data: (rabbit) => rabbit != null,
      orElse: () => false,
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go(AppRoutes.me);
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
                    _DetailHeader(
                      onBack: () => context.go(AppRoutes.me),
                      actionTooltip: hasRabbit ? '编辑档案' : '建立兔兔档案',
                      actionIcon: hasRabbit
                          ? RabyIconKind.edit
                          : RabyIconKind.add,
                      onAction: () => context.go(
                        hasRabbit
                            ? AppRoutes.rabbitEdit
                            : AppRoutes.onboardingRabbit,
                      ),
                    ),
                    const SizedBox(height: RabySpacing.lg),
                    rabbitState.when(
                      data: (rabbit) => rabbit == null
                          ? const _NoRabbitCard()
                          : _RabbitDetailContent(rabbit: rabbit),
                      loading: () => const _LoadingCard(),
                      error: (error, _) => const _ErrorCard(),
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
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({
    required this.onBack,
    required this.actionTooltip,
    required this.actionIcon,
    required this.onAction,
  });

  final VoidCallback onBack;
  final String actionTooltip;
  final RabyIconKind actionIcon;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: '返回',
          onPressed: onBack,
          icon: const RabySketchIcon(kind: RabyIconKind.back),
        ),
        Expanded(
          child: Text('兔兔档案', style: Theme.of(context).textTheme.titleLarge),
        ),
        IconButton(
          tooltip: actionTooltip,
          onPressed: onAction,
          icon: RabySketchIcon(kind: actionIcon),
        ),
      ],
    );
  }
}

class _RabbitDetailContent extends StatelessWidget {
  const _RabbitDetailContent({required this.rabbit});

  final Rabbit rabbit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RabyCard(
          radius: RabyRadius.hero,
          color: RabyColors.paper,
          clayShadow: true,
          child: Row(
            children: [
              RabbitAvatar(
                avatarPath: rabbit.avatarPath,
                size: 72,
                iconSize: 34,
              ),
              const SizedBox(width: RabySpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rabbit.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: RabySpacing.xs),
                    RabyMutedText('${rabbit.breed} · ${rabbit.furColor}'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: RabySpacing.md),
        RabyCard(
          softShadow: true,
          child: Column(
            children: [
              _DetailRow(label: '性别', value: _sexLabel(rabbit.sex.value)),
              const Divider(height: 1),
              _DetailRow(label: '生日', value: rabbit.birthDate ?? '未填写'),
              const Divider(height: 1),
              _DetailRow(label: '领养日', value: rabbit.adoptedDate ?? '未填写'),
              const Divider(height: 1),
              _DetailRow(label: '初始体重', value: _weightLabel(rabbit)),
            ],
          ),
        ),
        const SizedBox(height: RabySpacing.md),
        RabyCard(
          color: RabyColors.paper,
          borderColor: RabyColors.borderWarm,
          clayShadow: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('常用记录', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: RabySpacing.sm),
              const RabyMutedText('从档案页也可以直接补记今天的状态。'),
              const SizedBox(height: RabySpacing.md),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.go(AppRoutes.weightNew),
                      icon: const RabySketchIcon(kind: RabyIconKind.weight),
                      label: const Text('记体重'),
                    ),
                  ),
                  const SizedBox(width: RabySpacing.md),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => context.go(AppRoutes.recordsNew),
                      icon: const RabySketchIcon(kind: RabyIconKind.diary),
                      label: const Text('写日记'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: RabySpacing.md),
        _DeleteRabbitCard(rabbit: rabbit),
      ],
    );
  }
}

class _DeleteRabbitCard extends ConsumerWidget {
  const _DeleteRabbitCard({required this.rabbit});

  final Rabbit rabbit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RabyCard(
      color: RabyColors.surface,
      borderColor: RabyColors.danger.withValues(alpha: 0.35),
      softShadow: true,
      child: Row(
        children: [
          const RabySticker(
            icon: RabyIconKind.error,
            size: 46,
            background: RabyColors.surface,
            foreground: RabyColors.danger,
          ),
          const SizedBox(width: RabySpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('删除档案', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                const RabyMutedText('会隐藏这只兔兔的日记、照片和体重记录。'),
              ],
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: RabyColors.danger),
            onPressed: () => _confirmDelete(context, ref),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('删除 ${rabbit.name} 的档案?'),
        content: const Text('删除后,相关日记、照片和体重记录会从当前 app 中隐藏。这个操作需要确认。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('取消'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            icon: const RabySketchIcon(kind: RabyIconKind.delete),
            label: const Text('删除'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }

    try {
      await ref.read(rabbitRepositoryProvider).softDeleteRabbit(rabbit.id);
      if (!context.mounted) {
        return;
      }
      context.go(AppRoutes.onboardingRabbit);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('兔兔档案已删除')));
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

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: RabyColors.textSecondary),
          ),
          const Spacer(),
          Text(value, style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}

class _NoRabbitCard extends StatelessWidget {
  const _NoRabbitCard();

  @override
  Widget build(BuildContext context) {
    return RabyStateCard(
      icon: RabyIconKind.rabbit,
      title: '还没有兔兔档案',
      message: '先建立第一只兔兔档案,这里会显示完整资料。',
      actionLabel: '建立兔兔档案',
      actionIcon: RabyIconKind.add,
      tone: RabyStateTone.warm,
      onAction: () => context.go(AppRoutes.onboardingRabbit),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return const RabyCard(
      child: Center(child: CircularProgressIndicator(strokeWidth: 3)),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard();

  @override
  Widget build(BuildContext context) {
    return RabyStateCard(
      icon: RabyIconKind.error,
      title: '档案读取失败',
      message: '本地档案暂时不可用,返回后可以再试一次。',
      actionLabel: '返回我的',
      actionIcon: RabyIconKind.back,
      tone: RabyStateTone.danger,
      onAction: () => context.go(AppRoutes.me),
    );
  }
}

String _sexLabel(String value) {
  return switch (value) {
    'female' => '女孩',
    'male' => '男孩',
    _ => '未知',
  };
}

String _weightLabel(Rabbit rabbit) {
  final grams = rabbit.initialWeightGrams;
  return grams == null ? '未填写' : '${grams}g';
}
