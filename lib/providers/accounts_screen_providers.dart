import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/account_db_helper.dart';
import '../services/accounts_service.dart';

final accountServiceProvider =
    Provider<AcountService>((ref) => AcountService());

final accountDbHelperProvider =
    Provider<AccountDbHelper>((ref) => AccountDbHelper());

final emailControllerProvider =
    StateProvider<TextEditingController>((ref) => TextEditingController());
final passControllerProvider =
    StateProvider<TextEditingController>((ref) => TextEditingController());
final showPassStateProvider = StateProvider<bool>((ref) => false);
