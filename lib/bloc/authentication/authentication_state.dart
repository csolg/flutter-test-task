import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  AuthenticationState();

  @override
  List<Object> get props => [];
}

/// UnInitialized
class UnAuthenticationState extends AuthenticationState {
  UnAuthenticationState();

  @override
  String toString() => 'UnAuthenticationState';
}

class SmsSentAuthenticationState extends AuthenticationState {
  SmsSentAuthenticationState();

  @override
  String toString() => 'SmsSentAuthenticationState';
}

/// Initialized
class SignedInAuthenticationState extends AuthenticationState {
  SignedInAuthenticationState(this.hello);

  final String hello;

  @override
  String toString() => 'InAuthenticationState $hello';

  @override
  List<Object> get props => [hello];
}

class ErrorAuthenticationState extends AuthenticationState {
  ErrorAuthenticationState(this.errorMessage);

  final String errorMessage;

  @override
  String toString() => 'ErrorAuthenticationState';

  @override
  List<Object> get props => [errorMessage];
}
