import 'package:intl/intl.dart';
import 'package:light_center/BusinessLogic/Cubits/User/user_cubit.dart';
import 'package:light_center/Data/Models/event_model.dart';
import 'package:light_center/Data/Models/User/user_model.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:light_center/Services/network_service.dart';
import 'package:light_center/Views/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:light_center/colors.dart';
import 'package:light_center/enums.dart';
import 'package:jiffy/jiffy.dart';

List<Event> eventsList = [];

late UserCubit userCubit;
Map<DateTime, List> events = {};
late final ValueNotifier<List<Event>> selectedEvents;
late ValueNotifier<DateTime?> selectedDay;
late ValueNotifier<DateTime> focusedDay;

/*DateTime getFirstDateToSchedule({required Appointments? appointments}) {
  if (appointments != null) {
    if (appointments.firstDateToSchedule != null) {
      if (appointments.firstDateToSchedule!.isAfter(DateTime.now())) {
        return appointments.firstDateToSchedule!;
      }
    }
  }
  return DateTime.now();
}

DateTime getLastDateToSchedule({required Appointments? appointments}) {
  if (appointments != null) {
    if (appointments.lastDateToSchedule != null) {
      return appointments.lastDateToSchedule!;
    }
  }
  return DateTime.now();
}

List<Event> generateEventsList({required User user}) {
  List<Event> eventsList = [];
  if (user.appointments?.scheduledAppointments != null) {
    List<String> scheduledList = user.appointments!.scheduledAppointments ?? [];
    List<String> bookedList = user.appointments!.bookedDates ?? [];
    scheduledList.addAll(bookedList);
    for (var appointment in scheduledList) {
      eventsList.add(Event(title: 'Tratamiento de ${user.currentTreatment!}', dateTime: DateTime.parse(appointment)));
    }
  }
  return eventsList;
}*/

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

/*List<String> getDaySchedule() {
  sendRequest(
      endPoint: '/day-schedule',
      method: HTTPMethod.post,
      body: {'day': DateFormat.yMMMMd('es-MX').format(selectedDay.value!)}
  );

  return [];
}*/

Future<List<String>> getDaySchedule({required DateTime day}) async {
  try {
    Map<String, dynamic> data = await sendRequest(
        endPoint: '/day-schedule',
        method: HTTPMethod.post,
        body: {'day': DateFormat('dd-MM-yyyy').format(selectedDay.value!)}
    );
    if (data.containsKey('Error')) {
      return [
        'Ocurrió un error al cargar los horarios',
        data['Eror'],
        'Si el error persiste, favor de notificar a LightCenter'
      ];
    } else {
      return List<String>.from(data['Schedule']);
    }
  } catch (e) {
    return [
      'Ocurrió un error al cargar los horarios:',
      e.toString(),
      'Si el error persiste, favor de notificar a LightCenter'
    ];
  }
}

/*void scheduleAppointment({required BuildContext context, required DateTime day, required User user}) {
  int appointmentsInWeek = 0;

  for (String appointment in user.appointments!.scheduledAppointments!) {
    DateTime appointmentAsDT = DateTime.parse(appointment);
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

  if (appointmentsInWeek < user.appointments!.appointmentsPerWeek!) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('¿Agendar cita?'),
        content: Text('¿Deseas la cita para el ${DateFormat.yMMMMd('es-MX').format(day)} a la(s) ${DateFormat.jm().format(day)}?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No',
              style: TextStyle(
                  color: Colors.red
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              bool scheduleResult = await userCubit.scheduleAppointment(whatsappNumber: user.whatsappNumber!, day: day);
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
                      onPressed: () => Navigator.pop(context),
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
        content: Text('Ya tienes agendadas $appointmentsInWeek citas en esta semana, el límite por semana es de ${user.appointments!.appointmentsPerWeek}'),
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
}*/

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
            cancelAppointment(context: context, day: scheduledDate, user: user);
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