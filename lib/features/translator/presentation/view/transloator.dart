import 'package:brain_voice/core/utils/assets_manager.dart';
import 'package:brain_voice/features/translator/presentation/view/widgets/drop_down.dart';
import 'package:brain_voice/features/translator/presentation/view/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../main/manager/app_cubit/app_cubit.dart';


class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({Key? key}) : super(key: key);

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _controller.text = _lastWords;
    });
  }
  var textField = '';

  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  ImageAssets.character2Image,
                  height: MediaQuery.of(context).size.height * 0.8,
                ),
                const DropDownIcon(),
                Row(
                  children: [
                    InputField(controller: _controller, onChange: (String? value ) {
                      onChangeText(context, value!);
                    },
                      validate: (String? value){
                        if (AppCubit.get(context).formKey.currentState!.validate()) {
                          AppCubit.get(context).formKey.currentState!.save();
                          onChangeText(context, value!);
                        }
                      },),
                    MaterialButton(
                      onPressed: _speechToText.isNotListening
                          ? _startListening
                          : _stopListening,
                      child: Image.asset(
                        ImageAssets.micImage,
                        width: 36,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  checkValueInJsonData(value) {
    var cubit = AppCubit.get(context);
    for (var i = 0; i < cubit.jsonData.length; i++) {
      if (value == cubit.jsonData[i]["id"]) {
        setState(() {
           textField = cubit.jsonData[i]["animate_assets"];
          print(textField);
          print(cubit.jsonData[i]["animate_assets"]);
        });
      }
    }
  }

  void onChangeText(context, String value) {
    textField = value;
    checkValueInJsonData(value);
  }
}

