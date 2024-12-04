import 'package:equatable/equatable.dart';

abstract class AddPostEvent extends Equatable {
  const AddPostEvent();

  @override
  List<Object?> get props => [];
}

class DistrictChanged extends AddPostEvent {
  final String district;

  const DistrictChanged(this.district);

  @override
  List<Object?> get props => [district];
}

class ShiftChanged extends AddPostEvent {
  final String shift;

  const ShiftChanged(this.shift);

  @override
  List<Object?> get props => [shift];
}

class SubmitPostEvent extends AddPostEvent {
  final String school;
  final String district;
  final String shift;
  final String salary;
  final String additionalInfo;

  const SubmitPostEvent({
    required this.school,
    required this.district,
    required this.shift,
    required this.salary,
    required this.additionalInfo,
  });

  @override
  List<Object?> get props => [school, district, shift, salary, additionalInfo];
}
