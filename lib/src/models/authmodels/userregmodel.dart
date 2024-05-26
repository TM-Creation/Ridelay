/*
class Location {
  final String type;
  final List<double> coordinates;

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

class Preferences {
  final String language;
  final double preferredDriverRating;

  Preferences({
    required this.language,
    required this.preferredDriverRating,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      language: json['language'],
      preferredDriverRating: json['preferredDriverRating'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'preferredDriverRating': preferredDriverRating,
    };
  }
}

class User {
  final String name;
  final String email;
  final String password;
  final String phone;
  final Location location;
  final String role;
  final Preferences preferences;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.location,
    required this.role,
    required this.preferences,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      location: Location.fromJson(json['location']),
      role: json['role'],
      preferences: Preferences.fromJson(json['preferences']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'location': location.toJson(),
      'role': role,
      'preferences': preferences.toJson(),
    };
  }
}
*/
