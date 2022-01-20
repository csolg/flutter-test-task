import 'package:flutter/material.dart';
import 'package:flutter_test_task/bloc/authentication/index.dart';

class AuthenticationPage extends StatefulWidget {
  static const String routeName = '/authentication';

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final _authenticationBloc = AuthenticationBloc(UnAuthenticationState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
      ),
      body: AuthenticationScreen(authenticationBloc: _authenticationBloc),
    );
  }
}
