import 'package:cloud_firestore/cloud_firestore.dart';

abstract class NotificationState {}

class NotificationLoadingState extends NotificationState {}

class NotificationLoadedState extends NotificationState {
  final Stream<QuerySnapshot> pendingRequestsStream;
  final Stream<QuerySnapshot> acceptedRequestsStream;

  NotificationLoadedState(this.pendingRequestsStream, this.acceptedRequestsStream);
}

class NotificationErrorState extends NotificationState {
  final String error;

  NotificationErrorState(this.error);
}
