import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/core/ui.dart';
import 'package:frontend/logic/cubits/userCubit/user_cubit.dart';
import 'package:frontend/logic/cubits/userCubit/user_state.dart';
import 'package:frontend/presentation/screens/auth/login_screen.dart';

import 'package:frontend/presentation/screens/auth/providers/signup_provider.dart';
import 'package:frontend/presentation/screens/home/home_screen.dart';
import 'package:frontend/presentation/widgets/gapwidget.dart';
import 'package:frontend/presentation/widgets/link_button.dart';
import 'package:frontend/presentation/widgets/primary_Button.dart';
import 'package:frontend/presentation/widgets/primary_textfield.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  static const String routeName = "signup";
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignupProvider>(context);
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserLoggedInState) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
            child: Form(
          key: provider.formkey,
          child: ListView(padding: const EdgeInsets.all(16), children: [
            Text(
              "Sign Up",
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
            GapWidget(),
            PrimaryTextField(
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Confirm your Password!";
                }
                if (value.trim() != provider.passwordController.text.trim()) {
                  return "Passwords do not match";
                }
                return null;
              },
              controller: provider.cpasswordController,
              labeltext: "Confirm Password",
              obsecure: false,
            ),
            GapWidget(
              height: 10,
            ),
            PrimaryButton(
                buttonText: provider.isloading ? "..." : "Create Account",
                onpress: provider.createAccount,
                buttonColor: Colors.redAccent),
            GapWidget(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an Account?",
                  style: TextStyles.body1,
                ),
                LinkButton(
                    buttonText: 'LogIn',
                    onpress: () {
                      Navigator.pushNamed(context, LoginScreen.routeName);
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
