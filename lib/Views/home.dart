import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_center/BusinessLogic/Cubits/Home/home_cubit.dart';
import 'package:light_center/BusinessLogic/Cubits/User/user_cubit.dart';
import 'package:light_center/Views/custom_widgets.dart';
import 'package:light_center/Views/schedule.dart';
import 'package:light_center/Views/my_appointments.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget? _currentScreen;
    final UserCubit userCubit = BlocProvider.of<UserCubit>(context);
    userCubit.getUser();

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserUpdated || state is UserSaved) {
          userCubit.getUser();
          _currentScreen = updatingScreen(context: context);
        }

        if (state is UserLoading) {
          _currentScreen = loadingScreen(context: context);
        }

        if (state is UserLoaded) {
          state.user.treatments.load();
          List<Widget> widgetOptions = <Widget>[
            Schedule(user: state.user),
            MyAppointments(user: state.user),
          ];

          return BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return Scaffold(
                appBar: commonAppBar(),
                body: widgetOptions.elementAt(state.currentIndex),
                bottomNavigationBar: BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_month),
                      label: 'Agendar',
                    ),

                    BottomNavigationBarItem(
                      icon: Icon(Icons.medical_information),
                      label: 'Mis Citas',
                    ),
                  ],
                  type: BottomNavigationBarType.fixed,
                  currentIndex: state.currentIndex,
                  selectedItemColor: Colors.purple,
                  onTap: (int selectedIndex) =>
                      BlocProvider.of<HomeCubit>(context).changeSelectedIndex(
                          selectedIndex),
                ),
              );
            },
          );
        }

        if (state is UserError) {
          _currentScreen = errorScreen(context: context, errorMessage: state.errorMessage.toString());
        }

        _currentScreen ??= invalidStateScreen(context: context);

        return Scaffold(
          appBar: commonAppBar(),
          body: _currentScreen,
        );
      },
    );

    /*return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        const List<Widget> widgetOptions = <Widget>[
          Schedule(),
          MyAppointments(),
        ];

        return Scaffold(
          appBar: commonAppBar(),
          body: widgetOptions.elementAt(state.currentIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: 'Agendar',
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.medical_information),
                label: 'Mis Citas',
              ),
            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: state.currentIndex,
            selectedItemColor: Colors.purple,
            onTap: (int selectedIndex) =>
                BlocProvider.of<HomeCubit>(context).changeSelectedIndex(
                    selectedIndex),
          ),
        );
      },
    );*/
  }
}