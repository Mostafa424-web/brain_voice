import 'dart:convert';
import 'dart:io';

import 'package:brain_voice/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:ndialog/ndialog.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:typed_data/src/typed_buffer.dart';

import '../../app_constance.dart';
import '../../features/connection/presentation/view/widgets/video_player.dart';
import '../../features/main/manager/app_cubit/app_cubit.dart';
import '../../features/main/model/data_model.dart';
import '../../features/main/presentation/view/main_screen.dart';
import '../../features/translator/presentation/view/widgets/drop_down.dart';
import '../../features/translator/presentation/view/widgets/input_field.dart';
import 'assets_manager.dart';

class MQTTClient extends StatefulWidget {
  const MQTTClient({Key? key}) : super(key: key);

  @override
  _MQTTClientState createState() => _MQTTClientState();
}

class _MQTTClientState extends State<MQTTClient> {
  String statusText = "Status Text";
  bool isConnected = false;
  TextEditingController idTextController = TextEditingController();

  final MqttServerClient client = MqttServerClient(
      'a1jtktwatyl5gb-ats.iot.us-east-1.amazonaws.com',
      'iotconsole-89c88826-6e10-49ea-bc62-e7b24c4e93d0');

  @override
  void dispose() {
    idTextController.dispose();
    super.dispose();
  }

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  String textField = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
    print(AppCubit().jsonData);
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
    var formKey = GlobalKey<FormState>();

  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    final bool hasShortWidth = width < 600;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [ body(hasShortWidth)],
        ),
      ),
    );
  }


  Widget body(bool hasShortWidth) {
    return Expanded(
      flex: 20,
      child: Container(
        child: hasShortWidth
            ? Column(
                children: [bodyMenu(), Expanded(child: bodySteam())],
              )
            : Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: bodyMenu(),
                  ),
                  Expanded(
                    flex: 8,
                    child: bodySteam(),
                  )
                ],
              ),
      ),
    );
  }

  Widget bodyMenu() {
    return isConnected ? Container() : Center(
      child: Container(
        color: Colors.black26,
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2, vertical: 10),
              child: GestureDetector(
                onTap: _connect,
                child: const Text('Connect To Gloves',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget bodySteam() {
    return Container(
      color: Colors.white60,
      child: StreamBuilder(
        stream: client.updates,
        builder: (context, snapshot)
    {
      if (!snapshot.hasData) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: ListView(
                children: [
                  textField.isEmpty ? SizedBox(
                    height: isConnected ? MediaQuery.sizeOf(context).height * 0.77 : MediaQuery.sizeOf(context).height * 0.68,
                    child: const Center(
                      child: Text(
                        'Write To Make A Video',
                        style: Styles.textStyle24,
                      ),
                    ),
                  ) : VideoPlayerWidget(
                    videoUrl: textField,
                  ),
                  // Container(
                  //   height: 30,
                  //   margin: const EdgeInsets.symmetric(horizontal: 150),
                  //   decoration: BoxDecoration(
                  //       color: Colors.black.withOpacity(0.5)),
                  //   // child: Container(),
                  //   child: FutureBuilder(
                  //       future: AppCubit.get(context).getPersonData(),
                  //       builder: (context, snapshot) {
                  //         if (snapshot.hasData) {
                  //           final data = snapshot.data![1];
                  //           return Center(
                  //             child: Text(
                  //               data.id,
                  //               style: const TextStyle(
                  //                   color: Colors.white),
                  //             ),
                  //           );
                  //         } else if (snapshot.hasError) {
                  //           print(snapshot.error);
                  //           return Center(
                  //             child: Text('Error: ${snapshot.error}'),
                  //           );
                  //         } else {
                  //           return const Center(
                  //             child: CircularProgressIndicator(),
                  //           );
                  //         }
                  //       }),
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  const DropDownIcon(),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 22),
                          child: Form(
                            key: formKey,
                            child: TextFormField(
                              controller: _controller,
                              onChanged: (String? value) {
                                if (value!.isNotEmpty) {
                                onChangeText(context, value);
                                }  else if (value.isEmpty){
                                  setState(() {
                                    textField = '';
                                  });
                                }
                              },
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'please enter Your Text';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Type to translate'.padLeft(22),
                                hintStyle: GoogleFonts.outfit(
                                  textStyle: Styles.textStyle16.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xffB9C0C9),
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.send,
                                    color: AppConstance.primaryColor,
                                  ),
                                ),
                                contentPadding:
                                const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 15),
                                fillColor: const Color(0xffF9F9F9),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppConstance.primaryColor,
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10))),
                                filled: true,
                                prefixIcon: Container(
                                  decoration: const BoxDecoration(
                                      color: AppConstance.primaryColor),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                          const MainScreen(hearing: false),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                focusColor: AppConstance.primaryColor,
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12))),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // InputField(controller: _controller),
                      MaterialButton(
                        // onPressed: () {
                        //   if (formKey.currentState!.validate()) {
                        //     formKey.currentState!.save();
                        //     print('saved');
                        //     return;
                        //   }
                        // },
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
        );

      } else {
      final mqttReceivedMessages =
          snapshot.data;
      // print(mqttReceivedMessages);

      final recMess =
          mqttReceivedMessages![0].payload;
      print("Recieved Message is : $recMess");
      _onDataReceived(recMess);
        return Center(
          child:  Text(
            'Connect Gloves To Server',
            style: Styles.textStyle24.copyWith(
                fontWeight: FontWeight.bold
            ),
          ),
        );

    }
        },
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
  void _onDataReceived(MqttMessage message) {
    if (message is MqttPublishMessage) {
      final payload = message.payload.message;
      String
        stringData = String.fromCharCodes(payload);

      print('Received data: $stringData');
    }
  }

  _connect() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        blur: 0,
        dialogTransitionType: DialogTransitionType.Shrink,
        dismissable: false);
    progressDialog.setLoadingWidget(const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.red),
    ));
    progressDialog.setMessage(
        const Text("Please Wait, Connecting to AWS IoT MQTT Broker"));
    progressDialog.setTitle(const Text("Connecting"));
    progressDialog.show();

    isConnected =
        await mqttConnect('iotconsole-89c88826-6e10-49ea-bc62-e7b24c4e93d0');
    progressDialog.dismiss();
  }

  _disconnect() {
    client.disconnect();
  }

  Future<bool> mqttConnect(String uniqueId) async {
    setStatus("Connecting MQTT Broker");

    // After adding your certificates to the pubspec.yaml, you can use Security Context.
    //
    ByteData rootCA =
        await rootBundle.load('assets/Amazon trust services endpoint.pem');
    ByteData deviceCert =
        await rootBundle.load('assets/Device certificate.pem.crt');
    ByteData privateKey = await rootBundle.load('assets/Private key file.key');

    SecurityContext context = SecurityContext.defaultContext;
    context.setClientAuthoritiesBytes(rootCA.buffer.asUint8List());
    context.useCertificateChainBytes(deviceCert.buffer.asUint8List());
    context.usePrivateKeyBytes(privateKey.buffer.asUint8List());

    client.securityContext = context;

    client.logging(on: true);
    client.port = 8883;
    client.secure = true;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.pongCallback = pong;

    final MqttConnectMessage connMess =
        MqttConnectMessage().withClientIdentifier(uniqueId).startClean();
    client.connectionMessage = connMess;

    await client.connect();
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      debugPrint("Connected to AWS Successfully!");

    } else {
      return false;
    }

    const topic = 'esp32/pub';
    client.subscribe(topic, MqttQos.atMostOnce);

    final builder = MqttClientPayloadBuilder().addString('Hello from Flutter!').payload;
    client.publishMessage('esp32/sub', MqttQos.atMostOnce , builder!);
    return true;
  }

  void setStatus(String content) {
    setState(() {
      statusText = content;
    });
  }

  void onConnected() {
    setStatus("Client connection was successful");
  }

  void onDisconnected() {
    setStatus("Client Disconnected");
    isConnected = false;
  }

  void pong() {
    print('Ping response client callback invoked');
  }
}
