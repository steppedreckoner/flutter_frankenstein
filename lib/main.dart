// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:camera/camera.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:frankenstein/widgets/camera.dart';

List<CameraDescription> cameras;

void main() async {
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    final wordPair = WordPair.random();
    return MaterialApp(
      title: 'The Name Thing',
      theme: ThemeData(
          primaryColor: Colors.lightBlue
      ),
        home: MainMenu(),
//      home: RandomWords(),
    );
  }
}

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(title: Text('Main Menu'),),
      body: _buildMainMenu(context)

    );
  }

  Widget _buildMainMenu(BuildContext context) {

    return
    ListView(
      padding: const EdgeInsets.all(8.0),
      children: <Widget> [
        ListTile(title: Text("Random Words"), trailing: Icon(Icons.short_text, color: Colors.red), onTap: _randomWords(context)),
        Divider(),
        ListTile(title: Text("OCR Camera (not working)"), trailing: Icon(Icons.camera, color: Colors.black), onTap: _ocrCamera(context)),
        Divider(),
        ListTile(title: Text("Camera in Frame"), trailing: Icon(Icons.all_out, color: Colors.amber), onTap: _cameraInFrame(context)),
        Divider(),
        ListTile(title: Text("Display Camera View"), trailing: Icon(Icons.all_inclusive, color: Colors.tealAccent), onTap: _openCamera(context)),
      ],
    );

  }

  void _randomWords(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return RandomWords();
        }
      )
    );
  }

  void _ocrCamera(BuildContext context) {
    print('pressed ocr camera');
//    Navigator.of(context).push(
//      MaterialPageRoute<void>(
//        builder: (BuildContext context) {
//          return OcrCameraPage(cameras);
//        }
//      )
//    );
  }

  void _cameraInFrame(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return CameraExampleHome(cameras);
        },
      ),
    );
  }

  void _openCamera(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return CameraApp();
        },
      ),
    );
  }
}

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController controller;
  List<CameraDescription> cameras;

  @override
  void initState() {
    super.initState();
    _initCamera();
//    cameras = availableCameras();
//    controller = CameraController(cameras[0], ResolutionPreset.medium);
//    controller.initialize().then((_) {
//      if (!mounted) {
//        return;
//      }
//      setState(() {});
//    });
  }

  void _initCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
        aspectRatio:
        controller.value.aspectRatio,
        child: CameraPreview(controller));
  }
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }



  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
                  (WordPair pair) {
                return ListTile(
                  title: Text(
                    pair.asPascalCase,
                    style: _biggerFont,
                  ),
                );
              }
          );
          final List<Widget> divided = ListTile.divideTiles(tiles: tiles, context: context).toList();
          return Scaffold(
              appBar: AppBar (title: Text('Saved Suggestions'),),
              body: ListView(children: divided,)
          );
        },
      ),
    );
  }

  Widget _buildSuggestions() {

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();

        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_suggestions[index]);
      },

    );
  }



  Widget _buildRow(WordPair wordPair) {
    final _alreadySaved = _saved.contains(wordPair);
    return ListTile(
      title: Text(
          wordPair.asPascalCase,
          style: _biggerFont
      ),
      trailing: Icon(
        _alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: _alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (_alreadySaved) _saved.remove(wordPair);
          else _saved.add(wordPair);
        });
      },
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}
