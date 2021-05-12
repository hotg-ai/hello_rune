import 'dart:math';
import 'package:runevm_fl/runevm_fl.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello Rune',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Hello rune'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _loaded = false;
  double _input = 0;
  String? _output;

  @override
  void initState() {
    super.initState();
    _loadRune();
  }

  Future<void> _loadRune() async {
    try {
      //Load Rune from assets into memory;
      ByteData bytes = await rootBundle.load('assets/sine.rune');
      bool loaded =
          await RunevmFl.loadWASM(bytes.buffer.asUint8List()) ?? false;
      print("Rune deployed:");
      if (loaded) {
        //Read Manifest with capabilities
        String manifest = (await RunevmFl.manifest).toString();
        print("Manifest loaded: $manifest");
      }
    } on Exception {
      print('Failed to init rune');
    }
    setState(() {
      _loaded = true;
    });
  }

  void _runRune() async {
    try {
      Random rand = Random();
      _input = rand.nextDouble() * 2 * pi;
      //convert input to 4 bytes representing a Float32 (See assets/Runefile)
      Uint8List inputBytes = Uint8List(4)
        ..buffer.asByteData().setFloat32(0, _input, Endian.little);
      //Run rune with the inputBytes
      _output = await RunevmFl.runRune(inputBytes);
      setState(() {});
    } on Exception {
      print('Failed to run rune');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Rune Input: $_input',
              ),
              Text(
                'Rune Output: $_output',
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _runRune,
          tooltip: 'Run Rune',
          child: Icon(Icons.play_arrow),
        ));
  }
}
