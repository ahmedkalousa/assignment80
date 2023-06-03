import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piano/piano.dart';
import 'package:flutter_midi/flutter_midi.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

enum SampleItem { itemOne, itemTwo, itemThree }

class _MyAppState extends State<MyApp> {
  SampleItem? selectedMenu;
  String? selectedOption;

  @override
  void initState() {
    load("assets/Piano.sf2");
    super.initState();
  }

  List<NotePosition> highlightedNotes = [
    NotePosition(note: Note.C, octave: 3),
  ];
  void load(String asset) async {
    FlutterMidi().unmute();
    ByteData bytes = await rootBundle.load(asset);
    FlutterMidi().prepare(sf2: bytes);
  }

  String as = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 205, 56, 56),
          leading: Icon(Icons.arrow_back),
          title: Align(
            child: Text("Multi Instruments"),
            alignment: Alignment.center,
          ),
          actions: [
            DropdownButton<String>(
              style: TextStyle(color: Colors.white),
              dropdownColor: const Color.fromARGB(255, 205, 56, 56),
              value: selectedOption,
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
              iconSize: 40,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedOption = newValue;
                    load("assets/$selectedOption.sf2");
                  });
                }
                print("$newValue");
              },
              items: <String>['Flute', 'Guitars', 'Piano']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
        body: InteractivePiano(
          highlightedNotes: highlightedNotes,
          naturalColor: Colors.white,
          accidentalColor: Colors.black,
          keyWidth: 60,
          noteRange: NoteRange.forClefs([Clef.Treble]),
          onNotePositionTapped: (position) {
            FlutterMidi().playMidiNote(midi: position.pitch);
          },
        ),
      ),
    );
  }
}
