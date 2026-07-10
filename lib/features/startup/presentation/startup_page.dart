import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/raby_colors.dart';
import '../../../app/theme/raby_tokens.dart';
import '../../../shared/widgets/raby_card.dart';
import '../application/startup_controller.dart';

class StartupPage extends ConsumerWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<StartupDestination>>(startupProvider, (
      previous,
      next,
    ) {
      next.whenData((destination) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) {
            return;
          }
          context.go(
            destination == StartupDestination.onboarding
                ? AppRoutes.onboardingRabbit
                : AppRoutes.records,
          );
        });
      });
    });

    final startup = ref.watch(startupProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(RabySpacing.md),
            child: RabyCard(
              radius: RabyRadius.hero,
              clayShadow: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 34,
                    height: 34,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                  const SizedBox(height: RabySpacing.md),
                  Text('Raby', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: RabySpacing.xs),
                  Text(
                    startup.hasError ? '本地档案准备失败' : '正在准备本地档案',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: startup.hasError
                          ? RabyColors.danger
                          : RabyColors.textSecondary,
                    ),
                  ),
                  if (kDebugMode && startup.hasError) ...[
                    const SizedBox(height: RabySpacing.sm),
                    SelectableText(
                      startup.error.toString(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: RabyColors.danger,
                      ),
                    ),
                  ],
                  if (startup.hasError) ...[
                    const SizedBox(height: RabySpacing.md),
                    FilledButton(
                      onPressed: () => ref.invalidate(startupProvider),
                      child: const Text('重试'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
