//import 'dart:convert';
//import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter_yandexspeach/loaded.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:provider/provider.dart';


void main() {

  

  final patterns = Patterns();
   
  
  Provider.debugCheckInvalidValueType = null;
  runApp(
       
       FutureBuilder(
        future: patterns.loadPatterns(),
        builder: (context, snapshot) {
          if (patterns.list.isNotEmpty){
              return Provider(create: (_) => patterns,  child: const MyApp()); 
          } else {
            return const LoadedWidget();

          }
        }, ));
}

class PatternDTO {
  String? mesage;

  PatternDTO({this.mesage});

  PatternDTO.fromJson(Map<String, dynamic> json) {
    mesage = json['MESSAGETEMPTEXTRU'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['MESSAGETEMPTEXTRU'] = mesage;
    return data;
  }
}
   


class Patterns with ChangeNotifier, DiagnosticableTreeMixin {
  List<PatternDTO> _list = [];

  List<PatternDTO> get list => _list;
  
  
  Future<void> loadPatterns() async  {
    final dio = Dio();
    dio.interceptors.add(PrettyDioLogger());
    try {
    final response = await dio.get('http://172.17.10.12:7000/get/pattern');
    if (response.statusCode == 200)
    {
      List<PatternDTO> list2 =  List<PatternDTO>.from(
        response.data.map((v) => PatternDTO.fromJson(v)),
      );
      _list = list2;
    } else {

    }
    } catch (e){
       print('$e');
    }
    // notifyListeners();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('list', list.toString()));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(178, 161, 205, 233)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  void _sentText()async {
    final dio = Dio();
  await dio.post('http://172.17.10.12:7000/sent/text',data:{'datasent':myController.text,'voiceName':voiceName});
  }

  // List<DropdownMenuItem<String>>? _getPattern()  {
  //   final dio = Dio();
  //   print(dio.get('http://172.17.10.112:7000/get/pattern'));
  // }


  String? voiceName; 
  final myController = TextEditingController();
  //String? myController;
  String dropdownvalue = 'alena';
  late PatternDTO valueFirst;
  late Patterns patterns;
  late List<DropdownMenuItem<PatternDTO>> menuItem;

    
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    patterns = context.read<Patterns>();
    valueFirst = patterns.list.first;   
    menuItem = buildMenuItem();
    
  }
  void _playerComplite(void event)
    {
      player.play(AssetSource('newFile.mp3'));
   }


  final List<String> list = <String>[
      'alena',
      'filipp',
      'ermil',
      'jane',
      'omazh',
      'zahar',
      'dasha',
      'julia',
      'lera',
      'masha',
      'marina',
      'alexander',
    ];

  List<DropdownMenuItem<PatternDTO>> buildMenuItem() {
      return patterns.list.map((p) =>  DropdownMenuItem<PatternDTO>(value: p, child: Text('${p.mesage}', style: TextStyle(overflow: TextOverflow.clip)))).toList();
  }

  @override
  Widget build(BuildContext context){   


    return Scaffold(
      backgroundColor:const Color.fromARGB(159, 151, 191, 243),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(159, 151, 191, 243),
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            const Text(
               'YandexSpeachKit',
               style: TextStyle(fontSize: 30),
            ),

             SizedBox(
              width: 600,
              child: DropdownButton<PatternDTO>(
                isExpanded: true,
                
                value: valueFirst,
                 items: menuItem,
                 onChanged:(newValue) {setState(() {
                   valueFirst = newValue!;
                   myController.text = newValue.mesage.toString();
                 });},
                 ),
             ),
             
            //  TextField(
            //    controller: myController, 
            //    decoration: 
            //    const InputDecoration(
            //      border: OutlineInputBorder(),
            //      hintText: 'Enter text',
            //    ),
            //  ),

            const SizedBox(height: 20),

            const Text(
              'Voice for voice acting',
              style: TextStyle(fontSize: 20)
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              DropdownButton(
              style: const TextStyle(fontSize: 15,
              color: Color.fromARGB(159, 31, 31, 31)),
              value: dropdownvalue,
                  icon: const Icon(Icons.account_circle),
                  items:list.map((String items) {
                       return DropdownMenuItem(
                           value: items,
                           child: Text(items),
                       );
                  }
                  ).toList(),
                onChanged: (String? newValue) {
                  setState(() { dropdownvalue = newValue!; voiceName = newValue; });
                },
                //onTap:_incrementCounter,
              ),
              const SizedBox(width: 30),

              FloatingActionButton(
                onPressed: _playerComplite,
                tooltip: 'play',
                child: const Icon(Icons.keyboard_voice)),
              const SizedBox(width: 30),
              
              FloatingActionButton(
              onPressed: _sentText,
              tooltip: 'sent server',
              child: const Icon(Icons.send)
            ),
            ],
            ),   
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _sentText,
      //   tooltip: 'sent',
      //   child: const Icon(Icons.send),
      // ), 
    );
  }
}