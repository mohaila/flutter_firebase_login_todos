import 'package:flutter/material.dart';

import '../bloc/loginbloc.dart';
import '../bloc/disposableprovider.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LoginBloc bloc = DisposableProvider.of<LoginBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Todos Login',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: StreamBuilder(
          stream: bloc.buildOut,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  _appLogo(),
                  _emailField(bloc),
                  _passwordField(bloc),
                  _signinButton(bloc, context),
                  _signupButton(bloc),
                  _errorField(bloc),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _appLogo() {
    return Padding(
      padding: EdgeInsets.all(40),
      child: Image.asset(
        'assets/flutter.png',
        width: 96,
        height: 96,
      ),
    );
  }

  Widget _emailField(LoginBloc bloc) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        maxLines: 1,
        autofocus: false,
        autocorrect: false,
        onChanged: bloc.validateEmail,
        decoration: InputDecoration(
          errorText: bloc.emailError,
          hintText: 'Email',
          icon: Icon(
            Icons.mail,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _passwordField(LoginBloc bloc) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextField(
        maxLines: 1,
        autofocus: false,
        autocorrect: false,
        obscureText: true,
        onChanged: bloc.validatePassword,
        decoration: InputDecoration(
          errorText: bloc.passwordError,
          hintText: 'Password',
          icon: Icon(
            Icons.lock,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  Text _signinPrimaryText() {
    return Text(
      'Login',
      style: TextStyle(
        fontSize: 20.0,
        color: Colors.white,
      ),
    );
  }

  Text _signupPrimaryText() {
    return Text(
      'Create account',
      style: TextStyle(
        fontSize: 20.0,
        color: Colors.white,
      ),
    );
  }

  Widget _signinButton(LoginBloc bloc, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              color: bloc.signin ? Colors.blue[600] : Colors.green[600],
              child: bloc.signin ? _signinPrimaryText() : _signupPrimaryText(),
              onPressed: bloc.canSubmit
                  ? () {
                      bloc.submit(context);
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _signupSecondaryText() {
    return Text(
      'Create an account',
      style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Text _signinSecondaryText() {
    return Text(
      'Have an account? Sign in',
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _signupButton(LoginBloc bloc) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: FlatButton(
        child: bloc.signin ? _signupSecondaryText() : _signinSecondaryText(),
        onPressed: () {
          bloc.toggle();
        },
      ),
    );
  }

  Widget _errorField(LoginBloc bloc) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        bloc.signError,
        style: TextStyle(
          fontSize: 14,
          color: Colors.red,
          fontWeight: FontWeight.w300,
          height: 1.0,
        ),
      ),
    );
  }
}
