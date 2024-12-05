import 'package:equatable/equatable.dart';

abstract class AdDescriptionEvent extends Equatable {
  const AdDescriptionEvent();

  @override
  List<Object> get props => [];
}

class SubmitJobRequest extends AdDescriptionEvent {
  final String adId;

  const SubmitJobRequest(this.adId);

  @override
  List<Object> get props => [adId];
}
class LaunchPhone extends AdDescriptionEvent {
  final String adId;

  const LaunchPhone(this.adId);

  @override
  List<Object> get props => [adId];
}