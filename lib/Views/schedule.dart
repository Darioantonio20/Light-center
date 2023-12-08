import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:light_center/BusinessLogic/Cubits/User/user_cubit.dart';
import 'package:light_center/Data/Models/Treatment/treatment_model.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:light_center/Views/custom_widgets.dart';
import 'package:light_center/colors.dart';
import 'package:light_center/BusinessLogic/Controllers/schedule_controller.dart';
import 'package:table_calendar/table_calendar.dart';

class Schedule extends StatelessWidget {
  const Schedule({super.key});

  @override
  Widget build(BuildContext context) {
    userCubit = BlocProvider.of<UserCubit>(context);
    userCubit.getAvailableDatesBySOAP();
    Widget? currentScreen;

    return BlocBuilder<UserCubit, UserState>(builder: (context, state) {
      if (state is UserUpdated || state is UserSaved) {
        userCubit.getAvailableDatesBySOAP();
        currentScreen = updatingScreen(context: context);
      }

      if (state is UserLoading) {
        currentScreen = loadingScreen(context: context);
      }

      if (state is UserLoaded) {
        focusedDay = ValueNotifier<DateTime>(DateTime.now());
        selectedDay = ValueNotifier<DateTime>(DateTime.now());

        availableDates = state.user.treatments.last.availableDates ?? [];
        eventsList = state.user.treatments.last.scheduledAppointments ?? [];

        if (availableDates.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Icon(FontAwesomeIcons.calendarMinus,
                      size: 200, color: Colors.red),
                ),
                Text('No hay fechas disponibles',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: LightCenterColors.mainBrown))
              ],
            ),
          );
        }

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

            Visibility(
              visible: state.user.treatments.last.dateRanges!.isNotEmpty,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.user.treatments.last.dateRanges!.length,
                  itemBuilder: (context, index) {
                    late Color rangeColor;
                    if (index % 2 == 0) {
                      rangeColor = LightCenterColors.backgroundPurple;
                    } else {
                      rangeColor = LightCenterColors.backgroundPink;
                    }

                    return Container(
                      color: rangeColor,
                      child: Text(state.user.treatments.last.dateRanges![index].toString(),
                        style: const TextStyle(
                          fontSize: 18
                        ),
                      ),
                    );
                  }
                  ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ValueListenableBuilder(
                  valueListenable: focusedDay,
                  builder: (context, iFocusedDay , _) {
                    return TableCalendar<Appointment>(
                      firstDay: DateTime.now(),
                      lastDay: availableDates.last,
                      focusedDay: iFocusedDay,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      locale: 'es-MX',
                      enabledDayPredicate: (DateTime date) {
                        //return if (availableDates.where((element) => isSameDay(element, date)).isNotEmpty || eventsList.where((element) => isSameDay(element.dateTime, date)).isNotEmpty);
                        return availableDates.where((element) => isSameDay(element, date)).isNotEmpty;
                      },
                      eventLoader: (date) {
                        return eventsList.where((event) => DateUtils.isSameDay(event.dateTime, date)).toList();
                      },
                      selectedDayPredicate: (day) {
                        return isSameDay(selectedDay.value, day);
                      },

                      onDaySelected: (newSelectedDay, newFocusedDay) {
                        selectedDay.value = newSelectedDay;
                        focusedDay.value = newFocusedDay;
                        getDaySchedule(day: selectedDay.value!, user: state.user).then((daySchedule) {
                          if (daySchedule.where((element) => element.toLowerCase().contains('error')).toList().isNotEmpty) {
                            NavigationService.showSnackBar(message: 'Ocurrió un error al cargar los horarios.');
                          } else {
                            showModal(
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
        currentScreen = errorScreen(context: context, errorMessage: '${state.errorMessage}\n\nRecargando datos...');
        Future.delayed(
            const Duration(seconds: 5), () {
              userCubit.getAvailableDatesBySOAP();
        });
      }

      currentScreen ??= invalidStateScreen(context: context);

      return currentScreen!;
    });
  }
}