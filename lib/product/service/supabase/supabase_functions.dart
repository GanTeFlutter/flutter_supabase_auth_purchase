import 'package:flutter_supabase_google_odeme/main.dart';
import 'package:flutter_supabase_google_odeme/product/service/service_locator.dart';

class SupabaseFunctionService {
  Future<Map<String, dynamic>> callFunction({
    required String functionName,
    required Map<String, dynamic> body,
  }) async {
    try {
      final res = await supabase.functions.invoke(functionName, body: body);
      final data = res.data as Map<String, dynamic>;
      return data;
    } catch (error) {
      locator.loggerService.e('Supabase Function Error: $error');
      return {'error': error.toString()};
    }
  }
}
