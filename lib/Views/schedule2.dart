import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_center/BusinessLogic/Cubits/User/user_cubit.dart';
import 'package:light_center/Data/Models/event_model.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:light_center/Views/custom_widgets.dart';
import 'package:light_center/colors.dart';
import 'package:light_center/BusinessLogic/Controllers/schedule_controller.dart';
import 'package:table_calendar/table_calendar.dart';
//import 'package:light_center/Data/Models/Treatment/treatment_model.dart';

class Schedule extends StatelessWidget {
  //final Treatment treatment;
  //const Schedule({super.key, required this.treatment});
  const Schedule({super.key});

  @override
  /*Widget build(BuildContext context) {
    userCubit = BlocProvider.of<UserCubit>(context);
    userCubit.getAvailableDates();

    return BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserUpdated || state is UserSaved) {
            userCubit.getAvailableDates();
            return updatingScreen(context: context);
          }

          if (state is UserLoading) {
            return loadingScreen(context: context);
          }

          if (state is UserLoaded) {
            selectedDay = ValueNotifier<DateTime?>(null);
            focusedDay = ValueNotifier<DateTime>(getFirstDateToSchedule(appointments: state.user.appointments));
            eventsList = generateEventsList(user:  state.user);

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
                          lastDay: getLastDateToSchedule(appointments: state.user.appointments),
                          focusedDay: iFocusedDay,
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          locale: 'es-MX',
                          enabledDayPredicate: (DateTime date) {
                            return date.weekday != DateTime.saturday && date.weekday != DateTime.sunday;
                          },
                          eventLoader: (date) {
                            return eventsList
                                .where((event) => DateUtils.isSameDay(event.dateTime, date)).toList();
                          },
                          selectedDayPredicate: (day) {
                            return isSameDay(selectedDay.value, day);
                          },

                          onDaySelected: (newSelectedDay, newFocusedDay) {
                            selectedDay.value = newSelectedDay;
                            focusedDay.value = newFocusedDay;
                            getDaySchedule(day: selectedDay.value!).then((daySchedule) {
                              if (daySchedule.where((element) => element.toLowerCase().contains('error')).toList().isNotEmpty) {
                                NavigationService.showSnackBar(message: 'Ocurrió un error al cargar los horarios.');
                              } else {
                                showModal(
                                    context: context,
                                    events: getEventsForDay(),
                                    schedule: daySchedule,
                                    user: state.user
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
          }

          if (state is UserError) {
            return errorScreen(context: context, errorMessage: state.errorMessage);
          }

          return invalidStateScreen(context: context);
        }
    );
  }*/
  Widget build(BuildContext context) {
    return const Center();
  }
}