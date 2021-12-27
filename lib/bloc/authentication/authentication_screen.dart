import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_task/bloc/authentication/index.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({
    required AuthenticationBloc authenticationBloc,
    Key? key,
  })  : _authenticationBloc = authenticationBloc,
        super(key: key);

  final AuthenticationBloc _authenticationBloc;

  @override
  AuthenticationScreenState createState() {
    return AuthenticationScreenState();
  }
}

class AuthenticationScreenState extends State<AuthenticationScreen> {
  AuthenticationScreenState();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        bloc: widget._authenticationBloc,
        builder: (
          BuildContext context,
          AuthenticationState currentState,
        ) {
          if (currentState is UnAuthenticationState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorAuthenticationState) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(currentState.errorMessage ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text('reload'),
                    onPressed: _load,
                  ),
                ),
              ],
            ));
          }
           if (currentState is InAuthenticationState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(currentState.hello),
                ],
              ),
            );
          }
          return Center(
              child: CircularProgressIndicator(),
          );
          
        });
  }

  void _load() {
    widget._authenticationBloc.add(LoadAuthenticationEvent());
  }
}
