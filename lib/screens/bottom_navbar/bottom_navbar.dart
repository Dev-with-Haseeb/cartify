import 'package:cartify/screens/cart_screen/cart_screen.dart';
import 'package:cartify/screens/home_screen/home_screen.dart';
import 'package:cartify/screens/products_screen/products_screen.dart';
import 'package:cartify/screens/profile_screen/profile_screen.dart';
import 'package:cartify/widgets/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key, this.screenIndex});

  final int? screenIndex;

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {

  late final PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(
      initialIndex: widget.screenIndex ?? 0,
    );
  }

  List<Widget> _buildScreens() {
    return [
      const HomeScreen(),
      const ProductsScreen(),
      const CartScreen(),
      const ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.house_fill),
        title: "Home",
        activeColorPrimary: AppColors.mainColor,
        inactiveColorPrimary: Colors.grey,
        activeColorSecondary: AppColors.mainColor,
        iconSize: 24,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.sell),
        title: "Products",
        activeColorPrimary: AppColors.mainColor,
        inactiveColorPrimary: Colors.grey,
        activeColorSecondary: AppColors.mainColor,
        iconSize: 24,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.shopping_bag),
        title: "Cart",
        activeColorPrimary: AppColors.mainColor,
        inactiveColorPrimary: Colors.grey,
        activeColorSecondary: AppColors.mainColor,
        iconSize: 24,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.profile_circled),
        title: "Profile",
        activeColorPrimary: AppColors.mainColor,
        inactiveColorPrimary: Colors.grey,
        activeColorSecondary: AppColors.mainColor,
        iconSize: 24,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineToSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      navBarHeight: 70,
      padding: const EdgeInsets.all(8.0),
      navBarStyle: NavBarStyle.style3,
    ));
  }
}
