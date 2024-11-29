// add_post_state.dart

abstract class AddPostState {
  final String? selectedDistrict;
  final String? selectedShift;

  AddPostState({this.selectedDistrict, this.selectedShift});
}

class AddPostInitial extends AddPostState {
  AddPostInitial({String? selectedDistrict, String? selectedShift})
      : super(selectedDistrict: selectedDistrict, selectedShift: selectedShift);
}

class AddPostLoading extends AddPostState {}

class AddPostSuccess extends AddPostState {}

class AddPostFailure extends AddPostState {
  final String error;
  AddPostFailure({required this.error});
}
