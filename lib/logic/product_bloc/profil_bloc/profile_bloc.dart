import 'package:bloc/bloc.dart';
import 'package:diety/data/repositories/api_service.dart';
import 'dart:io';
import 'package:diety/presentation/widgets/session_manager.dart';
import 'package:diety/data/models/user_model.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final SessionManager _sessionManager = SessionManager();
  final ApiService _apiService = ApiService();

  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileLoadRequested>(_onProfileLoadRequested);
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
    on<ProfileImageUpdateRequested>(_onProfileImageUpdateRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onProfileLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoadInProgress());
    final user = await _sessionManager.getUser();
    if (user != null) {
      emit(ProfileLoadSuccess(user));
    } else {
      emit(ProfileLoadFailure());
    }
  }

  Future<void> _onProfileUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    // Ensure we only update if we have user data available
    if (state is ProfileLoadSuccess || state is ProfileUpdateFailure) {
      final currentUser = (state as dynamic).user;

      emit(ProfileUpdateInProgress(currentUser));
      try {
        final response = await _apiService.editUser(
          name: event.name,
          phoneNumber: event.phoneNumber,
        );
        // The 'response' from editUser is already the user map.
        // We can parse it directly.
        final updatedUser = User.fromJson(response);
        await _sessionManager.saveSession(
          (await _sessionManager.getToken())!,
          updatedUser,
        );
        // Transition to a success state, then immediately to the loaded state with new data.
        emit(ProfileUpdateSuccess(updatedUser));
        emit(
          ProfileLoadSuccess(updatedUser),
        ); // Then update the UI with the new user
      } catch (e) {
        emit(
          ProfileUpdateFailure(
            currentUser,
            e.toString().replaceFirst('Exception: ', ''),
          ),
        );
      }
    } else {
      // This case should ideally not be reached if the UI disables buttons correctly.
      emit(ProfileLoadFailure()); // Or a more specific error state
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<ProfileState> emit,
  ) async {
    await _sessionManager.logout();
    emit(ProfileLogoutSuccess());
  }

  Future<void> _onProfileImageUpdateRequested(
    ProfileImageUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    // Handle image update from either a success or failure state, as long as we have user data.
    if (state is ProfileLoadSuccess || state is ProfileUpdateFailure) {
      final user = (state as dynamic).user;

      emit(ProfileUpdateInProgress(user)); // Show loading indicator
      try {
        final updatedUser = await _apiService.uploadImage(
          imageFile: event.imageFile,
        );
        await _sessionManager.saveSession(
          (await _sessionManager.getToken())!,
          updatedUser,
        );
        emit(ProfileUpdateSuccess(updatedUser));
        emit(
          ProfileLoadSuccess(updatedUser),
        ); // Then update the UI with the new user
      } catch (e) {
        emit(
          ProfileUpdateFailure(
            user,
            e.toString().replaceFirst('Exception: ', ''),
          ),
        );
      }
    }
  }
}
