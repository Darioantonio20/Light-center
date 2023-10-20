import 'package:light_center/BusinessLogic/Cubits/User/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:light_center/Data/Models/User/user_model.dart';
import 'package:light_center/Data/Models/Treatment/treatment_model.dart';
import 'package:light_center/colors.dart';
import 'package:intl/intl.dart';

late UserCubit userCubit;

List<Widget> scheduledAppointmentsList(List<String> appointmentsList) {
  List<Widget> scheduledAppointmentsList = [];
  if (appointmentsList.isNotEmpty) {
    scheduledAppointmentsList =
        List<Widget>.generate(appointmentsList.length, (index) {
      return Container(
        color: index.isEven
            ? LightCenterColors.backgroundPurple
            : LightCenterColors.backgroundPink,
        child: ListTile(
          title: Text(DateFormat.yMMMMd('es-MX').format(DateTime.parse(appointmentsList[index])).toString()),
          subtitle: Text(DateFormat.jm().format(DateTime.parse(appointmentsList[index])).toString()),
        ),
      );
    });
  }

  return scheduledAppointmentsList;
}

/*String pendingAppointments({required Appointments? appointments}) {
  if (appointments != null) {
    if (appointments.availableAppointments != null) {
      return appointments.availableAppointments.toString();
    }
  }
  return 'Sin datos...';
}*/

String pendingAppointments({required Treatment treatment}) {
  if (treatment.availableAppointments != null) {
    return treatment.availableAppointments.toString();
  }
  return 'Sin datos...';
}


/*String lastDateToSchedule({required Appointments? appointments}) {
  if (appointments != null) {
    if (appointments.lastDateToSchedule != null) {
      return DateFormat.yMd('es-MX').format(appointments.lastDateToSchedule!).toString();
    }
  }
  return 'Sin asignar...';
}*/

String lastDateToSchedule({required Treatment treatment}) {
  if (treatment.lastDateToSchedule != null) {
    return DateFormat.yMd('es-MX').format(treatment.lastDateToSchedule!).toString();
  }
  return 'Sin asignar...';
}