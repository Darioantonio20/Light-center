import 'dart:ffi';

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
late UserCubit userCubit;
late TreatmentCubit treatmentCubit;
late LocationCubit locationCubit;
Location? selectedLocation;

void fillForm(User user) async {
  if (user.id > 0) {
    await user.location.load();
    await user.treatments.load();
  }

  if (user.whatsappNumber != null) {
    usernameController.text = user.whatsappNumber!;
  }

  if (user.code != null) {
    passwordController.text = user.code!;
  }

  if (user.location.value != null) {
    selectedLocation = user.location.value!;
  }
}

void login({required User user}) async {
  if (formKey.currentState!.validate()) {
    user.whatsappNumber = usernameController.text;
    user.code = passwordController.text;
    user.location.value = selectedLocation;
    await userCubit.updateUserForLogin(user: user);
  }
}

void validateUser ({required User user}) async {
  String data = await sendSOAPRequest(
      soapAction: 'http://tempuri.org/SPA_VALIDAPACIENTE',
      envelopeName: 'SPA_VALIDAPACIENTE',
      content: {
        'DSNDataBase': user.location.value!.code,
        'NoWhatsAPP': '521${user.whatsappNumber}'
      });

  //print("Respuesta validacion");
  //print(data);
  
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

    ///Ask about login code validation
    data = data.substring(data.indexOf("€") + 1);
    List<String> datosPaciente = data.split(",");
    print(datosPaciente);

    late Treatment currentTreatment;

    try {
      user.name = trimUserData(datosPaciente.where((String element) => element.contains('nombrepaciente')).first)!;
      List<Treatment> userTreatments = await user.treatments.filter().findAll();

      // Checks if there's more than one treatment in response (NEED TO ADD)
      if (userTreatments.isEmpty) {
        currentTreatment = Treatment();
        currentTreatment.name = trimUserData(datosPaciente.where((String element) => element.contains('descrippaquetecorporal')).first)!;
        currentTreatment.orderId = int.parse(trimUserData(datosPaciente.where((String element) => element.contains('idpedido')).first)!);
        currentTreatment.productId = int.parse(trimUserData(datosPaciente.where((String element) => element.contains('idpaquete')).first)!);
        currentTreatment.lastDateToSchedule = parseDateTimeFromResponse(trimUserData(datosPaciente.where((String element) => element.contains('vigenciapaquete')).first)!);
        await treatmentCubit.updateTreatment(currentTreatment);
        user.treatments.add(await treatmentCubit.getTreatmentByOrderId(currentTreatment.orderId!) ?? currentTreatment);
      } else {
        for (Treatment userTreatment in userTreatments) {
          currentTreatment = await user.treatments.filter().orderIdEqualTo(userTreatment.orderId).findFirst() ?? Treatment();
          currentTreatment.name = trimUserData(datosPaciente.where((String element) => element.contains('descrippaquetecorporal')).first)!;
          currentTreatment.orderId = int.parse(trimUserData(datosPaciente.where((String element) => element.contains('idpedido')).first)!);
          currentTreatment.productId = int.parse(trimUserData(datosPaciente.where((String element) => element.contains('idpaquete')).first)!);
          //currentTreatment.lastDateToSchedule = DateTime.parse(trimUserData(datosPaciente.where((String element) => element.contains('vigenciapaquete')).first)!);
          currentTreatment.lastDateToSchedule = parseDateTimeFromResponse(trimUserData(datosPaciente.where((String element) => element.contains('vigenciapaquete')).first)!);
          user.treatments.add(await treatmentCubit.getTreatmentByOrderId(currentTreatment.orderId!) ?? currentTreatment);
          user.treatments.add(currentTreatment);
        }
      }
      await userCubit.updateUserForLogin(user: user, isValidation: true);
    } catch(e) {
      print("Error en validacion");
      print(e);
      userCubit.emit(UserError(e.toString()));
    }
  }
}

String? trimUserData(String data) {
  return data.substring(data.indexOf("=") + 1);
}

DateTime? parseDateTimeFromResponse(String dateString) {
  print("Parseando");
  print(dateString);
  try {
    if (dateString.isNotEmpty) {
      return DateTime.parse(dateString);
    }

    return null;
  } catch (e) {
    return null;
  }
}