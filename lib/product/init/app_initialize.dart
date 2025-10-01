import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_supabase_google_odeme/product/service/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@immutable
final class AppInitialize {
  Future<void> make() async {
    WidgetsFlutterBinding.ensureInitialized();
     await Supabase.initialize(
      url: 'https://gubpddukavajhqmvjkxq.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd1YnBkZHVrYXZhamhxbXZqa3hxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkwODA5ODAsImV4cCI6MjA3NDY1Njk4MH0.xVqzoanq3-dweluhetXUE7A48pMRjlQaRYhCwHQPWoE',
    );
    setupLocator();
     }
}
