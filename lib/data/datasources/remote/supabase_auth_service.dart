import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trip_pilot/core/errors/failures.dart';
import 'package:trip_pilot/core/utils/either.dart';

/// Supabase Authentication Service
class SupabaseAuthService {
  final SupabaseClient _client;

  SupabaseAuthService({required SupabaseClient client}) : _client = client;

  /// Sign up with email and password
  Future<Either<Failure, void>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _client.auth.signUp(
        email: email,
        password: password,
      );
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(
        message: e.message,
        code: e.statusCode,
      ));
    } catch (e) {
      return Left(AuthFailure(
        message: 'Sign up failed: ${e.toString()}',
      ));
    }
  }

  /// Sign in with email and password
  Future<Either<Failure, AuthResponse>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return Right(response);
    } on AuthException catch (e) {
      return Left(AuthFailure(
        message: e.message,
        code: e.statusCode,
      ));
    } catch (e) {
      return Left(AuthFailure(
        message: 'Sign in failed: ${e.toString()}',
      ));
    }
  }

  /// Sign out
  Future<Either<Failure, void>> signOut() async {
    try {
      await _client.auth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(
        message: 'Sign out failed: ${e.toString()}',
      ));
    }
  }

  /// Get current user
  User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return _client.auth.currentUser != null;
  }

  /// Reset password
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(
        message: 'Reset password failed: ${e.toString()}',
      ));
    }
  }

  /// Listen to auth state changes
  Stream<AuthState> authStateChanges() {
    return _client.auth.onAuthStateChange;
  }
}
