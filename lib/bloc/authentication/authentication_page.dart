import 'package:flutter/material.dart';
import 'package:flutter_test_task/bloc/authentication/index.dart';
import 'package:flutter_test_task/repositories/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationPage extends StatefulWidget {
  static const String routeName = '/authentication';

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
      ),
      body: AuthenticationScreen(
          authenticationBloc:
              AuthenticationBloc(context.read<AuthenticationRepository>())),
    );
  }
}
