import 'package:flutter/material.dart';
import 'package:flutter_app_instaclone/repositories/auth/auth_repository.dart';
import 'package:flutter_app_instaclone/screens/login/cubit/login_cubit.dart';
import 'package:flutter_app_instaclone/screens/signup/signup_screen.dart';
import 'package:flutter_app_instaclone/widgets/error_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  static Route route() {
    return PageRouteBuilder(
        settings: RouteSettings(name: routeName),
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (context, _, __) => BlocProvider<LoginCubit>(
            create: (_) =>
                LoginCubit(authRepository: context.read<AuthRepository>()),
            child: LoginScreen()));
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.error) {
              showDialog(
                context: context,
                builder: (context) => ErrorDialog(content: state.failure.message),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Instagram',
                              style: TextStyle(
                                  fontSize: 28.0, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 12.0,
                            ),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'Email'),
                              onChanged: (value) => context
                                  .read<LoginCubit>()
                                  .emailChanged(value),
                              validator: (value) => !value.contains('@')
                                  ? 'Please enter a valid email'
                                  : null,
                            ),
                            const SizedBox(
                              height: 12.0,
                            ),
                            TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(hintText: 'Password'),
                              onChanged: (value) => context
                                  .read<LoginCubit>()
                                  .passwordChanged(value),
                              validator: (value) => value.length < 6
                                  ? 'Must be at least 6 characters'
                                  : null,
                            ),
                            SizedBox(
                              height: 28.0,
                            ),
                            ElevatedButton(
                              onPressed: () => _submitForm(context,
                                  state.status == LoginStatus.submitting),
                              child: Text(
                                'Login',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context)
                                  .pushNamed(SignupScreen.routeName),
                              child: Text(
                                'No account? Sign up',
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey[200],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    print('aaa');
    if (_formKey.currentState.validate() && !isSubmitting) {
      print('bbb');
      context.read<LoginCubit>().logInWithCredentials();
    }
  }
}
