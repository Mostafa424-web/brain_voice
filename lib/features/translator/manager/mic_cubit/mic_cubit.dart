import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'mic_states.dart';

class MicCubit extends Cubit<MicStates> {
  MicCubit() : super(InitialState());

  static MicCubit get(context) => BlocProvider.of<MicCubit>(context , listen: false);

  // static MicCubit get(context) => BlocProvider.of(context);

  // Methods for Icon Speak From TextField
  bool isSpeaking = true;
  TextEditingController textController = TextEditingController();
  final flutterTts = FlutterTts();
  void initializeTts() {
    flutterTts.setStartHandler(() {
      isSpeaking = true;
      emit(StartSpeakState());
    });
    flutterTts.setCompletionHandler(() {
      isSpeaking = false;
      emit(StopSpeakState());
    });
    flutterTts.setErrorHandler((message) {
      isSpeaking = false;
      emit(StopSpeakState());
    });
  }

   speak(context) async {
    if (textController.text.isNotEmpty) {
      await flutterTts.speak(textController.text);
    } else {
      return;
    }
  }

   stop() async {
    await flutterTts.stop();
    isSpeaking = false;
    emit(StopSpeakState());
  }
  
  // ###########################################################
}