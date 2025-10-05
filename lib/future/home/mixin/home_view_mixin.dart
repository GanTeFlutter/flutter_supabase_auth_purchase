import 'package:flutter/widgets.dart';
import 'package:flutter_supabase_google_odeme/future/home/home_view.dart';
import 'package:flutter_supabase_google_odeme/product/service/service_locator.dart';

mixin HomeViewMixin<T extends StatefulWidget> on State<HomeView> {
  Map<String, dynamic> dataT = {};
  final String functionName = 'hello-world';
  final Map<String, dynamic> body = {'name': 'kadir'};

  void istek() {
    locator.supabaseFunctionService
        .callFunction(functionName: functionName, body: body)
        .then((value) {
          setState(() {
            locator.loggerService.i('GelenData: $value');
            dataT = value;
          });
        });
  }
}
