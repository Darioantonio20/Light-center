import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_center/BusinessLogic/Cubits/Home/home_cubit.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:light_center/Views/custom_widgets.dart';
import 'package:light_center/Views/schedule.dart';
import 'package:light_center/Views/my_appointments.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    List<Widget> widgetOptions = <Widget>[
      const Schedule(),
      const MyAppointments(),
    ];

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: commonAppBar(
            actions: [
              IconButton(
                  onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
                  icon: const Icon(Icons.menu))
            ]
          ),
          body: widgetOptions.elementAt(state.currentIndex),
          endDrawer: commonDrawer(),
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
}