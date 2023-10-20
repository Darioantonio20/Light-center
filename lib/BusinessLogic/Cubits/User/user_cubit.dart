import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_center/Data/Repositories/user_repository.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:light_center/Data/Models/User/user_model.dart';
import 'package:flutter/material.dart';
import 'package:light_center/Views/home.dart';
import 'package:intl/intl.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _repository;

  UserCubit(this._repository) : super(UserInitial());

  Future<bool> requestWhatsappCode(String whatsappNumber) async {
    try {
      emit(UserLoading());
      Map<String, dynamic> data = await _repository.requestUserCode(whatsappNumber);
      if (data.containsKey('Error')) {
        emit(UserError(data['Error']));
        return false;
      } else {
        User? user = await _repository.getUser();
        user ??= User();
        user.whatsappNumber = whatsappNumber;
        if (await _repository.updateUser(user)) {
          emit(UserLoaded(user: user));
          return true;
        } else {
         emit(UserError('Ocurrió un error al registrar el número de WhatsApp'));
         return false;
        }
      }
    } catch (e) {
      emit(UserError('Ocurrió un error al solicitar el código de WhatsApp: $e'));
      return false;
    }
  }

  Future<bool> validateUserCode({required String whatsappNumber, required String userCode}) async {
    try {
      emit(UserLoading());
      Map<String, dynamic> data = await _repository.validateUserCode(whatsappNumber: whatsappNumber, userCode: userCode);
      if (data.containsKey('Error')) {
        emit(UserError(data['Error']));
        return false;
      } else {
        User? user = await _repository.getUser();
        user ??= User();
        user.code = userCode;
        user.name = data['Name'];
        //user.currentTreatment = data['DesiredTreatment'];
        //user.appointments = getAppointmentsFromJson(data['Appointments']);
        if (await _repository.updateUser(user)) {
          NavigationService.showSnackBar(message: 'Su código ha sido verificado. Ingresando al sistema...');

          Future.delayed(const Duration(seconds: 4), (){
            NavigationService.pushReplacementNamed(NavigationService.homeScreen, arguments: HomeArguments(userRepository: _repository));
            //NavigationService.pushReplacementNamed(NavigationService.treatmentSelection, arguments: TreatmentSelectionArguments(isar: _repository.isar));
          });

          emit(UserLoaded(user: user));
          return true;
        } else {
          emit(UserError('Ocurrió un error al registrar el código de usuario'));
          return false;
        }
      }
    } catch (e) {
      emit(UserError('Ocurrió un error al validar el código de usuario: $e'));
      return false;
    }
  }

  Future<bool> loginWithCredentials({required String whatsappNumber, required String userCode}) async {
    try {
      emit(UserLoading());
      Map<String, dynamic> data = await _repository.loginWithCredentials(whatsappNumber: whatsappNumber, userCode: userCode);
      if (data.containsKey('Error')) {
        emit(UserError(data['Error']));
        return false;
      } else {
        User? user = await _repository.getUser();
        user ??= User();
        user.code = userCode;
        user.name = data['Name'];
        //user.currentTreatment = data['DesiredTreatment'];
        //user.appointments = getAppointmentsFromJson(data['Appointments']);
        if (await _repository.updateUser(user)) {
          NavigationService.pushReplacementNamed(NavigationService.homeScreen, arguments: HomeArguments(userRepository: _repository));
          //NavigationService.pushReplacementNamed(NavigationService.treatmentSelection, arguments: TreatmentSelectionArguments(isar: _repository.isar));
          return true;
        } else {
          emit(UserError('Ocurrió un error al registrar el código de usuario'));
          return false;
        }
      }
    } catch (e) {
      emit(UserError('Ocurrió un error al iniciar sesión: $e'));
      return false;
    }
  }

  Future<void> getUser() async {
    try {
      emit(UserLoading());
      User? user = await _repository.getUser();
      if (user == null) {
        emit(UserLoaded(user: User()));
      } else {
        emit(UserLoaded(user: user));
      }
    } catch (e) {
      emit(UserError('Ocurrió un error al obtener el usuario: $e'));
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await _repository.updateUser(user);
      emit(UserUpdated());
    } catch (e) {
      emit(UserError('Ocurrió un error al actualizar el usuario: $e'));
    }
  }

  Future<void> updateUserForLogin({required User user}) async {
    try {
      await _repository.updateUserForLogin(user);
      emit(UserUpdated());
    } catch (e) {
      emit(UserError('Ocurrió un error al actualizar el usuario: $e'));
    }
  }

  Future<void> setWhatsappNumber(String newNumber) async {
    try {
      await _repository.updateWhatsappNumber(newNumber);
      emit(UserUpdated());
    } catch (e) {
      emit(UserError('Ocurrió un error al actualizar el número de WhatsApp: $e'));
    }
  }

  Future<void> setCode(String newCode) async {
    try {
      await _repository.updateCode(newCode);
      emit(UserUpdated());
    } catch (e) {
      emit(UserError('Ocurrió un error al actualizar el código de usuario: $e'));
    }
  }

  Future<void> removeWhatsappNumber() async {
    try {
      await _repository.removeWhatsappNumber();
      emit(UserUpdated());
    } catch (e) {
      emit(UserError('Ocurrió un error al remover el número de WhatsApp: $e'));
    }
  }

  Future<void> removeUserCode() async {
    try {
      await _repository.removeUserCode();
      emit(UserUpdated());
    } catch (e) {
      emit(UserError('Ocurrió un error al remover el código de usuario: $e'));
    }
  }

  /*Appointments? getAppointmentsFromJson(Map<String, dynamic> json) {
    Appointments appointments = Appointments();
    appointments.availableAppointments = json['AvailableAppointments'];
    appointments.appointmentsPerWeek = json['AppointmentsPerWeek'];
    appointments.bookedDates = List<String>.from(json['BookedDates']);
    appointments.scheduledAppointments = List<String>.from(json['ScheduledAppointments']);
    appointments.firstDateToSchedule = DateTime.parse(json['FirstDateToSchedule']);
    appointments.lastDateToSchedule = DateTime.parse(json['LastDateToSchedule']);
    return appointments;
  }*/



  /*Future<void> getAvailableDates({int treatmentID = 0}) async {
    try {
      emit(UserLoading());
      Map<String, dynamic> data = await _repository.getAvailableDates();
      if (data.containsKey('Error')) {
        emit(UserError(data['Error']));
      } else {
        User? user = await _repository.getUser();
        if (user == null) {
          emit(UserError('No se pudo accesar a la información del usuario'));
        }
        if (user?.appointments == null) {
          emit(UserError('No se pudo accesar a la información de las citas agendadas.'));
        }
        user!.appointments = getAppointmentsFromJson(data);
        await _repository.updateUser(user);
        emit(UserLoaded(user: user));
      }
    } catch (e) {
      emit(UserError('Ocurrió un error al obtener las fechas: $e'));
    }
  }*/

  /*Future<List<String>> getDaySchedule({required String day}) async {
    try {
      emit(UserLoading());
      Map<String, dynamic> data = await _repository.getDaySchedule(day: day);
      print(data);
      if (data.containsKey('Error')) {
        emit(UserError(data['Error']));
      } else {
        User? user = await _repository.getUser();
        if (user == null) {
          emit(UserError('No se pudo accesar a la información del usuario'));
        }
        if (user?.appointments == null) {
          emit(UserError('No se pudo accesar a la información de las citas agendadas.'));
        }
        user!.appointments = getAppointmentsFromJson(data);
        await _repository.updateUser(user);
        emit(UserLoaded(user: user));
      }
    } catch (e) {
      emit(UserError('Ocurrió un error al obtener las fechas: $e'));
    }
  }*/

  Future<bool> scheduleAppointment({required String whatsappNumber, required DateTime day}) async {
    try {
      emit(UserLoading());
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
  }

  Future<bool> updateAppointment({required String whatsappNumber, required DateTime day, required DateTime previousDay}) async {
    try {
      emit(UserLoading());
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
  }

  Future<bool> cancelAppointment({required String whatsappNumber, required DateTime day}) async {
    try {
      emit(UserLoading());
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
  }

  void reloadUserData() async {
    try {
      emit(UserLoading());
      User? user = await _repository.getUser();
      Map<String, dynamic> data = await _repository.loginWithCredentials(whatsappNumber: user!.whatsappNumber!, userCode: user.code!);
      if (data.containsKey('Error')) {
        emit(UserError(data['Error']));
      } else {
        user.name = data['Name'];
        //user.currentTreatment = data['DesiredTreatment'];
        //user.appointments = getAppointmentsFromJson(data['Appointments']);
        if (await _repository.updateUser(user)) {
          emit(UserLoaded(user: user));
        } else {
          emit(UserError('Ocurrió un error al actualizar la información del usuario'));
        }
      }
    } catch(e) {
      emit(UserError('Ocurrió un error al recargar la información del usuario: $e'));
      Future.delayed(const Duration(seconds: 5), () {
        reloadUserData();
      });
    }
  }

  void emitUpdate() {
    emit(UserUpdated());
  }

  Future<void> updateScreen({required VoidCallback action, required User user}) async {
    try {
      emit(UserLoading());
      action;
      emit(UserLoaded(user: user));
    } catch (e) {
      emit(UserError('Ocurrió un error al actualizar la pantalla: $e'));
    }
  }
}