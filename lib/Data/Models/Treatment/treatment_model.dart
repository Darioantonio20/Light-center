import 'package:isar/isar.dart';
import 'package:light_center/Data/Models/User/user_model.dart';
import 'package:jiffy/jiffy.dart';

part 'treatment_model.g.dart';

@collection
class Treatment {
  Id id = Isar.autoIncrement;
  int? productId;
  int? orderId;
  String? name;
  int? availableAppointments;
  int? appointmentsPerWeek;
  //List<String>? scheduledAppointments;
  List<Appointment>? scheduledAppointments;
  DateTime? firstDateToSchedule;
  DateTime? lastDateToSchedule;

  @Backlink(to: "treatments")
  final user = IsarLink<User>();
}

@embedded
class Appointment {
  int? id;
  String? date;
  String? time;

  @override
  String toString() {
    return 'ID: $id\nDate: $date\nTime: $time';
    //return super.toString();
  }

  DateTime get dateTime => Jiffy.parse('${date!} ${time!}', pattern: 'dd/MM/yyyy h:mm:ss').dateTime;
  String get jiffyDate => Jiffy.parse('${date!} ${time!}', pattern: 'dd/MM/yyyy h:mm:ss').yMMMMEEEEd;
  String get jiffyTime => Jiffy.parse('${date!} ${time!}', pattern: 'dd/MM/yyyy h:mm:ss').jms;
  String get jiffyDateTime => Jiffy.parse('${date!} ${time!}', pattern: 'dd/MM/yyyy h:mm:ss').yMMMMEEEEdjm;
}