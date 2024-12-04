import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'add_post_event.dart';
import 'add_post_state.dart';
import '../../models/ad.dart';

class AddPostBloc extends Bloc<AddPostEvent, AddPostState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;

  AddPostBloc() : super(AddPostInitial()) {
    on<DistrictChanged>((event, emit) {
      emit(AddPostInitial(selectedDistrict: event.district, selectedShift: state.selectedShift));
    });

    on<ShiftChanged>((event, emit) {
      emit(AddPostInitial(selectedDistrict: state.selectedDistrict, selectedShift: event.shift));
    });

    on<SubmitPostEvent>((event, emit) async {
      emit(AddPostLoading());
      try {
        // Get the current user's UID
        final user = _firebaseAuth.currentUser;
        if (user == null) {
          throw Exception("User not authenticated");
        }

        // Prepare ad data, including all fields in the Ad model
        final adData = {
          'school': event.school,
          'profilePic': user.photoURL ?? '', // Use user's profile picture if available
          'address': event.district, // Stored as 'address' in Firestore
          'additionalInfo': event.additionalInfo,
          'shift': event.shift,
          'date': DateTime.now().toIso8601String(),
          'phoneNumber': user.phoneNumber ?? '', // Use user's phone number if available
          'views': 0, // Default to 0 for a new post
          'requestCount': 0, // Default to 0 for a new post
          'price': int.tryParse(event.salary) ?? 0, // Ensure price is a number
          'ownerId': user.uid, // Set the owner ID
          'status': 'open', // Default status for a new post
        };

        // Add the ad to Firestore
        final docRef = await _firestore.collection('ad').add(adData);

        // Create an Ad object for emitting to other parts of the app
        final newAd = Ad.fromMap(adData, docRef.id);

        emit(AddPostSuccess(newAd));
      } catch (e) {
        emit(AddPostFailure(error: e.toString()));
      }
    });
  }
}
