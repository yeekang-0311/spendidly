import 'package:hive/hive.dart';

part 'recurrent_transaction.g.dart';

@HiveType(typeId: 1)
class RecurrentTransaction extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late DateTime lastUpdate;

  @HiveField(2)
  late String category;

  @HiveField(3)
  late double amount;

  @HiveField(4, defaultValue: "")
  late String note;

  @HiveField(5)
  late String frequency;
}
