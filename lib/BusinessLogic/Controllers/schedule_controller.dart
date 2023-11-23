import 'package:intl/intl.dart';
import 'package:light_center/BusinessLogic/Cubits/User/user_cubit.dart';
import 'package:light_center/Data/Models/Treatment/treatment_model.dart';
import 'package:light_center/Data/Models/event_model.dart';
import 'package:light_center/Data/Models/User/user_model.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:light_center/Services/network_service.dart';
import 'package:light_center/Views/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:light_center/colors.dart';
import 'package:jiffy/jiffy.dart';

List<Event> eventsList = [];

late UserCubit userCubit;
Map<DateTime, List> events = {};
late final ValueNotifier<List<Event>> selectedEvents;
late ValueNotifier<DateTime?> selectedDay;
late ValueNotifier<DateTime> focusedDay;
List<DateTime> availableDates = [];
late bool scheduled;

void showModal({required BuildContext context, required List<Event> events, required List<String> schedule, required User user}) {
  showModalBottomSheet<void>(
    context: context,
    isDismissible: false,
    isScrollControlled: true,
    enableDrag: false,
    builder: (BuildContext context) {
      return eventsModalSheet(context: context, selectedDay: selectedDay.value!, events: eventsList, schedule: schedule, user: user);
    },
  );
}

List<Event> getEventsForDay() {
  return eventsList.where((event) => DateUtils.isSameDay(event.dateTime, selectedDay.value)).toList();
}

Future<List<String>> getDaySchedule({required DateTime day, required User user}) async {
  try {
    String data = await sendSOAPRequest(
        soapAction: 'http://tempuri.org/SPA_HORASDISPONIBLES',
        envelopeName: 'SPA_HORASDISPONIBLES',
        content: {
          'DSNDataBase': user.location.value!.code,
          'NoWhatsAPP': '521${user.whatsappNumber}',
          'EXTERNAL_FechaCandidata': DateFormat("dd/MM/yyyy").format(day).toString()
        }
    );

    if (data.contains('ERR:')) {
      return [
        'Ocurrió un error al cargar los horarios',
        data.replaceAll("ERR: ", ""),
        'Si el error persiste, favor de notificar a LightCenter'
      ];
    } else {
      data = data.substring(0, data.lastIndexOf(","));
      List<String> hours = [];
      for (String hour in data.split(",")) {
        hour = hour.trim();
        if (hour.length == 1) {
          hour = "0$hour:00";
        } else {
          hour = "$hour:00";
        }
        hours.add(hour);
      }
      return hours;
    }
  } catch (e) {
    return [
      'Ocurrió un error al cargar los horarios:',
      e.toString(),
      'Si el error persiste, favor de notificar a LightCenter'
    ];
  }
}

Future<void> scheduleAppointment({required BuildContext context, required DateTime day, required User user}) async {
  int appointmentsInWeek = 0;

  for (Appointment appointment in user.treatments.last.scheduledAppointments!) {
    DateTime appointmentAsDT = appointment.dateTime!;

    if (DateUtils.isSameDay(appointmentAsDT, day)) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Seleccione otra fecha'),
          content: const Text('No se puede agendar más de una cita por día'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Ok',
                style: TextStyle(
                    color: LightCenterColors.mainPurple
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }

    if (Jiffy.parseFromDateTime(appointmentAsDT).weekOfYear == Jiffy.parseFromDateTime(day).weekOfYear){
      appointmentsInWeek += 1;
    }
  }

  if (appointmentsInWeek < (user.treatments.last.appointmentsPerWeek ?? 1)) {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('¿Agendar cita?'),
        content: Text('¿Deseas la cita para el ${DateFormat.yMMMMd('es-MX').format(day)} a la(s) ${DateFormat.jm().format(day)}?'),
        actions: <Widget>[
          TextButton(
            //onPressed: () => Navigator.pop(context),
            onPressed: () => NavigationService.pop(),
            child: const Text('No',
              style: TextStyle(
                  color: Colors.red
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              bool scheduleResult = await userCubit.scheduleAppointment(day: day);
              scheduled = true;

              await showDialog(
                context: NavigationService.context(),
                builder: (BuildContext context) => AlertDialog(
                  title: Text(scheduleResult == true ? 'Éxito al agendar' : 'Error al agendar',
                    style: TextStyle(
                      color: scheduleResult ? LightCenterColors.mainPurple : LightCenterColors.mainBrown
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(scheduleResult ? Icons.check : Icons.close,
                        color: scheduleResult ? Colors.green : Colors.red,
                        size: 80,
                      ),

                      Text(scheduleResult == true ? 'La cita para el ${DateFormat.yMMMMd('es-MX').format(day)} a la(s) '
                          '${DateFormat.jm().format(day)}, se agendó exitosamente'
                          : 'La cita no pudo ser agendada.')
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => NavigationService.pop(),
                      child: Text('Cerrar',
                        style: TextStyle(
                            color: LightCenterColors.mainPurple
                        ),
                      ),
                    ),
                  ],
                ),
              );
              // Closing modalShow
              NavigationService.pop();
              userCubit.emitUpdate();
            },
            child: Text('Sí',
              style: TextStyle(
                  color: LightCenterColors.mainPurple
              ),
            ),
          ),
        ],
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Límite alcanzado'),
        content: Text('Ya tienes agendadas $appointmentsInWeek citas en esta semana, el límite por semana es de ${user.treatments.last.appointmentsPerWeek}'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Ok',
              style: TextStyle(
                  color: LightCenterColors.mainPurple
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void manageScheduledAppointment({required BuildContext context, required DateTime scheduledDate, required User user}){
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Seleccione una opción'),
      content: Text('Selecciona una opción para la cita del ${DateFormat.yMMMMd('es-MX').format(scheduledDate)} a la(s) ${DateFormat.jm().format(scheduledDate)}'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cerrar',
            style: TextStyle(
                color: LightCenterColors.mainPurple
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            //cancelAppointment(context: context, day: scheduledDate, user: user);
          },
          child: const Text('Cancelar',
            style: TextStyle(
                color: Colors.red
            ),
          ),
        ),
      ],
    ),
  );
}