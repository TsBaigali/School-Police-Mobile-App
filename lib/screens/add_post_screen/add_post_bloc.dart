// add_post_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_post_event.dart';
import 'add_post_state.dart';

class AddPostBloc extends Bloc<AddPostEvent, AddPostState> {
  AddPostBloc() : super(AddPostInitial()) {
    // Handle district changes
    on<DistrictChanged>((event, emit) {
      // If the current state is AddPostInitial, keep the other properties
      final currentState = state as AddPostInitial;
      emit(AddPostInitial(
        selectedDistrict: event.district,
        selectedShift: currentState.selectedShift,
      ));
    });

    // Handle shift changes
    on<ShiftChanged>((event, emit) {
      final currentState = state as AddPostInitial;
      emit(AddPostInitial(
        selectedDistrict: currentState.selectedDistrict,
        selectedShift: event.shift,
      ));
    });

    // Handle post submission
    on<SubmitPostEvent>((event, emit) async {
      emit(AddPostLoading());

      // Simulate a network request or database operation
      await Future.delayed(Duration(seconds: 1));

      // Here, you could add conditions to emit AddPostFailure if there’s an error
      emit(AddPostSuccess());
    });
  }
}
