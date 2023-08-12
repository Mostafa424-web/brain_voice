import 'package:brain_voice/features/main/manager/app_cubit/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../manager/app_cubit/app_cubit.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key, required this.hearing}) : super(key: key);
  final bool hearing;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context , state) {
        return PersistentTabView(
          context,
          screens: hearing ? AppCubit.get(context).screensHearing : AppCubit.get(context).screensDeaf,
          items: AppCubit.get(context).navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: Colors.white,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(10.0),
            colorBehindNavBar: Colors.white,
          ),
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          itemAnimationProperties: const ItemAnimationProperties(
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation(
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: NavBarStyle.style11,
        );
      }
    );
  }
}

