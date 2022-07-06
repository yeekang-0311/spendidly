import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:spendidly/main.dart';

import '../widget/shared_app_bar.dart';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _HomePageState();
}

class _HomePageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late CameraDescription firstCamera;

  @override
  void initState() {
    initialiseCamera();
    super.initState();
  }

  void initialiseCamera() {
    // Get available cameras

    _controller = CameraController(
      camera!,
      ResolutionPreset.medium,
    );

    // Next initialize the conbtroller. Thisn returns a Future
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SharedAppBar(title: 'Scan Picture', isBackButton: true),
      body:
          // You must wait until the controller is initialized before displaying the
          // camera preview. Use a FutureBuilder to display a loading spinner until the
          // controller has finished initializing.
          FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.camera_alt),
          onPressed: () async {
            try {
              // Ensure camera is initialized
              await _initializeControllerFuture;

              // Attempt to take a picture and get the file `image`
              // where it was saved.
              final image = await _controller.takePicture();
              final extractedText =
                  await readPictureTaken(InputImage.fromFilePath(image.path));
              for (String line in extractedText.split('\n')) {
                // print(line + 'XXXXXX');
              }
              print(extractedText);

              // If the picture was taken, display it on a new screen.
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(
                    // Pass the automatically generated path to
                    // the DisplayPictureScreen widget.
                    imagePath: image.path,
                  ),
                ),
              );
            } catch (e) {
              print(e);
            }
          }),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SharedAppBar(
        title: 'Display the Picture',
        isBackButton: true,
      ),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      // body: Image.file(File(imagePath)),
      body: Container(
        child: Column(
          children: [
            Image.file(File(imagePath)),
          ],
        ),
      ),
    );
  }
}

Future<String> readPictureTaken(InputImage img) async {
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final RecognizedText recognizedText = await textRecognizer.processImage(img);
  String text = recognizedText.text;
  for (TextBlock block in recognizedText.blocks) {
    final Rect rect = block.boundingBox;
    final List<Point<int>> cornerPoints = block.cornerPoints;
    print(cornerPoints[0]);
    final String text = block.text;
    final List<String> languages = block.recognizedLanguages;

    for (TextLine line in block.lines) {
      // Same getters as TextBlock
      for (TextElement element in line.elements) {
        // Same getters as TextBlock
      }
    }
  }
  textRecognizer.close();
  return text;
}
