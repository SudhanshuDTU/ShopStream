import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/logic/cubits/cartCubit/cart_cubit.dart';
import 'package:frontend/logic/cubits/cartCubit/cart_state.dart';
import 'package:frontend/logic/cubits/userCubit/user_cubit.dart';
import 'package:frontend/logic/cubits/userCubit/user_state.dart';
import 'package:frontend/presentation/screens/cart/cart_screen.dart';
import 'package:frontend/presentation/screens/home/category_screen.dart';
import 'package:frontend/presentation/screens/home/profile_screen.dart';
import 'package:frontend/presentation/screens/home/userFeed_screen.dart';
import 'package:frontend/presentation/screens/splash/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = "home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> screens = const [
    UserFeedScreen(),
    CategoryScreen(),
    ProfileScreen()
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserLoggedOutState) {
          Navigator.pushReplacementNamed(context, SplashScreen.routeName);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Shop Stream",
            style: GoogleFonts.fasthand(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.height * 0.04),
          ),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () {
              Navigator.pushNamed(context, CartScreen.routeName);
            }, icon: BlocBuilder<CartCubit, CartState>(
              builder: (context, state) {
                return Badge(
                  label: Text("${state.items.length}"),
                  isLabelVisible: state is CartLoadingState ? false : true,
                  child: const Icon(CupertinoIcons.cart_fill),
                );
              },
            )),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.category), label: 'Categories'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person_fill), label: 'Profile')
            ]),
        body: screens[currentIndex],
      ),
    );
  }
}
