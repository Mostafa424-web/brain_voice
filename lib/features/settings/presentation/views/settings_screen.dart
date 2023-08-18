import 'package:brain_voice/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 74.0, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About Us',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
             SizedBox(
               height: 20,
             ),
             ListTile(
              title: Text('Faq',style: GoogleFonts.outfit(
                  textStyle: Styles.textStyle16
              ),),
              leading: const Icon(Icons.question_answer),
            ),
             ListTile(
              title: Text('Privacy Policy',style: GoogleFonts.outfit(
              textStyle: Styles.textStyle16
              ),),
              leading: const Icon(Icons.privacy_tip_outlined),
            ),
             ListTile(
              title: Text('Contact Us',style: GoogleFonts.outfit(
              textStyle: Styles.textStyle16
              ),),
              leading: const Icon(Icons.contact_mail_sharp),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: (){},
              child: const Text(
                'Other',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
             ListTile(
              title: Text('Share',style: GoogleFonts.outfit(
              textStyle: Styles.textStyle16
              ),),
              leading: const Icon(Icons.share),
            ),
             ListTile(
              title: Text('Get The Latest Version',
              style: GoogleFonts.outfit(
                textStyle: Styles.textStyle16
              ),),
              leading: const Icon(Icons.assignment_late_sharp),
            ),
          ],
        ),
      ),
    );
  }

  // Future loadModel() async {
  //   Tflite.close();
  //   try {
  //     String res;
  //         res = (await Tflite.loadModel(
  //           model: "assets/converted_model.tflite",
  //         ))!;
  //     print(res);
  //   } on PlatformException {
  //     print('Failed to load model.');
  //   }
  // }
}