import 'dart:convert';

import 'package:five_pointed_star/five_pointed_star.dart';
import 'package:flutter/material.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/models/base%20url.dart';
import 'package:ridely/src/presentation/ui/screens/past_rides_screens/driver_previous_ride_detail_screen.dart';
import 'package:ridely/src/presentation/ui/screens/past_rides_screens/driverpreviousridescreen_container.dart';
import 'package:ridely/src/presentation/ui/templates/decorations/box_decoration_templates.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_bars/app_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';
import 'package:ridely/src/presentation/ui/templates/previous_rides_screens_widgets/previous_ride_container.dart';
import 'package:http/http.dart' as http;

import '../../../../models/passenger_rating_model/driverpreviousridemodel.dart';
class DriverPreviousRidesScreen extends StatefulWidget {
  const DriverPreviousRidesScreen({Key? key}) : super(key: key);
  static const routeName = '/previousrides-screen';

  @override
  State<DriverPreviousRidesScreen> createState() => _DriverPreviousRidesScreenState();
}
class _DriverPreviousRidesScreenState extends State<DriverPreviousRidesScreen> {
  int count = 0;
  late Future<List<Ride>> futureRides;
  Future<List<Ride>> fetchRides() async {
    final response = await http.get(Uri.parse('${baseulr().burl}/api/v1/feedback/66532d5b49a53711e9096838'));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      List<Ride> rides = jsonResponse.map((ride) => Ride.fromJson(ride)).toList();

      print("All Previous Rides : $rides");
      // Count occurrences

      for (var ride in jsonResponse) {
        count++;
      }

      print("Occurrences: $count");

      return rides;
    } else {
      throw Exception('Failed to load rides');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureRides = fetchRides();
  }
  int mycount=3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 70),
          child: SizedBox(
            height: ScreenConfig.screenSizeHeight * 1.2,
            width: ScreenConfig.screenSizeWidth,
            child: SingleChildScrollView(
                child: Column(
                  children: [
                    displayText(
                      "Previous Rides",
                      ScreenConfig.theme.textTheme.headline1,
                    ),
                    spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
                    FutureBuilder<List<Ride>>(future: futureRides, builder: (context,snapshot){
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding:  EdgeInsets.only(top: ScreenConfig.screenSizeHeight*0.35),
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('No rides found');
                      }else{
                        return Column(
                          children: List.generate(snapshot.data!.length, (index) {
                            final ride = snapshot.data![index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Container(
                                width: ScreenConfig.screenSizeWidth * 0.9,
                                decoration: blueContainerTemplate(),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                                  child: Center(
                                    child: SizedBox(
                                      width: ScreenConfig.screenSizeWidth * 0.8,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Total Payed Amount',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: ScreenConfig.screenSizeWidth * 0.04),
                                              ),
                                              Text(
                                                "${ride.fare}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: ScreenConfig.screenSizeWidth * 0.04),
                                              ),
                                            ],
                                          ),
                                          spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                                          Container(
                                            color: Colors.transparent,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: ScreenConfig.screenSizeWidth * 0.085,
                                                  height: ScreenConfig.screenSizeWidth * 0.085,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage("assets/images/UserProfileImage.png"), fit: BoxFit.cover),
                                                    borderRadius:
                                                    const BorderRadius.all(Radius.circular(5)),
                                                  ),
                                                ),
                                                spaceWidth(ScreenConfig.screenSizeWidth * 0.02),
                                                Text("${ride.passenger.name}",style: TextStyle(color: Colors.white,fontSize: ScreenConfig.screenSizeWidth*0.04),)
                                              ],
                                            ),
                                          ),
                                          spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
                                          SizedBox(
                                            width: ScreenConfig.screenSizeWidth * 0.8,
                                            child: Row(
                                              children: [
                                                displayText(
                                                  "Your rating",
                                                  ScreenConfig.theme.textTheme.bodyText1,
                                                  width: 0.2,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    FivePointedStar(
                                                      defaultSelectedCount: ride.rating,
                                                      count: 5,
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return  DriverPreviousRideDetailScreen();
                                                },
                                              );
                                            },
                                            child: Container(
                                                height: ScreenConfig.screenSizeHeight * 0.05,
                                                width: ScreenConfig.screenSizeWidth * 0.8,
                                                decoration: squareButtonTemplate(),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 10.0, vertical: 5),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          displayText(
                                                            "Distance:",
                                                            ScreenConfig.theme.textTheme.headline4,
                                                            width: 0.25,
                                                          ),
                                                          displayText(
                                                            "${ride.distance}",
                                                            ScreenConfig.theme.textTheme.headline4,
                                                            width: 0.2,
                                                          ),
                                                        ],
                                                      ),
                                                      Buttons.forwardButton(context, () {})
                                                    ],
                                                  ),
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      }
                    })
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
