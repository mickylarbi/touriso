import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Client extends Equatable {
  String id;
  String firstName;
  String otherNames;
  String email;
  String? pictureUrl;

  Client(
      {this.id = '',
      required this.firstName,
      required this.otherNames,
      required this.email,
      this.pictureUrl});

  Client.fromFirebase(Map<String, dynamic> map, String clientId)
      : id = clientId,
        firstName = map['firstName'],
        otherNames = map['otherNames'],
        email = map['email'],
        pictureUrl = map['pictureUrl'];

  Map<String, dynamic> toFirebase() => {
        'firstName': firstName,
        'otherNames': otherNames,
        'email': email,
        'pictureUrl': pictureUrl,
      };

  String get name => '$firstName $otherNames';
  
  @override
  List<Object?> get props => [id, firstName, otherNames, email, pictureUrl];
}
