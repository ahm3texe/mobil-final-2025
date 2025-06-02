// lib/models/hotel.dart

class Hotel {
  final String id;
  final String name;
  final String location;
  final double pricePerNight;
  final String roomType;
  final int starRating;
  final double reviewScore;
  final bool hasPool;
  final bool breakfastIncluded;
  final bool freeWifi;
  final bool petFriendly;
  final String imageUrl; // Yeni alan

  Hotel({
    required this.id,
    required this.name,
    required this.location,
    required this.pricePerNight,
    required this.roomType,
    required this.starRating,
    required this.reviewScore,
    required this.hasPool,
    required this.breakfastIncluded,
    required this.freeWifi,
    required this.petFriendly,
    required this.imageUrl,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      pricePerNight: (json['pricePerNight'] as num).toDouble(),
      roomType: json['roomType'] as String,
      starRating: json['starRating'] as int,
      reviewScore: (json['reviewScore'] as num).toDouble(),
      hasPool: json['hasPool'] as bool,
      breakfastIncluded: json['breakfastIncluded'] as bool,
      freeWifi: json['freeWifi'] as bool,
      petFriendly: json['petFriendly'] as bool,
      imageUrl: json['imageUrl'] as String,
    );
  }
}
