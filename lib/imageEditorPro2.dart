
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_editor_pro/transform.dart';
import 'package:screenshot/screenshot.dart';
import 'package:signature/signature.dart';


TextEditingController heightcontroler = TextEditingController();
TextEditingController widthcontroler = TextEditingController();
var width = 300;
var height = 300;
int index=0;

List<SignatureController> _controllers = [];
SignatureController _controller =
SignatureController(penStrokeWidth: thickness, penColor: Colors.green);

List fontsize = [];
var howmuchwidgetis = 0;
List multiwidget = [];
Color currentcolors = Colors.white;
Color pickerColor = Color(0xff443a49);
Color currentColor = Color(0xff443a49);

var thickness = 0.0;

class BrushThickness extends StatefulWidget {
  var thickness;
  BrushThickness(this.thickness);
  @override
  _BrushThicknessState createState() => _BrushThicknessState();
}

class _BrushThicknessState extends State<BrushThickness> {
  @override
  Widget build(BuildContext context) {
    return Slider(
      min: 0,
      max: 10,
      value: thickness,
      onChanged: (value) {
        setState(() {
          thickness = value;
        });
      },
    );
  }
}




class imageEditorPro2 extends StatefulWidget {
  final Color appBarColor;
  final Color bottomBarColor;
  File image;
  imageEditorPro2({this.appBarColor, this.bottomBarColor, this.image});
  @override
  _imageEditorPro2State createState() => _imageEditorPro2State();
}
var slider = 0.0;

class _imageEditorPro2State extends State<imageEditorPro2> {
  void changeColor(Color color) {
    setState(() => pickerColor = color);
    var points = _controller.points;
  }

  List<Offset> offsets = [];
  Offset offset1 = Offset.zero;
  Offset offset2 = Offset.zero;
  final scaf = GlobalKey<ScaffoldState>();
  var openbottomsheet = false;
  List<Offset> _points = <Offset>[];
  List type = [];
  List aligment = [];

  final GlobalKey container = GlobalKey();
  final GlobalKey globalKey = new GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();
  Timer timeprediction;

  void timers() {
    Timer.periodic(Duration(milliseconds: 10), (tim) {
      setState(() {});
      timeprediction = tim;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('j2'),),
      body: Container(
        width: 200,
        height: 200,
        child: TransformDemo(),
      ),
    );
  }
}
