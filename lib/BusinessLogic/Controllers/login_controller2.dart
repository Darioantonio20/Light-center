import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:light_center/BusinessLogic/Cubits/Location/location_cubit.dart';
import 'package:light_center/BusinessLogic/Cubits/Treatment/treatment_cubit.dart';
import 'package:light_center/BusinessLogic/Cubits/User/user_cubit.dart';
import 'package:light_center/Data/Models/Location/location_model.dart';
import 'package:light_center/Data/Models/Treatment/treatment_model.dart';
import 'package:light_center/Data/Models/User/user_model.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:light_center/Services/network_service.dart';

late GlobalKey<FormState> formKey;
late TextEditingController usernameController;
late TextEditingController passwordController;
late bool showWhatsappNumber;
late UserCubit userCubit;
late TreatmentCubit treatmentCubit;
late LocationCubit locationCubit;
late Location selectedLocation;


void login() async {
  if (formKey.currentState!.validate()) {
    if (showWhatsappNumber == true) {
      showWhatsappNumber = !showWhatsappNumber;
      //requestUserCode();
      //Provisional al requestUserCode();
      userCubit.setWhatsappNumber(usernameController.text);
      return;
    }
    validateUserCode();
  }
}

void loginWithCredentials({required String username, required String password}) async {
  if (await userCubit.loginWithCredentials(whatsappNumber: username, userCode: password) == false) {
    NavigationService.showSnackBar(message: 'Se regresará a la pantalla anterior');
    Future.delayed(const Duration(seconds: 4), (){
      userCubit.getUser();
    });
  }
}

void requestUserCode() async {
  if (await userCubit.requestWhatsappCode(usernameController.text) == false) {
    showWhatsappNumber = !showWhatsappNumber;
    NavigationService.showSnackBar(message: 'Se regresará a la pantalla anterior');
    Future.delayed(const Duration(seconds: 4), (){
      userCubit.removeWhatsappNumber();
    });
  } else {
    NavigationService.showSnackBar(message: 'El código ha sido enviado a su WhatsApp');
  }
}

void validateUserCode() async {
  if (await userCubit.validateUserCode(whatsappNumber: usernameController.text, userCode: passwordController.text) == false) {
    passwordController.clear();
    NavigationService.showSnackBar(message: 'Se regresará a la pantalla anterior', duration: const Duration(seconds: 8));
    Future.delayed(const Duration(seconds: 8), (){
      userCubit.removeUserCode();
    });
    return;
  }
}

void goToLogin({int seconds = 4, VoidCallback? action}) {
  NavigationService.showSnackBar(message: 'Se regresará a la pantalla anterior');
  Future.delayed(Duration(seconds: seconds));
}

void switchWhatsappNumberVisibility({required User user}) {
  showWhatsappNumber = !showWhatsappNumber;
  userCubit.removeWhatsappNumber();
}

void pruebas({required User user}) async {
  String data = await sendSOAPRequest(
      soapAction: 'http://tempuri.org/SPA_VALIDAPACIENTE',
      envelopeName: 'SPA_VALIDAPACIENTE',
      content: {
        'DSNDataBase': selectedLocation.code,
        'NoWhatsAPP': '521${usernameController.text}'
      });

  if (data.contains('ERR:') || data.length == 1) {
    if (data.length == 1) {
      data = 'No cuenta con ningún paquete, favor de comunicarse con la clínica para realizar la adquisición de un tratamiento.';
    } else {
      data = data.replaceAll("ERR: ", "");
    }

    NavigationService.showSimpleErrorAlertDialog(
        title: 'Error al ingresar',
        content: data);
  } else {
    data = data.substring(data.indexOf("€") + 1);
    List<String> datosPaciente = data.split(",");
    late Treatment currentTreatment;
    try {
      user.whatsappNumber = usernameController.text;
      user.code = '0000';
      user.name = trimUserData(datosPaciente.where((String element) => element.contains('nombrepaciente')).first)!;
      await userCubit.updateUser(user);
      //await user.treatments.load();
      //print("Se cargan los tratamientos");
      List<Treatment> userTreatments = await user.treatments.filter().findAll();
      for (Treatment userTreatment in userTreatments) {
        //Treatment currentTreatment = await treatmentCubit.getTreatmentByOrderId(userTreatment.id) ?? Treatment();
        currentTreatment = await user.treatments.filter().orderIdEqualTo(userTreatment.orderId).findFirst() ?? Treatment();
        currentTreatment.name = trimUserData(datosPaciente.where((String element) => element.contains('descrippaquetecorporal')).first)!;
        currentTreatment.orderId = int.parse(trimUserData(datosPaciente.where((String element) => element.contains('idpedido')).first)!);
        currentTreatment.productId = int.parse(trimUserData(datosPaciente.where((String element) => element.contains('idpaquete')).first)!);
        currentTreatment.lastDateToSchedule = DateTime.parse(trimUserData(datosPaciente.where((String element) => element.contains('vigenciapaquete')).first)!);
        //user.treatments.reset();
        user.treatments.add(currentTreatment);
        await user.treatments.save();
        //await userCubit.updateUser(user);
      }
    } catch(e) {
      print(e);
      userCubit.emit(UserError(e.toString()));
    }
  }
}

String? trimUserData(String data) {
  return data.substring(data.indexOf("=") + 1);
}