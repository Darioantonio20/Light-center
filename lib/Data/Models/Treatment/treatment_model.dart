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
  List<Appointment>? scheduledAppointments;
  List<DateTime>? availableDates;
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

  Appointment({this.id, this.date, this.time});

  @override
  String toString() {
    return 'ID: $id\nDate: $date\nTime: $time';
    //return super.toString();
  }

  DateTime? get dateTime => date != null && time != null ? Jiffy.parse('${date!} ${time!}', pattern: 'dd/MM/yyyy h:mm:ss').dateTime : null;
  String? get jiffyDate => date != null ? Jiffy.parse(date!, pattern: 'dd/MM/yyyy').yMMMMEEEEd : null;
  String? get jiffyTime => time != null ? Jiffy.parse(time!, pattern: 'h:mm:ss').jms : null;
  String? get jiffyDateTime => date != null && time != null ? Jiffy.parse('${date!} ${time!}', pattern: 'dd/MM/yyyy h:mm:ss').yMMMMEEEEdjm : null;
}