import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/location_selection_screen.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/authentication_selection.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/other_widgets/space_line_between_two_text_fields.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/generic_textfield.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  void Function(Directions?)? onInfoReceived;
  bool isFullScreen;
  bool isShowMyLocationIcon;
  String image;
  String hintFieldOne;
  void Function() fieldOneButtonFunction;
  Widget suffixIconFieldOne;
  TextEditingController fieldOneController;
  bool isDisplayFieldTwo;
  bool? autoupdatepolyline;
  String hintFieldTwo;
  void Function() fieldTwoButtonFunction;
  Widget suffixIconFieldTwo;
  TextEditingController fieldTwoController;
  void Function()? fieldButtonFunction;
  bool? isFieldsReadOnly = false;
  bool? showTextFields = true;
  bool? showAds = false;
  bool check;
  List<Location>? search = [];

  MapScreen({
    Key? kek,
    this.onInfoReceived,
    required this.isFullScreen,
    required this.isShowMyLocationIcon,
    required this.image,
    required this.hintFieldOne,
    required this.fieldOneButtonFunction,
    required this.isDisplayFieldTwo,
    required this.hintFieldTwo,
    required this.fieldTwoButtonFunction,
    required this.suffixIconFieldTwo,
    required this.fieldTwoController,
    required this.fieldOneController,
    required this.suffixIconFieldOne,
    this.fieldButtonFunction,
    this.isFieldsReadOnly,
    this.showAds,
    this.showTextFields,
    this.autoupdatepolyline,
    required this.check,
    required this.search,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  late LatLngBounds _polylineBounds;

  var uuid = Uuid();
  String sessionToken = "122344";
  List<dynamic> placeList1 = [];
  List<dynamic> placeList2 = [];
  bool flag1 = false;
  bool flag2 = true;

  @override
  void initState() {
    _loadMarkerIcons();
    widget.fieldOneController.addListener(() {
      onChange();
    });
    widget.fieldTwoController.addListener(() {
      onChange();
    });
    super.initState();
  }

  void onChange() {
    if (sessionToken == null) {
      setState(() {
        sessionToken = uuid.v4();
      });
    }
    getSuggestion1(widget.fieldOneController.text);
    getSuggestion2(widget.fieldTwoController.text);
  }

  void getSuggestion1(String input) async {
    String KPLACES_API_KEY = "AIzaSyAW34SKXZzfAUZYRkFqvMceV740PImrruE";
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$KPLACES_API_KEY&sessiontoken=$sessionToken';

    try {
      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print("data: $data");
        if (data['status'] == 'OK') {
          if(mounted){
            setState(() {
              placeList1 = data['predictions'];
            });
          }
        } else {
          throw Exception('Failed to get suggestions: ${data['status']}');
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void getSuggestion2(String input) async {
    String KPLACES_API_KEY = "AIzaSyAW34SKXZzfAUZYRkFqvMceV740PImrruE";
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$KPLACES_API_KEY&sessiontoken=$sessionToken';

    try {
      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print("data: $data");
        if (data['status'] == 'OK') {
          if(mounted){setState(() {
            placeList2 = data['predictions'];
          });}
        } else {
          throw Exception('Failed to get suggestions: ${data['status']}');
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Future<void> _requestPermissionAndGetCurrentLocation() async {
    _mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: userLiveLocation().userlivelocation!,
        zoom: 15.0,
      ),
    ));
  }

  void _adjustCameraToBounds() {
    if (_info != null && _mapController != null) {
      final List<LatLng> polylinePoints = _info!.polylinePoints
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      double minLat = polylinePoints[0].latitude;
      double minLng = polylinePoints[0].longitude;
      double maxLat = polylinePoints[0].latitude;
      double maxLng = polylinePoints[0].longitude;

      for (final point in polylinePoints) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLng) minLng = point.longitude;
        if (point.longitude > maxLng) maxLng = point.longitude;
      }

      _polylineBounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );

      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          _polylineBounds,
          100, // Padding to adjust the position of the bounds inside the map
        ),
      );
    }
  }

  void showpolyline(LatLng pickup, LatLng dropoff) async {
    final directions = await DirectionsRepository(dio: dio).getDirections(
      origin: pickup,
      destination: dropoff,
    );
    if (directions != null) {
      _info = directions;
      if (_info != null) {
        onInfoReceived(_info);
        if (widget.autoupdatepolyline == false) {
          widget.fieldButtonFunction!();
        }
        _adjustCameraToBounds();
        if(mounted){setState(() {});}
      }
    } else {
      print("direction null");
    }
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

  final dio = Dio();
  late List<Location> pick = [];
  late List<Location> drop = [];
  Directions? _info;
  BitmapDescriptor? _originIcon;
  BitmapDescriptor? _destinationIcon;
  final obj = LocationSelectionScreen();
  GoogleMapController? _mapController;
  static const initailposition = CameraPosition(
    target: LatLng(31.459917, 74.246294),
    zoom: 11.5,
  );

  @override
  void dispose() {
    widget.fieldOneController.removeListener(onChange);
    widget.fieldTwoController.removeListener(onChange);
    _mapController?.dispose();
    super.dispose();
  }

  void locationUpdate() async {
    final pickLocations =
        await locationFromAddress(widget.fieldOneController.text);
    final dropLocations =
        await locationFromAddress(widget.fieldTwoController.text);

    // Update the state within setState
    setState(() {
      pick = pickLocations as List<Location>;
      drop = dropLocations as List<Location>;
      showpolyline(
        LatLng(pick[0].latitude, pick[0].longitude),
        LatLng(drop[0].latitude, drop[0].longitude),
      );
    });
  }

  late String livelocationdata;

  @override
  Widget build(BuildContext context) {
    if (widget.check == true) {
      locationUpdate();
    }
    if (widget.search!.isNotEmpty) {
      _mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target:
              LatLng(widget.search![0].latitude, widget.search![0].longitude),
          zoom: 15.0,
        ),
      ));
    }
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        SizedBox(
          height: widget.isFullScreen
              ? ScreenConfig.screenSizeHeight * 1.2
              : ScreenConfig.screenSizeHeight * 0.8,
          width: ScreenConfig.screenSizeWidth,
          child:
          GoogleMap(
            initialCameraPosition: initailposition,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            padding: EdgeInsets.only(
              right: 20,
              bottom: 60,
            ),
            markers: {
              if (widget.search!.isNotEmpty)
                Marker(
                    markerId: MarkerId('pickup'),
                    infoWindow: InfoWindow(
                      title: 'Origin',
                      snippet: 'Pickup Location',
                      anchor: Offset(0.5, 0.5),
                    ),
                    icon: BitmapDescriptor.defaultMarker!,
                    position: LatLng(widget.search![0].latitude,
                        widget.search![0].longitude)),
              if (pick != null && pick.isNotEmpty)
                Marker(
                    markerId: MarkerId('pickup'),
                    infoWindow: InfoWindow(
                      title: 'Origin',
                      snippet: 'Pickup Location',
                      anchor: Offset(0.5, 0.5),
                    ),
                    icon: BitmapDescriptor.defaultMarker!,
                    position: LatLng(pick[0].latitude, pick[0].longitude)),
              if (drop != null && drop.isNotEmpty)
                Marker(
                    markerId: MarkerId('dropoff'),
                    infoWindow: InfoWindow(
                      title: 'Destination',
                      snippet: 'Dropoff Location',
                      anchor: Offset(0.5, 0.5),
                    ),
                    icon: BitmapDescriptor.defaultMarker!,
                    position: LatLng(drop[0].latitude, drop[0].longitude)),
            },
            polylines: {
              // if (_info != null && DistanceLessThenFiftyKM())
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
              if (widget.check != true) {
                _requestPermissionAndGetCurrentLocation();
              }
              // Request permission and get current location
            },
          ),
        ),
        Column(
          children: [
            spaceHeight(ScreenConfig.screenSizeHeight * 0.12),
            if (widget.showAds!)
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
            if (widget.showTextFields!)
              SizedBox(
                height: ScreenConfig.screenSizeHeight * 0.5,
                width: ScreenConfig.screenSizeWidth * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    genericTextField(
                      widget.hintFieldOne,
                      widget.suffixIconFieldOne,
                      widget.fieldOneController,
                      (value) {
                        setState(() {
                         flag1 = !value.isEmpty;
                        });
                        getSuggestion1(widget.fieldOneController.text);
                      },
                      isReadOnly: widget.isFieldsReadOnly!,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (flag1)
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    widget.fieldOneController.text = '';
                                    List<Placemark> placemarks =
                                        await placemarkFromCoordinates(
                                            userLiveLocation().userlivelocation!.latitude,
                                            userLiveLocation().userlivelocation!.longitude);
                                    print("usr live locatio is this");
                                    setState(() {
                                      widget.fieldOneController.text =
                                          '${placemarks.reversed.last.name}' +
                                              ' ' +
                                              '${placemarks.reversed.last.street}' +
                                              ' ' +
                                              '${placemarks.reversed.last.locality}' +
                                              ' ' +
                                              '${placemarks.reversed.last.country}';
                                      print('$placemarks place mark');
                                      flag1 = false;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: ScreenConfig.theme.primaryColor,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20))),
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.navigation,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Select Your Live Location",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    placeList1.length,
                                    (index) {
                                      return ListTile(
                                        onTap: () async {
                                          flag1 = false;
                                          // Set the text of the controller to the tapped place's description
                                          widget.fieldOneController.text =
                                              placeList1[index]['description'];
                                          // Call getSuggestion with the tapped place's description to update suggestions
                                          getSuggestion1(
                                              placeList1[index]['description']);
                                          try {
                                            List<Location> locations =
                                                await locationFromAddress(
                                                    "${placeList1[index]['description']}");
                                            print("locations: $locations");
                                            if (locations != null &&
                                                locations.isNotEmpty) {
                                              print(
                                                  "longitude: ${locations.last.longitude}");
                                              print(
                                                  "latitude: ${locations.last.latitude}");
                                            } else {
                                              print(
                                                  'No location found for this address');
                                            }
                                          } catch (e) {
                                            print('Error getting location: $e');
                                          }
                                        },
                                        title: Text(
                                          placeList1[index]['description'],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (widget.isDisplayFieldTwo) spaceHeight(10),
                    if (widget.isDisplayFieldTwo) lineSeparatorTextFields(),
                    if (widget.isDisplayFieldTwo) spaceHeight(10),
                    if (widget.isDisplayFieldTwo)
                      genericTextField(
                        widget.hintFieldTwo,
                        widget.suffixIconFieldTwo,
                        widget.fieldTwoController,
                        (value) {
                          setState(() {
                            flag2 = !value.isEmpty;
                          });
                          getSuggestion2(widget.fieldTwoController.text);
                        },
                        isReadOnly: widget.isFieldsReadOnly!,
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    if (flag2)
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                placeList2.length,
                                (index) {
                                  return ListTile(
                                    onTap: () async {
                                      flag2 = false;
                                      // Set the text of the controller to the tapped place's description
                                      widget.fieldTwoController.text =
                                          placeList2[index]['description'];
                                      // Call getSuggestion with the tapped place's description to update suggestions
                                      getSuggestion2(
                                          placeList2[index]['description']);
                                      try {
                                        List<Location> locations =
                                            await locationFromAddress(
                                                "${placeList2[index]['description']}");
                                        print("locations: $locations");
                                        if (locations != null &&
                                            locations.isNotEmpty) {
                                          print(
                                              "longitude: ${locations.last.longitude}");
                                          print(
                                              "latitude: ${locations.last.latitude}");
                                        } else {
                                          print(
                                              'No location found for this address');
                                        }
                                      } catch (e) {
                                        print('Error getting location: $e');
                                      }
                                    },
                                    title: Text(
                                      placeList2[index]['description'],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              )
          ],
        ),
        if (widget.isDisplayFieldTwo && widget.autoupdatepolyline == false)
          Positioned(
              bottom: 80,
              left: 20,
              child: FloatingActionButton(
                onPressed: () async {
                  if (widget.fieldOneController.text.isNotEmpty &&
                      widget.fieldTwoController.text.isNotEmpty) {
                    pick = await locationFromAddress(
                        widget.fieldOneController.text);
                    drop = await locationFromAddress(
                        widget.fieldTwoController.text);
                    setState(() {
                      pickanddrop().pickloc=LatLng(pick[0].latitude, pick[0].longitude);
                      pickanddrop().droploc=LatLng(drop[0].latitude, drop[0].longitude);
                      print("${pickanddrop().pickloc} pickloc a gya");
                    });

                    print("${pick} and  ${drop} both a done");
                    showpolyline(LatLng(pick[0].latitude, pick[0].longitude),
                        LatLng(drop[0].latitude, drop[0].longitude));
                  } else {
                    print('ni aya');
                  }
                },
                child: Icon(Icons.directions),
              )),
      ],
    );
  }
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
        'key': 'AIzaSyAW34SKXZzfAUZYRkFqvMceV740PImrruE',
      },
    );
    print('$destination helo');
    // Check if response is successful
    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }
    return null;
  }
}

bool DistanceLessThenFiftyKM() {
  // Extract numerical value from the string
  final distanceString = distance?.totalDistance ?? "";
  final distanceNumeric =
      double.tryParse(distanceString.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;

  if (distanceNumeric <= 50) {
    print("Hello moeen");
    return true;
  } else {
    return false;
  }
}

class pickanddrop {
  static final pickanddrop _instance = pickanddrop._internal();

  factory pickanddrop() {
    return _instance;
  }

  pickanddrop._internal();

  LatLng? pickloc, droploc;
}
