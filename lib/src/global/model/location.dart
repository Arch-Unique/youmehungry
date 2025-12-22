import 'dart:convert';

class Location {
  int id;
  String name;
  String address;
  String? country;
  List<String> images;
  double? lat;
  double? lng;
  DateTime? updatedAt;
  DateTime? createdAt;

  Location({
    this.id = 0,
    required this.name,
    required this.address,
    this.images = const [],
    this.country,
    this.lat,
    this.lng,
    this.updatedAt,
    this.createdAt,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      country: json['country'],
      images: json['images'] != null ? List<String>.from(jsonDecode(json['images'])) : [],
      lat: json['lat']?.toDouble(),
      lng: json['lng']?.toDouble(),
      updatedAt:
          json['updatedat'] != null ? DateTime.parse(json['updatedat']) : null,
      createdAt: DateTime.parse(json['createdat']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'images': images,
        'lat': lat,
        'lng': lng,
      };
}
