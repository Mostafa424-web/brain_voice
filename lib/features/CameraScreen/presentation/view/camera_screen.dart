
import 'package:brain_voice/core/utils/assets_manager.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/styles.dart';
import '../../../main/presentation/view/widgets/image_instruction.dart';
import 'package:image_picker/image_picker.dart';


class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
   _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  bool _isTakingPicture = false;
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _initializeCamera().then((value){
      setState(() {

      });
    });
    ImageViewer(
      imageProvider: ImageAssets.dialogImage,
    );
  }

  Future<void> _initializeCamera() async {
    // Get available cameras
    final cameras = await availableCameras();


    // Initialize the camera
    await _controller!.initialize();
  }

  Future<void> takePicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(source: ImageSource.camera);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: CameraPreview(
                    _controller!,
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.2,
                    top: MediaQuery.of(context).size.height * 0.2
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(124))
                  ),
                  height: 248,
                  width: 248,
                ),
                // _imageFile != null
                //     ? Container(
                //   decoration: const BoxDecoration(
                //     color: Colors.white
                //   ),
                //         height: MediaQuery.of(context).size.height,
                //         child: Image.file(File(_imageFile!.path)))
                //     : Container(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: IconButton(
                      onPressed: _isTakingPicture
                          ? null
                          : () async {
                              setState(() {
                                _isTakingPicture = true;
                              });
                              try {
                                // Take the picture
                                final image = await _controller!.takePicture();
                                // Display the image
                                setState(() {
                                  _imageFile = image;
                                });
                              } catch (e) {
                                print(e);
                              }
                              setState(() {
                                _isTakingPicture = false;
                              });
                            },
                      icon: Container(
                        width: 80,
                        height: 80,
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          child: Icon(
                            Icons.camera_alt,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: _imageFile != null
          ? FloatingActionButton(
              onPressed: () {
                // Clear the image and go back to the camera
                setState(() {
                  _imageFile = null;
                });
              },
              child: const Icon(
                Icons.arrow_back,
                size: 35,
              ),
            )
          : Container(
        width: 100,
        height: 25,
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width * 0.35,
            vertical: 75),
        alignment: Alignment.bottomCenter,
        decoration: const BoxDecoration(
            color: Colors.white
        ),
        child:  Center(
          child: Text(
            'Hi',
            // 'Fine',
            style: Styles.textStyle16,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
