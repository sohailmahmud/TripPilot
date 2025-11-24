import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trip_pilot/core/errors/failures.dart';
import 'package:trip_pilot/core/utils/either.dart';
import 'package:trip_pilot/data/datasources/remote/supabase_auth_service.dart';
import 'package:trip_pilot/domain/repositories/auth_repository.dart';

/// Implementation of authentication repository
class AuthRepositoryImpl implements AuthRepository {
  final SupabaseAuthService _authService;

  AuthRepositoryImpl({required SupabaseAuthService authService})
      : _authService = authService;

  @override
  Future<Either<Failure, void>> signUp({
    required String email,
    required String password,
  }) async {
    return await _authService.signUp(email: email, password: password);
  }

  @override
  Future<Either<Failure, AuthResponse>> signIn({
    required String email,
    required String password,
  }) async {
    return await _authService.signIn(email: email, password: password);
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    return await _authService.signOut();
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    return await _authService.resetPassword(email: email);
  }

  @override
  User? getCurrentUser() {
    return _authService.getCurrentUser();
  }

  @override
  bool isAuthenticated() {
    return _authService.isAuthenticated();
  }

  @override
  Stream<AuthState> authStateChanges() {
    return _authService.authStateChanges();
  }
}
