import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:spendidly/pages/addTransaction_page.dart';
import 'package:spendidly/widget/shared_app_bar.dart';
import 'package:images_picker/images_picker.dart';

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
  // final _imgPicker = ImagePicker();

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

  Future getImage() async {
    List<Media>? res = await ImagesPicker.pick(
      count: 1,
      pickType: PickType.image,
    );
    if (res != null) {
      return res[0].path;
    }
    return null;
  }

  // Future pickImageAndGetPath() async {
  //   try {
  //     final image = await _imgPicker.pickImage(
  //         source: ImageSource.gallery, imageQuality: 100);
  //     if (image == null) {
  //       return null;
  //     } else {
  //       return image.path;
  //     }
  //   } on PlatformException catch (e) {
  //     print('Failed to pick image: $e');
  //   }
  //   return null;
  // }

  Future extractAndCategorize(String imgPath) async {
    // Check network connectivity
    if (await checkConnectivity()) {
      // Start loading
      setState(() {
        isLoading = true;
        price = 0;
        date = DateTime.now();
      });

      // Extract the text from the image
      final extractedText =
          await readPictureTaken(InputImage.fromFilePath(imgPath));
      // print(extractedText);

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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Connectivity issue"),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.of(context).pop();
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
        final formatPrice =
            RegExp(r'(\d)(\d\.)(?:\d{1,2}(?:,\d{2})*|\d+)(?:\.\d{1,2})?(?!\.)');
        var matches = formatPrice.firstMatch(text);
        String? priceString = matches?.group(0);

        if (matches?.group(0) != null) {
          double? price = double.tryParse(priceString!);
          if (price != null) {
            // print("price is: " + price.toString());
            if (price > this.price) {
              setState(() {
                this.price = price;
              });
            }
          }
        }

        // Check for date
        if (!isCheckedDate) {
          final formatCheck = RegExp(
              r'(\b(0?[1-9]|[12]\d|30|31)[^\w\d\r\n:](0?[1-9]|1[0-2])[^\w\d\r\n:](\d{4})\b)|(\b(0?[1-9]|1[0-2])[^\w\d\r\n:](0?[1-9]|[12]\d|30|31)[^\w\d\r\n:](\d{4})\b)');
          var matches = formatCheck.firstMatch(line.text);
          DateTime parsedDate;

          if (matches?.group((0)) != null) {
            String? dateString = matches?.group(0);
            try {
              parsedDate = DateFormat('d/M/y').parse(dateString!);
            } catch (e) {
              try {
                parsedDate = DateFormat('d-M-y').parse(dateString!);
              } catch (e) {
                try {
                  parsedDate = DateFormat('d.M.y').parse(dateString!);
                } catch (e) {
                  parsedDate = DateTime.now();
                }
              }
            }
            // print("Date is: " + parsedDate.toString());
            setState(() {
              date = parsedDate;
            });
            isCheckedDate = true;
          } else {
            final formatCheck2 = RegExp(
                r'\d{4}[\-/](0[1-9]|1[012])[\-/](0[1-9]|[12][0-9]|3[01])');
            var matches = formatCheck2.firstMatch(line.text);
            if (matches?.group((0)) != null) {
              String? dateString = matches?.group(0);
              try {
                parsedDate = DateFormat('y/M/d').parse(dateString!);
              } catch (e) {
                try {
                  parsedDate = DateFormat('y-M-d').parse(dateString!);
                } catch (e) {
                  try {
                    parsedDate = DateFormat('y.M.d').parse(dateString!);
                  } catch (e) {
                    parsedDate = DateTime.now();
                  }
                }
              }
              // print("Date is: " + parsedDate.toString());
              setState(() {
                date = parsedDate;
              });
              isCheckedDate = true;
            }
          }
        }
      }
    }
    return recognizedText.text;
  }

  Future<bool> checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<String> categorizeImg(String text) async {
    var url = Uri.parse('http://192.168.0.161:8080/');
    try {
      var response = await http.post(url, body: {'text': text});
      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        List<double> confidentResponse =
            List<double>.from(json.decode(response.body));
        // print(confidentResponse);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SharedAppBar(
        title: "Receipt Scanner",
        isBackButton: true,
        isSettings: true,
      ),
      body: isLoading
          ? const Center(
              child: SpinKitCircle(
                color: Colors.blueAccent,
                size: 150,
                duration: Duration(seconds: 2),
              ),
            )
          : SizedBox(
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
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(250, 50)),
                    onPressed: () async {
                      // String? imgPath = await pickImageAndGetPath();
                      String? imgPath = await getImage();
                      if (imgPath != null) {
                        await extractAndCategorize(imgPath);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
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
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(250, 50)),
                    onPressed: () async {
                      var imgPath = await Navigator.of(context)
                          .pushNamed("/takePicture/");
                      if (imgPath.toString() != "") {
                        await extractAndCategorize(imgPath.toString());
                      }
                      // var status = await Permission.camera.status;
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
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
