import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'add_post_event.dart';
import 'add_post_state.dart';
import '../../models/ad.dart';
import '../../models/school.dart';

class AddPostBloc extends Bloc<AddPostEvent, AddPostState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;

  // Predefined list of schools with names and positions
  final List<School> _schools = [
    // Баянгол
    School(name: '20 дугаар сургууль', latitude: 47.9132824175524, longitude: 106.8816681590401),
    School(name: '47 дугаар сургууль', latitude: 47.91834, longitude: 106.9071),
    School(name: '73 дугаар сургууль', latitude: 47.92056, longitude: 106.9092),
    School(name: '93 дугаар сургууль', latitude: 47.92345, longitude: 106.9108),
    School(name: '"Оюунлаг" бүрэн дунд сургууль', latitude: 47.92678, longitude: 106.9119),
    School(name: '"Шинэ-Үе" бүрэн дунд сургууль', latitude: 47.92678, longitude: 106.9120),

    // Баянзүрх
    School(name: '14 дүгээр сургууль', latitude: 47.92223, longitude: 106.9064),
    School(name: '33 дугаар сургууль', latitude: 47.91934, longitude: 106.9079),
    School(name: '44 дүгээр сургууль', latitude: 47.92156, longitude: 106.9082),
    School(name: '48 дугаар сургууль', latitude: 47.92445, longitude: 106.9118),
    School(name: '"Шинэ Монгол" бүрэн дунд сургууль', latitude: 47.92778, longitude: 106.9129),
    School(name: '"Орчлон" бүрэн дунд сургууль', latitude: 47.92878, longitude: 106.9140),

    // Сүхбаатар
    School(name: '1 дүгээр сургууль', latitude: 47.92023, longitude: 106.9044),
    School(name: '2 дугаар сургууль', latitude: 47.91734, longitude: 106.9059),
    School(name: '31 дүгээр сургууль', latitude: 47.91956, longitude: 106.9062),
    School(name: '45 дугаар сургууль', latitude: 47.92245, longitude: 106.9088),
    School(name: '"Эрдмийн далай" цогцолбор сургууль', latitude: 47.92578, longitude: 106.9109),
    School(name: '"Элит" олон улсын бүрэн дунд сургууль', latitude: 47.92678, longitude: 106.9120),

    // Чингэлтэй
    School(name: '5 дугаар сургууль', latitude: 47.92123, longitude: 106.9054),
    School(name: '17 дугаар сургууль', latitude: 47.91834, longitude: 106.9071),
    School(name: '24 дүгээр сургууль', latitude: 47.92056, longitude: 106.9092),
    School(name: '50 дугаар сургууль', latitude: 47.92345, longitude: 106.9108),
    School(name: '"Гёте" сургууль', latitude: 47.92678, longitude: 106.9119),
    School(name: '"Сакура" бүрэн дунд сургууль', latitude: 47.92678, longitude: 106.9120),

    // Хан-Уул
    School(name: '18 дугаар сургууль', latitude: 47.92123, longitude: 106.9054),
    School(name: '32 дугаар сургууль', latitude: 47.91834, longitude: 106.9071),
    School(name: '34 дүгээр сургууль', latitude: 47.92056, longitude: 106.9092),
    School(name: '41 дүгээр сургууль', latitude: 47.92345, longitude: 106.9108),
    School(name: '"Эмпати" сургууль', latitude: 47.92678, longitude: 106.9119),
    School(name: '"Шинэ Монгол Харүмафүжи" сургууль', latitude: 47.92678, longitude: 106.9120),

    // Сонгинохайрхан
    School(name: '62 дугаар сургууль', latitude: 47.92123, longitude: 106.9054),
    School(name: '65 дугаар сургууль', latitude: 47.91834, longitude: 106.9071),
    School(name: '105 дугаар сургууль', latitude: 47.92056, longitude: 106.9092),
    School(name: '107 дугаар сургууль', latitude: 47.92345, longitude: 106.9108),
    School(name: '"Зуун билэг" бүрэн дунд сургууль', latitude: 47.92678, longitude: 106.9119),
    School(name: '"Номт наран" бүрэн дунд сургууль', latitude: 47.92678, longitude: 106.9120),
  ];


  AddPostBloc()
      : super(AddPostInitial(
    selectedDistrict: null,
    selectedShift: null,
    selectedSchool: null,
    availableSchools: [],
  )) {
    on<DistrictChanged>((event, emit) {
      // Filter schools based on the selected district
      final filteredSchools = _schools.where((school) {
        if (event.district == 'Сүхбаатар') {
          return school.name == '1 дүгээр сургууль' ||
              school.name == '2 дугаар сургууль' ||
              school.name == '31 дүгээр сургууль' ||
              school.name == '45 дугаар сургууль' ||
              school.name == '"Эрдмийн далай" цогцолбор сургууль' ||
              school.name == '"Элит" олон улсын бүрэн дунд сургууль';
        } else if (event.district == 'Баянгол') {
          return school.name == '20 дугаар сургууль' ||
              school.name == '47 дугаар сургууль' ||
              school.name == '73 дугаар сургууль' ||
              school.name == '93 дугаар сургууль' ||
              school.name == '"Оюунлаг" бүрэн дунд сургууль' ||
              school.name == '"Шинэ-Үе" бүрэн дунд сургууль';
        } else if (event.district == 'Баянзүрх') {
          return school.name == '14 дүгээр сургууль' ||
              school.name == '33 дугаар сургууль' ||
              school.name == '44 дүгээр сургууль' ||
              school.name == '48 дугаар сургууль' ||
              school.name == '"Шинэ Монгол" бүрэн дунд сургууль' ||
              school.name == '"Орчлон" бүрэн дунд сургууль';
        } else if (event.district == 'Чингэлтэй') {
          return school.name == '5 дугаар сургууль' ||
              school.name == '17 дугаар сургууль' ||
              school.name == '24 дүгээр сургууль' ||
              school.name == '50 дугаар сургууль' ||
              school.name == '"Гёте" сургууль' ||
              school.name == '"Сакура" бүрэн дунд сургууль';
        } else if (event.district == 'Хан-Уул') {
          return school.name == '18 дугаар сургууль' ||
              school.name == '32 дугаар сургууль' ||
              school.name == '34 дүгээр сургууль' ||
              school.name == '41 дүгээр сургууль' ||
              school.name == '"Эмпати" сургууль' ||
              school.name == '"Шинэ Монгол Харүмафүжи" сургууль';
        } else if (event.district == 'Сонгинохайрхан') {
          return school.name == '62 дугаар сургууль' ||
              school.name == '65 дугаар сургууль' ||
              school.name == '105 дугаар сургууль' ||
              school.name == '107 дугаар сургууль' ||
              school.name == '"Зуун билэг" бүрэн дунд сургууль' ||
              school.name == '"Номт наран" бүрэн дунд сургууль';
        } else {
          return false; // No schools available for other districts
        }
      }).map((school) => school.name).toList();

    emit(AddPostInitial(
        selectedDistrict: event.district,
        selectedShift: state.selectedShift,
        selectedSchool: null, // Reset selected school
        availableSchools: filteredSchools, // Filtered schools based on district
      ));
    });

    on<ShiftChanged>((event, emit) {
      emit(AddPostInitial(
        selectedDistrict: state.selectedDistrict,
        selectedShift: event.shift,
        selectedSchool: state.selectedSchool,
        availableSchools: state.availableSchools,
      ));
    });

    on<SchoolChanged>((event, emit) {
      emit(AddPostInitial(
        selectedDistrict: state.selectedDistrict,
        selectedShift: state.selectedShift,
        selectedSchool: event.selectedSchool,
        availableSchools: state.availableSchools,
      ));
    });

    on<SubmitPostEvent>((event, emit) async {
      emit(AddPostLoading());
      try {
        // Get the current user's UID
        final user = _firebaseAuth.currentUser;
        if (user == null) {
          throw Exception("User not authenticated");
        }

        // Find the selected school object
        final selectedSchool = _schools.firstWhere(
              (school) => school.name == event.school,
          orElse: () => throw Exception("Invalid school selected"),
        );

        // Prepare ad data
        final adData = {
          'school': selectedSchool.name,
          'latitude': selectedSchool.latitude,
          'longitude': selectedSchool.longitude,
          'profilePic': user.photoURL ?? '',
          'address': event.district,
          'additionalInfo': event.additionalInfo,
          'shift': event.shift,
          'date': DateTime.now().toIso8601String(),
          'phoneNumber': user.phoneNumber ?? '',
          'views': 0,
          'requestCount': 0,
          'price': int.tryParse(event.salary) ?? 0,
          'ownerId': user.uid,
          'status': 'open',
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
