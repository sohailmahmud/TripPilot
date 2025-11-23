/// Either type for handling success or failure cases
abstract class Either<L, R> {
  const Either();

  B fold<B>(
    B Function(L l) ifLeft,
    B Function(R r) ifRight,
  );

  Either<L, B> map<B>(B Function(R r) fn) =>
      fold((l) => Left(l), (r) => Right(fn(r)));

  Either<B, R> mapLeft<B>(B Function(L l) fn) =>
      fold((l) => Left(fn(l)), (r) => Right(r));

  Either<L, B> flatMap<B>(Either<L, B> Function(R r) fn) =>
      fold((l) => Left(l), (r) => fn(r));

  B getOrElse<B extends R>(B Function(L l) fn) =>
      fold((l) => fn(l), (r) => r as B);

  R getOrNull() => fold((l) => null, (r) => r) as R;

  L? getLeftOrNull() => fold((l) => l, (r) => null);

  bool get isLeft => this is Left;
  bool get isRight => this is Right;
}

/// Left side of Either - represents failure
class Left<L, R> extends Either<L, R> {
  final L value;

  const Left(this.value);

  @override
  B fold<B>(
    B Function(L l) ifLeft,
    B Function(R r) ifRight,
  ) =>
      ifLeft(value);
}

/// Right side of Either - represents success
class Right<L, R> extends Either<L, R> {
  final R value;

  const Right(this.value);

  @override
  B fold<B>(
    B Function(L l) ifLeft,
    B Function(R r) ifRight,
  ) =>
      ifRight(value);
}
