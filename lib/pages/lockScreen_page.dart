import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:spendidly/widget/color_theme.dart';

class LockScreenPage extends StatefulWidget {
  const LockScreenPage({Key? key}) : super(key: key);

  @override
  State<LockScreenPage> createState() => _LockScreenPageState();
}

class _LockScreenPageState extends State<LockScreenPage> {
  List<String> currentPin = ["", "", "", ""];
  TextEditingController pin1Cont = TextEditingController();
  TextEditingController pin2Cont = TextEditingController();
  TextEditingController pin3Cont = TextEditingController();
  TextEditingController pin4Cont = TextEditingController();
  final String _passcode = Hive.box("settings").get("passcode");
  bool isWrong = false;

  var outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(color: Colors.transparent),
  );

  int pinIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(146, 193, 240, 0.9),
      body: SafeArea(
        child: Column(
          children: [
            // buildExitButton(),
            const SizedBox(
              height: 50,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const ImageIcon(
                    AssetImage(
                        "assets/icons/ic_stat_monetization_on_bigger.png"),
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  buildSecurityText(),
                  isWrong
                      ? const Text(
                          "Passcode does not match",
                          style: const TextStyle(color: Colors.red),
                        )
                      : const Text(""),
                  const SizedBox(
                    height: 40,
                  ),
                  buildPinRow(),
                ]),
              ),
            ),
            buildNumberPad(),
          ],
        ),
      ),
    );
  }

  buildNumberPad() {
    return Expanded(
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KeyboardNumber(
                    n: 1,
                    onPressed: () {
                      pinIndexSetup("1");
                    },
                  ),
                  KeyboardNumber(
                    n: 2,
                    onPressed: () {
                      pinIndexSetup("2");
                    },
                  ),
                  KeyboardNumber(
                    n: 3,
                    onPressed: () {
                      pinIndexSetup("3");
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KeyboardNumber(
                    n: 4,
                    onPressed: () {
                      pinIndexSetup("4");
                    },
                  ),
                  KeyboardNumber(
                    n: 5,
                    onPressed: () {
                      pinIndexSetup("5");
                    },
                  ),
                  KeyboardNumber(
                    n: 6,
                    onPressed: () {
                      pinIndexSetup("6");
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KeyboardNumber(
                    n: 7,
                    onPressed: () {
                      pinIndexSetup("7");
                    },
                  ),
                  KeyboardNumber(
                    n: 8,
                    onPressed: () {
                      pinIndexSetup("8");
                    },
                  ),
                  KeyboardNumber(
                    n: 9,
                    onPressed: () {
                      pinIndexSetup("9");
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    width: 60,
                    child: MaterialButton(
                      onPressed: null,
                      child: SizedBox(),
                    ),
                  ),
                  KeyboardNumber(
                    n: 0,
                    onPressed: () {
                      pinIndexSetup("0");
                    },
                  ),
                  SizedBox(
                    width: 60,
                    child: MaterialButton(
                      onPressed: () {
                        clearPin();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: const Icon(
                        Icons.backspace_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  clearPin() {
    if (pinIndex == 0) {
      pinIndex = 0;
    } else if (pinIndex == 4) {
      setPin(pinIndex, "");
      currentPin[pinIndex - 1] = "";
      pinIndex--;
    } else {
      setPin(pinIndex, "");
      currentPin[pinIndex - 1] = "";
      pinIndex--;
    }
  }

  pinIndexSetup(String text) {
    if (pinIndex == 0) {
      pinIndex = 1;
    } else if (pinIndex < 4) {
      pinIndex++;
    }
    setPin(pinIndex, text);
    currentPin[pinIndex - 1] = text;
    String strPin = "";
    for (var element in currentPin) {
      strPin += element;
    }
    if (pinIndex == 4) {
      if (strPin == _passcode) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/home/", (route) => false);
      } else {
        setState(() {
          isWrong = true;
        });
        Future.delayed(const Duration(milliseconds: 1000), () {
          clearPin();
          clearPin();
          clearPin();
          clearPin();
        });
      }
    }
  }

  setPin(int n, String text) {
    switch (n) {
      case 1:
        pin1Cont.text = text;
        break;
      case 2:
        pin2Cont.text = text;
        break;
      case 3:
        pin3Cont.text = text;
        break;
      case 4:
        pin4Cont.text = text;
        break;
    }
  }

  buildPinRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        PINNumber(
          outlineInputBorder: outlineInputBorder,
          textEditingController: pin1Cont,
        ),
        PINNumber(
          outlineInputBorder: outlineInputBorder,
          textEditingController: pin2Cont,
        ),
        PINNumber(
          outlineInputBorder: outlineInputBorder,
          textEditingController: pin3Cont,
        ),
        PINNumber(
          outlineInputBorder: outlineInputBorder,
          textEditingController: pin4Cont,
        ),
      ],
    );
  }

  buildSecurityText() {
    return const Text(
      "Security PIN",
      style: TextStyle(
        color: Colors.white,
        fontSize: 21,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  buildExitButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: MaterialButton(
            onPressed: () {},
            height: 50,
            minWidth: 50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(Icons.clear, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class PINNumber extends StatelessWidget {
  final TextEditingController textEditingController;
  final OutlineInputBorder outlineInputBorder;

  const PINNumber(
      {Key? key,
      required this.outlineInputBorder,
      required this.textEditingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: textEditingController,
        enabled: false,
        obscureText: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          border: outlineInputBorder,
          filled: true,
          fillColor: Colors.white,
        ),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 21,
          color: Colors.black,
        ),
      ),
    );
  }
}

class KeyboardNumber extends StatelessWidget {
  final int n;
  final Function() onPressed;
  const KeyboardNumber({Key? key, required this.n, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorTheme.darkblue,
      ),
      alignment: Alignment.center,
      child: MaterialButton(
        padding: const EdgeInsets.all(8.0),
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
        height: 90,
        child: Text(
          "$n",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24 * MediaQuery.of(context).textScaleFactor,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
