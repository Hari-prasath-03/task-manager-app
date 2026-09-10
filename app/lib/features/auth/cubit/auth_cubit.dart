import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/services/sp_service.dart';
import 'package:task_manager/features/auth/repository/auth_remote_repository.dart';
import 'package:task_manager/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SPService _spService = SPService();
  final AuthRemoteRepository _authRemoteRepository = AuthRemoteRepository();

  AuthCubit() : super(AuthInitial());

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());

      await _authRemoteRepository.signIn(
        name: name,
        email: email,
        password: password,
      );

      emit(AuthSignedUp());
    } catch (e) {
      emit(AuthError(error: e.toString()));
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      emit(AuthLoading());

      final user = await _authRemoteRepository.login(
        email: email,
        password: password,
      );

      if (user.token.isNotEmpty) {
        await _spService.setToken(user.token);
      }

      emit(AuthLoggedIn(user: user));
    } catch (e) {
      emit(AuthError(error: e.toString()));
    }
  }

  Future<void> getUserData() async {
    try {
      emit(AuthLoading());
      final user = await _authRemoteRepository.getUserData();

      if (user != null) {
        emit(AuthLoggedIn(user: user));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthError(error: e.toString()));
    }
  }
}
