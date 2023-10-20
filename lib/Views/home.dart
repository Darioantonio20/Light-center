import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_center/BusinessLogic/Cubits/Home/home_cubit.dart';
import 'package:light_center/BusinessLogic/Cubits/User/user_cubit.dart';
import 'package:light_center/Data/Repositories/user_repository.dart';
import 'package:light_center/Views/custom_widgets.dart';
import 'package:light_center/Views/schedule.dart';
import 'package:light_center/Views/my_appointments.dart';
import 'package:light_center/Views/news.dart';

class HomeArguments {
  final UserRepository userRepository;
  HomeArguments({required this.userRepository});
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as HomeArguments;
    final UserCubit userCubit = UserCubit(args.userRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>(create: (_) => userCubit),
        BlocProvider<HomeCubit>(create: (_) => HomeCubit())
      ],
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          const List<Widget> widgetOptions = <Widget>[
            Schedule(),
            MyAppointments(),
            News(),
          ];

          return Scaffold(
            appBar: commonAppBar(showReload: true, userCubit: userCubit),
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

                BottomNavigationBarItem(
                  icon: Icon(Icons.newspaper),
                  label: 'Noticias',
                )
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
      ),
    );
  }
}