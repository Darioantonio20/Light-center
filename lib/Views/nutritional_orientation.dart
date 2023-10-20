import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:light_center/Services/network_service.dart';
import 'package:light_center/Views/custom_widgets.dart';
import 'package:light_center/colors.dart';
import 'package:light_center/enums.dart';

class NutritionalOrientation extends StatelessWidget {
  const NutritionalOrientation({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: commonAppBar(
        title: const Text('Orientación Nutricional')
      ),
      body: FutureBuilder<List<String>>(
        future: getNutritionalOrientation(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                  child: Text('No hay noticias',
                    style: TextStyle(
                        color: LightCenterColors.mainBrown,
                        fontWeight: FontWeight.bold,
                        fontSize: 24
                    ),
                  )
              );
            }

            ValueNotifier<int> currentSlide = ValueNotifier(0);
            final CarouselController carouselController = CarouselController();

            return Column(
              children: [
                Expanded(
                  child: CarouselSlider(
                      carouselController: carouselController,
                      items: snapshot.data!.map((item) => Image.network(
                        item,
                        fit: BoxFit.cover,
                        height: screenHeight,
                      )).toList(),
                      options: CarouselOptions(
                          height: screenHeight,
                          viewportFraction: 1,
                          enlargeCenterPage: false,
                          onPageChanged: (index, reason) {
                            currentSlide.value = index;
                          }
                      )
                  ),
                ),

                ValueListenableBuilder<int>(
                  valueListenable: currentSlide,
                  builder: (context, index, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: snapshot.data!.asMap().entries.map((entry) {
                        return Container(
                          width: 12.0,
                          height: 12.0,
                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : LightCenterColors.mainPurple)
                                  .withOpacity(currentSlide.value == entry.key ? 0.9 : 0.4)),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return errorScreen(context: context, errorMessage: snapshot.error.toString());
          } else {
            return loadingScreen(context: context);
          }
        },
      ),
    );
  }
}

Future<List<String>> getNutritionalOrientation() async {
  Map<String, dynamic> response = await sendRequest(
    endPoint: '/nutritional',
    method: HTTPMethod.get,
  );

  return List<String>.from(response['Links']);
}