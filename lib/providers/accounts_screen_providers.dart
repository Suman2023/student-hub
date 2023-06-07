import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/account_db_helper.dart';
import '../services/accounts_service.dart';

final isSignInAuthStateProvider = StateProvider<bool>((ref) => true);

final accountServiceProvider =
    Provider<AcountService>((ref) => AcountService());

final accountDbHelperProvider =
    Provider<AccountDbHelper>((ref) => AccountDbHelper());

final emailControllerProvider =
    StateProvider<TextEditingController>((ref) => TextEditingController());
final passControllerProvider =
    StateProvider<TextEditingController>((ref) => TextEditingController());
final showPassStateProvider = StateProvider<bool>((ref) => false);

final authSignLoadingStateProvider = StateProvider<bool>((ref) => false);



final invalidEmailStateProvider = StateProvider<String?>((ref) => null);
final invalidPwdStateProvider = StateProvider<String?>((ref) => null);

final isAuthenticatedProvider =
    FutureProvider<Map<String, dynamic>?>((ref) async {
  final authservice = ref.read(accountServiceProvider);
  final data = await authservice.isAuthenticated();
  if(data != null){
      ref.read(isLoggedInStateProvider.notifier).state = true;
  }
  return data;
});

final isLoggedInStateProvider = StateProvider<bool>((ref)=>false);