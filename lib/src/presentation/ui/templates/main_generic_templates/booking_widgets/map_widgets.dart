import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart'; // Import the permission_handler package
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/other_widgets/space_line_between_two_text_fields.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/generic_textfield.dart';

GoogleMapController? _mapController;
const initailposition = CameraPosition(
  target: LatLng(31.459917, 74.246294),
  zoom: 10,
);

Widget displayMapWidget() {
  @override
  void dispose() {
    _mapController?.dispose();
  }
 LatLng? _userLocation;
  return GoogleMap(
    initialCameraPosition: initailposition,
    myLocationEnabled: true,
    myLocationButtonEnabled: false,
    mapType: MapType.normal,
    zoomGesturesEnabled: true,
    zoomControlsEnabled: false,
    onCameraMove: ((_position) async {
      // Handle camera movement here if needed
    }),
    onMapCreated: (GoogleMapController controller) async {
      _mapController = controller;
      await _requestPermissionAndGetCurrentLocation(); // Request permission and get current location
    },

  );
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
        zoom: 15.0,
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
  bool isFieldsReadOnly = false,
  bool showTextFields = true,
  bool showAds = false,
  LatLng? userLocation,
}) {
  return Stack(
    alignment: AlignmentDirectional.topCenter,
    children: [
      SizedBox(
        height: isFullScreen
            ? ScreenConfig.screenSizeHeight * 1.2
            : ScreenConfig.screenSizeHeight * 0.8,
        width: ScreenConfig.screenSizeWidth,
        child: displayMapWidget(),
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
    ],
  );
}
