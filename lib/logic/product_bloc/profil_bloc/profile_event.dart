part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileLoadRequested extends ProfileEvent {}

class ProfileUpdateRequested extends ProfileEvent {
  final String name;
  final String phoneNumber;

  const ProfileUpdateRequested({required this.name, required this.phoneNumber});

  @override
  List<Object> get props => [name, phoneNumber];
}

class ProfileImageUpdateRequested extends ProfileEvent {
  final File imageFile;

  const ProfileImageUpdateRequested({required this.imageFile});

  @override
  List<Object> get props => [imageFile];
}

class LogoutRequested extends ProfileEvent {}
