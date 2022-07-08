import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:spendidly/pages/addTransaction_page.dart';
import 'package:spendidly/widget/shared_app_bar.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  bool isLoading = false;
  double price = 0;
  DateTime date = DateTime.now();
  late TextRecognizer textRecognizer;

  @override
  void initState() {
    textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    super.initState();
  }

  @override
  void dispose() {
    textRecognizer.close();
    super.dispose();
  }

  Future pickImage(ImageSource source) async {
    try {
      final image =
          await ImagePicker().pickImage(source: source, imageQuality: 100);
      if (image == null) return;

      // Start loading
      setState(() {
        isLoading = true;
        price = 0;
        date = DateTime.now();
      });
      var imageTemp = File(image.path);

      // Extract the text from the image
      final extractedText =
          await readPictureTaken(InputImage.fromFilePath(imageTemp.path));
      print(extractedText);

      // Send to server for categorisation
      final cat = await categorizeImg(extractedText);

      setState(() {
        isLoading = false;
      });

      // Navigate to add transaction page
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddTransactionPage(
          cat: cat,
          price: price,
          recognisedDate: date,
        ),
      ));
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<String> readPictureTaken(InputImage img) async {
    final RecognizedText recognizedText =
        await textRecognizer.processImage(img);
    bool isCheckedDate = false;

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        // Check for price
        String text = line.text.toUpperCase().replaceAll(" ", "");
        if (text.startsWith("RM")) {
          text = text.replaceFirst("RM", "");
          double? price = double.tryParse(text);

          if (price != null) {
            print("price is: " + price.toString());
            if (price > this.price) {
              setState(() {
                this.price = price;
              });
            }
          }
        }

        // Check for date
        if (!isCheckedDate) {
          final date = RegExp(
              r'(\b(0?[1-9]|[12]\d|30|31)[^\w\d\r\n:](0?[1-9]|1[0-2])[^\w\d\r\n:](\d{4}|\d{2})\b)|(\b(0?[1-9]|1[0-2])[^\w\d\r\n:](0?[1-9]|[12]\d|30|31)[^\w\d\r\n:](\d{4}|\d{2})\b)');
          var matches = date.firstMatch(line.text);
          if (matches?.group((0)) != null) {
            String? dateString = matches?.group(0);
            DateTime parsedDate;
            print("Date: " + dateString!);
            try {
              parsedDate = DateFormat('d/M/y').parse(dateString);
            } catch (e) {
              try {
                parsedDate = DateFormat('d-M-y').parse(dateString);
              } catch (e) {
                parsedDate = DateTime.now();
              }
            }
            setState(() {
              this.date = parsedDate;
            });
            isCheckedDate = true;
          }
        }
      }
    }
    return recognizedText.text;
  }

  Future<String> categorizeImg(String text) async {
    // Test http request
    var url = Uri.parse('http://192.168.0.161:8080/');

    try {
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
    } on Exception catch (_) {
      throw Exception('Server error, try again later');
    }
  }

  uploadImg(String title, File file) async {
    var url = Uri.parse('http://192.168.0.161:8080/upload');
    var request = http.MultipartRequest("POST", url);
    request.fields['title'] = "dummyImg";
    request.headers['Authorization'] = "";

    var picture = http.MultipartFile.fromBytes(
        'image', await file.readAsBytes(),
        filename: title);

    request.files.add(picture);

    var response = await request.send();

    var responseData = await response.stream.toBytes();

    var result = String.fromCharCodes(responseData);

    print(result);
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
