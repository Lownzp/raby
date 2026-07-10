import '../../domain/domain_validation_exception.dart';
import '../../domain/models/rabbit.dart';
import '../../domain/repositories/rabbit_repository.dart';
import '../database/app_database.dart';
import 'drift_mappers.dart';

class DriftRabbitRepository implements RabbitRepository {
  DriftRabbitRepository(this._database, {DateTime Function()? now})
    : _now = now ?? (() => DateTime.now().toUtc());

  final AppDatabase _database;
  final DateTime Function() _now;

  RabbitDao get _dao => _database.rabbitDao;

  @override
  Stream<List<Rabbit>> watchActiveRabbits() {
    return _dao.watchActiveRabbits().map(
      (rows) => rows.map(rabbitFromRow).toList(growable: false),
    );
  }

  @override
  Stream<Rabbit?> watchDefaultRabbit() {
    return _dao.watchDefaultRabbit().map(
      (row) => row == null ? null : rabbitFromRow(row),
    );
  }

  @override
  Future<Rabbit?> getDefaultRabbit() async {
    final row = await _dao.getDefaultRabbit();
    return row == null ? null : rabbitFromRow(row);
  }

  @override
  Future<void> createRabbit(Rabbit rabbit) {
    _validateRabbit(rabbit);
    return _dao.insertRabbit(rabbitToCompanion(rabbit));
  }

  @override
  Future<void> updateRabbit(Rabbit rabbit) {
    _validateRabbit(rabbit);
    return _dao.updateRabbit(rabbitToCompanion(rabbit));
  }

  @override
  Future<void> softDeleteRabbit(String id) {
    return _dao.softDeleteRabbit(id, dateTimeToMillis(_now()));
  }

  void _validateRabbit(Rabbit rabbit) {
    if (rabbit.name.trim().isEmpty || rabbit.name.trim().length > 20) {
      throw const DomainValidationException('兔子名字需要是 1-20 个字符');
    }
    if (rabbit.birthDate == null && rabbit.adoptedDate == null) {
      throw const DomainValidationException('生日和领养日至少填写一个');
    }
    if (rabbit.breed.trim().isEmpty) {
      throw const DomainValidationException('品种不能为空');
    }
    if (rabbit.furColor.trim().isEmpty) {
      throw const DomainValidationException('毛色不能为空');
    }
    final initialWeight = rabbit.initialWeightGrams;
    if (initialWeight != null && initialWeight <= 0) {
      throw const DomainValidationException('初始体重必须大于 0');
    }
  }
}
