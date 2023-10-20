import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_center/BusinessLogic/Cubits/Location/location_cubit.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:video_player/video_player.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.asset('assets/animation.mp4')
      ..initialize().then((_)  async {
        setState(() {
          _controller.play();
        });
        Future.delayed(const Duration(seconds: 8), () {
          _controller.pause();
          _controller.dispose();
          NavigationService.pushReplacementNamed(NavigationService.loginScreen);
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget currentScreen = Container();

    if (_controller.value.isInitialized) {
      LocationCubit locationCubit = BlocProvider.of<LocationCubit>(context);
      locationCubit.fetchLocations();

      currentScreen = AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      );
    }

    return Scaffold(
      body: currentScreen
    );
  }
}