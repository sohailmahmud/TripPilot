import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignUpRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

class AuthPasswordResetRequested extends AuthEvent {
  final String email;

  const AuthPasswordResetRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthCheckStatusRequested extends AuthEvent {
  const AuthCheckStatusRequested();
}

class AuthSessionChanged extends AuthEvent {
  final bool isAuthenticated;
  final String? userId;
  final String? email;

  const AuthSessionChanged({
    required this.isAuthenticated,
    this.userId,
    this.email,
  });

  @override
  List<Object?> get props => [isAuthenticated, userId, email];
}
