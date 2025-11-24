import 'package:equatable/equatable.dart';
import 'package:trip_pilot/core/errors/failures.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final String userId;
  final String email;
  final bool isNewUser;

  const AuthSuccess({
    required this.userId,
    required this.email,
    this.isNewUser = false,
  });

  @override
  List<Object?> get props => [userId, email, isNewUser];
}

class AuthUnauthenticated extends AuthState {
  final String? message;

  const AuthUnauthenticated({this.message});

  @override
  List<Object?> get props => [message];
}

class AuthFailure extends AuthState {
  final Failure failure;

  const AuthFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}

class PasswordResetSent extends AuthState {
  final String email;

  const PasswordResetSent({required this.email});

  @override
  List<Object?> get props => [email];
}
