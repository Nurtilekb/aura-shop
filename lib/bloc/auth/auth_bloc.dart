import 'package:aurashop/bloc/auth/auth_event.dart';
import 'package:aurashop/bloc/auth/auth_state.dart';
import 'package:aurashop/repositories/auth_repository.dart';
import 'package:aurashop/shared/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required this._authRepository}) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
    on<AuthRestoreRequested>(_onRestore);
    on<AuthGoogleRequested>(_onGoogleLogin);
  }

  Future<void> _emitAuthenticatedUser(
    Emitter<AuthState> emit,
    UserModel user,
  ) async {
    final refreshedUser = await _authRepository.getUserData(user.id);

    emit(AuthAuthenticated(user: refreshedUser ?? user));
  }

  void _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await _authRepository.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      if (user != null) {
        final userModel = await _authRepository.getUserData(user.id);
        if (userModel != null) {
          await _emitAuthenticatedUser(emit, userModel);
        } else {
          await _emitAuthenticatedUser(emit, user);
        }
        return;
      }

      final firebaseUser = _authRepository.currentUser;
      if (firebaseUser != null) {
        final tempUser = UserModel(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'User',
          email: firebaseUser.email ?? '',
          createdAt: DateTime.now(),
          isAdmin: false,
        );
        await _emitAuthenticatedUser(emit, tempUser);
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await _authRepository.signUpWithEmailAndPassword(
        name: event.name,
        email: event.email,
        password: event.password,
      );

      if (user != null) {
        final userModel = await _authRepository.getUserData(user.id);
        if (userModel != null) {
          await _emitAuthenticatedUser(emit, userModel);
        } else {
          await _emitAuthenticatedUser(emit, user);
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onUpdateProfileRequested(
    UpdateProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = _authRepository.currentUser;
      if (user == null) {
        emit(AuthUnauthenticated());
        return;
      }

      await _authRepository.updateProfile(uid: user.uid, name: event.name);

      final updatedUser = await _authRepository.getUserData(user.uid);
      if (updatedUser != null) {
        emit(AuthAuthenticated(user: updatedUser));
      } else {
        emit(
          AuthAuthenticated(
            user: UserModel(
              id: user.uid,
              name: event.name,
              createdAt: DateTime.now(),
              isAdmin: false,
            ),
          ),
        );
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await Future.delayed(const Duration(seconds: 2));
      await _authRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRestore(
    AuthRestoreRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(GetUserLoading());
      final user = _authRepository.currentUser;

      if (user != null) {
        final userModel = await _authRepository.getUserData(user.uid);
        if (userModel != null) {
          await _emitAuthenticatedUser(emit, userModel);
        } else {
          final tempUser = UserModel(
            id: user.uid,
            name: user.displayName ?? 'User',
            email: user.email ?? '',
            createdAt: DateTime.now(),
            isAdmin: false,
          );
          await _emitAuthenticatedUser(emit, tempUser);
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onGoogleLogin(
    AuthGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final userModel = await _authRepository.signInWithGoogle();

      if (userModel != null) {
        await _emitAuthenticatedUser(emit, userModel);
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
