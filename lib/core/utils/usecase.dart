import 'package:trip_pilot/core/utils/either.dart';
import 'package:trip_pilot/core/errors/failures.dart';

/// Abstract base class for all use cases
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Use case with no parameters
abstract class UseCaseNoParams<T> {
  Future<Either<Failure, T>> call();
}

/// Parameters class for use cases that don't need parameters
class NoParams {
  const NoParams();
}
