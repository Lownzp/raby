import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/raby_colors.dart';
import '../../../app/theme/raby_tokens.dart';
import '../../../shared/widgets/raby_card.dart';
import '../../../shared/widgets/raby_sketch_icon.dart';
import '../../../shared/widgets/raby_page.dart';
import 'widgets/rabbit_form.dart';

class RabbitOnboardingPage extends StatelessWidget {
  const RabbitOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                RabySpacing.md,
                RabySpacing.md,
                RabySpacing.md,
                148,
              ),
              sliver: SliverList.list(
                children: [
                  RabyCard(
                    radius: RabyRadius.hero,
                    softShadow: true,
                    gradient: const LinearGradient(
                      colors: [RabyColors.surfaceWarm, RabyColors.paper],
                    ),
                    child: Row(
                      children: [
                        const RabySticker(
                          icon: RabyIconKind.rabbit,
                          size: 62,
                          background: RabyColors.surface,
                          foreground: RabyColors.secondary,
                        ),
                        const SizedBox(width: RabySpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '建立第一只兔兔档案',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(color: RabyColors.secondary),
                              ),
                              const SizedBox(height: RabySpacing.xs),
                              const RabyMutedText(
                                '先填几个核心信息,后面每天的记录都会自动归到这只兔兔名下。',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: RabySpacing.lg),
                  RabbitForm(
                    submitLabel: '完成建档',
                    onSaved: () => context.go(AppRoutes.records),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
