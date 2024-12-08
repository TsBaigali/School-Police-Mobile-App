import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class NotificationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadNotificationsEvent extends NotificationEvent {}

// States
abstract class NotificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotificationLoadingState extends NotificationState {}

class NotificationLoadedState extends NotificationState {
  final Stream<QuerySnapshot> pendingRequestsStream;
  final Stream<QuerySnapshot> acceptedRequestsStream;

  NotificationLoadedState(this.pendingRequestsStream, this.acceptedRequestsStream);

  @override
  List<Object?> get props => [pendingRequestsStream, acceptedRequestsStream];
}

class NotificationErrorState extends NotificationState {
  final String error;

  NotificationErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

// Bloc
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  NotificationBloc(this.firestore, this.auth) : super(NotificationLoadingState()) {
    on<LoadNotificationsEvent>(_onLoadNotifications);
  }

  Future<void> _onLoadNotifications(
      LoadNotificationsEvent event,
      Emitter<NotificationState> emit,
      ) async {
    emit(NotificationLoadingState());
    try {
      final currentUserId = auth.currentUser!.uid;

      // Get Ad IDs owned by the current user
      final userAdIds = await _getUserAdIds(currentUserId);

      // Handle empty Ad IDs for pending requests
      Stream<QuerySnapshot> pendingRequestsStream;
      if (userAdIds.isNotEmpty) {
        pendingRequestsStream = firestore
            .collection('requests')
            .where('status', isEqualTo: 'pending')
            .where('adId', whereIn: userAdIds)
            .snapshots();
      } else {
        // Provide an empty stream if no Ad IDs
        pendingRequestsStream = const Stream.empty();
      }

      // Accepted requests: worker's accepted notifications
      final acceptedRequestsStream = firestore
          .collection('requests')
          .where('workerId', isEqualTo: currentUserId)
          .where('status', isEqualTo: 'accepted')
          .snapshots();

      emit(NotificationLoadedState(pendingRequestsStream, acceptedRequestsStream));
    } catch (e) {
      emit(NotificationErrorState('Error loading notifications: $e'));
    }
  }

  // Helper function to fetch Ad IDs owned by the current user
  Future<List<String>> _getUserAdIds(String userId) async {
    final adDocs = await firestore.collection('ad').where('ownerId', isEqualTo: userId).get();
    return adDocs.docs.map((doc) => doc.id).toList();
  }
}
