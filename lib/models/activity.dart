import 'package:equatable/equatable.dart';
import 'package:touriso/models/cduration.dart';

// ignore: must_be_immutable
class Activity extends Equatable {
  String id;
  String siteId;
  String name;
  CDuration duration;
  num price;
  String? location;
  String description;
  List<String> imageUrls;
  Map<String, dynamic> workingHours;

  Activity(
      {required this.id,
      required this.siteId,
      required this.name,
      required this.duration,
      required this.price,
      this.location,
      required this.description,
      required this.imageUrls,
      this.workingHours = const {'all day': true}});

  Activity.empty(
      {this.id = '',
      this.siteId = '',
      required this.name,
      required this.duration,
      required this.price,
      required this.location,
      required this.description,
      this.imageUrls = const [],
      this.workingHours = const {'all day': true}});

  Activity.fromFirebase(Map<String, dynamic> map, String activityId)
      : id = activityId,
        siteId = map['siteId'],
        name = map['name'],
        duration = CDuration.fromFirebase(map['duration'] as List),
        price = map['price'],
        location = map['location'],
        description = map['description'],
        imageUrls = map['imageUrls'] == null
            ? []
            : (map['imageUrls'] as List).map((e) => e.toString()).toList(),
        workingHours = map['workingHours'] ?? {'all day': true};

  Map<String, dynamic> toFirebase() => {
        'siteId': siteId,
        'name': name,
        'duration': duration.toFirebase(),
        'price': price,
        'location': location,
        'description': description,
        'imageUrls': imageUrls,
        'workingHours': workingHours,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        duration,
        price,
        location,
        description,
        workingHours,
      ];
}
