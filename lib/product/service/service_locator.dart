import 'package:flutter_supabase_google_odeme/product/service/purchasing/purchasing_service.dart';
import 'package:flutter_supabase_google_odeme/product/service/helper_services/logger_service.dart';
import 'package:flutter_supabase_google_odeme/product/service/supabase/supabase_functions.dart';
import 'package:flutter_supabase_google_odeme/product/service/supabase/supabase_service.dart';
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
  locator.registerLazySingleton<PurchasingService>(() => PurchasingService());
  locator.registerLazySingleton<SupabaseFunctionService>(
    () => SupabaseFunctionService(),
  );
}

// void _registerFactories() {}

extension ServiceLocator on GetIt {
  SupabaseService get supabaseService => locator<SupabaseService>();
  LoggerService get loggerService => locator<LoggerService>();
  PurchasingService get purchasingService => locator<PurchasingService>();
  SupabaseFunctionService get supabaseFunctionService =>
      locator<SupabaseFunctionService>();
}


/// Kullanim
/// locator.logger.i("Uygulama başladı");
/// locator.supabase.addRandomUser();