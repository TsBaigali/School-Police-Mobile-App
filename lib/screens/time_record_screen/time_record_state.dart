import 'package:equatable/equatable.dart';

class TimeRecordState extends Equatable {
  final bool isArrived;
  final bool isDeparted;
  final String statusMessage;

  const TimeRecordState({
    this.isArrived = false,
    this.isDeparted = false,
    this.statusMessage = "Not Checked",
  });

  TimeRecordState copyWith({
    bool? isArrived,
    bool? isDeparted,
    String? statusMessage,
  }) {
    return TimeRecordState(
      isArrived: isArrived ?? this.isArrived,
      isDeparted: isDeparted ?? this.isDeparted,
      statusMessage: statusMessage ?? this.statusMessage,
    );
  }

  @override
  List<Object?> get props => [isArrived, isDeparted, statusMessage];
}
