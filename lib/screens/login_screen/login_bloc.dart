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

    final token =
        await authService.authenticateUser(event.username, event.password);

    if (token != null) {
      emit(LoginSuccess(token: token));
    } else {
      emit(LoginFailure(message: 'Нэвтрэх нэр эсвэл нууц үг буруу байна'));
    }
  }

  void _onTogglePasswordVisibility(
      TogglePasswordVisibility event, Emitter<LoginState> emit) {
    obscurePassword = !event.obscurePassword;
    emit(ObscurePasswordState(obscurePassword: obscurePassword));
  }
}
