
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

class TransformDemo extends StatelessWidget {
  String text;
  File image;
  TransformDemo({this.text,this.image});
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
    return  Scaffold(
      appBar: AppBar(
        title: Text("Apply Text"),
      ),
      body: Container(
        height: 200,
        width: 200,
        color: Colors.blue,
        child: Stack(
          children: [
            image != null
                ? Image.file(
              image,

              fit: BoxFit.cover,
            )
                : Container(
              height: 200,
              width: 200,
              color: Colors.blue,
            ),
            MatrixGestureDetector(
              onMatrixUpdate: (m, tm, sm, rm) {

                notifier.value = m;
              },
              shouldRotate: true,
              shouldScale: true,
              shouldTranslate: true,
              child: AnimatedBuilder(
                animation: notifier,
                builder: (ctx, child) {
                  print("animating ");
                  return Transform(
                    transform: notifier.value,
                    child:
                    Positioned.fill(
                      child: Container(
                        transform: notifier.value,
                        color: Colors.red,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text("hello",),
                        ),
                      ),
                    ),


                  );
                },
              ),
            ),
          ],

        ),
      ),
    );
  }
}
