import 'package:flutter_bloc/flutter_bloc.dart';
import 'time_record_event.dart';
import 'time_record_state.dart';

class TimeRecordBloc extends Bloc<TimeRecordEvent, TimeRecordState> {
  TimeRecordBloc() : super(const TimeRecordState()) {
    on<ArriveEvent>((event, emit) {
      emit(state.copyWith(isArrived: true, statusMessage: "Arrival confirmed"));
    });
    on<DepartEvent>((event, emit) {
      emit(state.copyWith(isDeparted: true, statusMessage: "Departure confirmed"));
    });
  }
}
