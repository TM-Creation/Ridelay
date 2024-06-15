class FeedbackModel {
  String ride;
  String passenger;
  String driver;
  int rating;
  String feedback;

  FeedbackModel({
    required this.ride,
    required this.passenger,
    required this.driver,
    required this.rating,
    required this.feedback,
  });

  // Method to convert a FeedbackModel object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'ride': ride,
      'passenger': passenger,
      'driver': driver,
      'rating': rating,
      'feedback': feedback,
    };
  }
}
