import 'dart:typed_data';

import 'package:chat_bot_app/feature_box.dart';
import 'package:chat_bot_app/openai_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final speech_to_text = SpeechToText();
  String lastwords = '';
  final GeminiAPI geminiAPI = GeminiAPI();
  final flutterTts = FlutterTts();
  String? gen_content;
  Uint8List? gem_img_url;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }
  
  Future<void> initTextToSpeech() async{
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }
  

  Future<void> initSpeechToText() async{
    await speech_to_text.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speech_to_text.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speech_to_text.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastwords = result.recognizedWords;
    });
  }

  Future<void> sysspeak(String content) async{
    await flutterTts.speak(content);
  }
  
  
  @override
  void dispose() {
    super.dispose();
    speech_to_text.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.purple,

        title: const Text('Frank',style: TextStyle(fontFamily: 'Anton',fontWeight: FontWeight.bold,color: Colors.white),),
        leading: const Icon(Icons.ac_unit,color: Colors.white,),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
               Stack(
                 children: [
                   Center(
                     child: Container(
                       height: 140,
                       width: 140,
                       margin: const EdgeInsets.only(top: 10),
                       decoration: const BoxDecoration(
                         color: Colors.orange,
                         shape: BoxShape.circle,
                       ),
                     ),
                   ),
                   Container(
                     height: 125,
                     margin: const EdgeInsets.only(top: 10),
                     decoration: const BoxDecoration(
                       shape: BoxShape.circle,
                       image: DecorationImage(
                         image: AssetImage('assets/images/robo.png')
                       ),
                     ),
                   )
                 ],
               ),

            Visibility(
              visible: gem_img_url == null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 40,).copyWith(top: 30,right: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(20).copyWith(topLeft: Radius.zero,bottomRight: Radius.zero),
                ),
                child: Text(
                  gen_content == null ?'Hello, What can I do for You?' : gen_content!
                  ,style: TextStyle(fontFamily: 'Bebas',fontSize: 24),),
              ),
            ),

            if (gem_img_url != null) ...[
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.memory(gem_img_url!)),
            ),
            ],

            Visibility(
              visible: gen_content == null && gem_img_url == null,
              child: Container(
                padding: const EdgeInsets.all(10),
                  height: 50,
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 20,top: 8),
                  child: const Text('Here are some Features',style: TextStyle(fontFamily: 'Bebas',fontSize: 20,fontWeight: FontWeight.w800),)),
            ),

            Visibility(
              visible: gen_content == null && gem_img_url == null,
              child: const Column(
                children:[
                  Feature_box(color: Colors.yellowAccent,head_text: 'Gemini AI',
                    des_text: 'Get Smarter response with Gemini',),

                  Feature_box(color: Colors.redAccent,head_text: 'Stability AI',
                    des_text: 'Generate AI pictures with Stability AI',),

                  Feature_box(color: Colors.greenAccent,head_text: 'Smart Voice Assistant',
                    des_text: 'Get the best of both worlds with a voice assistant powered by Gemini and Stability AI',),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        if (await speech_to_text.hasPermission && speech_to_text.isNotListening) {
          await startListening();
        }
        else if (speech_to_text.isListening) {
          //final speech = await openAI.isArtPromptAPI(lastwords);
          final vars = await geminiAPI.yesOrNo(lastwords);
          if (vars == 'yes') {
            // gem_img_url = speech;
            gem_img_url = await geminiAPI.genImg(lastwords);
            gen_content = null;
            setState(() {});
          }
          else {
            gen_content = await geminiAPI.getAns(lastwords);
            gem_img_url = null;
            setState(() {});
          }
          // await sysspeak(speech);
          await sysspeak(gen_content!);
          await stopListening();
        }
        else {
          initSpeechToText();
        }
      },
        backgroundColor: Colors.purpleAccent,
        child: Icon(speech_to_text.isListening ? Icons.stop : Icons.mic),),
    );
  }
}
