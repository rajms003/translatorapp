// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:translator/translator.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<String> language = [
    'English',
    'Hindi',
    'Arabic',
    'German',
    'Russian',
    'Urdu',
  ];
  String selectedLanguage = "English";
  String targetLanguage = "Hindi";
  String from = 'en';
  String data = 'Translated Text';
  String to = 'hi';
  TextEditingController controller =
      TextEditingController(text: 'Hello How can I help you?');
  //text validation
  final formkey = GlobalKey<FormState>();
  //validating network connection
  bool isloading = false;

  final List<String> languageCode = [
    'en',
    'hi',
    'ar',
    'de',
    'ru',
    'ur',
  ];

  // Translator
  final translator = GoogleTranslator();

  translate() async {
    try {
      if (formkey.currentState!.validate()) {
        await translator
            .translate(controller.text, from: from, to: to)
            .then((value) {
          data = value.text;
          isloading = false;
          setState(() {});
        });
      }
    } on SocketException catch (_) {
      isloading = true;
      SnackBar snackBar = const SnackBar(
        content: Text('Internet not connected'),
        duration: Duration(seconds: 10),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  //init state
  // @override
  // void initState() {
  //   super.initState();
  //   translate();

  // }

  // Speech to text
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  // void _startListening() async {
  //   await _speechToText.listen(onResult: _onSpeechResult);
  //   setState(() {});
  // }

  // /// Manually stop the active speech recognition session
  // /// Note that there are also timeouts that each platform enforces
  // /// and the SpeechToText plugin supports setting timeouts on the
  // /// listen method.
  // void _stopListening() async {
  //   await _speechToText.stop();
  //   setState(() {});
  // }

  // /// This is the callback that the SpeechToText plugin calls when
  // /// the platform returns recognized words.
  // void _onSpeechResult(SpeechRecognitionResult result) {
  //   setState(() {
  //     _lastWords = result.recognizedWords;
  //   });
  // }

  void _toggleRecording() async {
    if (!_speechEnabled) {
      setState(() => _speechEnabled = true);
      await _speechToText.listen(onResult: (result) {
        Future.delayed(const Duration(seconds: 5), () {
          setState(() {
            controller.text = result.recognizedWords;
            _speechEnabled = false;
          });
        });
      });
    } else {
      setState(() => _speechEnabled = false);
      await _speechToText.stop();
    }
  }

  // Text to speech
  final FlutterTts flutterTts = FlutterTts();

  speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    
    
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      
        appBar: AppBar(
          title: const Center(child: Text('Translator App', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),)),
          backgroundColor: const Color.fromARGB(255, 1, 61, 79),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: Column(children: [
              SizedBox(
                // width: mq.width,
                height: mq.height * .03,
              ),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Space buttons evenly
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: const Row(
                        children: [
                          Icon(
                            Icons.language,
                            size: 16,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              'Language',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      items: language
                          .map((String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      value: selectedLanguage,

                      onChanged: (value) {
                        if (value == language[0]) {
                          from = languageCode[0];
                        } else if (value == language[1]) {
                          from = languageCode[1];
                        } else if (value == language[2]) {
                          from = languageCode[2];
                        } else if (value == language[3]) {
                          from = languageCode[3];
                        } else if (value == language[4]) {
                          from = languageCode[4];
                        } else if (value == language[5]) {
                          from = languageCode[5];
                        }

                        setState(() {
                          // print(value);
                          // print(from);

                          selectedLanguage = value!;
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 50,
                        width: 160,
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color.fromARGB(255, 1, 61, 79),
                          ),
                        ),
                      ),
                      
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        offset: const Offset(0, 0),
                        scrollbarTheme: ScrollbarThemeData(
                          radius: const Radius.circular(40),
                          thickness: MaterialStateProperty.all(6),
                          thumbVisibility: MaterialStateProperty.all(true),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                      
                        height: 40,
                        padding: EdgeInsets.only(left: 14, right: 14),
                      ),
                    ),
                  ),

                  // middle icon
                  const Icon(Icons.double_arrow_outlined),

                  //
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: const Row(
                        children: [
                          Icon(
                            Icons.language,
                            size: 16,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              'Language',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      items: language
                          .map((String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      value: targetLanguage,
                      onChanged: (value) {
                        setState(() {
                          if (value == language[0]) {
                            to = languageCode[0];
                          } else if (value == language[1]) {
                            to = languageCode[1];
                          } else if (value == language[2]) {
                            to = languageCode[2];
                          } else if (value == language[3]) {
                            to = languageCode[3];
                          } else if (value == language[4]) {
                            to = languageCode[4];
                          } else if (value == language[5]) {
                            to = languageCode[5];
                          }

                          // print(value);
                          //   print(from);
                          targetLanguage = value!;
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 50,
                        width: 160,
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color.fromARGB(255, 1, 61, 79),
                          ),
                        ),
                      ),
                      
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          // color: Colors.redAccent,
                        ),
                        offset: const Offset(-40, 0),
                        scrollbarTheme: ScrollbarThemeData(
                          radius: const Radius.circular(40),
                          thickness: MaterialStateProperty.all(6),
                          thumbVisibility: MaterialStateProperty.all(true),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                        padding: EdgeInsets.only(left: 14, right: 14),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: mq.height * .04,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  color: const Color.fromARGB(255, 254, 224, 132),
                  height: mq.height * .255,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Stack(children: [
                      Column(
                        children: [
                          Text(selectedLanguage, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 1, 61, 79)),),
                          //text validation
                          Form(
                            key: formkey,
                            child: TextFormField(
                              controller: controller,
                              style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 1, 61, 79), fontWeight: FontWeight.w500),
                              maxLines: 4,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter Some text';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                // hintText: 'Enter a search term',
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: _toggleRecording,
                                  icon: const Icon(Icons.mic, color: Color.fromARGB(255, 1, 61, 79))),
                              SizedBox(
                                width: mq.width * .01,
                              ),
                              IconButton(
                                  onPressed: () => speak(controller.text),
                                  icon: const Icon(Icons.volume_up, color: Color.fromARGB(255, 1, 61, 79),)),
                              const Spacer(), // Creates flexible space between elements
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 1, 61, 79), // Set background color to blue
  ),
                               
                                onPressed: translate,
                                child: isloading
                                    ? const SizedBox.square(
                                        dimension: 25,
                                        child: CircularProgressIndicator(
                                          color: Colors.blueAccent,
                                        ),
                                      )
                                    : const Text('Translate', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                              ),
                            ],
                          )
                        ],
                      )
                    ]),
                  ),
                ),
              ),
              SizedBox(
                height: mq.height * .04,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  color: const Color.fromARGB(255, 254, 224, 132),
                  height: mq.height * .255,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Stack(children: [
                      Column(
                        children: [
                          Text(targetLanguage, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 1, 61, 79)),),
                          TextField(
                            style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 1, 61, 79)),
                            readOnly: true,
                            maxLines: 4,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: data,
                              hintStyle: TextStyle(color: Color.fromARGB(255, 1, 61, 79))
                            ),
                          ),
                          Row(
                            children: [
                              // IconButton(onPressed: () {}, icon: Icon(Icons.mic)),
                              // SizedBox(
                              //   width: mq.width * .01,
                              // ),
                              IconButton(
                                  onPressed: () => speak(data),
                                  icon: const Icon(Icons.volume_up, color: Color.fromARGB(255, 1, 61, 79),)),
                              const Spacer(), // Creates flexible space between elements
                              IconButton(
                                  onPressed: () async {
                                    await Clipboard.setData(
                                        ClipboardData(text: data));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Text copied to clipboard!'),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.copy_outlined, color: Color.fromARGB(255, 1, 61, 79),))
                            ],
                          )
                        ],
                      )
                    ]),
                  ),
                ),
              ),
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(20.0),
              //   child: Container(
              //     color: Colors.amber,
              //     height: mq.height * .255,
              //     child: Padding(
              //       padding: const EdgeInsets.all(12.0),
              //       child: Stack(children: [
              //         Column(
              //           children: [
              //             const Text("English"),
              //             const TextField(
              //               maxLines: 3,
              //               decoration: InputDecoration(
              //                 border:
              //                     OutlineInputBorder(borderSide: BorderSide.none),
              //                 hintText: 'Enter a search term',
              //               ),
              //             ),
              //             Row(
              //               children: [
              //                 Icon(Icons.mic),
              //                 SizedBox(
              //                   width: mq.width * .05,
              //                 ),
              //                 Icon(Icons.volume_up),
              //                 Spacer(), // Creates flexible space between elements
              //                 Icon(Icons.copy_outlined)
              //               ],
              //             )
              //           ],
              //         )
              //       ]),
              //     ),
              //   ),
              // ),
            ]),
          ),
        ));
  }
}
