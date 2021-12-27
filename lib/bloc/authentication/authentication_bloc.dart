import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:flutter_test_task/bloc/authentication/index.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {

  AuthenticationBloc(AuthenticationState initialState) : super(initialState){
   on<AuthenticationEvent>((event, emit) {
      return emit.forEach<AuthenticationState>(
        event.applyAsync(currentState: state, bloc: this),
        onData: (state) => state,
        onError: (error, stackTrace) {
          developer.log('$error', name: 'AuthenticationBloc', error: error, stackTrace: stackTrace);
          return ErrorAuthenticationState(error.toString());
        },
      );
    });
  }
}
