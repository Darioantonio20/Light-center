import 'package:isar/isar.dart';
import 'package:light_center/Data/Models/User/user_model.dart';

part 'treatment_model.g.dart';

@collection
class Treatment {
  Id id = Isar.autoIncrement;
  int? productId;
  int? orderId;
  String? name;
  int? availableAppointments;
  int? appointmentsPerWeek;
  List<String>? scheduledAppointments;
  DateTime? firstDateToSchedule;
  DateTime? lastDateToSchedule;

  @Backlink(to: "treatments")
  final user = IsarLink<User>();
}