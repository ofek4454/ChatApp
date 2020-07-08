import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Future<void> _submitForm(Map<String, String> values, AuthMode currentMode,
      BuildContext ctx) async {
    final _auth = FirebaseAuth.instance;
    AuthResult result;
    try {
      if (currentMode == AuthMode.LogIn) {
        result = await _auth.signInWithEmailAndPassword(
            email: values['email'], password: values['password']);
      } else {
        result = await _auth.createUserWithEmailAndPassword(
            email: values['email'], password: values['password']);
        await Firestore.instance
            .collection('users')
            .document(result.user.uid)
            .setData(
          {
            'email': values['email'],
            'username': values['username'],
          },
        );
      }
    } on PlatformException catch (error) {
      var message = 'An error occurred, please check your credentials!';
      if (error.message != null) {
        message = error.message;
      }
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitForm),
    );
  }
}
