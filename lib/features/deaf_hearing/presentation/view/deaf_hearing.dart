import 'package:brain_voice/app_constance.dart';
import 'package:brain_voice/core/utils/styles.dart';
import 'package:brain_voice/features/deaf_hearing/presentation/view/widgets/dialog.dart';
import 'package:brain_voice/features/main/presentation/view/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/mqtt_conntioon.dart';

class DeafHearing extends StatelessWidget {
  const DeafHearing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            Image.asset(
              ImageAssets.characterImage,
              height: MediaQuery.of(context).size.height * 0.6,
            ),
            Container(
              width: double.infinity,
              height: 3,
                color: const Color(0xff0E2C66).withOpacity(0.3),
            ),
            const SizedBox(
              height: 46,
            ),
            Text(
              'Are you use Glove OR No?',
              style: GoogleFonts.outfit(
                textStyle: Styles.textStyle24
              ),
            ),
            const SizedBox(
              height: 34,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 48,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8)
              ),
              child: ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    AppConstance.primaryColor,
                  ),
                ),
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const MQTTClient()),);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MainScreen(
                    hearing: false,),),);
                },
                child: const Text('Visual Aid'),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 48,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(color: AppConstance.primaryColor, spreadRadius: 1),
                ],
                borderRadius: BorderRadius.circular(8)
              ),
              child: ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Color(0xffFFFFFF),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ArduinoConnectDialog()));
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const MainScreen(
                  // hearing: true,),),);
                },
                child: Text('Glove User',
                style: Styles.textStyle16.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppConstance.primaryColor
                ),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

