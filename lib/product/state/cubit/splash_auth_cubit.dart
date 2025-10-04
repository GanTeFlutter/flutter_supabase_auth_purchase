import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_google_odeme/main.dart';
import 'package:flutter_supabase_google_odeme/product/service/service_locator.dart';
import 'package:meta/meta.dart';

part 'splash_auth_state.dart';

class SplashAuthCubit extends Cubit<SplashAuthState> {
  SplashAuthCubit() : super(SplashAuthInitial());

  Future<void> checkAuthStatus() async {
    try {
      emit(SplashAuthLoading());

      final session = supabase.auth.currentSession;
      final isLoggedIn = session != null;

      emit(SplashAuthSuccess(isLoggedIn));
      locator.loggerService.i(
        'Auth durumu kontrol edildi: ${isLoggedIn ? "Giriş yapılmış" : "Giriş yapılmamış"}',
      );
    } catch (e) {
      locator.loggerService.e('Auth durumu kontrol edilemedi', error: e);
      emit(SplashAuthError(e.toString()));
    }
  }
}
