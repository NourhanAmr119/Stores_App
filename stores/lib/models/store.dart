class Store {
  final int id;
  final String name;
  final double latitude;
  final double longitude;

  Store({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory Store.fromMap(Map<String, dynamic> json) {
    return Store(
      id: json['id'] as int,
      name: json['name'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}