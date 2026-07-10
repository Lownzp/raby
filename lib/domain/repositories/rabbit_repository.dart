import '../models/rabbit.dart';

abstract interface class RabbitRepository {
  Stream<List<Rabbit>> watchActiveRabbits();
  Stream<Rabbit?> watchDefaultRabbit();
  Future<Rabbit?> getDefaultRabbit();
  Future<void> createRabbit(Rabbit rabbit);
  Future<void> updateRabbit(Rabbit rabbit);
  Future<void> softDeleteRabbit(String id);
}
