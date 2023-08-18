import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tflite/tflite.dart';

class FilePickerPage extends StatefulWidget {
  const FilePickerPage({super.key});

  @override
  _FilePickerPageState createState() => _FilePickerPageState();
}

class _FilePickerPageState extends State<FilePickerPage> {
  String filePath = '';
  String fileType = '';

  Future<void> pickFileAndRunModel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        filePath = result.files.single.path!;
      });

      // Load the TensorFlow Lite model
      await Tflite.loadModel(
        model: 'assets/model.tflite', // Replace with your model path
        labels: 'assets/labels.txt', // Replace with your labels path
      );

      // Run inference on the selected file
      List<dynamic>? output = await Tflite.runModelOnImage(
        path: filePath,
      );

      // Get the predicted class label
      String predictedLabel = output?[0]['label'] ?? '';

      // Update the file type based on the predicted label
      setState(() {
        fileType = predictedLabel;
      });

      // Unload the TensorFlow Lite model
      Tflite.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Picker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: pickFileAndRunModel,
              child: const Text('Pick a File'),
            ),
            const SizedBox(height: 16),
            Text('Selected File: $filePath'),
            const SizedBox(height: 16),
            Text('File Type: $fileType'),
          ],
        ),
      ),
    );
  }
}