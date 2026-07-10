import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/raby_colors.dart';
import '../../../app/theme/raby_tokens.dart';
import '../../../shared/widgets/raby_card.dart';
import '../../../shared/widgets/raby_sketch_icon.dart';
import '../../../shared/widgets/raby_state_card.dart';
import '../application/current_rabbit_providers.dart';
import 'widgets/rabbit_form.dart';

class RabbitEditPage extends ConsumerWidget {
  const RabbitEditPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rabbitState = ref.watch(currentRabbitProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go(AppRoutes.rabbitDetail);
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
                    Row(
                      children: [
                        IconButton(
                          tooltip: '返回',
                          onPressed: () => context.go(AppRoutes.rabbitDetail),
                          icon: const RabySketchIcon(kind: RabyIconKind.back),
                        ),
                        Expanded(
                          child: Text(
                            '编辑档案',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: RabySpacing.lg),
                    rabbitState.when(
                      data: (rabbit) {
                        if (rabbit == null) {
                          return RabyStateCard(
                            icon: RabyIconKind.rabbit,
                            title: '还没有兔兔档案',
                            message: '先建立第一只兔兔档案,再回来补充资料。',
                            actionLabel: '建立兔兔档案',
                            actionIcon: RabyIconKind.add,
                            tone: RabyStateTone.warm,
                            onAction: () =>
                                context.go(AppRoutes.onboardingRabbit),
                          );
                        }
                        return RabbitForm(
                          existing: rabbit,
                          submitLabel: '保存修改',
                          onSaved: () => context.go(AppRoutes.rabbitDetail),
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
}
