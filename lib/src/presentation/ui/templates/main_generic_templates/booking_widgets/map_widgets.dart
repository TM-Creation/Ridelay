import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/other_widgets/space_line_between_two_text_fields.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/generic_textfield.dart';

Widget displayMapWidget() {
  GoogleMapController? _mapController;
  LatLng? _userLocation;

  return GoogleMap(
    initialCameraPosition: CameraPosition(
      target: LatLng(30.37, 69.34),
      zoom: 5,
    ),
    myLocationEnabled: true,
    myLocationButtonEnabled: false,
    mapType: MapType.normal,
    zoomGesturesEnabled: true,
    zoomControlsEnabled: false,
    onCameraMove: ((_position) async {
      // Handle camera movement here if needed
    }),
    onMapCreated: (GoogleMapController controller) {
      _mapController = controller;
      _showUserLocation(_mapController!);
    },
    markers: _userLocation != null
        ? {
      Marker(
        markerId: MarkerId("user_location"),
        position: _userLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueBlue,
        ),
      ),
    }
        : {},
  );
}

void _showUserLocation(GoogleMapController controller) async {
  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  LatLng userLocation = LatLng(position.latitude, position.longitude);
  controller.animateCamera(CameraUpdate.newCameraPosition(
    CameraPosition(
      target: userLocation,
      zoom: 15.0,
    ),
  ));
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
                  isShowMyLocationIcon
                      ? Buttons.getMyCurrentLocationButton()
                      : Container(),
                ],
              ),
            )
        ],
      ),
    ],
  );
}
