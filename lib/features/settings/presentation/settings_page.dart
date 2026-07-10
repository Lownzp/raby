import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/raby_colors.dart';
import '../../../app/theme/raby_tokens.dart';
import '../../../shared/widgets/raby_card.dart';
import '../../../shared/widgets/raby_page.dart';
import '../../../shared/widgets/raby_sketch_icon.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                    _SettingsTopBar(onBack: () => context.go(AppRoutes.me)),
                    const SizedBox(height: RabySpacing.lg),
                    const _AppInfoCard(),
                    const SizedBox(height: RabySpacing.md),
                    const _AboutCard(),
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

class _SettingsTopBar extends StatelessWidget {
  const _SettingsTopBar({required this.onBack});

  final VoidCallback onBack;

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
          child: Text('设置', style: Theme.of(context).textTheme.titleLarge),
        ),
      ],
    );
  }
}

class _AppInfoCard extends StatelessWidget {
  const _AppInfoCard();

  @override
  Widget build(BuildContext context) {
    return RabyCard(
      radius: RabyRadius.hero,
      softShadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('App 信息', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: RabySpacing.md),
          Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: RabyColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(RabyRadius.md),
                ),
                child: const SizedBox.square(
                  dimension: 52,
                  child: Center(
                    child: RabySketchIcon(
                      kind: RabyIconKind.rabbit,
                      color: RabyColors.primary,
                      size: 28,
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
                      'Raby',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: RabySpacing.xs),
                    const RabyMutedText('v0.1.0 本地优先内测版'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: RabySpacing.lg),
          const _InfoRow(label: '版本', value: 'v0.1.0'),
          const Divider(height: 1),
          const _InfoRow(label: '数据', value: '本机私有存储'),
          const Divider(height: 1),
          const _InfoRow(label: '网络', value: '核心记录离线可用'),
        ],
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context) {
    return RabyCard(
      color: RabyColors.paper,
      borderColor: RabyColors.borderWarm,
      clayShadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('关于 Raby', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: RabySpacing.sm),
          const RabyMutedText('一个轻量、本地优先的兔兔生活记录本。'),
          const SizedBox(height: RabySpacing.md),
          Wrap(
            spacing: RabySpacing.sm,
            runSpacing: RabySpacing.sm,
            children: const [
              _InfoChip(label: '本地优先'),
              _InfoChip(label: '离线记录'),
              _InfoChip(label: 'v0.1.0'),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

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

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: RabyColors.surface,
        borderRadius: BorderRadius.circular(RabyRadius.pill),
        border: Border.all(color: RabyColors.borderWarm),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: RabyColors.secondary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
