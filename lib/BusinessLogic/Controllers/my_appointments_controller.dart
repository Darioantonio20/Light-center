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

Future<void> fetchAppointments({required User user}) async {
  String data = await sendSOAPRequest(
      soapAction: 'http://tempuri.org/SPA_CITASRESERVADAS',
      envelopeName: 'SPA_CITASRESERVADAS',
      content: {
        'DSNDataBase': user.location.value!.code,
        'NoWhatsAPP': '521${user.whatsappNumber}',
        'EXTERNAL_Idref_pedidospresup': user.treatments.last.orderId
      }
  );

  if (data.contains('ERR:') || data.length == 1) {
    if (data.length == 1) {
      data = 'No cuenta con ninguna cita agendada.';
    } else {
      data = data.replaceAll("ERR: ", "");
    }

    return;
    /*return {
      'validation': false,
      'message': data
    };*/
  } else {
    user.treatments.last.scheduledAppointments = [];
    for (String appointmentData in data.substring(0, data.length - 1).split('ð')) {
      List<String> appointmentValues = appointmentData.split(',');
      Appointment _currentAppointment = Appointment();
      _currentAppointment.id = int.parse(appointmentValues.where((String element) => element.contains('id')).first.trim().trimEqualsData());
      _currentAppointment.date = appointmentValues.where((String element) => element.contains('fecha')).first.trim().trimEqualsData();
      _currentAppointment.time = appointmentValues.where((String element) => element.contains('hora')).first.trim().trimEqualsData();
      if (_currentAppointment.time!.length == 1) {
        _currentAppointment.time = '0${_currentAppointment.time}:00:00';
      } else {
        _currentAppointment.time = '${_currentAppointment.time}:00:00';
      }
      user.treatments.last.scheduledAppointments!.add(_currentAppointment);
    }
    treatmentCubit.updateTreatment(user.treatments.last);
  }
}

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

void cancelAppointment({required BuildContext context, required DateTime day, required User user}) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('¿Cancelar cita?'),
      content: Text('¿Deseas cancelar la cita agendada el ${DateFormat.yMMMMd('es-MX').format(day)} a la(s) ${DateFormat.jm().format(day)}?'),
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
            bool cancelResult = await userCubit.cancelAppointment(whatsappNumber: user.whatsappNumber!, day: day);
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

                      Text(cancelResult == true ? 'La cita para el ${DateFormat.yMMMMd('es-MX').format(day)} a la(s) '
                          '${DateFormat.jm().format(day)}, se canceló exitosamente'
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
            // Closing modalShow
            NavigationService.pop();
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