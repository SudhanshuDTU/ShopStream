import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/ui.dart';
import 'package:frontend/data/models/user/user_model.dart';
import 'package:frontend/logic/cubits/userCubit/user_cubit.dart';
import 'package:frontend/logic/cubits/userCubit/user_state.dart';
import 'package:frontend/presentation/widgets/gapwidget.dart';
import 'package:frontend/presentation/widgets/primary_Button.dart';
import 'package:frontend/presentation/widgets/primary_textfield.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  static const routeName = 'editProfile';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: SafeArea(child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.redAccent,
              ),
            );
          }
          if (state is UserErrorState) {
            return Center(child: Text(state.message));
          }
          if (state is UserLoggedInState) {
            return editProfile(state.userModel);
          }
          return const Center(
            child: Text("An Error Occured!"),
          );
        },
      )),
    );
  }

  Widget editProfile(UserModel user) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          "Personal Details",
          style: TextStyles.body1.copyWith(fontWeight: FontWeight.bold),
        ),
        GapWidget(),
        PrimaryTextField(
          labeltext: 'Full Name',
          initialValue: user.fullName,
          onchanged: (value) {
            user.fullName = value;
          },
        ),
        GapWidget(),
        PrimaryTextField(
          labeltext: "Phone Number",
          initialValue: user.phoneNumber,
          onchanged: (value) {
            user.phoneNumber = value;
          },
        ),
        GapWidget(),
        Text(
          "Address",
          style: TextStyles.body1.copyWith(fontWeight: FontWeight.bold),
        ),
        GapWidget(),
        PrimaryTextField(
          labeltext: "Address",
          initialValue: user.address,
          onchanged: (value) {
            user.address = value;
          },
        ),
        GapWidget(),
        PrimaryTextField(
          labeltext: "City",
          initialValue: user.city,
          onchanged: (value) {
            user.city = value;
          },
        ),
        GapWidget(),
        PrimaryTextField(
          labeltext: "State",
          initialValue: user.state,
          onchanged: (value) {
            user.state = value;
          },
        ),
        GapWidget(),
        PrimaryButton(
            buttonText: 'Save',
            onpress: () async {
              bool success =
                  await BlocProvider.of<UserCubit>(context).updateUser(user);
              if (success) {
                Navigator.pop(context);
              }
            },
            buttonColor: Colors.blueAccent)
      ],
    );
  }
}
