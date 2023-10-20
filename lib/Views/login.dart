import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_center/BusinessLogic/Cubits/Location/location_cubit.dart';
import 'package:light_center/BusinessLogic/Cubits/User/user_cubit.dart';
import 'package:light_center/Data/Models/Location/location_model.dart';
import 'custom_widgets.dart';
import 'package:light_center/BusinessLogic/Controllers/login_controller.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    formKey = GlobalKey<FormState>();
    usernameController = TextEditingController();
    passwordController = TextEditingController();

    userCubit = BlocProvider.of<UserCubit>(context);
    userCubit.getUser();

    locationCubit = BlocProvider.of<LocationCubit>(context);

    Widget? currentScreen;

    return BlocBuilder<UserCubit, UserState>(builder: (context, state) {
      if (state is UserUpdated || state is UserSaved) {
        userCubit.getUser();
        currentScreen = updatingScreen(context: context);
      }

      if (state is UserLoading) {
        currentScreen = loadingScreen(context: context);
      }

      if (state is UserLoaded) {
        fillForm(state.user);

        currentScreen = Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    locationsDropDownMenu(),

                    TextFormField(
                      controller: usernameController,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: const InputDecoration(
                        prefix: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.phone),
                        ),
                        labelText: 'Ingrese su número de Whatsapp',
                        hintText: '9617894561',
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty || text.length != 10) {
                          return 'Favor de ingresar un número de 10 dígitos';
                        }

                        return null;
                      },
                      onFieldSubmitted: (text) => login,
                    ),

                    TextFormField(
                      controller: passwordController,
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: const InputDecoration(
                          prefix: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.lock),
                          ),
                          labelText: 'Ingrese su código de usuario',
                          hintText: '0000'
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty || text.length != 4) {
                          return 'Favor de ingresar un código de 4 dígitos';
                        }
                        return null;
                      },
                    ),

                    FilledButton(
                      onPressed: () => login(user: state.user),
                      child: const Text('Ingresar'),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      }

      if (state is UserError) {
        currentScreen = errorScreen(context: context, errorMessage: state.errorMessage.toString());
      }

      currentScreen ??= invalidStateScreen(context: context);

      return Scaffold(
        appBar: commonAppBar(),
        body: currentScreen,
      );
    });
  }

  BlocBuilder locationsDropDownMenu() {
    Widget currentDropDownScreen = const SizedBox.shrink();

    return BlocBuilder<LocationCubit, LocationState>(builder: (context, state) {
      if (state is LocationUpdated || state is LocationSaved) {
        currentDropDownScreen = updatingScreen(context: context);
      }

      if (state is LocationLoading) {
        currentDropDownScreen = loadingScreen(context: context);
      }

      if (state is LocationsLoaded) {
        currentDropDownScreen = DropdownMenu<Location>(
          initialSelection: selectedLocation,
          leadingIcon: const Icon(Icons.location_city),
          hintText: 'Clínica',
          onSelected: (Location? value) {
            if (value != null) {
              selectedLocation = value;
            }
          },
          dropdownMenuEntries: state.locationsList.map<DropdownMenuEntry<Location>>((Location value) {
            return DropdownMenuEntry<Location>(value: value, label: value.city!);
          }).toList(),
        );
      }

      if (state is LocationError) {
        currentDropDownScreen = errorScreen(context: context, errorMessage: state.errorMessage.toString());
      }

      return currentDropDownScreen;
    });
  }
}


/*class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    formKey = GlobalKey<FormState>();
    usernameController = TextEditingController();
    passwordController = TextEditingController();

    userCubit = BlocProvider.of<UserCubit>(context);
    userCubit.getUser();

    locationCubit = BlocProvider.of<LocationCubit>(context);

    Widget? currentScreen;

    return BlocBuilder<UserCubit, UserState>(builder: (context, state) {
      if (state is UserUpdated || state is UserSaved) {
        userCubit.getUser();
        currentScreen = updatingScreen(context: context);
      }

      if (state is UserLoading) {
        currentScreen = loadingScreen(context: context);
      }

      if (state is UserLoaded) {
        fillForm(state.user);

        currentScreen = Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    BlocBuilder<LocationCubit, LocationState>(builder: (context, state) {
                      if (state is LocationUpdated || state is LocationSaved) {
                        return updatingScreen(context: context);
                      }

                      if (state is LocationLoading) {
                        return loadingScreen(context: context);
                      }

                      if (state is LocationsLoaded) {
                        return DropdownMenu<Location>(
                          initialSelection: selectedLocation,
                          leadingIcon: const Icon(Icons.location_city),
                          hintText: 'Clínica',
                          onSelected: (Location? value) {
                            if (value != null) {
                              setState(() {
                                selectedLocation = value;
                              });
                            }
                          },
                          dropdownMenuEntries: state.locationsList.map<DropdownMenuEntry<Location>>((Location value) {
                            return DropdownMenuEntry<Location>(value: value, label: value.city!);
                          }).toList(),
                        );
                      }

                      if (state is LocationError) {
                        return errorScreen(context: context, errorMessage: state.errorMessage.toString());
                      }

                      return Text("Ocurrió un error al cargar las clínicas, favor de reiniciar la app");
                    }),

                    //locationsDropDownMenu(),

                    TextFormField(
                      controller: usernameController,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: const InputDecoration(
                        prefix: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.phone),
                        ),
                        labelText: 'Ingrese su número de Whatsapp',
                        hintText: '9617894561',
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty || text.length != 10) {
                          return 'Favor de ingresar un número de 10 dígitos';
                        }

                        return null;
                      },
                      onFieldSubmitted: (text) => login,
                    ),

                    TextFormField(
                      controller: passwordController,
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: const InputDecoration(
                          prefix: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.lock),
                          ),
                          labelText: 'Ingrese su código de usuario',
                          hintText: '0000'
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty || text.length != 4) {
                          return 'Favor de ingresar un código de 4 dígitos';
                        }
                        return null;
                      },
                    ),

                    FilledButton(
                      onPressed: () => login(user: state.user),
                      child: const Text('Ingresar'),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      }

      if (state is UserError) {
        currentScreen = errorScreen(context: context, errorMessage: state.errorMessage.toString());
      }

      currentScreen ??= invalidStateScreen(context: context);

      return Scaffold(
        appBar: commonAppBar(),
        body: currentScreen,
      );
    });
  }
}

BlocBuilder locationsDropDownMenu() {
  Widget currentDropDownScreen = const SizedBox.shrink();

  return BlocBuilder<LocationCubit, LocationState>(builder: (context, state) {
    if (state is LocationUpdated || state is LocationSaved) {
      currentDropDownScreen = updatingScreen(context: context);
    }

    if (state is LocationLoading) {
      currentDropDownScreen = loadingScreen(context: context);
    }

    if (state is LocationsLoaded) {
      currentDropDownScreen = DropdownMenu<Location>(
        initialSelection: selectedLocation,
        leadingIcon: const Icon(Icons.location_city),
        hintText: 'Clínica',
        onSelected: (Location? value) {
          if (value != null) {
            selectedLocation = value;
          }
        },
        dropdownMenuEntries: state.locationsList.map<DropdownMenuEntry<Location>>((Location value) {
          return DropdownMenuEntry<Location>(value: value, label: value.city!);
        }).toList(),
      );
    }

    if (state is LocationError) {
      currentDropDownScreen = errorScreen(context: context, errorMessage: state.errorMessage.toString());
    }

    return currentDropDownScreen;
  });
}*/