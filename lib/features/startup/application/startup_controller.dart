import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/repository_providers.dart';

enum StartupDestination { onboarding, records }

final startupProvider = FutureProvider<StartupDestination>((ref) async {
  await ref.watch(tagRepositoryProvider).ensureSystemTagsSeeded();
  final rabbit = await ref.watch(rabbitRepositoryProvider).getDefaultRabbit();
  return rabbit == null
      ? StartupDestination.onboarding
      : StartupDestination.records;
});
