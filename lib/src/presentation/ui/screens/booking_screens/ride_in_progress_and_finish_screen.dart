import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/models/googlemapapikey.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/ride_rating_screen.dart';
import 'package:ridely/src/presentation/ui/screens/driver_screens/driver_main_screen.dart';

import 'package:ridely/src/presentation/ui/templates/decorations/box_decoration_templates.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_bars/app_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/booking_widgets/map_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/other_widgets/slider_for_bottom_navigation.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';
import 'package:ridely/src/presentation/ui/templates/ride_widgets/ride_detail_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

class RideInProgressAndFinishedScreen extends StatefulWidget {
  const RideInProgressAndFinishedScreen({Key? key}) : super(key: key);
  static const routeName = '/rideinprogressandfinished-screen';

  @override
  State<RideInProgressAndFinishedScreen> createState() =>
      _RideInProgressAndFinishedScreenState();
}

class _RideInProgressAndFinishedScreenState
    extends State<RideInProgressAndFinishedScreen> {
  int currentIndex = -1;
  TextEditingController pickupEnterController = TextEditingController();
  TextEditingController dropoffEnterController = TextEditingController();
  String image = "assets/images/LocationDistanceScreenMap.png";
  List namesList = ["Mini", "Go", "Comfort", "Mini"];
  Set<Polyline> _polylines = {};
  late GoogleMapController _controller;
  LatLng pick = LatLng(0.0, 0.0);
  LatLng drop = LatLng(0.0, 0.0);
  late IO.Socket socket2;
  String distance = '', ETA = '';
  String numberplate = '', drivername = '', vahiclename = '';
  String rideid = '', driverid = '', driverImage = '', vehicleImage = '';
  double driverraiting = 0.0;
  int fare = 0;

  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve pickup and drop-off locations from arguments after dependencies change
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      setState(() {
        pickupEnterController.text = args['pickupLocation']!;
        dropoffEnterController.text = args['dropoffLocation']!;
        drivername = args['driverName']!;
        driverraiting = args['driverRaiting']!;
        driverImage = args['driverImage'];
        vahiclename = args['vahicleName']!;
        numberplate = args['vahicleNumberplate']!;
        vehicleImage = args['vehicleImage'];
        fare = args['fare']!;
        rideid = args['rideid']!;
        driverid = args['driverID']!;
      });
      print('Data data data $drivername');
    }
  }

  @override
  void initState() {
    pick = pickanddrop().pickloc!;
    drop = pickanddrop().droploc!;
    _initLocationService();
    initSocket();
    super.initState();
  }

  initSocket() {
    IO.Socket socket = socketconnection().socket;
    setState(() {
      socket2 = socket;
    });
    socket.on('completeRide', (data) {
      print('on of is run correctly');
      Navigator.of(context)
          .pushReplacementNamed(RideRatingScreen.routeName, arguments: {
        "pickupLocation": pickupEnterController.text,
        "dropoffLocation": dropoffEnterController.text,
        "fare": fare,
        "rideid": rideid,
        "driverID": driverid,
        "drivername": drivername
      });
    });
  }

  Future<void> _initLocationService() async {
    _updatePolyline();
    _trackDriverLocation();
  }

  String calculateDistance(double pickupLat, double pickupLon,
      double dropoffLat, double dropoffLon) {
    const double earthRadiusKm = 6371; // Earth's radius in kilometers

    double degreeToRadian(double degree) {
      return degree * pi / 180;
    }

    final double lat1Rad = degreeToRadian(pickupLat);
    final double lon1Rad = degreeToRadian(pickupLon);
    final double lat2Rad = degreeToRadian(dropoffLat);
    final double lon2Rad = degreeToRadian(dropoffLon);

    final double dLat = lat2Rad - lat1Rad;
    final double dLon = lon2Rad - lon1Rad;

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distanceKm = earthRadiusKm * c;
    distanceKm = distanceKm * 1.58500;
    return '${distanceKm.toStringAsFixed(2)} km';
  }

  Future<String> getTravelTime(
      double startLat, double startLng, double endLat, double endLng) async {
    final apiKey = '${GoogleMapKey().googlemapkey}';
    final url = 'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=$startLat,$startLng'
        '&destination=$endLat,$endLng'
        '&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final travelTime = data['routes'][0]['legs'][0]['duration']['text'];
      return travelTime;
    } else {
      throw Exception('Failed to get travel time: ${response.statusCode}');
    }
  }

  Future<List<LatLng>> _getRoutePolylinePoints(
      LatLng origin, LatLng destination) async {
    String apiUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=${GoogleMapKey().googlemapkey}';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      List<LatLng> polylinePoints = [];

      // Extracting route polyline points from API response
      List steps = decoded['routes'][0]['legs'][0]['steps'];
      steps.forEach((step) {
        String points = step['polyline']['points'];
        List<LatLng> decodedPolylinePoints = decodeEncodedPolyline(points);
        polylinePoints.addAll(decodedPolylinePoints);
      });

      return polylinePoints;
    } else {
      throw Exception('Failed to load route');
    }
  }

  List<LatLng> decodeEncodedPolyline(String encoded) {
    List<LatLng> polylinePoints = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      double latitude = lat / 1E5;
      double longitude = lng / 1E5;
      polylinePoints.add(LatLng(latitude, longitude));
    }
    return polylinePoints;
  }

  void _updatePolyline() {
    print("check polyline update $pick $drop");
    _getRoutePolylinePoints(pick, drop).then((polylinePoints) {
      if (mounted) {
        setState(() async {
          distance = calculateDistance(
              pick.latitude, pick.longitude, drop.latitude, drop.longitude);
          ETA = await getTravelTime(
              pick.latitude, pick.longitude, drop.latitude, drop.longitude);
          _polylines = {
            Polyline(
              polylineId: PolylineId('route'),
              points: polylinePoints,
              color: Colors.red,
              width: 5,
            )
          };
        });
      }
      /*_controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _driverLocation,
          zoom: 13.0,
        ),
      ));*/
    }).catchError((e) {
      print('Error fetching route: $e');
    });
  }

  void _trackDriverLocation() {
    Geolocator.getPositionStream().listen((Position position) {
      if (mounted) {
        setState(() {
          pick = LatLng(position.latitude, position.longitude);
          _updatePolyline();
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    socket2.off('completeRide');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget bottomModalNonSlideable() {
      return Container(
        //height: ScreenConfig.screenSizeHeight * 0.32,
        width: ScreenConfig.screenSizeWidth,
        decoration: bottomModalTemplate(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: SizedBox(
            width: ScreenConfig.screenSizeWidth * 0.9,
            child: Column(
              children: [
                sliderBar(),
                spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                rideDetailsInProgressAndFinishedWidget(
                  "Your Ride Is In Progress",
                  context,
                  distance,
                  ETA,
                  drivername,
                  driverraiting,
                  vahiclename,
                  vehicleImage,
                  driverImage,
                  numberplate,
                ),
                spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: pick,
              zoom: 15,
            ),
            markers: {
              Marker(
                markerId: MarkerId('passengerlivelocation'),
                position: pick,
                infoWindow: InfoWindow(title: 'Your Live Location'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
              ),
              Marker(
                markerId: MarkerId('passangerdropoff'),
                position: drop,
                infoWindow: InfoWindow(title: 'Your Drop Location'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
              ),
            },
            polylines: _polylines,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
          ),
          spaceHeight(
            ScreenConfig.screenSizeHeight * 0.2,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              spaceHeight(ScreenConfig.screenSizeHeight * 0.04),
              bottomModalNonSlideable(),
            ],
          )
        ],
      ),
    );
  }
}
