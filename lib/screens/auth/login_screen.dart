import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:touriso/screens/shared/buttons.dart';
import 'package:touriso/screens/shared/custom_text_form_field.dart';
import 'package:touriso/screens/shared/custom_text_span.dart';
import 'package:touriso/utils/constants.dart';
import 'package:touriso/utils/dialogs.dart';
import 'package:touriso/utils/dimensions.dart';
import 'package:touriso/utils/firebase_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  ValueNotifier<bool> buttonEnabledNotifier = ValueNotifier(false);

  setButtonState() {
    if (emailController.text.isEmpty ||
        !emailController.text.trim().contains(RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")) ||
        passwordController.text.isEmpty ||
        passwordController.text.length < 6) {
      buttonEnabledNotifier.value = false;
    } else {
      buttonEnabledNotifier.value = true;
    }
  }

  @override
  void initState() {
    super.initState();

    emailController.addListener(() {
      setButtonState();
    });
    passwordController.addListener(() {
      setButtonState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ListView(
          padding: const EdgeInsets.all(24),
          shrinkWrap: true,
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
                'Login',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              controller: emailController,
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            const SizedBox(height: 20),
            PasswordTextFormField(controller: passwordController),
            const SizedBox(height: 40),
            StatefulLoadingButton(
              buttonEnabledNotifier: buttonEnabledNotifier,
              onPressed: () async {
                try {
                  await auth.signInWithEmailAndPassword(
                    email: emailController.text.trim(),
                    password: passwordController.text,
                  );

                  // ignore: use_build_context_synchronously
                  context.go('/explore');
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    print('No user found for that email.');
                  } else if (e.code == 'wrong-password') {
                    print('Wrong password provided for that user.');
                  }
                } catch (e) {
                  print(e);
                  showAlertDialog(context);
                }
              },
              child: const Text('LOGIN'),
            ),
            const SizedBox(height: 30),
            CustomTextSpan(
              firstText: 'Not signed up?',
              secondText: 'Register here',
              onPressed: () {
                context.go('/register');
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    buttonEnabledNotifier.dispose();

    super.dispose();
  }
}
