import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_center/BusinessLogic/Cubits/User/user_cubit.dart';
import 'package:light_center/Data/Models/event_model.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:light_center/Views/custom_widgets.dart';
import 'package:light_center/colors.dart';
import 'package:light_center/BusinessLogic/Controllers/schedule_controller.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:light_center/Data/Models/User/user_model.dart';

class Schedule extends StatelessWidget {
  final User user;
  const Schedule({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DateTime>>(
        future: getAvailableDays(user: user),
        builder: (BuildContext context, AsyncSnapshot<List<DateTime>> snapshot) {
          if (snapshot.hasData) {
            availableDates = snapshot.data!;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('Fechas disponibles',
                    style: TextStyle(
                        color: LightCenterColors.mainBrown,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ValueListenableBuilder(
                      valueListenable: focusedDay,
                      builder: (context, iFocusedDay , _) {
                        return TableCalendar<Event>(
                          firstDay: DateTime.now(),
                          //lastDay: getLastDateToSchedule(validity: user.treatments.last.lastDateToSchedule),
                          lastDay: availableDates.last,
                          focusedDay: iFocusedDay,
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          locale: 'es-MX',
                          enabledDayPredicate: (DateTime date) {
                            return (date.weekday != DateTime.saturday && date.weekday != DateTime.sunday && availableDates.where((element) => isSameDay(element, date)).isNotEmpty);
                          },
                          /*eventLoader: (date) {
                            return eventsList
                                .where((event) => DateUtils.isSameDay(event.dateTime, date)).toList();
                          },*/
                          selectedDayPredicate: (day) {
                            return isSameDay(selectedDay.value, day);
                          },

                          onDaySelected: (newSelectedDay, newFocusedDay) {
                            selectedDay.value = newSelectedDay;
                            focusedDay.value = newFocusedDay;
                            /*getDaySchedule(day: selectedDay.value!).then((daySchedule) {
                              if (daySchedule.where((element) => element.toLowerCase().contains('error')).toList().isNotEmpty) {
                                NavigationService.showSnackBar(message: 'Ocurrió un error al cargar los horarios.');
                              } else {
                                showModal(
                                    context: context,
                                    events: getEventsForDay(),
                                    schedule: daySchedule,
                                    user: user
                                );
                              }
                            });*/
                            getDaySchedule(day: selectedDay.value!, user: user).then((daySchedule) {
                              if (daySchedule.where((element) => element.toLowerCase().contains('error')).toList().isNotEmpty) {
                                NavigationService.showSnackBar(message: 'Ocurrió un error al cargar los horarios.');
                              } else {
                                showModal(
                                    context: context,
                                    events: getEventsForDay(),
                                    schedule: daySchedule,
                                    user: user
                                );
                              }
                            });
                          },
                          headerStyle: const HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true
                          ),
                          calendarStyle: CalendarStyle(
                              markerDecoration: BoxDecoration(
                                  color: LightCenterColors.mainBrown,
                                  shape: BoxShape.circle),
                              selectedDecoration: BoxDecoration(
                                  color: LightCenterColors.mainPurple,
                                  shape: BoxShape.circle),
                              todayDecoration: BoxDecoration(
                                  color: LightCenterColors.backgroundPurple,
                                  shape: BoxShape.circle)
                          ),
                        );
                      }),
                )
              ],
            );
          } else if (snapshot.hasError) {
            return errorScreen(context: context, errorMessage: 'Ocurrió un error al obtener las fechas disponibles');
          }
          return loadingScreen(context: context);
        }
    );
  }
}