import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_center/Data/Repositories/treatment_repository.dart';
import 'package:light_center/Data/Repositories/user_repository.dart';
import 'package:light_center/Data/Models/Treatment/treatment_model.dart';
import 'package:light_center/Data/Models/User/user_model.dart';

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