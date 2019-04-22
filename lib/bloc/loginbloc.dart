import 'dart:async';
import 'package:flutter/material.dart';

import 'disposable.dart';
import '../service/auth.dart';
import '../service/loginservice.dart';

class LoginBloc extends Disposable {
  final _buildController = StreamController<bool>();
  final Auth _auth = LoginService();
  String _email = '';
  String _password = '';
  String _emailError = '';
  String _passwordError = '';
  String _signError = '';
  bool _signin = true;

  final rexp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  get _build => _buildController.sink;

  Stream<bool> get buildOut => _buildController.stream;

  bool get signin => _signin;

  String get emailError => _emailError;

  String get passwordError => _passwordError;

  String get signError => _signError;

  bool get canSubmit => _email.isNotEmpty && _password.isNotEmpty;

  @override
  void dispose() {
    _buildController.close();
  }

  void toggle() {
    _signin = !_signin;
    _build.add(true);
  }

  void submit(BuildContext context) async {
    if (_signin)
      _signinAction().then((String value) {
        if (value != null) {
          Navigator.pushReplacementNamed(context, '/todos');
        }
      });
    else
      _signupAction().then((String value) {
        if (value != null) toggle();
      });
  }

  Future<String> _signinAction() async {
    try {
      if (_email.isEmpty) {
        _signError = 'Invalid or empty email';
        return null;
      }

      if (_password.isEmpty) {
        _signError = 'Invalid or empty password';
        return null;
      }

      return _auth.signIn(_email, _password);
    } catch (e) {
      _signError = e.message;
    }
    return null;
  }

  Future<String> _signupAction() async {
    try {
      if (_email.isEmpty) {
        _signError = 'Invalid or empty email';
        return null;
      }
      if (_password.isEmpty) {
        _signError = 'Invalid or empty password';
        return null;
      }

      return _auth.signUp(_email, _password);
    } catch (e) {
      _signError = e.message;
    }
    return null;
  }

  void validateEmail(String email) {
    if (rexp.hasMatch(email)) {
      _email = email;
      _emailError = '';
    } else {
      _emailError = 'Invalid email';
    }

    _build.add(true);
  }

  void validatePassword(String password) {
    if (password.length >= 8) {
      _password = password;
      _passwordError = '';
    } else {
      _passwordError = 'Password must be at least 8 characters';
    }

    _build.add(true);
  }
}
