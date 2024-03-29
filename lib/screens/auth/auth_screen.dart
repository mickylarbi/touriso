import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:touriso/screens/shared/custom_text_form_field.dart';
import 'package:touriso/screens/shared/custom_text_span.dart';
import 'package:touriso/screens/shared/loading_button.dart';
import 'package:touriso/utils/constants.dart';
import 'package:touriso/utils/dimensions.dart';

class AuthScreen extends StatefulWidget {
  final AuthType authType;
  const AuthScreen({Key? key, required this.authType}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // SystemChannels.textInput.invokeMethod('TextInput.hide');
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Hero(
                      tag: kLogoTag,
                      child: Image.asset(
                        'assets/images/TOURISO 2.png',
                        width: (kScreenWidth(context)) * 0.8,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Sign ${widget.authType == AuthType.signUp ? 'up' : 'in'}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (widget.authType == AuthType.signUp)
                      const SizedBox(height: 20),
                    if (widget.authType == AuthType.signUp)
                      CustomTextFormField(
                        controller: _fullNameController,
                        hintText: 'Full name',
                        prefixIcon: const Icon(Icons.person_outline_rounded),
                      ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      controller: _emailController,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    const SizedBox(height: 20),
                    PasswordTextFormField(controller: _passwordController),
                    if (widget.authType == AuthType.login)
                      const SizedBox(height: 10),
                    if (widget.authType == AuthType.login)
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            // fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    const SizedBox(height: 40),
                    LoadingButton(
                      onPressed: () {
                        context.go('/');
                        // if (_emailController.text.trim().isEmpty ||
                        //     _passwordController.text.isEmpty ||
                        //     (widget.authType == AuthType.signUp &&
                        //         _confirmPasswordController.text.isEmpty)) {
                        //   showAlertDialog(context,
                        //       message: 'One or more fields are empty');
                        // } else if (!_emailController.text.trim().contains(RegExp(
                        //     r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
                        //   showAlertDialog(context,
                        //       message: 'Email address is invalid');
                        // } else if (widget.authType == AuthType.signUp &&
                        //     (_passwordController.text !=
                        //         _confirmPasswordController.text)) {
                        //   showAlertDialog(context,
                        //       message: 'Passwords do not match');
                        // } else if (_passwordController.text.length < 6) {
                        //   showAlertDialog(context,
                        //       message:
                        //           'Password should not be less than 6 characters');
                        // } else {
                        //   if (widget.authType == AuthType.login) {
                        //     _auth.signIn(
                        //       context,
                        //       email: _emailController.text.trim(),
                        //       password: _passwordController.text,
                        //     );
                        //   } else {
                        //     _auth.signUp(context,
                        //         email: _emailController.text.trim(),
                        //         password: _passwordController.text);
                        //   }
                        // }
                      },
                      child: Text(widget.authType == AuthType.login
                          ? 'SIGN UP'
                          : 'SIGN IN'),
                    ),
                    const SizedBox(height: 30),
                    CustomTextSpan(
                      firstText: widget.authType == AuthType.login
                          ? "Don't have an account?"
                          : 'Already have an account?',
                      secondText: widget.authType == AuthType.login
                          ? 'Sign up'
                          : 'Sign in',
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AuthScreen(
                              authType: widget.authType == AuthType.login
                                  ? AuthType.signUp
                                  : AuthType.login,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

enum AuthType { login, signUp }

// class AuthWidget extends StatelessWidget {
//   AuthWidget({Key? key}) : super(key: key);
//   final AuthService _authService = AuthService();

//   @override
//   Widget build(BuildContext context) {
//     if (_authService.currentUser == null) {
//       return const AuthScreen(authType: AuthType.login);
//     }

//     return const TabView();
//   }
// }

