import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_tracker/services/auth_service.dart';

class SignUp extends ConsumerStatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const SignUp(
      {Key? key,
      required this.emailController,
      required this.passwordController})
      : super(key: key);

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
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

                            keyboardType: TextInputType.emailAddress,
                            controller: widget.emailController,
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
                            controller: widget.passwordController,
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
                                  onPressed: () async {
                                    final authRepository =
                                        ref.watch(authProvider);
                                    await authRepository.signUp(
                                        email: widget.emailController.text,
                                        password:
                                            widget.passwordController.text);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Sign Up'))),
                        ],
                      ),
                    ),
                  )
                ],
              ));
  }
}
