import 'package:flutter/material.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:light_center/Services/network_service.dart';
import 'package:light_center/Views/custom_widgets.dart';
import 'package:light_center/colors.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    String nombre = 'Jesús Eduardo Martínez García';
    String telefono = '961 307 9673';
    return Scaffold(
      appBar: commonAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.call),),
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

                      Text(nombre,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(telefono,
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
                  onTap: null,
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