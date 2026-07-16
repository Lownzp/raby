import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/raby_tokens.dart';
import '../../../shared/widgets/raby_image_slot.dart';
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
                  Column(
                    children: [
                      Text(
                        '创建宠物档案',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: RabySpacing.sm),
                      Text(
                        '让我们先认识一下你的兔兔吧。',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: RabySpacing.md),
                      const RabyImageSlot(
                        aspectRatio: 4 / 3,
                        radius: RabyRadius.lg,
                        semanticLabel: '待替换建档主视觉',
                      ),
                    ],
                  ),
                  const SizedBox(height: RabySpacing.lg),
                  RabbitForm(
                    submitLabel: '完成建档',
                    onSaved: () => context.go(AppRoutes.records),
                  ),
                  const SizedBox(height: RabySpacing.sm),
                  Center(
                    child: TextButton(
                      onPressed: () => context.go(AppRoutes.records),
                      child: const Text('稍后再说'),
                    ),
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
