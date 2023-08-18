
import 'package:flutter/material.dart';

class MyModelScreen extends StatefulWidget {
  @override
  _MyModelScreenState createState() => _MyModelScreenState();
}

class _MyModelScreenState extends State<MyModelScreen> {
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    // final modelPath = await _downloadModelFromFirebase();
    // await Tflite.loadModel(model: 'assets/converted_model.tflite');
    setState(() {
      _isLoaded = true;
    });
  }

  // Future<TaskSnapshot> _downloadModelFromFirebase() async {
  //   final storage = FirebaseStorage.instance;
  //   final ref = storage.ref('assets/converted_model.tflite');
  //   final file = await ref.writeToFile(File('converted_model.tflite'));
  //   return file;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Model'),
      ),
      body: Center(
        child: _isLoaded
            ? Text('Model loaded successfully!')
            : CircularProgressIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    // Tflite.close();
    super.dispose();
  }
}