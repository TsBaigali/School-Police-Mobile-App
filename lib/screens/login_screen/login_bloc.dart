import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_police/services/auth_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService authService;
  bool obscurePassword = true;

  LoginBloc(this.authService) : super(LoginInitial()) {
    on<Check>(_onCheck);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
  }

  Future<void> _onCheck(Check event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      final userId =
      await authService.loginWithEmailAndPassword(event.username, event.password);

      if (userId != null) {
        emit(LoginSuccess(token: userId));
      } else {
        emit(LoginFailure(message: 'Нэвтрэх нэр эсвэл нууц үг буруу байна'));
      }
    } catch (error) {
      emit(LoginFailure(message: 'Алдаа гарлаа: ${error.toString()}'));
    }
  }

  void _onTogglePasswordVisibility(
      TogglePasswordVisibility event, Emitter<LoginState> emit) {
    obscurePassword = !event.obscurePassword;
    emit(ObscurePasswordState(obscurePassword: obscurePassword));
  }
}
