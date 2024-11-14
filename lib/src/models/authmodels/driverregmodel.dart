import 'dart:convert';

class Driver {
  String name;
  String type;
  String email;
  String password;
  String phone;
  Location location;
  String driverImage;
  String idCardFront;
  String idCardBack;
  String drivingLicenseFront;
  String drivingLicenseBack;

  Driver({
    required this.name,
    required this.type,
    required this.email,
    required this.password,
    required this.phone,
    required this.location,
    required this.driverImage,
    required this.idCardFront,
    required this.idCardBack,
    required this.drivingLicenseFront,
    required this.drivingLicenseBack,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      name: json['name'],
      type: json['type'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      location: Location.fromJson(json['location']),
      driverImage: json['driverImage'],
      idCardFront: json['idCardFront'],
      idCardBack: json['idCardBack'],
      drivingLicenseFront: json['drivingLicenseFront'],
      drivingLicenseBack: json['drivingLicenseBack'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'email': email,
      'password': password,
      'phone': phone,
      'location': location.toJson(),
      'driverImage': driverImage,
      'idCardFront': idCardFront,
      'idCardBack': idCardBack,
      'drivingLicenseFront': drivingLicenseFront,
      'drivingLicenseBack': drivingLicenseBack,
    };
  }
}

class Location {
  String type;
  List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: List<double>.from(json['coordinates']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}