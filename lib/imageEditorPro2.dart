
import 'package:flutter/material.dart';
import 'package:image_editor_pro/transform.dart';
class imageEditorPro2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ji'),),
      body: Container(
        width: 200,
        height: 200,
        child: TransformDemo(),
      ),
    );
  }
}
