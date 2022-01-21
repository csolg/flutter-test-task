import 'dart:async';
import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test_task/bloc/authentication/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent {
  Stream<AuthenticationState> applyAsync(
      {AuthenticationState currentState, AuthenticationBloc bloc});
}

class SignOutAuthenticationEvent extends AuthenticationEvent {
  @override
  Stream<AuthenticationState> applyAsync(
      {AuthenticationState? currentState, AuthenticationBloc? bloc}) async* {
    yield UnAuthenticationState();
  }
}

class SmsSentAuthenticationEvent extends AuthenticationEvent {
  final String verificationId;
  SmsSentAuthenticationEvent(this.verificationId);

  @override
  Stream<AuthenticationState> applyAsync(
      {AuthenticationState? currentState, AuthenticationBloc? bloc}) async* {
    bloc?.verficationId = verificationId;
    yield SmsSentAuthenticationState();
  }
}

class FailedAuthenticationEvent extends AuthenticationEvent {
  final String message;
  FailedAuthenticationEvent(this.message);

  @override
  Stream<AuthenticationState> applyAsync(
      {AuthenticationState? currentState, AuthenticationBloc? bloc}) async* {
    print(message);
    yield ErrorAuthenticationState(message);
  }
}

class SmsSendAuthenticationEvent extends AuthenticationEvent {
  SmsSendAuthenticationEvent(this.phone);

  final String phone;

  @override
  Stream<AuthenticationState> applyAsync(
      {AuthenticationState? currentState, AuthenticationBloc? bloc}) async* {
    print(phone);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) {
        // ANDROID ONLY!
        print("SmsSendAuthenticationEvent verificationCompleted");
        bloc!.add(SignInAuthenticationEvent(null, credential));
      },
      verificationFailed: (FirebaseAuthException e) {
        bloc!.add(FailedAuthenticationEvent(e.code + ': ' + (e.message ?? '')));
      },
      codeSent: (String verificationId, int? resendToken) {
        bloc!.add(SmsSentAuthenticationEvent(verificationId));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    yield UnAuthenticationState();
  }
}

class SignInAuthenticationEvent extends AuthenticationEvent {
  PhoneAuthCredential? credential;
  final String? code;

  SignInAuthenticationEvent([this.code, this.credential]);

  @override
  Stream<AuthenticationState> applyAsync(
      {AuthenticationState? currentState, AuthenticationBloc? bloc}) async* {
    try {
      // Create a PhoneAuthCredential with the code
      if (code != null) {
        credential = PhoneAuthProvider.credential(
          verificationId: bloc!.verficationId!,
          smsCode: code!,
        );
      }

      // Sign the user in (or link) with the credential
      final user =
          await FirebaseAuth.instance.signInWithCredential(credential!);

      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      users.add({
        'uid': user.user!.uid,
        'phoneNumber': user.user!.phoneNumber,
      });
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadAuthenticationEvent', error: _, stackTrace: stackTrace);
      yield ErrorAuthenticationState(_.toString());
    }
  }
}
