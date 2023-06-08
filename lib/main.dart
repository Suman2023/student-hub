import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_hub/providers/accounts_screen_providers.dart';
import 'package:student_hub/screens/base_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
    await dotenv.load(fileName: ".env"); 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isAuthenticated.when(
        data: (data) {
          print(data);
          return BaseScreen(
            data: data,
          );
        },
        error: (obj, stk) => Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Something went wrong. Please refresh!"),
                IconButton(
                  onPressed: () => ref.refresh(isAuthenticatedProvider.future),
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),
        ),
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
