import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_center/BusinessLogic/Cubits/Treatment/treatment_cubit.dart';
import 'package:light_center/Data/Models/Treatment/treatment_model.dart';
import 'package:light_center/Data/Models/User/user_model.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:light_center/Services/network_service.dart';
import 'package:light_center/enums.dart';
import 'package:isar/isar.dart';

class UserRepository {
  final Isar isar;

  const UserRepository(this.isar);

  Future<User?> getUser() async {
    User? user = await isar.collection<User>().get(1);
    return user;
  }

  Future<Map<String, dynamic>> requestUserCode(String whatsappNumber) async {
    Map<String, dynamic> response = await sendRequest(
        endPoint: '/request-code',
        method: HTTPMethod.post,
        body: {
          'whatsappNumber' : whatsappNumber
        }
    );
    return response;
  }

  Future<Map<String, dynamic>> validateUserCode({required String whatsappNumber, required String userCode}) async {
    Map<String, dynamic> response = await sendRequest(
        endPoint: '/validate-code',
        method: HTTPMethod.post,
        body: {
          'whatsappNumber': whatsappNumber,
          'userCode' : userCode
        }
    );
    return response;
  }

  Future<Map<String, dynamic>> loginWithCredentials({required String whatsappNumber, required String userCode}) async {
    Map<String, dynamic> response = await sendRequest(
        endPoint: '/get-info',
        method: HTTPMethod.post,
        body: {
          'whatsappNumber': whatsappNumber,
          'userCode' : userCode
        }
    );
    return response;
  }

  Future<bool> updateUser(User newUser) async {
    return await isar.writeTxn(() async {
      if (await isar.collection<User>().put(newUser) > -1) {
        return true;
      }

      return false;
    });
  }

  Future<bool> updateUserForLogin(User newUser) async {
    return await isar.writeTxn(() async {
      if (await isar.collection<User>().put(newUser) > -1) {
        await newUser.location.save();
        return true;
      }

      return false;
    });
  }

  Future<bool> updateUserForValidation(User newUser) async {
    return await isar.writeTxn(() async {
      if (await isar.collection<User>().put(newUser) > -1) {
        await newUser.treatments.save();
        return true;
      }

      return false;
    });
  }

  Future<bool> updateWhatsappNumber(String newNumber) async {
    User user = await getUser() ?? User() ;
    user.whatsappNumber = newNumber;
    return await updateUser(user);
  }

  Future<bool> updateCode(String newCode) async {
    User user = await getUser() ?? User();
    user.code = newCode;
    return await updateUser(user);
  }

  Future<bool> updateName(String newName) async {
    User user = await getUser() ?? User();
    user.name = newName;
    return await updateUser(user);
  }

  /*Future<bool> updateCurrentTreatment(String newTreatment) async {
    User user = await getUser() ?? User();
    user.currentTreatment = newTreatment;
    return await updateUser(user);
  }*/

  Future<bool> removeWhatsappNumber() async {
    User? user = await getUser();
    if(user != null) {
      user.whatsappNumber = null;
      return await updateUser(user);
    }

    return false;
  }

  Future<bool> removeUserCode() async {
    User? user = await getUser();
    if(user != null) {
      user.code = null;
      return await updateUser(user);
    }

    return false;
  }

  /*void updateTreatment({required int treatmentID}) async {
    User? user = await getUser();
    user!.treatments!.where((treatment) => treatment.id == treatmentID).first;
  }*/

  /*Future<int> findTreatment({required int treatmentID}) async {
    User? user = await getUser();
    if (user == null) {
      return -1;
    }
  }*/

  Future<Map<String, dynamic>> getAvailableDates() async {
    Map<String, dynamic> response = await sendRequest(endPoint: '/available-dates', method: HTTPMethod.get);
    return response;
  }

  Future<Map<String, dynamic>> scheduleAppointment({required String whatsappNumber, required String day}) async {
    Map<String, dynamic> response = await sendRequest(
        endPoint: '/appointment',
        method: HTTPMethod.post,
        body: {
          'whatsappNumber' : whatsappNumber,
          'day': day
        }
    );
    return response;
  }

  Future<Map<String, dynamic>> updateAppointment({required String whatsappNumber, required String day, required String previousDay}) async {
    Map<String, dynamic> response = await sendRequest(
        endPoint: '/appointment',
        method: HTTPMethod.patch,
        body: {
          'whatsappNumber' : whatsappNumber,
          'day': day,
          'previousDay': previousDay
        }
    );
    return response;
  }

  Future<Map<String, dynamic>> cancelAppointment({required String whatsappNumber, required String day}) async {
    Map<String, dynamic> response = await sendRequest(
        endPoint: '/appointment',
        method: HTTPMethod.delete,
        body: {
          'whatsappNumber' : whatsappNumber,
          'day': day
        }
    );
    return response;
  }

  Future<Map<String, dynamic>> fetchUser({required User user}) async {
    String data = await sendSOAPRequest(
        soapAction: 'http://tempuri.org/SPA_VALIDAPACIENTE',
        envelopeName: 'SPA_VALIDAPACIENTE',
        content: {
          'DSNDataBase': user.location.value!.code,
          'NoWhatsAPP': '521${user.whatsappNumber}',
          'CodVerificador': user.code
        });

    if (data.contains('ERR:') || data.length == 1) {
      if (data.length == 1) {
        data = 'No cuenta con ningún paquete, favor de comunicarse con la clínica para realizar la adquisición de un tratamiento.';
      } else {
        data = data.replaceAll("ERR: ", "");
      }

      return {
        'validation': false,
        'message': data
      };
    } else {
      data = data.substring(data.indexOf("€") + 1);
      List<String> datosPaciente = data.split(",");
      print(datosPaciente);

      late Treatment currentTreatment;
      TreatmentCubit treatmentCubit = BlocProvider.of<TreatmentCubit>(NavigationService.context());

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
        await updateUserForValidation(user);
        return {
          'validation': true,
          'message': 'El usuario ha sido actualizado'
        };
      } catch(e) {
        print("Error en validacion");
        print(e);
        return {
          'validation': false,
          'message': 'Error en la validación:\n${e.toString()}'
        };
      }
    }
  }

  String? trimUserData(String data) {
    return data.substring(data.indexOf("=") + 1);
  }

  DateTime? parseDateTimeFromResponse(String dateString) {
    try {
      if (dateString.isNotEmpty) {
        return DateTime.parse(dateString);
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}