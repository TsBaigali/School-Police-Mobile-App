import '../../models/ad.dart';

abstract class AddPostState {
  final String? selectedDistrict;
  final String? selectedShift;
  final String? selectedSchool;

  // Dynamic list of school options
  final List<String> availableSchools;

  AddPostState({
    this.selectedDistrict,
    this.selectedShift,
    this.selectedSchool,
    required this.availableSchools,
  });
}

class AddPostInitial extends AddPostState {
  AddPostInitial({
    String? selectedDistrict,
    String? selectedShift,
    String? selectedSchool,
    required List<String> availableSchools,
  }) : super(
    selectedDistrict: selectedDistrict,
    selectedShift: selectedShift,
    selectedSchool: selectedSchool,
    availableSchools: availableSchools,
  );
}

class AddPostLoading extends AddPostState {
  AddPostLoading() : super(availableSchools: []);
}

class AddPostSuccess extends AddPostState {
  final Ad ad;

  AddPostSuccess(this.ad) : super(availableSchools: []);
}

class AddPostFailure extends AddPostState {
  final String error;

  AddPostFailure({required this.error}) : super(availableSchools: []);
}
