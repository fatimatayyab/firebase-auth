import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testproject/services/auth/bloc/auth_bloc.dart';
import 'package:testproject/services/auth/bloc/auth_event.dart';
import 'package:testproject/services/auth/bloc/auth_state.dart';
import 'package:testproject/utilities/dialogs/loading_dialog.dart';
import '../utilities/dialogs/error_dialog.dart';
import 'package:testproject/services/auth/auth_exceptions.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  CloseDialog? _closeDialogHandle;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          final closeDialog = _closeDialogHandle;
          if (!state.isLoading && closeDialog != null) {
            closeDialog();
            _closeDialogHandle = null;
          } else if (state.isLoading && closeDialog==null){

          
            _closeDialogHandle = showLoadingDialog(
              context: context,
              text: 'Loading...',
            );
          }
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'User Not Found');
          } else if (state.exception is WrongPasswordFoundAuthException) {
            await showErrorDialog(context, 'Wrong Credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication Error');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Column(
          children: [
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "Enter Your Email",
              ),
            ),
            TextField(
              controller: _password,
              decoration: const InputDecoration(
                hintText: "Enter Your Password",
              ),
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
            ),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                context.read<AuthBloc>().add(
                      AuthEventLogIn(
                        email,
                        password,
                      ),
                    );
              },
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                      const AuthEventShouldRegister(),
                    );
              },
              child: const Text('Not Registered yet? Register here!'),
            )
          ],
        ),
      ),
    );
  }
}
