// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'camera_preview_scanner.dart';
import 'material_barcode_scanner.dart';
import 'picture_scanner.dart';

class OcrCameraPage extends StatefulWidget {
  OcrCameraPage(this.cameras);
  final List<CameraDescription> cameras;

  @override
  State<StatefulWidget> createState() => _OcrCameraPageState();
}


class _OcrCameraPageState extends State<OcrCameraPage> {
  List<CameraDescription> cameras;

  static final List<String> _exampleWidgetNames = <String>[
    '$PictureScanner',
    '$CameraPreviewScanner',
    '$MaterialBarcodeScanner',
  ];

  @override
  void initState() {
    super.initState();
    this.cameras = widget.cameras;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example List'),
      ),
      body: ListView.builder(
        itemCount: _exampleWidgetNames.length,
        itemBuilder: (BuildContext context, int index) {
          final String widgetName = _exampleWidgetNames[index];

          return Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey)),
            ),
            child: ListTile(
              title: Text(widgetName),
              onTap: () => Navigator.pushNamed(context, '/$widgetName'),
            ),
          );
        },
      ),
    );
  }
}
