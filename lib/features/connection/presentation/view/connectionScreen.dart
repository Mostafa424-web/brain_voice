import 'dart:convert';

import 'package:brain_voice/core/utils/assets_manager.dart';
import 'package:brain_voice/features/connection/presentation/view/widgets/video_player.dart';
import 'package:brain_voice/features/deaf_hearing/manager/connection_cubit.dart';
import 'package:brain_voice/features/main/manager/app_cubit/app_cubit.dart';
import 'package:brain_voice/features/main/model/data_model.dart';
import 'package:brain_voice/features/translator/presentation/view/widgets/drop_down.dart';
import 'package:brain_voice/features/translator/presentation/view/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:typed_data/src/typed_buffer.dart';

import '../../../../core/utils/styles.dart';
import '../../../deaf_hearing/manager/connection_states.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({Key? key}) : super(key: key);

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  String textField = '';
  @override
  void initState() {
    super.initState();
    _initSpeech();
    AppCubit.get(context).readJson();
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

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _controller.text = _lastWords;
    });
  }

  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ConnectionCubit>(
        create: (context) => ConnectionCubit(),
        child: BlocBuilder<ConnectionCubit, ConnectionStates>(
            builder: (context, state) {
          return StreamBuilder(
            stream: ConnectionCubit.get(context).client.updates,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: ListView(
                        controller: AppCubit.get(context).scrollController,
                        children: [
                          textField.isEmpty
                              ? SizedBox(
                                  height: ConnectionCubit.get(context)
                                          .isConnected
                                      ? MediaQuery.sizeOf(context).height * 0.70
                                      : MediaQuery.sizeOf(context).height *
                                          0.75,
                                  child: const Center(
                                    child: Text(
                                      'Write To Make A Video',
                                      style: Styles.textStyle24,
                                    ),
                                  ),
                                )
                              : VideoPlayerWidget(
                                  videoUrl: textField,
                                ),
                          const SizedBox(
                            height: 20,
                          ),
                          const DropDownIcon(),
                          Row(
                            children: [
                              Form(
                                key: formKey,
                                child: InputField(
                                  controller: _controller,
                                  onChange: (String? value) {
                                    onChangeText(context, value!);
                                  },
                                  validate: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();
                                  }
                                },
                                // onPressed: _speechToText.isNotListening
                                //     ? _startListening
                                //     : _stopListening,
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
                );
              } else {
                // final mqttReceivedMessages = snapshot.data;
                // // print(mqttReceivedMessages);
                //
                // final recMess = mqttReceivedMessages![0].payload;
                // print("Recieved Message is : $recMess");
                return Center(
                  child: Text(
                    'Connect Gloves To Server',
                    style: Styles.textStyle24
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                );
              }
            },
          );
        }),
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
