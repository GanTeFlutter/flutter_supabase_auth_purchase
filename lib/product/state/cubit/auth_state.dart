part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final bool loggedIn;
  AuthSuccess(this.loggedIn);
}

final class AuthError extends AuthState {
  final String errorMessage;
  AuthError(this.errorMessage);
}
