import 'package:chat_app/pages/cubit/auth_cubit/auth_cubit.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textField.dart';
import '../widgets/show_snack_bar.dart';
import 'chat_page.dart';
import 'cubit/chat_cubit/chat_cubit.dart';

class LoginPage extends StatelessWidget {
  GlobalKey<FormState> formKey = GlobalKey();

  static String id = 'LoginPage';

  String? email;
  String? password;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          isLoading = true;
        } else if (state is LoginSuccess) {
          BlocProvider.of<ChatCubit>(context).getMessages();
          Navigator.pushNamed(context, ChatPage.id, arguments: email);
          isLoading = false;
        } else if (state is LoginFailure) {
          showSnakBar(context, state.errMessage);
          isLoading = false;
        }
      },
      builder: (context, state) => ModalProgressHUD(
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
                        'Sign In',
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
                  const SizedBox(height: 15),
                  CustomForTextField(
                    obscureText: true,
                    onChanged: (data) {
                      password = data;
                    },
                    hintText: 'Enter Password',
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        BlocProvider.of<AuthCubit>(context)
                            .loginUser(email: email!, password: password!);

                        // isLoading = true;

                        // try {
                        //   UserCredential user = await loginUser();
                        //   print(user.user!.email);
                        //   showSnakBar(context, 'SignUp succesfully');
                        //   // i can send arguments in navigator it accepted object can send anything
                        //   Navigator.pushNamed(context, ChatPage.id,
                        //       arguments: email);
                        // } on FirebaseAuthException catch (e) {
                        //   if (e.code == 'user-not-found') {
                        //     print('No user found for that email.');
                        //     showSnakBar(
                        //         context, 'No user found for that email. ');
                        //   } else if (e.code == 'wrong-password') {
                        //     print('Wrong password provided for that user.');
                        //     showSnakBar(context,
                        //         'Wrong password provided for that user. ');
                        //   }
                        // } catch (e) {
                        //   print(e);
                        //   showSnakBar(
                        //       context, 'There is an error , please try again');
                        // }
                        isLoading = false;
                      } else {}
                    },
                    buttonText: 'SignIn',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'dont have an account ! ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RegisterPage.id);
                        },
                        child: Text('SignUp',
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
      ),
    );
  }

  Future<UserCredential> loginUser() async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
    return userCredential;
  }
}
