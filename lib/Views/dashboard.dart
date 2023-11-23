import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:light_center/BusinessLogic/Cubits/User/user_cubit.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:light_center/Views/custom_widgets.dart';
import 'package:light_center/colors.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:light_center/extensions.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    UserCubit userCubit = BlocProvider.of<UserCubit>(context);
    Widget? currentScreen;
    userCubit.getUser();

    return Scaffold(
      appBar: commonAppBar(),
      drawer: commonDrawer(),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
          distance: 130,
          overlayStyle: ExpandableFabOverlayStyle(
              blur: 10
          ),
          type: ExpandableFabType.up,
          openButtonBuilder: RotateFloatingActionButtonBuilder(
            fabSize: ExpandableFabSize.large,
            child: const Icon(
              Icons.quick_contacts_dialer,
              semanticLabel: 'Ayuda',
            ),
            foregroundColor: Colors.deepPurple,
            shape: const CircleBorder(),
          ),
          closeButtonBuilder: DefaultFloatingActionButtonBuilder(
            child: const Icon(Icons.close),
            fabSize: ExpandableFabSize.large,
            shape: const CircleBorder(),
          ),
          children: [
            FloatingActionButton.large(
              heroTag: 'email',
              tooltip: 'Enviar correo',
              onPressed: () => NavigationService.sendEmail(),
              child: const Icon(FontAwesomeIcons.envelope, color: Colors.blue, size: 50),
            ),

            FloatingActionButton.large(
              heroTag: 'whatsapp',
              tooltip: 'Link de Whatsapp',
              onPressed: () => NavigationService.openWhatsappLink(),
              child: const Icon(FontAwesomeIcons.whatsapp, color: Colors.green, size: 50),
            ),

            FloatingActionButton.large(
              heroTag: 'telephone',
              tooltip: 'Llamar',
              onPressed: () => NavigationService.makeCall(),
              child: Icon(Icons.phone, color: LightCenterColors.mainPurple, size: 50),
            ),
          ]
      ),
      body: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
        if (state is UserUpdated || state is UserSaved) {
          userCubit.getUser();
          currentScreen = updatingScreen(context: context);
        }

        if (state is UserLoading) {
          currentScreen = loadingScreen(context: context);
        }

        if (state is UserLoaded) {
          state.user.treatments.load();
          currentScreen = SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                Visibility(
                  visible: state.user.treatments.last.scheduledAppointments!.isNotEmpty,
                    child: Container(
                        decoration: BoxDecoration(
                          color: LightCenterColors.mainPurple.withOpacity(0.9),
                          //color: Color.fromRGBO(80, 50, 124, 0.75),
                        ),
                        child: Text('Su próxima cita es el día ${state.user.treatments.last.scheduledAppointments!.isNotEmpty ? state.user.treatments.last.scheduledAppointments!.first.jiffyDate : ''}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          ),
                        ))
                ),

                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01,
                      bottom: MediaQuery.of(context).size.height * 0.01
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            minRadius: 40,
                            child: Icon(Icons.person,
                              size: 50,
                            ),
                          ),

                          Text(state.user.name!.toPascalCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(state.user.whatsappNumber!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                GridView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 4/3,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                  ),
                  children: [
                    GestureDetector(
                      onTap: () => NavigationService.pushNamed(NavigationService.homeScreen),
                      child: Card(
                        color: const Color.fromRGBO(119, 61, 190, 1),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35.0),
                            image: const DecorationImage(image: AssetImage("assets/images/mis_citas.png"), fit: BoxFit.fill)
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () => NavigationService.showSnackBar(message: 'No implementado'),
                      child: Card(
                        color: const Color.fromRGBO(32, 203, 212, 1),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35.0),
                              image: const DecorationImage(image: AssetImage("assets/images/mis_pagos.png"), fit: BoxFit.fill)
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () => NavigationService.pushNamed(NavigationService.news),
                      child: Card(
                        color: const Color.fromRGBO(224, 23, 131, 1),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35.0),
                              image: const DecorationImage(image: AssetImage("assets/images/promociones.png"), fit: BoxFit.fill)
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () => NavigationService.pushNamed(NavigationService.nutritionalOrientation),
                      child: const Card(
                        color: Colors.green,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.restaurant,
                              size: 40,
                              color: Colors.white,
                            ),
                            Flexible(
                              child: Text('Orientación\nNutricional',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        }

        if (state is UserError) {
          currentScreen = errorScreen(context: context, errorMessage: state.errorMessage.toString());
        }

        currentScreen ??= invalidStateScreen(context: context);

        return currentScreen!;
      }),
    );
  }
}