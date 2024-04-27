import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart'; // Import the permission_handler package
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/location_selection_screen.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/other_widgets/space_line_between_two_text_fields.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/generic_textfield.dart';

final dio = Dio();
late List<Location> pick=[];
late List<Location> drop=[];
Directions? _info;
BitmapDescriptor? _originIcon;
BitmapDescriptor? _destinationIcon;
final obj = LocationSelectionScreen();
GoogleMapController? _mapController;
const initailposition = CameraPosition(
  target: LatLng(31.459917, 74.246294),
  zoom: 10,
);

Widget displayMapWidget(List<Location> pick, List<Location> drop,
    Directions? info) {
  @override
  void dispose() {
    _mapController?.dispose();
  }
  Future<void> _loadMarkerIcons() async {
    final double iconSize = 68.0; // Set the desired size of the icons

    _originIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(iconSize, iconSize)), // Specify the size
      'assets/images/CircularIconButton.png',
    );

    _destinationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(iconSize, iconSize)), // Specify the size
      'assets/images/destinationIcon.png',
    );
  }

  _loadMarkerIcons();
    return GoogleMap(
      initialCameraPosition: initailposition,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      mapType: MapType.normal,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: false,
      markers: {
        if(pick!=null && pick.isNotEmpty)
          Marker(markerId: MarkerId('pickup'),
              infoWindow: InfoWindow(
                title: 'Origin',
                snippet: 'Pickup Location',
                anchor: Offset(0.5, 0.5),
              ),
              icon: BitmapDescriptor.defaultMarker,
              position:LatLng(pick[0].latitude,pick[0].longitude)),
        if(drop!=null && drop.isNotEmpty)
          Marker(markerId: MarkerId('dropoff'),
              infoWindow: InfoWindow(
                title: 'Destination',
                snippet: 'Dropoff Location',
                anchor: Offset(0.5, 0.5),
              ),
              icon: BitmapDescriptor.defaultMarker!,
              position:LatLng(drop[0].latitude,drop[0].longitude)),
      },

      polylines: {
      if (_info != null)
        Polyline(
          polylineId: const PolylineId('overview_polyline'),
          color: Color(0XFFFC0A0A),
          width: 5,
          points: _info?.polylinePoints
              ?.map((e) => LatLng(e.latitude, e.longitude))
              .toList() ??
              [],
        ),
    },
      onCameraMove: ((_position) async {
        // Handle camera movement here if needed
      }),
      onMapCreated: (GoogleMapController controller) async {
        _mapController = controller;
        _requestPermissionAndGetCurrentLocation();
        // Request permission and get current location
      },
    );

}

void showpolyline(LatLng pickup, LatLng dropoff) async{
  final directions = await DirectionsRepository(dio: dio).getDirections(
    origin: pickup,
    destination: dropoff,
  );
  if(directions!= null){
    _info = directions;
  }else{
    print("direction null");
  }
}
Future<void> _requestPermissionAndGetCurrentLocation() async {
  // Check if location permission is granted
  var status = await Permission.location.request();
  if (status.isGranted) {
    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Update the map to show the user's current location
    LatLng userLocation = LatLng(position.latitude, position.longitude);
    _mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: userLocation,
        zoom: 4.0,
      ),
    ));
  } else {
    // Handle if permission is denied
    print('Location permission denied');
  }
}

Widget mapWidget({
  required bool isFullScreen,
  required bool isShowMyLocationIcon,
  required String image,
  required String hintFieldOne,
  required void Function() fieldOneButtonFunction,
  required Widget suffixIconFieldOne,
  required TextEditingController fieldOneController,
  required bool isDisplayFieldTwo,
  required String hintFieldTwo,
  required void Function() fieldTwoButtonFunction,
  required Widget suffixIconFieldTwo,
  required TextEditingController fieldTwoController,
  void Function()? fieldButtonFunction,
  bool isFieldsReadOnly = false,
  bool showTextFields = true,
  bool showAds = false,
  LatLng? userLocation,
  Directions? info,
}) {
  return Stack(
    alignment: AlignmentDirectional.topCenter,
    children: [
      SizedBox(
        height: isFullScreen
            ? ScreenConfig.screenSizeHeight * 1.2
            : ScreenConfig.screenSizeHeight * 0.8,
        width: ScreenConfig.screenSizeWidth,
        child: displayMapWidget(pick, drop, info),
      ),
      Column(
        children: [
          spaceHeight(ScreenConfig.screenSizeHeight * 0.17),
          if (showAds)
            Container(
              width: ScreenConfig.screenSizeWidth * 0.9,
              height: ScreenConfig.screenSizeHeight * 0.25,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage("assets/images/SampleAd.png"),
                  fit: BoxFit.cover,
                ),
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.40),
                    offset: const Offset(0.0, 1.2), //(x,y)
                    blurRadius: 6.0,
                  )
                ],
              ),
            ),
          if (showTextFields)
            SizedBox(
              height: isFullScreen
                  ? ScreenConfig.screenSizeHeight * 0.8
                  : ScreenConfig.screenSizeHeight * 0.5,
              width: ScreenConfig.screenSizeWidth * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      genericTextField(
                        hintFieldOne,
                        suffixIconFieldOne,
                        fieldOneController,
                        isReadOnly: isFieldsReadOnly,
                      ),
                      if (isDisplayFieldTwo) spaceHeight(10),
                      if (isDisplayFieldTwo) lineSeparatorTextFields(),
                      if (isDisplayFieldTwo) spaceHeight(10),
                      if (isDisplayFieldTwo)
                        genericTextField(
                          hintFieldTwo,
                          suffixIconFieldTwo,
                          fieldTwoController,
                          isReadOnly: isFieldsReadOnly,
                        ),
                    ],
                  ),
                ],
              ),
            )
        ],
      ),
      if (isDisplayFieldTwo)
        Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              onPressed: () async {
                if (fieldOneController.text.isNotEmpty && fieldTwoController.text.isNotEmpty) {
                  pick = await locationFromAddress(fieldOneController.text);
                  drop = await locationFromAddress(fieldTwoController.text);
                  showpolyline(LatLng(pick[0].latitude, pick[0].longitude),LatLng(drop[0].latitude, drop[0].longitude));
                  fieldButtonFunction!();
                } else {
                  print('ni aya');
                }

              },
              child: Icon(Icons.directions),
            ))
    ],
  );
}
class Directions {
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;
  final String totalDistance;
  final String totalDuration;

  const Directions({
    required this.bounds,
    required this.polylinePoints,
    required this.totalDistance,
    required this.totalDuration,
  });

  factory Directions.fromMap(Map<String, dynamic> map) {
    if ((map['routes'] as List).isEmpty) return null!;

    final data = Map<String, dynamic>.from(map['routes'][0]);

    final northeast = data['bounds']['northeast'];
    final southwest = data['bounds']['southwest'];
    final bounds = LatLngBounds(
      northeast: LatLng(northeast['lat'], northeast['lng']),
      southwest: LatLng(southwest['lat'], southwest['lng']),
    );

    String distance = '';
    String duration = '';
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
    }

    return Directions(
      bounds: bounds,
      polylinePoints:
      PolylinePoints().decodePolyline(data['overview_polyline']['points']),
      totalDistance: distance,
      totalDuration: duration,
    );
  }
}

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionsRepository({required Dio dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': 'AIzaSyC3zIrn8aFCIboCPmMyE52wKgFeQizPRNI',
      },
    );

    // Check if response is successful
    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }
    return null;
  }
}
