import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_center/BusinessLogic/Cubits/Location/location_cubit.dart';
import 'package:light_center/BusinessLogic/Cubits/User/user_cubit.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:light_center/Views/custom_widgets.dart';
import 'package:video_player/video_player.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    VideoPlayerController _controller = VideoPlayerController.asset('assets/animation.mp4');
    ValueNotifier<bool> videoLoadedNotifier = ValueNotifier<bool>(false);
    _controller.initialize().then((value) async {
      await _controller.play();
      videoLoadedNotifier.value = true;
    });

    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: videoLoadedNotifier,
        builder: (context, isLoaded, _) {
          if (_controller.value.isInitialized) {
            UserCubit _userCubit = BlocProvider.of<UserCubit>(context);
            LocationCubit locationCubit = BlocProvider.of<LocationCubit>(context);
            _userCubit.getUser();

            return FutureBuilder<Map<String, dynamic>>(
                future: _userCubit.validateCredentials(),
                builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    Future.delayed(const Duration(seconds: 8), (){
                      _controller.dispose().whenComplete(() {
                        if (snapshot.data!['validation'] == true)  {
                          NavigationService.pushReplacementNamed(NavigationService.dashboardScreen);
                        } else {
                          if (snapshot.data!['message'] == 'El usuario no existe.') {
                            NavigationService.pushReplacementNamed(NavigationService.agreementsScreen);
                          } else {
                            NavigationService.pushReplacementNamed(NavigationService.loginScreen);
                          }
                        }
                      });
                    });

                    if (snapshot.data!['validation'] == false) {
                      locationCubit.fetchLocations();
                    }

                    return AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    );
                  } else if (snapshot.hasError) {
                    return errorScreen(context: context, errorMessage: 'La información del usuario no pudo ser cargada');
                  } else {
                    return loadingScreen(context: context);
                  }
                }
            );
          } else {
            return loadingScreen(context: context);
          }
        },
      ),
    );

  }
}