import 'package:flutter_bloc/flutter_bloc.dart';
import 'ad_description_event.dart';
import 'ad_description_state.dart';

class AdDescriptionBloc extends Bloc<AdDescriptionEvent, AdDescriptionState> {
  AdDescriptionBloc() : super(AdDescriptionInitial()) {
    on<SubmitJobRequest>((event, emit) async {
      emit(JobRequestLoading());
      try {
        // Simulate sending a job request notification
        await sendJobRequestNotification(event.adId);
        emit(JobRequestSuccess());
      } catch (e) {
        emit(JobRequestError("Failed to send job request"));
      }
    });
  }

  Future<void> sendJobRequestNotification(String adId) async {
    // Simulate sending a notification, replace with actual implementation
    await Future.delayed(Duration(seconds: 2));
  }
}
