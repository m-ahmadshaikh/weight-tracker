import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_tracker/services/auth_service.dart';
import 'package:weight_tracker/views/sign_up.dart';

class EmailPasswordSignIn extends ConsumerStatefulWidget {
  const EmailPasswordSignIn({super.key});

  @override
  ConsumerState<EmailPasswordSignIn> createState() =>
      _EmailPasswordSignInState();
}

class _EmailPasswordSignInState extends ConsumerState<EmailPasswordSignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ref.watch(authProvider).isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          scale: 1.5,
                          image: NetworkImage(
                              "https://www.iconsdb.com/icons/preview/yellow/app-store-2-xxl.png"),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextFormField(
                            // initialValue: '',
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Enter email',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(
                                Icons.person,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            obscureText: true,
                            controller: passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Enter Password',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(
                                Icons.password,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                              width: 100, // <-- Your width
                              height: 50,
                              child: ElevatedButton(
                                  onPressed: () {
                                    final authRepository =
                                        ref.watch(authProvider);
                                    authRepository.signIn(
                                        email: emailController.text,
                                        password: passwordController.text);
                                  },
                                  child: const Text('Login'))),
                          const SizedBox(
                            height: 15,
                          ),
                          TextButton(
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.black),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUp(
                                              emailController: emailController,
                                              passwordController:
                                                  passwordController,
                                            )));
                              },
                              child: const Text('Sign Up'))
                        ],
                      ),
                    ),
                  )
                ],
              ));
  }
}
