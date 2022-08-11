import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_tracker/services/auth_service.dart';
import 'package:weight_tracker/views/email_password_signin.dart';
import 'package:weight_tracker/views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Shopping',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
        ),
        home: const SignCheck(),
      ),
    );
  }
}

class SignCheck extends ConsumerWidget {
  const SignCheck({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool check = ref.watch(authProvider).isLoggedIn;

    if (check) {
      return const HomeScreen();
    }
    return const EmailPasswordSignIn();
  }
}
