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

class Preferences {
  final String language;
  final double preferredDriverRating;

  Preferences({required this.language, required this.preferredDriverRating});

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'preferredDriverRating': preferredDriverRating,
    };
  }

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      language: json['language'],
      preferredDriverRating: json['preferredDriverRating'],
    );
  }
}

class User {
  final String name;
  final String email;
  final String password;
  final String phone;
  final Location location;
  final Preferences preferences;
  final String wallet;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.location,
    required this.preferences,
    required this.wallet,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'location': location.toJson(),
      'preferences': preferences.toJson(),
      'wallet': wallet,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      location: Location.fromJson(json['location']),
      preferences: Preferences.fromJson(json['preferences']),
      wallet: json['wallet'],
    );
  }
}
