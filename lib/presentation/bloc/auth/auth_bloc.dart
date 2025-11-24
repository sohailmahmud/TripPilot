import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_pilot/domain/repositories/auth_repository.dart';
import 'package:trip_pilot/presentation/bloc/auth/auth_event.dart';
import 'package:trip_pilot/presentation/bloc/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(const AuthInitial()) {
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthPasswordResetRequested>(_onPasswordResetRequested);
    on<AuthCheckStatusRequested>(_onCheckStatusRequested);
    on<AuthSessionChanged>(_onSessionChanged);
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authRepository.signUp(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthFailure(failure)),
      (_) => emit(
        AuthSuccess(
          userId: event.email.split('@')[0],
          email: event.email,
          isNewUser: true,
        ),
      ),
    );
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authRepository.signIn(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthFailure(failure)),
      (response) => emit(
        AuthSuccess(
          userId: response.user?.id ?? '',
          email: response.user?.email ?? '',
        ),
      ),
    );
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authRepository.signOut();

    result.fold(
      (failure) => emit(AuthFailure(failure)),
      (_) => emit(const AuthUnauthenticated()),
    );
  }

  Future<void> _onPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authRepository.resetPassword(email: event.email);

    result.fold(
      (failure) => emit(AuthFailure(failure)),
      (_) => emit(PasswordResetSent(email: event.email)),
    );
  }

  Future<void> _onCheckStatusRequested(
    AuthCheckStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = authRepository.getCurrentUser();
    
    if (user != null) {
      emit(
        AuthSuccess(
          userId: user.id,
          email: user.email ?? '',
        ),
      );
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onSessionChanged(
    AuthSessionChanged event,
    Emitter<AuthState> emit,
  ) async {
    if (event.isAuthenticated) {
      emit(
        AuthSuccess(
          userId: event.userId ?? '',
          email: event.email ?? '',
        ),
      );
    } else {
      emit(const AuthUnauthenticated());
    }
  }
}
