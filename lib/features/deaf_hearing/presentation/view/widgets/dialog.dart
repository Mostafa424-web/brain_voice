import 'dart:io';

import 'package:brain_voice/features/connection/presentation/view/connectionScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:ndialog/ndialog.dart';

import '../../../../../core/utils/styles.dart';
import '../../../../main/presentation/view/main_screen.dart';
import '../../../manager/connection_cubit.dart';
import '../../../manager/connection_states.dart';

class ArduinoConnectDialog extends StatefulWidget {
  const ArduinoConnectDialog({super.key});

  @override
  _ArduinoConnectDialogState createState() => _ArduinoConnectDialogState();
}

class _ArduinoConnectDialogState extends State<ArduinoConnectDialog> {
  @override
  void initState() {
    super.initState();
  }

  String statusText = "Status Text";
  bool isConnected = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConnectionCubit(),
      child: BlocBuilder<ConnectionCubit, ConnectionStates>(
          builder: (context, state) {
        return NAlertDialog(
          dialogStyle: DialogStyle(
            titleDivider: true,
            titlePadding: const EdgeInsets.symmetric(vertical: 12),
              contentPadding: const EdgeInsets.symmetric(vertical: 12)
          ),
          title: const Center(
            child: Text(
              "Connect To Gloves",
              style: TextStyle(
                color: Color(0xffCC6AEB),
              ),
            ),
          ),
          // content: Text("This is NAlertDialog's content"),
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  await ConnectionCubit.get(context).mqttConnect();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MainScreen(
                    hearing: true,),),);
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => const ConnectionScreen()));
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                      color: Color(0xffCC6AEB),
                    ),
                    child: Text(
                      "Connect",
                      style: Styles.textStyle16.copyWith(color: Colors.white),
                    ))),
            TextButton(
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                        border: Border.all(
                          color: const Color(0xffCC6AEB),
                        )),
                    child: Text(
                      "Close",
                      style:
                          Styles.textStyle16.copyWith(color: const Color(0xffCC6AEB)),
                    )),
                onPressed: () => Navigator.pop(context)),
          ],
        );
      }),
    );
  }

  Future mqttConnect() async {
    final client = MqttServerClient(
        'a1jtktwatyl5gb-ats.iot.us-east-1.amazonaws.com',
        'iotconsole-89c88826-6e10-49ea-bc62-e7b24c4e93d0');
    final securityContext = SecurityContext.defaultContext;

    ByteData rootCA =
        await rootBundle.load('assets/Amazon trust services endpoint.pem');
    ByteData deviceCert =
        await rootBundle.load('assets/Device certificate.pem.crt');
    ByteData privateKey = await rootBundle.load('assets/Private key file.key');
    SecurityContext context = SecurityContext.defaultContext;
    context.setClientAuthoritiesBytes(rootCA.buffer.asUint8List());
    context.useCertificateChainBytes(deviceCert.buffer.asUint8List());
    context.usePrivateKeyBytes(privateKey.buffer.asUint8List());

// Configure MQTT client with security context
    client.securityContext = securityContext;
    client.secure = true;
    client.logging(on: true);
    client.port = 8883;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.pongCallback = pong;

    await client.connect();
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print("Connected to AWS Successfully!");
    } else {
      return false;
    }
    client.subscribe('esp32/sub', MqttQos.atMostOnce);

    final message =
        MqttClientPayloadBuilder().addString('your-message').payload;
    client.publishMessage('esp32/pub', MqttQos.exactlyOnce, message!);
  }

  void setStatus(String content) {
    setState(() {
      statusText = content;
    });
  }

  void onConnected() {
    setStatus("Client connection was successful");
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ConnectionScreen()));
  }

  void onDisconnected() {
    setStatus("Client Disconnected");
    isConnected = false;
  }

  void pong() {
    print('Ping response client callback invoked');
  }
}
