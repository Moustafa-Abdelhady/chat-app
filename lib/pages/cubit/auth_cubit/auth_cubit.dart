import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

 Future<void> registerUser(
      {required String email, required String password}) async {
    emit(RegisterLoading());
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      emit(RegisterSuccess());
    }on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                         emit(RegisterFailure(errMessage:'The password provided is too weak.' ));
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                        emit(RegisterFailure(errMessage: 'The account already exists for that email.'));
                        }
                      }
     on Exception catch (e) {
      emit(RegisterFailure(errMessage: 'some thing went wrong .'));
    }
  }



  Future<void> loginUser(
      {required String email, required String password}) async {
    emit(LoginLoading());
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(LoginSuccess());
    }on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            print('No user found for that email.');
                            emit(LoginFailure(errMessage:'No user found for that email' ));
                          } else if (e.code == 'wrong-password') {
                            print('Wrong password provided for that user.');
                           emit(LoginFailure(errMessage: 'Wrong password provided for that user.'));
                          }
                        } on Exception catch (e) {
      emit(LoginFailure(errMessage: 'some thing went wrong .'));
    }
  }  

}
