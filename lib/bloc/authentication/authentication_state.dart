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

/// Initialized
class InAuthenticationState extends AuthenticationState {
  InAuthenticationState(this.hello);
  
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
