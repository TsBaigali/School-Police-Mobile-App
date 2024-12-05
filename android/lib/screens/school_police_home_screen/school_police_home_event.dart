import 'package:equatable/equatable.dart';

abstract class SchoolPoliceEvent extends Equatable {
  const SchoolPoliceEvent();

  @override
  List<Object> get props => [];
}

// Event to load school police based on the parent’s school
class LoadSchoolPolice extends SchoolPoliceEvent {
  final String parentSchool;

  const LoadSchoolPolice(this.parentSchool);

  @override
  List<Object> get props => [parentSchool];
}
