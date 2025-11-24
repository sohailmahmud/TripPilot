import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trip_pilot/core/errors/failures.dart';
import 'package:trip_pilot/core/utils/either.dart';

/// Abstract authentication repository interface
abstract class AuthRepository {
  Future<Either<Failure, void>> signUp({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthResponse>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, void>> resetPassword({required String email});

  User? getCurrentUser();

  bool isAuthenticated();

  Stream<AuthState> authStateChanges();
}
