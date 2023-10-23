import 'package:light_center/Data/Models/Treatment/treatment_model.dart';
import 'package:light_center/Data/Models/User/user_model.dart';
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
      /*for (int i = 0; i < newUser.treatments.length; i++) {
        int resultId = await isar.collection<Treatment>().put(newUser.treatments.elementAt(i));
        if (resultId < 1) {
          return false;
        } else {
          newUser.treatments.elementAt(i).id = resultId;
        }
      }*/

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

  /*Future<Map<String, dynamic>> getDaySchedule({required String day}) async {
    Map<String, dynamic> response = await sendRequest(
        endPoint: '/day-schedule',
        method: HTTPMethod.post,
        body: {'day': day}
    );
    return response;
  }*/
}