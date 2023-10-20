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
  if (user.whatsappNumber != null) {
    usernameController.text = user.whatsappNumber!;
  }

  if (user.code != null) {
    passwordController.text = user.code!;
  }

  if (user.location.value != null) {
    selectedLocation = user.location.value!;
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
        'DSNDataBase': selectedLocation!.code,
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