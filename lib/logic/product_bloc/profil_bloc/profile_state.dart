part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoadInProgress extends ProfileState {}

class ProfileLoadSuccess extends ProfileState {
  final User user;
  const ProfileLoadSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileLoadFailure extends ProfileState {}

class ProfileUpdateInProgress extends ProfileState {
  final User user;
  const ProfileUpdateInProgress(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileUpdateSuccess extends ProfileState {
  final User user;
  const ProfileUpdateSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileUpdateFailure extends ProfileState {
  final User user;
  final String error;
  const ProfileUpdateFailure(this.user, this.error);

  @override
  List<Object?> get props => [user, error];
}

class ProfileLogoutSuccess extends ProfileState {}
