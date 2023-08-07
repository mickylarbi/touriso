import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:touriso/models/client.dart';
import 'package:touriso/screens/shared/buttons.dart';
import 'package:touriso/screens/shared/custom_text_form_field.dart';
import 'package:touriso/screens/shared/custom_text_span.dart';
import 'package:touriso/utils/constants.dart';
import 'package:touriso/utils/dialogs.dart';
import 'package:touriso/utils/dimensions.dart';
import 'package:touriso/utils/firebase_helper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController otherNamesController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final ValueNotifier<XFile?> pictureNotifier = ValueNotifier(null);
  final TextEditingController passwordController = TextEditingController();

  final ValueNotifier<bool> buttonEnabledNotifier = ValueNotifier(false);

  setButtonState() {
    if (firstNameController.text.trim().isEmpty ||
        otherNamesController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        !emailController.text.trim().contains(RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")) ||
        // pictureNotifier.value == null ||
        passwordController.text.trim().isEmpty ||
        passwordController.text.trim().length < 6) {
      buttonEnabledNotifier.value = false;
    } else {
      buttonEnabledNotifier.value = true;
    }
  }

  @override
  void initState() {
    super.initState();

    firstNameController.addListener(() {
      setButtonState();
    });
    otherNamesController.addListener(() {
      setButtonState();
    });
    emailController.addListener(() {
      setButtonState();
    });
    // pictureNotifier.addListener(() {
    //   setButtonState();
    // });
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
                'Register',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              controller: firstNameController,
              hintText: 'First name',
              prefixIcon: const Icon(Icons.person_outline_rounded),
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              controller: otherNamesController,
              hintText: 'Other names',
              prefixIcon: const Icon(Icons.person_outline_rounded),
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              controller: emailController,
              hintText: 'Email',
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<XFile?>(
              valueListenable: pictureNotifier,
              builder: (context, value, child) {
                return Column(
                  children: [
                    if (value != null)
                      Image.network(
                        value.path,
                        width: 300,
                      ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        picker
                            .pickImage(source: ImageSource.gallery)
                            .then((value) {
                          pictureNotifier.value = value;
                        }).onError((error, stackTrace) {
                          showAlertDialog(context);
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black54,
                        foregroundColor: Colors.white,
                      ),
                      child:
                          Text('${value == null ? 'Choose' : 'Change'} image'),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            PasswordTextFormField(controller: passwordController),
            const SizedBox(height: 40),
            StatefulLoadingButton(
              buttonEnabledNotifier: buttonEnabledNotifier,
              onPressed: () async {
                try {
                  await register();

                  context.go('/explore');
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    showAlertDialog(context,
                        message: 'The password provided is too weak.');
                  } else if (e.code == 'email-already-in-use') {
                    showAlertDialog(context,
                        message: 'The account already exists for that email.');
                  }
                } catch (e) {
                  print(e);
                  showAlertDialog(context);
                }
              },
              child: const Text('REGISTER'),
            ),
            const SizedBox(height: 30),
            CustomTextSpan(
              firstText: 'Already registered?',
              secondText: 'Login here',
              onPressed: () {
                context.go('/login');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future register() async {
    await auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(), password: passwordController.text);

    if (pictureNotifier.value != null) {
      await picturesRef(uid)
          .putData(await pictureNotifier.value!.readAsBytes());
    }

    await clientsCollection.doc(uid).set(
          Client(
            firstName: firstNameController.text.trim(),
            otherNames: otherNamesController.text.trim(),
            email: emailController.text.trim(),
            pictureUrl: pictureNotifier.value != null
                ? await picturesRef(uid).getDownloadURL()
                : null,
          ).toFirebase(),
        );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    otherNamesController.dispose();
    emailController.dispose();
    pictureNotifier.dispose();
    passwordController.dispose();

    buttonEnabledNotifier.dispose();

    super.dispose();
  }
}
