import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/repository_providers.dart';
import '../../../domain/models/rabbit.dart';

final currentRabbitProvider = StreamProvider<Rabbit?>((ref) {
  return ref.watch(rabbitRepositoryProvider).watchDefaultRabbit();
});

final activeRabbitsProvider = StreamProvider<List<Rabbit>>((ref) {
  return ref.watch(rabbitRepositoryProvider).watchActiveRabbits();
});
