import 'dart:io';

import 'package:brain_voice/features/deaf_hearing/manager/connection_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../../connection/presentation/view/connectionScreen.dart';

class ConnectionCubit extends Cubit<ConnectionStates> {
  ConnectionCubit() : super(InitialState());

  static ConnectionCubit get(context) => BlocProvider.of<ConnectionCubit>(context);

  String statusText = "Status Text";
  bool isConnected = false;
  final client = MqttServerClient('a1jtktwatyl5gb-ats.iot.us-east-1.amazonaws.com',
      'iotconsole-89c88826-6e10-49ea-bc62-e7b24c4e93d0');
  Future mqttConnect() async {
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
    client.onSubscribed = onSubscribed;

    final connMessage = MqttConnectMessage()
        .authenticateAs('username', 'password')
        .keepAliveFor(60)
        .withWillTopic('esp32/sub')
        .withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;

    await client.connect();
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print("Connected to AWS Successfully!");
    } else {
      return false;
    }
    client.subscribe('esp32/sub', MqttQos.atMostOnce);

    final message = MqttClientPayloadBuilder()
        .addString('your-message')
        .payload;
    client.publishMessage('esp32/pub', MqttQos.exactlyOnce, message!);
    print("publish Message is ${message.toString()}");
  }

  void setStatus(String content) {
      statusText = content;
    emit(UpdateSatus());
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

  void onSubscribed(String topic) {
    client.subscribe('esp32/sub', MqttQos.atMostOnce);
    print('Subscribed topic: $topic');
  }

}