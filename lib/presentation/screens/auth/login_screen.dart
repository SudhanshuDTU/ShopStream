import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/ui.dart';
import 'package:frontend/logic/cubits/userCubit/user_cubit.dart';
import 'package:frontend/logic/cubits/userCubit/user_state.dart';
import 'package:frontend/presentation/screens/auth/providers/login_provider.dart';
import 'package:frontend/presentation/screens/auth/signup_screen.dart';
import 'package:frontend/presentation/screens/splash/splash_screen.dart';
import 'package:frontend/presentation/widgets/gapwidget.dart';
import 'package:frontend/presentation/widgets/link_button.dart';
import 'package:frontend/presentation/widgets/primary_Button.dart';
import 'package:frontend/presentation/widgets/primary_textfield.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = "login";
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context);
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserLoggedInState) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacementNamed(context, SplashScreen.routeName);
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
            child: Form(
          key: provider.formkey,
          child: ListView(padding: const EdgeInsets.all(16), children: [
            Text(
              "LogIn",
              style: TextStyles.heading1,
            ),
            GapWidget(
              height: 40,
            ),
            provider.error != ""
                ? Text(
                    provider.error,
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w700),
                  )
                : const SizedBox(),
            GapWidget(),
            PrimaryTextField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Email Address is Required";
                  }
                  if (!EmailValidator.validate(value.trim())) {
                    return "Invalid Email Address";
                  }
                  return null;
                },
                controller: provider.emailController,
                labeltext: "Email Address"),
            GapWidget(),
            PrimaryTextField(
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Password is Required!";
                }
                return null;
              },
              controller: provider.passwordController,
              labeltext: "Password",
              obsecure: true,
            ),
            GapWidget(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                LinkButton(
                    buttonText: 'Forget Password?',
                    onpress: () {},
                    TextColor: Colors.teal)
              ],
            ),
            GapWidget(
              height: 10,
            ),
            PrimaryButton(
                buttonText: provider.isloading ? "..." : "LogIn",
                onpress: provider.login,
                buttonColor: Colors.redAccent),
            GapWidget(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an Account?",
                  style: TextStyles.body1,
                ),
                LinkButton(
                    buttonText: 'Create Account',
                    onpress: () {
                      Navigator.pushNamed(context, SignupScreen.routeName);
                    },
                    TextColor: Colors.blue)
              ],
            )
          ]),
        )),
      ),
    );
  }
}
