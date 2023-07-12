import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/logic/cubits/userCubit/user_cubit.dart';
import 'package:frontend/logic/cubits/userCubit/user_state.dart';

class LoginProvider with ChangeNotifier {
  final BuildContext context;
  LoginProvider(this.context) {
    listenUserCubit();
  }
  bool isloading = false;
  String error = "";
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  StreamSubscription? streamSubscription;

  void listenUserCubit() {
    print("listening to userstate");
    streamSubscription =
        BlocProvider.of<UserCubit>(context).stream.listen((Userstate) {
      if (Userstate is UserLoadingState) {
        isloading = true;
        error = "";
        notifyListeners();
      } else if (Userstate is UserErrorState) {
        isloading = false;
        error = Userstate.message;
        notifyListeners();
      } else {
        isloading = false;
        error = "";
        notifyListeners();
      }
    });
  }

  void login() async {
    if (!formkey.currentState!.validate()) {
      return;
    }
    BlocProvider.of<UserCubit>(context).signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    streamSubscription?.cancel();
    super.dispose();
  }
}
