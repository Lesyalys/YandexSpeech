import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';


void main() {
  runApp(const MyApp());
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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 60, 59, 131)),
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

  void _incrementCounter()async {
    final dio = Dio();
  await dio.post('http://172.17.10.112:7000/sent/text',data:{'datasent':pattern,'datasentvoice':voiceName});
  }

  List<DropdownMenuItem<String>>? _getPattern()  {
    final dio = Dio();
    dio.get('http://172.17.10.112:7000/get/pattern');
  }


  String? voiceName;
  String? pattern;


  @override
  //final myController = TextEditingController();
  String dropdownvalue = 'alena';
  //String dropdownvaluepattern = 'У выхода №%25 на 2 этаже терминала %24 … населенный пункт %22 авиакомпании %23';
  Widget build(BuildContext context) {
    const List<String> list = <String>[
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


  //@override
  //Widget build(BuildContext context){
    return Scaffold(
      backgroundColor:const Color.fromARGB(160, 37, 36, 36),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(160, 37, 36, 36),
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            const Text(
              '',
            ),
            const Text(
              'YandexSpeachKit',
              //style: Theme.of(context).textTheme.headlineMedium,
            ), 
            DropdownButton(
              icon: const Icon(Icons.account_circle),
               items: _getPattern().map((String items) {
                       return DropdownMenuItem(
                           value: items,
                           child: Text(items),
                       );
                  }
                  ).toList(),
               onChanged: (String? newValue) {
                   setState(() {pattern = newValue;});
             }),
            // TextField(
            //   controller: myController, 
            //   decoration: 
            //   const InputDecoration(
            //     border: OutlineInputBorder(),
            //     hintText: 'Enter text',
            //   ),
            // ),
            const SizedBox(height: 30),
            const Text(
              'Voice for voice acting'
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              DropdownButton(
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
            ],
            ),   
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'sent',
        child: const Icon(Icons.send),
      ), 
    );
  }
}