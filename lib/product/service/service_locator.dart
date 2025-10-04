import 'package:flutter_supabase_google_odeme/product/service/services/logger_service.dart';
import 'package:flutter_supabase_google_odeme/product/service/services/supabase_table_service.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

///[../services] dosyasindaki servisleri burada kayit ediyoruz
/// duruma göre hemem oluşurken [registerSingleton]duruma göre de daha sonra ilk kullanımda oluşmasını sağlayabilitoruz [registerLazySingleton]
/// ayrıca her kullanımda yeni bir nesne oluşturmak için de [registerFactory] kullanabiliriz

/// [main.dart]/ [AppInitialize.make] dosyasında uygulama başında [setupLocator] fonksiyonu çağrılarak servislerin kaydı yapıyoruz

void setupLocator() {
  _registerSingletons();
  _registerLazySingletons();
  // _registerFactories();
}

void _registerSingletons() {
  locator.registerSingleton<LoggerService>(LoggerService());
}

void _registerLazySingletons() {
  locator.registerLazySingleton<SupabaseService>(() => SupabaseService());
}

// void _registerFactories() {}

extension ServiceLocator on GetIt {
  SupabaseService get supabase => locator<SupabaseService>();
  LoggerService get logger => locator<LoggerService>();
}


/// Kullanim
/// locator.logger.i("Uygulama başladı");
/// locator.supabase.addRandomUser();