import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class CDuration extends Equatable {
  num value;
  String unit;

  CDuration(this.value, this.unit);

  CDuration.fromFirebase(List list)
      : value = list[0],
        unit = list[1];

  List toFirebase() => [value, unit];

  @override
  List<Object?> get props => [value, unit];

  @override
  String toString() => '$value $unit';
}
