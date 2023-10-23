import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:light_center/BusinessLogic/Cubits/User/user_cubit.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:light_center/Services/network_service.dart';
import 'package:light_center/Views/custom_widgets.dart';
import 'package:light_center/colors.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    UserCubit _userCubit = BlocProvider.of<UserCubit>(context);

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
              tooltip: 'Enviar correo',
              onPressed: () => NavigationService.sendEmail(),
              child: const Icon(FontAwesomeIcons.envelope, color: Colors.blue, size: 50),
            ),

            FloatingActionButton.large(
              tooltip: 'Link de Whatsapp',
              onPressed: () => NavigationService.openWhatsappLink(),
              child: const Icon(FontAwesomeIcons.whatsapp, color: Colors.green, size: 50),
            ),

            FloatingActionButton.large(
              tooltip: 'Llamar',
              onPressed: () => NavigationService.makeCall(),
              child: Icon(Icons.phone, color: LightCenterColors.mainPurple, size: 50),
            ),
          ]
      ),
      /*floatingActionButton: FloatingActionButton.large(
        onPressed: () {},
        child: const Icon(Icons.call)),*/
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05,
                  bottom: MediaQuery.of(context).size.height * 0.05
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

                      Text('Cambiar por cubit',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('Agregar estados',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                          )
                      )
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
                  crossAxisSpacing: 20
              ),
              children: [
                GestureDetector(
                  onTap: () => NavigationService.pushNamed(NavigationService.homeScreen),
                  child: Card(
                    color: LightCenterColors.mainPurple,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.book,
                            size: 50,
                            color: Colors.white,
                          ),
                          Flexible(
                            child: Text('Mis\nCitas',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    sendSOAPRequest(
                        soapAction: 'http://tempuri.org/SPA_FRANQUICIAS',
                        envelopeName: 'SPA_FRANQUICIAS',
                        content: {
                          'DameNombreUDN': 'REGISTROINICIAL'
                        });
                  },
                  child: Card(
                    color: LightCenterColors.mainBrown,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.attach_money,
                          size: 50,
                          color: Colors.white,
                        ),
                        Flexible(
                          child: Text('Mis\nPagos',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () => NavigationService.pushNamed(NavigationService.news),
                  child: const Card(
                    color: Colors.deepOrange,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_offer,
                          size: 40,
                          color: Colors.white,
                        ),
                        Flexible(
                          child: Text('Promos',
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
      )
    );
  }
}