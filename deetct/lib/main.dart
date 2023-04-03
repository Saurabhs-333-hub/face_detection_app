import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:ui' as ui;

List<int> ids = [];
void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File _imageFile;
  List<Face> _faces;
  bool isLoading = false;
  ui.Image _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: _getImage,
          child: Icon(Icons.add_a_photo),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : (_imageFile == null)
                ? Center(child: Text('no image selected'))
                : Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // for (var i = 0; i < ids.length; i++)
                      Container(
                        color: Colors.amber,
                        // width: 100,
                        height: 40,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Face ID: ${ids}"),
                          ),
                        ),
                      ),
                      FittedBox(
                        child: SizedBox(
                          width: _image.width.toDouble(),
                          height: _image.height.toDouble(),
                          child: CustomPaint(
                            painter: FacePainter(_image, _faces),
                          ),
                        ),
                      ),
                    ],
                  )));
  }

  _getImage() async {
    // ids = [];

    final imageFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      isLoading = true;
    });

    final image = InputImage.fromFile(File(imageFile.path));
    final faceDetector = GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
        enableTracking: true,
        // enableClassification: true,
        // enableContours: true,
        // enableLandmarks: true,
        performanceMode: FaceDetectorMode.accurate));
    List<Face> faces = await faceDetector.processImage(image);

    if (mounted) {
      setState(() {
        _imageFile = File(imageFile.path);
        _faces = faces;
        _loadImage(File(imageFile.path));
      });
    }
  }

  _loadImage(File file) async {
    final data = await file.readAsBytes();
    await decodeImageFromList(data).then((value) => setState(() {
          _image = value;
          isLoading = false;
        }));
  }
}

class FacePainter extends CustomPainter {
  final ui.Image image;
  final List<Face> faces;
  final List<Rect> rects = [];
  final List<int> id = [];

  FacePainter(this.image, this.faces) {
    for (var i = 0; i < faces.length; i++) {
      rects.add(faces[i].boundingBox);
      id.add(faces[i].trackingId);
      if (id.isNotEmpty) {
        for (var i = 0; i < id.length; i++) {
          print("${id[i]}");
        }
        ids = id;
        print(ids);
      }
    }
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..color = Color.fromARGB(255, 255, 255, 255);

    canvas.drawImage(image, Offset.zero, Paint());
    for (var i = 0; i < faces.length; i++) {
      canvas.drawRect(rects[i], paint);
      canvas.drawLine(Offset(0, 0), Offset(2, 2), paint);
    }
  }

  @override
  bool shouldRepaint(FacePainter old) {
    return image != old.image || faces != old.faces;
  }
}
