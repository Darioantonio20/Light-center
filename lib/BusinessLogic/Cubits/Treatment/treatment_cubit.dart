import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_center/Data/Repositories/treatment_repository.dart';
import 'package:light_center/Data/Repositories/user_repository.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:light_center/Data/Models/Treatment/treatment_model.dart';
import 'package:light_center/Data/Models/User/user_model.dart';
import 'package:flutter/material.dart';
import 'package:light_center/Views/home.dart';
import 'package:intl/intl.dart';

part 'treatment_state.dart';

class TreatmentCubit extends Cubit<TreatmentState> {
  final TreatmentRepository _repository;

  TreatmentCubit(this._repository) : super(TreatmentInitial());

  Future<void> getTreatments() async {
    try {
      emit(TreatmentLoading());
      User? user = await UserRepository(_repository.isar).getUser();
      Map<String, dynamic> data = await _repository.getTreatments(whatsappNumber: user!.whatsappNumber!);
      if (data.containsKey('Error')) {
        emit(TreatmentError(data['Error']));
      } else {
        List<Treatment> treatmentsList = _getTreatmentsFromJson(data['Treatments']);
        for (Treatment treatment in treatmentsList) {
          if (await _repository.updateTreatment(treatment) == false) {
            emit(TreatmentError('Ocurrió un error al guardar los tratamientos contratados'));
            return;
          }
        }
        emit(TreatmentsLoaded(treatmentsList: treatmentsList));
      }
    } catch (e) {
      emit(TreatmentError('Ocurrió un error al obtener los tratamientos contratados: $e'));
    }
  }

  Future<List<String>?> getAvailableDatesForTreatment({required int treatmentID}) async {
    try {
      emit(TreatmentLoading());
      Map<String, dynamic> data = await _repository.getAvailableDatesForTreatment(treatmentID: treatmentID);
      if (data.containsKey('Error')) {
        emit(TreatmentError(data['Error']));
        return null;
      } else {
        Treatment? treatment = await _repository.getTreatmentById(treatmentID);
        emit(TreatmentLoaded(treatment: treatment!));
        return List<String>.from(data['Dates']);
      }
    } catch (e) {
      emit(TreatmentError('Ocurrió un error al obtener las fechas: $e'));
      return null;
    }
  }

  Future<void> updateTreatment(Treatment treatment) async {
    try {
      await _repository.updateTreatment(treatment);
      emit(TreatmentUpdated());
    } catch (e) {
      emit(TreatmentError('Ocurrió un error al actualizar el tratamiento: $e'));
    }
  }

  Future<Treatment?> getTreatmentByOrderId(int orderId) async {
    try {
      emit(TreatmentLoading());
      Treatment? currentTreatment = await _repository.getTreatmentByOrderId(orderId) ?? Treatment();
      emit(TreatmentLoaded(treatment: currentTreatment));
      return await _repository.getTreatmentByOrderId(orderId);
    } catch (e) {
      emit(TreatmentError('Ocurrió un error al obtener el tratamiento: $e'));
      return null;
    }
  }

  /*Future<bool> scheduleAppointment({required String whatsappNumber, required DateTime day}) async {
    try {
      emit(TreatmentLoading());
      Map<String, dynamic> data = await _repository.scheduleAppointment(
          whatsappNumber: whatsappNumber,
          day: DateFormat.yMMMMd().add_Hm().toString()
      );

      if (data.containsKey('Error')) {
        await showDialog(
          context: NavigationService.context(),
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Ocurrió un error al agendar.\n${data['Error']}'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar',
                  style: TextStyle(
                      color: Colors.red
                  ),
                ),
              ),
            ],
          ),
        );
        return false;
      } else if (data.containsKey('Success')) {
        if (data['Success'] == false) {
          return false;
        } else {
          return true;
        }
      }

      await NavigationService.showSimpleErrorAlertDialog(
          title: 'Error al cancelar',
          content: 'Ocurrió un error en el servidor.');
      return false;
    } catch (e) {
      await NavigationService.showSimpleErrorAlertDialog(
          title: 'Error al cancelar',
          content: 'Ocurrió un error al agendar la cita: $e.');
      return false;
    }
  }*/

  /*Future<bool> updateAppointment({required String whatsappNumber, required DateTime day, required DateTime previousDay}) async {
    try {
      emit(TreatmentLoading());
      Map<String, dynamic> data = await _repository.updateAppointment(
          whatsappNumber: whatsappNumber,
          day: day.toIso8601String().substring(0,day.toIso8601String().indexOf('.')),
          previousDay: previousDay.toIso8601String().substring(0,day.toIso8601String().indexOf('.'))
      );

      if (data.containsKey('Error')) {
        await NavigationService.showSimpleErrorAlertDialog(
            title: 'Error al actualizar',
            content: 'Ocurrió un error al actualizar la cita.\n${data['Error']}');
        return false;
      } else if (data.containsKey('Success')) {
        if (data['Success'] != false) {
          return true;
        }
      }
      await NavigationService.showSimpleErrorAlertDialog(
          title: 'Error al actualizar',
          content: 'Ocurrió un error en el servidor.');
      return false;
    } catch (e) {
      await NavigationService.showSimpleErrorAlertDialog(
          title: 'Error al actualizar',
          content: 'Ocurrió un error al re-agendar la cita: $e.');
      return false;
    }
  }*/

  /*Future<bool> cancelAppointment({required String whatsappNumber, required DateTime day}) async {
    try {
      emit(TreatmentLoading());
      Map<String, dynamic> data = await _repository.cancelAppointment(
          whatsappNumber: whatsappNumber,
          day: day.toIso8601String().substring(0,day.toIso8601String().indexOf('.'))
      );

      if (data.containsKey('Error')) {
        await NavigationService.showSimpleErrorAlertDialog(
            title: 'Error al cancelar',
            content: 'Ocurrió un error al cancelar la cita.\n${data['Error']}');
        return false;
      } else if (data.containsKey('Success')) {
        if (data['Success'] != false) {
          return true;
        }
      }
      await NavigationService.showSimpleErrorAlertDialog(
          title: 'Error al cancelar',
          content: 'Ocurrió un error en el servidor.');
      return false;
    } catch (e) {
      await NavigationService.showSimpleErrorAlertDialog(
          title: 'Error al cancelar',
          content: 'Ocurrió un error al agendar la cita: $e.');
      return false;
    }
  }*/

  /*void reloadTreatmentData() async {
    try {
      emit(TreatmentLoading());
      Treatment? treatment = await _repository.getTreatment();
      Map<String, dynamic> data = await _repository.loginWithCredentials(whatsappNumber: treatment!.whatsappNumber!, treatmentCode: treatment.code!);
      if (data.containsKey('Error')) {
        emit(TreatmentError(data['Error']));
      } else {
        treatment.name = data['Name'];
        //treatment.currentTreatment = data['DesiredTreatment'];
        //treatment.appointments = getAppointmentsFromJson(data['Appointments']);
        treatment.treatments = getTreatmentsFromJson(data['Treatments']);
        if (await _repository.updateTreatment(treatment)) {
          emit(TreatmentLoaded(treatment: treatment));
        } else {
          emit(TreatmentError('Ocurrió un error al actualizar la información del usuario'));
        }
      }
    } catch(e) {
      emit(TreatmentError('Ocurrió un error al recargar la información del usuario: $e'));
      Future.delayed(const Duration(seconds: 5), () {
        reloadTreatmentData();
      });
    }
  }*/

  void emitUpdate() {
    emit(TreatmentUpdated());
  }

  List<Treatment> _getTreatmentsFromJson(List<Map<String, dynamic>> json) {
    List<Treatment> treatmentsList = [];
    for (var treatment in json) {
      Treatment currentTreatment = Treatment();
      currentTreatment.id = treatment['ID'];
      currentTreatment.name = treatment['Name'];
      currentTreatment.availableAppointments = treatment['AvailableAppointments'];
      currentTreatment.appointmentsPerWeek = treatment['AppointmentsPerWeek'];
      currentTreatment.scheduledAppointments = treatment['ScheduledAppointments'];
      currentTreatment.firstDateToSchedule = treatment['FirstDateToSchedule'];
      currentTreatment.lastDateToSchedule = treatment['LastDateToSchedule'];
      treatmentsList.add(currentTreatment);
    }
    return treatmentsList;
  }
}