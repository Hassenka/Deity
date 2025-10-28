part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String phoneNumber;
  final String password;
  final bool rememberMe;

  const LoginRequested({
    required this.phoneNumber,
    required this.password,
    required this.rememberMe,
  });

  @override
  List<Object> get props => [phoneNumber, password, rememberMe];
}
