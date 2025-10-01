import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_google_odeme/product/state/cubit/auth_cubit.dart';

///[StateInitialize] is a widget that initializes the state management
///[StateInitialize] bloc ve providerlarımızı burada başlatıyoruz
class StateInitialize extends StatelessWidget {
  const StateInitialize({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => AuthCubit())],
      child: child,
    );
  }
}
