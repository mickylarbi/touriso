import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Site extends Equatable {
  late String id;
  late String companyId;
  late String name;
  late String location;
  late GeoPoint geoLocation;
  late String description;
  List<String> imageUrls;

  Site({
    required this.id,
    required this.companyId,
    required this.name,
    required this.location,
    required this.geoLocation,
    required this.description,
    required this.imageUrls,
  });

  Site.empty({
    this.id = '',
    required this.companyId,
    required this.name,
    required this.location,
    required this.geoLocation,
    required this.description,
    this.imageUrls = const [],
  });

  Site.fromFirebase(Map<String, dynamic> map, String siteId)
      : id = siteId,
        companyId = map['companyId'],
        name = map['name'],
        location = map['location'],
        geoLocation = map['geoLocation'],
        description = map['description'],
        imageUrls = map['imageUrls'] == null
            ? []
            : (map['imageUrls'] as List).map((e) => e.toString()).toList();

  Map<String, dynamic> toFirebase() => {
        'companyId': companyId,
        'name': name,
        'location': location,
        'geoLocation': geoLocation,
        'description': description,
        'imageUrls': imageUrls,
      };

  // Site.fromJson(String json) {
  //   Map<String, dynamic> map = jsonDecode(json);
  //   id = map['id'] as String;
  //   companyId = map['companyId'] as String;
  //   name = map['name'];
  //   location = map['location'];
  //   geoLocation = map['geoLocation'];
  //   description = map['description'];
  //   imageUrls = map
  // }

  // String toJson() => jsonEncode({
  //       'id': id,
  //       'companyId': companyId,
  //       'name': name,
  //       'location': location,
  //       'geoLocation': geoLocation,
  //       'description': description,
  //     });

  @override
  List<Object?> get props => [
        id,
        name,
        location,
        geoLocation,
        description,
        imageUrls,
      ];
}
