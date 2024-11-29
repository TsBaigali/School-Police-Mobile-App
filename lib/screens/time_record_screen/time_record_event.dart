import 'package:equatable/equatable.dart';

abstract class TimeRecordEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ArriveEvent extends TimeRecordEvent {}

class DepartEvent extends TimeRecordEvent {}
