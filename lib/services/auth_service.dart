import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationHelper extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  get user => auth.currentUser;
  bool isLoading = false;
  bool isLoggedIn = false;
  Future signUp({required String email, required String password}) async {
    try {
      isLoading = true;
      notifyListeners();
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signIn({required String email, required String password}) async {
    try {
      isLoading = true;
      notifyListeners();
      await auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();

      isLoading = false;
      isLoggedIn = true;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    isLoading = true;
    notifyListeners();
    await auth.signOut();
    isLoggedIn = false;
    isLoading = false;
    notifyListeners();
    notifyListeners();
  }
}

final authProvider = ChangeNotifierProvider<AuthenticationHelper>((ref) {
  return AuthenticationHelper();
});
