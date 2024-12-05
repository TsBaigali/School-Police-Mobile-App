class Ad {
  final String id;
  final String school;
  final String profilePic;
  final String district;
  final String additionalInfo;
  final String shift;
  final String date;
  final String phoneNumber; // Add if required
  final int views;
  final int requestCount;
  final int price;
  final String ownerId; // New field added

  Ad({
    required this.id,
    required this.school,
    required this.profilePic,
    required this.district,
    required this.additionalInfo,
    required this.shift,
    required this.date,
    required this.phoneNumber,
    required this.views,
    required this.requestCount,
    required this.price,
    required this.ownerId, // Include in the constructor
  });

  // Factory method for converting Firestore data to an Ad object
  factory Ad.fromMap(Map<String, dynamic> map, String id) {
    return Ad(
      id: id,
      school: map['school'] ?? '',
      profilePic: map['profilePic'] ?? '',
      district: map['address'] ?? '',
      additionalInfo: map['additionalInfo'] ?? '',
      shift: map['shift'] ?? '',
      date: map['date'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      views: map['views'] ?? 0,
      requestCount: map['requestCount'] ?? 0,
      price: map['price'] ?? 0,
      ownerId: map['ownerId'] ?? '', // Fetch ownerId from the map
    );
  }

  // Converts an Ad object to a map for Firestore or debugging
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'school': school,
      'profilePic': profilePic,
      'address': district,
      'additionalInfo': additionalInfo,
      'shift': shift,
      'date': date,
      'phoneNumber': phoneNumber,
      'views': views,
      'requestCount': requestCount,
      'price': price,
      'ownerId': ownerId, // Include ownerId in the map
    };
  }
}
