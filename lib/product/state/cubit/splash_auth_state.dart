part of 'splash_auth_cubit.dart';

@immutable
sealed class SplashAuthState {}

final class SplashAuthInitial extends SplashAuthState {}

final class SplashAuthLoading extends SplashAuthState {}

final class SplashAuthSuccess extends SplashAuthState {
  final bool loggedIn;
  SplashAuthSuccess(this.loggedIn);
}

final class SplashAuthError extends SplashAuthState {
  final String errorMessage;
  SplashAuthError(this.errorMessage);
}
