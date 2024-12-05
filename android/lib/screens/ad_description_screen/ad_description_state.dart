import 'package:equatable/equatable.dart';

abstract class AdDescriptionState extends Equatable {
  const AdDescriptionState();

  @override
  List<Object> get props => [];
}

class AdDescriptionInitial extends AdDescriptionState {}

class JobRequestLoading extends AdDescriptionState {}

class JobRequestSuccess extends AdDescriptionState {}

class JobRequestError extends AdDescriptionState {
  final String message;

  const JobRequestError(this.message);

  @override
  List<Object> get props => [message];
}
