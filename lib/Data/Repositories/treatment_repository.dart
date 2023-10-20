import 'package:light_center/Data/Models/Treatment/treatment_model.dart';
import 'package:light_center/Services/network_service.dart';
import 'package:light_center/enums.dart';
import 'package:isar/isar.dart';

class TreatmentRepository {
  final Isar isar;

  const TreatmentRepository(this.isar);

  Future<Map<String, dynamic>> getTreatments({required String whatsappNumber}) async {
    Map<String, dynamic> response = await sendRequest(
        endPoint: '/treatments',
        body: {
          'whatsappNumber': whatsappNumber
        },
        method: HTTPMethod.post);
    return response;
  }

  Future<Treatment?> getTreatmentById(int id) async {
    Treatment? treatment = await isar.collection<Treatment>().get(id);
    return treatment;
  }

  Future<Treatment?> getTreatmentByOrderId(int id) async {
    Treatment? treatment = await isar.collection<Treatment>().filter().orderIdEqualTo(id).findFirst();
    return treatment;
  }

  Future<Map<String, dynamic>> getAvailableDatesForTreatment({required int treatmentID}) async {
    Map<String, dynamic> response = await sendRequest(
        endPoint: '/available-dates',
        body: {
          'treatmentID': treatmentID
        },
        method: HTTPMethod.post);
    return response;
  }

  Future<bool> updateTreatment(Treatment newTreatment) async {
    return await isar.writeTxn(() async {
      if (await isar.collection<Treatment>().put(newTreatment) > -1) {
        return true;
      }

      return false;
    });
  }

  /*Future<Treatment?> getTreatment() async {
    Treatment? treatment = await isar.collection<Treatment>().get(1);
    return treatment;
  }

  Future<Map<String, dynamic>> requestTreatmentCode(String whatsappNumber) async {
    Map<String, dynamic> response = await sendRequest(
        endPoint: '/request-code',
        method: HTTPMethod.post,
        body: {
          'whatsappNumber' : whatsappNumber
        }
    );
    return response;
  }

  Future<Map<String, dynamic>> validateTreatmentCode({required String whatsappNumber, required String treatmentCode}) async {
    Map<String, dynamic> response = await sendRequest(
        endPoint: '/validate-code',
        method: HTTPMethod.post,
        body: {
          'whatsappNumber': whatsappNumber,
          'treatmentCode' : treatmentCode
        }
    );
    return response;
  }

  Future<Map<String, dynamic>> loginWithCredentials({required String whatsappNumber, required String treatmentCode}) async {
    Map<String, dynamic> response = await sendRequest(
        endPoint: '/get-info',
        method: HTTPMethod.post,
        body: {
          'whatsappNumber': whatsappNumber,
          'treatmentCode' : treatmentCode
        }
    );
    return response;
  }

  Future<bool> updateTreatment(Treatment newTreatment) async {
    return await isar.writeTxn(() async {
      if (await isar.collection<Treatment>().put(newTreatment) > -1) {
        return true;
      }

      return false;
    });
  }

  Future<bool> updateWhatsappNumber(String newNumber) async {
    Treatment treatment = await getTreatment() ?? Treatment() ;
    treatment.whatsappNumber = newNumber;
    return await updateTreatment(treatment);
  }

  Future<bool> updateCode(String newCode) async {
    Treatment treatment = await getTreatment() ?? Treatment();
    treatment.code = newCode;
    return await updateTreatment(treatment);
  }

  Future<bool> updateName(String newName) async {
    Treatment treatment = await getTreatment() ?? Treatment();
    treatment.name = newName;
    return await updateTreatment(treatment);
  }

  Future<bool> updateCurrentTreatment(String newTreatment) async {
    Treatment treatment = await getTreatment() ?? Treatment();
    treatment.currentTreatment = newTreatment;
    return await updateTreatment(treatment);
  }

  Future<bool> removeWhatsappNumber() async {
    Treatment? treatment = await getTreatment();
    if(treatment != null) {
      treatment.whatsappNumber = null;
      return await updateTreatment(treatment);
    }

    return false;
  }

  Future<bool> removeTreatmentCode() async {
    Treatment? treatment = await getTreatment();
    if(treatment != null) {
      treatment.code = null;
      return await updateTreatment(treatment);
    }

    return false;
  }

  Future<Map<String, dynamic>> getAvailableDatesForTreatment({required int treatmentID}) async {
    Map<String, dynamic> response = await sendRequest(
        endPoint: '/available-dates',
        body: {
          'treatmentID': treatmentID
        },
        method: HTTPMethod.post);
    return response;
  }

  void updateTreatment({required int treatmentID}) async {
    Treatment? treatment = await getTreatment();
    treatment!.treatments!.where((treatment) => treatment.id == treatmentID).first;
  }

  Future<int> findTreatment({required int treatmentID}) async {
    Treatment? treatment = await getTreatment();
    if (treatment == null) {
      return -1;
    }
  }

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
  }*/

/*Future<Map<String, dynamic>> getDaySchedule({required String day}) async {
    Map<String, dynamic> response = await sendRequest(
        endPoint: '/day-schedule',
        method: HTTPMethod.post,
        body: {'day': day}
    );
    return response;
  }*/
}