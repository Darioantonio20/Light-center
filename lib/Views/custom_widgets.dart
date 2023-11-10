import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:light_center/BusinessLogic/Controllers/schedule_controller.dart';
import 'package:light_center/Data/Models/User/user_model.dart';
import 'package:light_center/Data/Models/event_model.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:light_center/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


AppBar commonAppBar({
  Widget? title,
  }) {
  return AppBar(
    title: title ?? Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Light",
            style: TextStyle(color: LightCenterColors.mainBrown)
        ),
        Container(
          color: LightCenterColors.mainPurple,
          child: const Text('CENTER',
            style: TextStyle(
                color: Colors.white
            ),
          ),
        )
      ],
    ),
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [LightCenterColors.backgroundPink, Colors.white, LightCenterColors.backgroundPurple]),
      ),
    ),
    backgroundColor: Colors.deepPurpleAccent,
    centerTitle: true,
    actions: [
      IconButton(
          onPressed: () => showAboutDialog(
              context: NavigationService.context(),
              applicationName: 'Light Center',
              applicationVersion: 'Versión 1.0',
              applicationLegalese: 'Kranzwide Consultive S.A. de C.V.',
              applicationIcon: Image.asset('assets/images/icon-512.png',
                  width: 50,
                  height: 50
              ),
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 20
                ),
                child: Row(
                  children: [
                    const Text('Desarrollador: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                        )
                    ),
                    GestureDetector(
                      onTap: () => NavigationService.openURL(baseUrl: 'github.com', endPoint: '/ChuyEx'),
                      child: Text('ChuyEx',
                          style: TextStyle(
                              color: LightCenterColors.mainPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: 14
                          )
                      ),
                    )
                  ],
                ),
              ),

              const Center(child: Text('Contacta a la consultora',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18
                ))
              ),

              Padding(
                padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10
                ),
                child: Row(
                  children: [
                    const Text('Pagina Web: '),
                    GestureDetector(
                      onTap: () => NavigationService.openURL(baseUrl: 'predictionsoft.com.mx', endPoint: ''),
                      child: Text('predictionsoft.com.mx', style: TextStyle(color: LightCenterColors.mainPurple)),
                    )
                  ],
                ),
              ),

              Row(
                children: [
                  const Text('Email: '),
                  GestureDetector(
                    onTap: () => NavigationService.sendEmail(email: 'ventas@predictionsoft.com.mx'),
                    child: Text('ventas@predictionsoft.com.mx', style: TextStyle(color: LightCenterColors.mainPurple)),
                  )
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10
                ),
                child: Row(
                  children: [
                    const Text('Facebook: '),
                    GestureDetector(
                      onTap: () => NavigationService.openURL(baseUrl: 'facebook.com', endPoint: '/PredictionSOFTwareNube'),
                      child: Text('PredictionSOFTwareNube', style: TextStyle(color: LightCenterColors.mainPurple)),
                    )
                  ],
                ),
              ),

              Row(
                children: [
                  const Text('Teléfono: '),
                  GestureDetector(
                    onTap: () => NavigationService.makeCall(phoneNumber: '5219613662079'),
                    child: Text('9613662079', style: TextStyle(color: LightCenterColors.mainPurple)),
                  )
                ],
              ),
            ]
          ),
          icon: const Icon(Icons.info))
    ],
  );
}

SizedBox updatingScreen({required BuildContext context, String message = 'Obteniendo datos...'}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Padding(
      padding: const EdgeInsets.only(
          left: 20.0,
          right:20.0
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: SpinKitHourGlass(color: LightCenterColors.mainPurple),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(message),
          )
        ],
      ),
    ),
  );
}

SizedBox loadingScreen({required BuildContext context, String message = 'Generando presentación...'}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Padding(
      padding: const EdgeInsets.only(
          left: 20.0,
          right:20.0
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: SpinKitWaveSpinner(
              color: LightCenterColors.mainPurple,
              trackColor: LightCenterColors.backgroundPink,
              waveColor: LightCenterColors.mainBrown,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(message),
          )
        ],
      ),
    ),
  );
}

SizedBox errorScreen({required BuildContext context, required String errorMessage}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Padding(
      padding: const EdgeInsets.only(
          left: 20.0,
          right:20.0
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text('Error: $errorMessage'),
          )
        ],
      ),
    ),
  );
}

SizedBox invalidStateScreen({required BuildContext context}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: const Padding(
      padding: EdgeInsets.only(
          left: 20.0,
          right:20.0
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.close,
            color: Colors.orange,
            size: 60,
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text('El estado no es válido'),
          )
        ],
      ),
    ),
  );
}

SizedBox invalidScreen({required BuildContext context}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: const Padding(
      padding: EdgeInsets.only(
          left: 20.0,
          right:20.0
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.close,
            color: Colors.orange,
            size: 60,
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text('El contenido no pudo ser cargado.'),
          )
        ],
      ),
    ),
  );
}

SizedBox eventsModalSheet({required BuildContext context, required DateTime selectedDay, required List<Event> events, required List<String> schedule, required User user}) {
  events = events.where((event) => DateUtils.isSameDay(event.dateTime, selectedDay)).toList();
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.6,
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Center(
                  child: Text(DateFormat.yMMMMd('es-MX').format(selectedDay).toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: LightCenterColors.mainBrown
                    ),
                  ),
                ),

                const Spacer(),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: LightCenterColors.mainPurple))
              ],
            ),
          ),
          
          Visibility(
              visible: events.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text('Citas agendadas',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: LightCenterColors.mainPurple
                          ),
                        ),
                      ),
                      getScheduleGrid(schedule: events, selectedDay: selectedDay, user: user),
                    ],
                  ),
                ),
              )
          ),

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text('Horas disponibles',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: LightCenterColors.mainPurple
                    ),
                  ),
                ),

                getScheduleGrid(schedule: schedule, selectedDay: selectedDay, user: user),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              bottom: 10.0
            ),
            child: ElevatedButton(
              child: const Text('Cerrar horario'),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    ),
  );
}

GridView getScheduleGrid({required List<dynamic> schedule, required DateTime selectedDay, required User user}) {
  return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 16/9,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20
      ),
      padding: const EdgeInsets.all(8.0),
      itemCount: schedule.length,
      itemBuilder: (context, index) {
        late DateTime currentDateTime;
        if (schedule.runtimeType == List<Event>) {
          currentDateTime = schedule[index].dateTime;
        } else {
          currentDateTime = DateTime.parse(''
              '${selectedDay.toString().substring(0,selectedDay.toString().indexOf(' '))}'
              ' ${schedule[index]}');
        }

        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.01,
          child: FilledButton(
              onPressed: () {
                if(schedule.runtimeType == List<Event>) {
                  manageScheduledAppointment(context: context, scheduledDate: currentDateTime, user: user);
                } else {
                  scheduleAppointment(context: context, day: currentDateTime, user: user);
                }
              },
              child: Text(
                  DateFormat.jm().format(currentDateTime),
                  textAlign: TextAlign.center
              )
          ),
        );
      }
  );
}

Drawer commonDrawer() {
  return Drawer(
    child: ListView(
      physics: const ClampingScrollPhysics(),
      children: [

        const Padding(
          padding: EdgeInsets.only(
            top: 10,
            bottom: 10
          ),
          child: Center(
              child: Text('Menú',
                style:TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              )
          ),
        ),

        tappableListTileItem(
            isDisabled: true,
            icon: Icons.person,
            title: 'Mi Perfil',
            action: () {
              NavigationService.pop();
              NavigationService.showSnackBar(message: 'No implementado');
            }
        ),

        const Divider(),

        tappableListTileItem(
            icon: Icons.book,
            title: 'Mis Citas',
            action: () => NavigationService.popAndPushNamed(NavigationService.homeScreen)
        ),

        const Divider(),

        tappableListTileItem(
            isDisabled: true,
            icon: Icons.attach_money,
            title: 'Mis Pagos',
            action: () {
              NavigationService.pop();
              NavigationService.showSnackBar(message: 'No implementado');
            }
        ),

        const Divider(),

        tappableListTileItem(
            icon: Icons.local_offer,
            title: 'Promociones',
            action: () => NavigationService.popAndPushNamed(NavigationService.news)
        ),

        const Divider(),

        tappableListTileItem(
            icon: Icons.restaurant,
            title: 'Orientación Nutrimental',
            action: () => NavigationService.popAndPushNamed(NavigationService.nutritionalOrientation)
        ),

        const Padding(
          padding: EdgeInsets.only(
              top: 50,
              bottom: 20
          ),
          child: Center(
              child: Text('Contáctanos',
                style:TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              )
          ),
        ),

        ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.only(
            left: 20,
            right: 20
          ),
          children: [
            FilledButton.icon(
                onPressed: () => NavigationService.makeCall(),
                icon: const Icon(Icons.phone),
                label: const Text('Llamada')),

            Padding(
              padding: const EdgeInsets.only(
                top: 15,
                bottom: 15
              ),
              child: OutlinedButton.icon(
                  onPressed: () => NavigationService.openWhatsappLink(),
                  icon: const Icon(FontAwesomeIcons.whatsapp, color: Colors.green,),
                  label: const Text('Whatsapp')),
            ),

            OutlinedButton.icon(
                onPressed: () => NavigationService.sendEmail(),
                icon: const Icon(FontAwesomeIcons.envelope, color: Colors.blue),
                label: const Text('Correo')),
          ],
        )
      ],
    ),
  );
}

GestureDetector tappableListTileItem({required IconData icon, required String title, required VoidCallback action, bool isDisabled = false}) {
  return GestureDetector(
    onTap: isDisabled ? null : action,
    child: ListTile(
      leading: Icon(icon, color: isDisabled ? Colors.grey : null),
      title: Text(title, style: TextStyle(color: isDisabled ? Colors.grey : null)),
    ),
  );
}