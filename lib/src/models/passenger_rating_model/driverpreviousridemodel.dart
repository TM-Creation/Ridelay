// ride.dart
class Passenger {
  final String name;
  final String image;

  Passenger({required this.name, required this.image});

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      name: json['name'],
      image: json['image'],
    );
  }

  @override
  String toString() {
    return 'Passenger(name: $name, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Passenger &&
        other.name == name &&
        other.image == image;
  }

  @override
  int get hashCode => name.hashCode ^ image.hashCode;
}

class Ride {
  final Passenger passenger;
  final String createdAt;
  final int fare;
  final String distance;
  final int rating;
  final String feedback;

  Ride({
    required this.passenger,
    required this.createdAt,
    required this.fare,
    required this.distance,
    required this.rating,
    required this.feedback,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      passenger: Passenger.fromJson(json['passenger']),
      createdAt: json['createdAt'],
      fare: json['fare'],
      distance: json['distance'],
      rating: json['rating'],
      feedback: json['feedback'],
    );
  }

  @override
  String toString() {
    return 'Ride(passenger: $passenger, createdAt: $createdAt, fare: $fare, distance: $distance, rating: $rating, feedback: $feedback)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Ride &&
        other.passenger == passenger &&
        other.createdAt == createdAt &&
        other.fare == fare &&
        other.distance == distance &&
        other.rating == rating &&
        other.feedback == feedback;
  }

  @override
  int get hashCode => passenger.hashCode ^ createdAt.hashCode ^ fare.hashCode ^ distance.hashCode ^ rating.hashCode ^ feedback.hashCode;
}
