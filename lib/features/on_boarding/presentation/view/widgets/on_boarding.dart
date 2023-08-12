import 'dart:io';

import 'package:brain_voice/core/utils/assets_manager.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:tflite/tflite.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../deaf_hearing/presentation/view/deaf_hearing.dart';

const kModelName = "converted_model";

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key, required this.title, required this.subTitle}) : super(key: key);

  final String title, subTitle;

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
@override
  void initState() {
    super.initState();
    initWithLocalModel();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            ImageAssets.characterImage,
            height: MediaQuery.of(context).size.height * 0.6,
          ),
          Center(
            child: Text(
              widget.title,
              style: GoogleFonts.outfit(textStyle: Styles.textStyle16),
            ),
          ),
          const SizedBox(
            height: 34,
          ),
          Center(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                widget.subTitle,
                style: GoogleFonts.outfit(
                    textStyle:
                        Styles.textStyle16.copyWith(fontWeight: FontWeight.w400)),
              ),
            ),
          ),
          const SizedBox(
            height: 99,
          ),
          Expanded(
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DeafHearing()));
                  },
                  child: Text(
                    'skip',
                    style: GoogleFonts.outfit(
                        textStyle: Styles.textStyle16.copyWith(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff582FFF))),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(right: 24),
                    alignment: Alignment.centerRight,
                    child: CircleAvatar(
                      backgroundColor: const Color(0xff582FFF),
                      child: IconButton(
                        icon: const Icon(
                          Icons.navigate_next_outlined,
                          color: Color(0xffFFFFFF),
                        ), onPressed: ()async{
                        final _model = await FirebaseModelDownloader.instance
                            .getModel(kModelName,
                            FirebaseModelDownloadType.latestModel);
                        setState(() {
                          model = _model;
                        });
                        if (model != null) {
                          print('${model!.size}');
                          print(model!.name);
                          print('${model!.file}');
                        }
                      },
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
  Future<String?> loadModel() async {
    Tflite.close();
    try {
      String res;
      res = (await Tflite.loadModel(
        model: "assets/converted_model.tflite",
        labels: "assets/file.txt",
        isAsset: true,
      ))!;
      print(res);
    } on PlatformException catch(e) {
      print('Failed to load model. ${e.toString()}');
    }
  }
FirebaseCustomModel? model;

/// Initially get the lcoal model if found, and asynchronously get the latest one in background.
initWithLocalModel() async {
  final _model = await FirebaseModelDownloader.instance.getModel(
      kModelName, FirebaseModelDownloadType.localModelUpdateInBackground);

  setState(() {
    model = _model;
  });
  print(model!.hash);
  print(model!.size);
  print(model!.file);
  print(model!.name);
}

}
