import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_center/BusinessLogic/Controllers/my_appointments_controller.dart';
import 'package:light_center/BusinessLogic/Cubits/User/user_cubit.dart';
import 'package:light_center/BusinessLogic/Cubits/Treatment/treatment_cubit.dart';
import 'package:light_center/Views/custom_widgets.dart';
import 'package:light_center/colors.dart';

class MyAppointments extends StatelessWidget {
  const MyAppointments({super.key});

  @override
  /*Widget build(BuildContext context) {
    userCubit = BlocProvider.of<TreatmentCubit>(context);
    userCubit.getUser();

    Widget? currentUserScreen;

    return BlocBuilder<UserCubit, UserState>(
      bloc: userCubit,
      builder: (context, state) {
        if (state is UserUpdated || state is UserSaved) {
          userCubit.getUser();
          currentUserScreen = updatingScreen(
              context: context, message: 'Obteniendo datos de usuario...');
        }

        if (state is UserLoading) {
          currentUserScreen = loadingScreen(context: context,
              message: 'Generando presentación de usuario...');
        }

        if (state is UserLoaded) {

          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          child: Icon(Icons.person),
                        ),

                        Text(state.user.name!),
                        Text(state.user.whatsappNumber!)
                      ],
                    ),
                  ),
                ),
              ),

              Visibility(
                  visible: state.user.appointments?.scheduledAppointments != null ,
                  child: ExpansionTile(
                    collapsedBackgroundColor: LightCenterColors.backgroundPurple,
                    backgroundColor: Colors.deepPurpleAccent,
                    initiallyExpanded: true,
                    title: const Text('Citas agendadas'),
                    children: scheduledAppointmentsList(state.user.appointments!.scheduledAppointments!),
                  )
              ),

              ListTile(
                title: const Text('Citas por agendar'),
                subtitle: Text(pendingAppointments(appointments: state.user.appointments),
                  style: TextStyle(
                      color: LightCenterColors.mainBrown,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),

              ListTile(
                title: const Text('Fecha límite para agendar'),
                subtitle: Text(lastDateToSchedule(appointments: state.user.appointments),
                    style: TextStyle(
                        color: LightCenterColors.mainBrown,
                        fontWeight: FontWeight.bold
                    )
                ),
              )
            ],
          );
        }

        if (state is UserError) {
          currentUserScreen = errorScreen(
              context: context, errorMessage: state.errorMessage.toString());
        }

        currentUserScreen ??= invalidStateScreen(context: context);

        return currentUserScreen!;
      }
      );
  }*/

  Widget build(BuildContext context) {
    return Center();
  }
}