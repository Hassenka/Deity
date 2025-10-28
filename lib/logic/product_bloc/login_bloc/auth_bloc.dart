import 'package:bloc/bloc.dart';
import 'package:diety/data/repositories/api_service.dart';
import 'package:diety/presentation/widgets/session_manager.dart';
import 'package:diety/data/models/user_model.dart'; 
import 'package:equatable/equatable.dart';

part 'auth_event.dart'; 
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService _apiService = ApiService();
  final SessionManager _sessionManager = SessionManager();

  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await _apiService.login(
          event.phoneNumber,
          event.password,
        );
        final user = User.fromJson(response['user']);
        final token = response['token'];

        // Save the session token and user data
        await _sessionManager.saveSession(token, user);

        // Save or clear credentials based on the "Remember Me" checkbox
        if (event.rememberMe) {
          await _sessionManager.saveCredentials(
            event.phoneNumber,
            event.password,
          );
        } else {
          await _sessionManager.clearCredentials();
        }

        emit(AuthSuccess(user: user));
      } catch (e) {
        emit(AuthFailure(error: e.toString().replaceFirst('Exception: ', '')));
      }
    });
  }
}
