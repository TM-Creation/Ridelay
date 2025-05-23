class Vehicle {
  final String driver;
  final String model;
  final String type;
  final String year;
  final String vehicleType;
  final String numberPlate;
  final String color;
  final String name;
  final String vehicleImage;

  Vehicle({
    required this.driver,
    required this.model,
    required this.type,
    required this.year,
    required this.vehicleType,
    required this.numberPlate,
    required this.color,
    required this.name,
    required this.vehicleImage
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      driver: json['driver'],
      model: json['model'],
      type: json['type'],
      year: json['year'],
      vehicleType: json['vehicleType'],
      numberPlate: json['numberPlate'],
      color: json['color'],
      name: json['name'],
      vehicleImage: json['vehicleImage']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driver': driver,
      'model': model,
      'type': type,
      'year': year,
      'vehicleType': vehicleType,
      'numberPlate': numberPlate,
      'color': color,
      'name' : name,
      'vehicleImage' : vehicleImage
    };
  }
}
