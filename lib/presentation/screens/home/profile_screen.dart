import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/ui.dart';
import 'package:frontend/data/models/user/user_model.dart';
import 'package:frontend/logic/cubits/userCubit/user_cubit.dart';
import 'package:frontend/logic/cubits/userCubit/user_state.dart';
import 'package:frontend/presentation/screens/order/myOrdersScreen.dart';
import 'package:frontend/presentation/screens/user/editProfile_screen.dart';
import 'package:frontend/presentation/widgets/gapwidget.dart';
import 'package:frontend/presentation/widgets/link_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
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
          return userProfile(state.userModel);
        }
        return const Center(
          child: Text("An Error Occured!"),
        );
      },
    );
  }

  Widget userProfile(UserModel user) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${user.fullName}",
              style: TextStyles.heading3,
            ),
            GapWidget(
              height: 8,
            ),
            Text("${user.email}", style: TextStyles.body2),
            GapWidget(
              height: 8,
            ),
            Text(
              "${user.address},${user.city},${user.state}",
              style: TextStyles.body2.copyWith(color: Colors.blueAccent),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            LinkButton(
                buttonText: 'Edit Profile',
                onpress: () {
                  Navigator.pushNamed(context, EditProfileScreen.routeName);
                },
                TextColor: Colors.teal),
          ],
        ),
        const Divider(),
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, MyOrderScreen.routeName);
          },
          leading: const Icon(CupertinoIcons.archivebox_fill),
          title: Text(
            "My Orders",
            style: TextStyles.body2.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        ListTile(
          onTap: () {
            BlocProvider.of<UserCubit>(context).signOut();
          },
          leading: const Icon(Icons.exit_to_app),
          title: Text(
            "Sign Out",
            style: TextStyles.body1
                .copyWith(color: Colors.red, fontWeight: FontWeight.w500),
          ),
        )
      ],
    );
  }
}
