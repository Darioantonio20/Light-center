import 'package:light_center/BusinessLogic/Cubits/Treatment/treatment_cubit.dart';
import 'package:light_center/BusinessLogic/Cubits/User/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:light_center/Data/Models/User/user_model.dart';
import 'package:light_center/Data/Models/Treatment/treatment_model.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:light_center/Services/network_service.dart';
import 'package:light_center/colors.dart';
import 'package:intl/intl.dart';
import 'package:light_center/extensions.dart';

late UserCubit userCubit;
late TreatmentCubit treatmentCubit;

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

String pendingAppointments({required Treatment treatment}) {
  if (treatment.availableAppointments != null) {
    return treatment.availableAppointments.toString();
  }
  return 'Sin datos...';
}

String lastDateToSchedule({required Treatment treatment}) {
  if (treatment.lastDateToSchedule != null) {
    return DateFormat.yMd('es-MX').format(treatment.lastDateToSchedule!).toString();
  }
  return 'Sin asignar...';
}

void cancelAppointment({required BuildContext context, required Appointment appointment}) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('¿Cancelar cita?'),
      content: Text('¿Deseas cancelar la cita agendada el ${appointment.jiffyDate} a la(s) ${appointment.jiffyTime}?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('No',
            style: TextStyle(
                color: LightCenterColors.mainPurple
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            NavigationService.pop();
            bool cancelResult = await userCubit.cancelAppointment(appointment: appointment);
            await NavigationService.showAlertDialog(
                title: Text(cancelResult == true ? 'Éxito al cancelar' : 'Error al cancelar',
                    style: TextStyle(
                        color: cancelResult ? LightCenterColors.mainPurple : LightCenterColors.mainBrown
                    )
                ),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(cancelResult ? Icons.check : Icons.close,
                        color: cancelResult ? Colors.green : Colors.red,
                        size: 80,
                      ),

                      Text(cancelResult == true ? 'La cita para del ${appointment.jiffyDate} a la(s) '
                          '${appointment.jiffyTime}, se canceló exitosamente'
                          : 'La cita no pudo ser cancelada.')
                    ]),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => NavigationService.pop(),
                    child: Text('Cerrar',
                      style: TextStyle(
                          color: LightCenterColors.mainPurple
                      ),
                    ),
                  ),
                ]
            );
            userCubit.emitUpdate();
          },
          child: const Text('Sí',
            style: TextStyle(
                color: Colors.red
            ),
          ),
        ),
      ],
    ),
  );
}