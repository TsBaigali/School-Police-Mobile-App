abstract class AddPostEvent {}

class DistrictChanged extends AddPostEvent {
  final String district;
  DistrictChanged(this.district);
}

class ShiftChanged extends AddPostEvent {
  final String shift;
  ShiftChanged(this.shift);
}

class SubmitPostEvent extends AddPostEvent {
  final String school;
  final String district;
  final String shift;
  final String salary;
  final String additionalInfo;

  SubmitPostEvent({
    required this.school,
    required this.district,
    required this.shift,
    required this.salary,
    required this.additionalInfo,
  });
}
