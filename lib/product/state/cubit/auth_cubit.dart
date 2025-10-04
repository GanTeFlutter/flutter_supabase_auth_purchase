import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_google_odeme/main.dart';
import 'package:flutter_supabase_google_odeme/product/service/service_locator.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> checkAuthStatus() async {
    try {
      emit(AuthLoading());

      final session = supabase.auth.currentSession;
      final isLoggedIn = session != null;

      emit(AuthSuccess(isLoggedIn));
      locator.logger.i(
        'Auth durumu kontrol edildi: ${isLoggedIn ? "Giriş yapılmış" : "Giriş yapılmamış"}',
      );
    } catch (e) {
      locator.logger.e('Auth durumu kontrol edilemedi', error: e);
      emit(AuthError(e.toString()));
    }
  }
}
