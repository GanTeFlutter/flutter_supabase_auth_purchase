import 'package:envied/envied.dart';

part 'env_dev.g.dart';

@Envied(path: 'assets/env/.dev.env')
abstract class EnvDev {
  @EnviedField(varName: 'SUPABASE_URL', obfuscate: true)
  static final String supabaseUrl = _EnvDev.supabaseUrl;

  @EnviedField(varName: 'SUPABASE_ANON_KEY', obfuscate: true)
  static final String supabaseAnonKey = _EnvDev.supabaseAnonKey;
}
