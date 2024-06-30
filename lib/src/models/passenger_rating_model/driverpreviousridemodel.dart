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
      createdAt: json['createdAt'] ?? '',
      fare: json['fare'] ?? 0,
      distance: json['distance'] ?? '',
      rating: json['rating'] ?? 0,
      feedback: json['feedback'] ?? '',
    );
  }
}

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
}