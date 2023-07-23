import 'package:chat_app/pages/cubit/auth_cubit/auth_cubit.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textField.dart';
import '../widgets/show_snack_bar.dart';
import 'chat_page.dart';

class RegisterPage extends StatelessWidget {
  GlobalKey<FormState> formKey = GlobalKey();

  static String id = 'registerPage';

  String? email;

  String? password;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    ////ModalProgressHUD we use this package to make circullar progress in page above the scaffold
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          isLoading = true;
        } else if (state is RegisterSuccess) {
          Navigator.pushNamed(context, ChatPage.id , arguments: email);
          isLoading = false;
        } else if (state is RegisterFailure) {
          showSnakBar(context, state.errMessage);
          isLoading = false;
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Scaffold(
            backgroundColor: kPrimaryColor,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 65),
                    Image.asset(
                      kLogo,
                      width: 400,
                      height: 200,
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Flutter Helper Chat',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Pacifico',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomForTextField(
                      onChanged: (data) {
                        email = data;
                      },
                      hintText: 'Enter Mail',
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomForTextField(
                      obscureText: true,
                      onChanged: (data) {
                        password = data;
                      },
                      hintText: 'Enter Password',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          BlocProvider.of<AuthCubit>(context)
                              .registerUser(email: email!, password: password!);

                          // isLoading = true;

                          // try {
                          //   UserCredential user = await registerUser();
                          //   print(user.user!.email);
                          //   showSnakBar(context, 'SignUp succesfully');
                          //   Navigator.pushNamed(context, ChatPage.id,arguments: email);
                          // } on FirebaseAuthException catch (e) {
                          //   if (e.code == 'weak-password') {
                          //     print('The password provided is too weak.');
                          //     showSnakBar(
                          //         context, 'The password provided is too weak. ');
                          //   } else if (e.code == 'email-already-in-use') {
                          //     print('The account already exists for that email.');
                          //     showSnakBar(context,
                          //         'The account already exists for that email. ');
                          //   }
                          // } catch (e) {
                          //   print(e);
                          //   showSnakBar(
                          //       context, 'There is an error , please try again');
                          // }
                          isLoading = false;
                        } else {}
                      },
                      buttonText: 'SignUp',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'already have an account ! ',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigator.pushNamed(context, 'LoginPage');

                            Navigator.pop(context);

                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) {
                            //   return LoginPage();
                            // }));
                          },
                          child: Text('SignIn',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<UserCredential> registerUser() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
    return user;
  }
}
