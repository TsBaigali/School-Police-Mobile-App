import 'package:flutter_bloc/flutter_bloc.dart';
import 'school_police_home_event.dart';
import 'school_police_home_state.dart';
import '../../models/user_model.dart';

class SchoolPoliceBloc extends Bloc<SchoolPoliceEvent, SchoolPoliceState> {
  final List<User> schoolPoliceList = [
    User(
      username: 'admin',
      firstName: 'Batla',
      lastName: 'Lhagva',
      password: '123',
      email: 'batlhagva15@gmail.com',
      phoneNumber: 80553609,
      role: UserRole.schoolPolice,
      assignedSchools: ['5-р сургууль', '10-р сургууль'],
    ),
    User(
      username: 'police2',
      firstName: 'Temuujin',
      lastName: 'Dorj',
      password: 'pass123',
      email: 'temuujin@example.com',
      phoneNumber: 90123456,
      role: UserRole.schoolPolice,
      assignedSchools: ['5-р сургууль', '24-р сургууль'],
    ),
    User(
      username: 'police3',
      firstName: 'Narangerel',
      lastName: 'Bold',
      password: 'password',
      email: 'narangerel@example.com',
      phoneNumber: 91234567,
      role: UserRole.schoolPolice,
      assignedSchools: ['24-р сургууль'],
    ),
  ];

  SchoolPoliceBloc() : super(SchoolPoliceLoading()) {
    on<LoadSchoolPolice>(_onLoadSchoolPolice);
  }

  void _onLoadSchoolPolice(LoadSchoolPolice event, Emitter<SchoolPoliceState> emit) {
    try {
      // Filter the list based on the parent’s school
      final filteredSchoolPolice = schoolPoliceList.where((police) {
        return police.assignedSchools?.contains(event.parentSchool) ?? false;
      }).toList();

      emit(SchoolPoliceLoaded(filteredSchoolPolice));
    } catch (e) {
      emit(SchoolPoliceError('Failed to load school police data.'));
    }
  }
}
