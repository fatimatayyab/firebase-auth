import 'package:flutter/material.dart';
import 'package:testproject/constants/routes.dart';
import 'package:testproject/services/auth/auth_service.dart';
import '../utilities/show_error_dialog.dart';
import 'package:testproject/services/auth/auth_exceptions.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

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
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Enter Your Email"),
          ),
          TextField(
            controller: _password,
            decoration: const InputDecoration(hintText: "Enter Your Password"),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          TextButton(
            onPressed: () async {
              try {
                final email = _email.text;
                final password = _password.text;

                await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  // user's email is Verified

                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } else {
                  // user's email is NOT Verified
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                    (route) => false,
                  );
                }
                 }
                on UserNotFoundAuthException{
                  await showErrorDialog(
                    context,
                    'User Not Found',
                  );
 
                } on WrongPasswordFoundAuthException{

                  await showErrorDialog(
                    context,
                    'Wrong Credentials',
                  );
                } on GenericAuthException{
                  await showErrorDialog(
                    context,
                     'Authentication Error',
                  ); 
                }
            },
            child: const Text("Login"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text('Not Registered yet? Register here!'),
          )
        ],
      ),
    );
  }
}
