import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as http;
import 'package:spendidly/widget/shared_app_bar.dart';

import '../widget/shared_navigation_drawer.dart';
import 'addTransaction_page.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  File? image;
  bool isLoading = false;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
        isLoading = true;
      });

      // Extract the text from the image
      final extractedText =
          await readPictureTaken(InputImage.fromFile(imageTemp));
      // Send to server for categorisation
      final cat = await categorizeImg(extractedText);

      setState(() {
        isLoading = false;
      });

      // Navigate to add transaction page
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddTransactionPage(
          cat: cat,
        ),
      ));
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<String> readPictureTaken(InputImage img) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(img);
    String text = recognizedText.text;
    textRecognizer.close();
    return text;
  }

  Future<String> categorizeImg(String text) async {
    // Test http request
    var url = Uri.parse('http://192.168.0.161:8080/');
    var response = await http.post(url, body: {'text': text});
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<double> confidentResponse =
          List<double>.from(json.decode(response.body));
      double maxConfident = confidentResponse.reduce(max);
      int indexOfMax = confidentResponse.indexOf(maxConfident);
      List<String> labels = [
        'General',
        'Food',
        'Transportation',
        'Entertainment',
        'Sports'
      ];

      return labels[indexOfMax];
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Server error, try again later');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SharedAppBar(
        title: "Receipt Scanner",
        isBackButton: true,
      ),
      body: isLoading
          ? const Center(
              child: SpinKitCircle(
                color: Colors.blueAccent,
                size: 150,
                duration: const Duration(seconds: 2),
              ),
            )
          : Container(
              width: 400,
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  // TODO IMAGES CANOT WORK WTFFF
                  Image.asset(
                    'assets/img/scanner_ai.jpg',
                    scale: 10,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    "Image Scanner",
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(fixedSize: Size(250, 50)),
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(children: const [
                        Icon(Icons.image),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Pick Gallery")
                      ]),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(fixedSize: Size(250, 50)),
                    onPressed: () {
                      pickImage(ImageSource.camera);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(children: const [
                        Icon(Icons.camera_alt),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Pick Camera")
                      ]),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
