import 'dart:convert';

import 'package:brain_voice/core/utils/mqtt_conntioon.dart';
import 'package:brain_voice/features/CameraScreen/presentation/view/camera_screen.dart';
import 'package:brain_voice/features/connection/presentation/view/connectionScreen.dart';
import 'package:brain_voice/features/translator/presentation/view/transloator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../../../history/presentation/view/history_screen.dart';
import '../../../languages/presentation/view/languages.dart';
import '../../../settings/presentation/views/settings_screen.dart';
import 'package:flutter/services.dart' as root_bundle;

import '../../model/data_model.dart';
import 'app_states.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(InitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  List jsonData = [];
  String textForInput = '';
  int index = 0;
  var formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();

  Future<String> _loadJsonData() async {
    return await rootBundle.loadString('assets/data_app.json');
  }

  Future<List<DataModel>> getPersonData() async {
    String jsonString = await _loadJsonData();
    List<dynamic> jsonData = jsonDecode(jsonString);
    List<DataModel> persons = jsonData.map((json) => DataModel.fromJson(json)).toList();

    // Print the data to the terminal
    // persons.forEach((data) {
    //   print('Name: ${data.id}, Age: ${data.animateVideo}');
    // });

    return persons;
  }
  Future<List<DataModel>?>? readJson() async {
    try {
      final String response =
      await root_bundle.rootBundle.loadString('assets/data_app.json');
      final data = await json.decode(response);
      jsonData = data["items"];
      print(jsonData.length);
      emit(LoadedJsonState());
    } on Exception catch (e) {
      print(e.toString());
    }
    // return data.map((e) => DataModel.fromJson(e)).toList();
  }

  List<PersistentBottomNavBarItem> navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.camera_alt),
        title: ("Recognition"),
        activeColorPrimary: CupertinoColors.systemIndigo,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.translate),
        title: ("Translator"),
        activeColorPrimary: CupertinoColors.systemIndigo,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.camera),
        title: ("History"),
        activeColorPrimary: CupertinoColors.systemIndigo,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.settings),
        title: ("Settings"),
        activeColorPrimary: CupertinoColors.systemIndigo,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  List<Widget> screensHearing = [
const ConnectionScreen(),
    const AvailableLanguage(),
    const HistoryScreen(),
    const SettingsScreen(),
  ];

  List<Widget> screensDeaf = [
     const CameraScreen(),
    const AvailableLanguage(),
    const HistoryScreen(),
    const SettingsScreen(),
  ];
  void navigateTo(context, widget) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => widget,
        ),
      );

  void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (Route<dynamic> route) => false);
  buildSizedBox(double height) {
    return SizedBox(
      height: height,
    );
  }
}
