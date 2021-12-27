import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_test_task/bloc/authentication/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent {
  Stream<AuthenticationState> applyAsync(
      {AuthenticationState currentState, AuthenticationBloc bloc});
}

class UnAuthenticationEvent extends AuthenticationEvent {
  @override
  Stream<AuthenticationState> applyAsync({AuthenticationState? currentState, AuthenticationBloc? bloc}) async* {
    yield UnAuthenticationState();
  }
}

class LoadAuthenticationEvent extends AuthenticationEvent {
   
  @override
  Stream<AuthenticationState> applyAsync(
      {AuthenticationState? currentState, AuthenticationBloc? bloc}) async* {
    try {
      yield UnAuthenticationState();
      await Future.delayed(const Duration(seconds: 1));
      yield InAuthenticationState('Hello world');
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadAuthenticationEvent', error: _, stackTrace: stackTrace);
      yield ErrorAuthenticationState( _.toString());
    }
  }
}
