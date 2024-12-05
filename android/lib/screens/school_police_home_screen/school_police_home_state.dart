import 'package:equatable/equatable.dart';
import 'package:school_police/models/user_model.dart';

abstract class SchoolPoliceState extends Equatable {
  const SchoolPoliceState();

  @override
  List<Object?> get props => [];
}

// Initial loading state
class SchoolPoliceLoading extends SchoolPoliceState {}

// State when school police data is successfully loaded
class SchoolPoliceLoaded extends SchoolPoliceState {
  final List<User> schoolPolice;

  const SchoolPoliceLoaded(this.schoolPolice);

  @override
  List<Object?> get props => [schoolPolice];
}

// Error state
class SchoolPoliceError extends SchoolPoliceState {
  final String message;

  const SchoolPoliceError(this.message);

  @override
  List<Object?> get props => [message];
}
