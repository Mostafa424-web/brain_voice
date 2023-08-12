import 'package:brain_voice/app_constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/utils/assets_manager.dart';
import '../../../../../on_boarding/presentation/view/main_on_boarding.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({Key? key}) : super(key: key);

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slidingAnimation;

  @override
  void initState() {
    super.initState();

    initSlidingAnimation();
    navigateToHome();
  }

  void navigateToHome() {
    Future.delayed(const Duration(seconds: 2), () {
      Get.to(() => const MainOnBoarding(),
          transition: Transition.fade,
          duration: AppConstance.kTransitionDuration);
    });
  }

  void initSlidingAnimation() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(minutes: 1));
    slidingAnimation =
        Tween<Offset>(begin: const Offset(0, 2), end: Offset.zero)
            .animate(animationController);

    animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        ImageAssets.splashLogo,
        width: MediaQuery.of(context).size.width / 0.5,
        height: MediaQuery.of(context).size.height * 0.2,
      ),
    );
  }
}
