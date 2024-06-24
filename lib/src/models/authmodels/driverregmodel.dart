class Location {
  final String type;
  final List<double> coordinates;

  Location({required this.type, required this.coordinates});

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: List<double>.from(json['coordinates']),
    );
  }
}

class driverregmodel {
  final String name;
  final String email;
  final String password;
  final String phone;
  final Location location;
  final String vehicle;
  final double rating;
  final String identityCardNumber;
  final String status;
  final String wallet;
  final String driverImage;

  driverregmodel({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.location,
    required this.vehicle,
    required this.rating,
    required this.identityCardNumber,
    required this.status,
    required this.wallet,
    required this.driverImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'location': location.toJson(),
      'vehicle' : vehicle,
      'rating': rating,
      'identityCardNumber': identityCardNumber,
      'status': status,
      'wallet': wallet,
      'driverImage': driverImage,
    };
  }

  factory driverregmodel.fromJson(Map<String, dynamic> json) {
    return driverregmodel(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      location: Location.fromJson(json['location']),
      vehicle: json['vehicle'],
      rating: json['rating'],
      identityCardNumber: json['identityCardNumber'],
      status: json['status'],
      wallet: json['wallet'],
      driverImage: json['driverImage'],
    );
  }
}
