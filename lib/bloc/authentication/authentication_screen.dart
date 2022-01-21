import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test_task/bloc/authentication/index.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

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

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
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
          if (currentState is! SignedInAuthenticationState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: FormBuilder(
                key: _formKey,
                child: (currentState is SmsSentAuthenticationState)
                    ? Column(
                        children: [
                          FormBuilderTextField(
                            name: 'code',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.numeric(context),
                              FormBuilderValidators.required(context),
                            ]),
                            decoration:
                                const InputDecoration(labelText: 'Code'),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                _formKey.currentState!.save();
                                if (_formKey.currentState!.validate()) {
                                  widget._authenticationBloc.add(
                                      SignInAuthenticationEvent(_formKey
                                          .currentState!.value['code']));
                                }
                              },
                              child: const Text('Sign In'))
                        ],
                      )
                    : Column(
                        children: [
                          FormBuilderPhoneField(
                              autofocus: true,
                              initialValue: '',
                              priorityListByIsoCode: ['RU', 'US'],
                              decoration:
                                  const InputDecoration(labelText: 'Phone'),
                              name: 'phone',
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.numeric(context),
                                FormBuilderValidators.required(context),
                              ])),
                          // (currentState is ErrorAuthenticationState)
                          //     ? Text(currentState.errorMessage)
                          //     : Container(),
                          ElevatedButton(
                              onPressed: () {
                                _formKey.currentState!.save();
                                if (_formKey.currentState!.validate()) {
                                  widget._authenticationBloc.add(
                                      SmsSendAuthenticationEvent(_formKey
                                          .currentState!.value['phone']));
                                }
                              },
                              child: const Text('Send code'))
                        ],
                      ),
              ),
            );
          }
          if (currentState is SignedInAuthenticationState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(currentState.hello),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
