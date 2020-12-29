import 'dart:async';
import 'dart:io';

import 'transform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_editor_pro/modules/all_emojies.dart';
import 'package:image_editor_pro/modules/bottombar_container.dart';
import 'package:image_editor_pro/modules/colors_picker.dart';
import 'package:image_editor_pro/modules/emoji.dart';
import 'package:image_editor_pro/modules/text.dart';
import 'package:image_editor_pro/modules/textview.dart';
import 'package:path_provider/path_provider.dart';
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

class ImageEditorPro extends StatefulWidget {
  final Color appBarColor;
  final Color bottomBarColor;
  File image;
  ImageEditorPro({this.appBarColor, this.bottomBarColor, this.image});

  @override
  _ImageEditorProState createState() => _ImageEditorProState();
}

var slider = 0.0;

class _ImageEditorProState extends State<ImageEditorPro> {
  // create some values

// ValueChanged<Color> callback
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
  void dispose() {
    timeprediction.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    //timers();
    _controller.clear();
    type.clear();
    fontsize.clear();
    offsets.clear();
    multiwidget.clear();
    howmuchwidgetis = 0;
    _controllers.add(_controller);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        key: scaf,
        appBar: new AppBar(
          actions: <Widget>[
            new IconButton(
                icon: Icon(FontAwesomeIcons.boxes),
                onPressed: () {
                  showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: new Text("Select Height Width"),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  setState(() {
                                    height = int.parse(heightcontroler.text);
                                    width = int.parse(widthcontroler.text);
                                  });
                                  heightcontroler.clear();
                                  widthcontroler.clear();
                                  Navigator.pop(context);
                                },
                                child: new Text("Done"))
                          ],
                          content: new SingleChildScrollView(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text("Define Height"),
                                new SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                    controller: heightcontroler,
                                    keyboardType:
                                        TextInputType.numberWithOptions(),
                                    decoration: InputDecoration(
                                        hintText: 'Height',
                                        contentPadding:
                                            EdgeInsets.only(left: 10),
                                        border: OutlineInputBorder())),
                                new SizedBox(
                                  height: 10,
                                ),
                                new Text("Define Width"),
                                new SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                    controller: widthcontroler,
                                    keyboardType:
                                        TextInputType.numberWithOptions(),
                                    decoration: InputDecoration(
                                        hintText: 'Width',
                                        contentPadding:
                                            EdgeInsets.only(left: 10),
                                        border: OutlineInputBorder())),
                              ],
                            ),
                          ),
                        );
                      });
                }),
            new FlatButton(
                child: new Text("Done"),
                textColor: Colors.white,
                onPressed: () {
                  File _imageFile;
                  _imageFile = null;
                  screenshotController
                      .capture(
                          delay: Duration(milliseconds: 500), pixelRatio: 1.5)
                      .then((File image) async {
                    //print("Capture Done");
                    setState(() {
                      _imageFile = image;
                    });
                    final paths = await getExternalStorageDirectory();
                    image.copy(paths.path +
                        '/' +
                        DateTime.now().millisecondsSinceEpoch.toString() +
                        '.png');
                    Navigator.pop(context, image);
                  }).catchError((onError) {
                    print(onError);
                  });
                }),
          ],
          backgroundColor: widget.appBarColor,
        ),
        body:

        Center(
          child: Screenshot(
            controller: screenshotController,
            child: Container(
              margin: EdgeInsets.all(20),
              color: Colors.white,
              width: width.toDouble(),
              height: height.toDouble(),
              child:
              RepaintBoundary(
                  key: globalKey,
                  child: Stack(
                    children: <Widget>[
                      widget.image != null
                          ? Image.file(
                              widget.image,
                              height: height.toDouble(),
                              width: width.toDouble(),
                              fit: BoxFit.cover,
                            )
                          : Container(),
                      ..._controllers.map((element){
                        return Container(
                          child: GestureDetector(
                              onPanUpdate: (DragUpdateDetails details) {
                                setState(() {
                                  RenderBox object = context.findRenderObject();
                                  Offset _localPosition = object
                                      .globalToLocal(details.globalPosition);
                                  _points = new List.from(_points)
                                    ..add(_localPosition);
                                });
                              },
                              onPanEnd: (DragEndDetails details) {
                                _points.add(null);
                              },
                              child: Signat(element)),
                        );
                      }).toList(),


                      Stack(
                         children:
                         multiwidget.asMap().entries.map((f) {
                          return type[f.key] == 1
                              ?
                          EmojiView(

                                  value: f.value.toString(),

                                )
                              : type[f.key] == 2
                                  ?
                              TransformDemo(Text(f.value.toString()))

                                    // TextView(
                                    //     left: offsets[f.key].dx,
                                    //     top: offsets[f.key].dy,
                                    //     ontap: () {
                                    //       scaf.currentState
                                    //           .showBottomSheet((context) {
                                    //         return Sliders(
                                    //           size: f.key,
                                    //           sizevalue:
                                    //               fontsize[f.key].toDouble(),
                                    //         );
                                    //       });
                                    //     },
                                    //     onpanupdate: (details) {
                                    //       setState(() {
                                    //         offsets[f.key] = Offset(
                                    //             offsets[f.key].dx +
                                    //                 details.delta.dx,
                                    //             offsets[f.key].dy +
                                    //                 details.delta.dy);
                                    //       });
                                    //     },
                                    //     value: f.value.toString(),
                                    //     fontsize: fontsize[f.key].toDouble(),
                                    //     align: TextAlign.center,
                                    //   )
                                  : null;
                        }).toList(),
                      )
                    ],)),
            ),),),
        bottomNavigationBar: openbottomsheet
            ? new Container()
            : Container(
                decoration: BoxDecoration(
                    color: widget.bottomBarColor,
                    boxShadow: [BoxShadow(blurRadius: 10.9)]),
                height: 70,
                child: new ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    BottomBarContainer(
                      colors: widget.bottomBarColor,
                      icons: FontAwesomeIcons.brush,
                      ontap: () {
                        // raise the [showDialog] widget
                        showDialog(
                            context: context,
                            child: AlertDialog(
                              title: const Text('Pick your Brush!'),
                              content: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ColorPicker(
                                      pickerColor: pickerColor,
                                      onColorChanged: changeColor,
                                      showLabel: true,
                                      pickerAreaHeightPercent: 0.8,
                                    ),
                                    BrushThickness(thickness)
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: const Text('Got it'),
                                  onPressed: () {
                                    setState(() {
                                      currentColor = pickerColor;
                                      index=index+1;
                                      SignatureController _recentController =
                                          SignatureController(
                                              penStrokeWidth: thickness,
                                              penColor: currentColor);
                                      _controllers.add(_recentController);
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ));
                      },
                      title: 'Brush',
                    ),
                    BottomBarContainer(
                      icons: Icons.text_fields,
                      ontap: () async {

                        final value = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TextEditor()));
                        if (value.toString().isEmpty) {
                          print("true");
                        } else {
                          type.add(2);
                          fontsize.add(200);
                          offsets.add(Offset.zero);
                          multiwidget.add(value);
                          howmuchwidgetis++;
                          setState(() {

                          });
                        }
                      },
                      title: 'Text',
                    ),
                    BottomBarContainer(
                      icons: FontAwesomeIcons.eraser,
                      ontap: () {
                        _controllers.last.clear();
                        _controllers.last.dispose();
                        type.clear();
                        fontsize.clear();
                        offsets.clear();
                        multiwidget.clear();
                        howmuchwidgetis = 0;
                      },
                      title: 'Eraser',
                    ),
                    BottomBarContainer(
                      icons: Icons.photo,
                      ontap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return ColorPiskersSlider();
                            });
                      },
                      title: 'Filter',
                    ),
                    BottomBarContainer(
                      icons: FontAwesomeIcons.smile,
                      ontap: () {
                        Future getemojis = showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Emojies();
                            });
                        getemojis.then((value) {
                          if (value != null) {
                            type.add(1);
                            fontsize.add(20);
                            offsets.add(Offset.zero);
                            multiwidget.add(value);
                            howmuchwidgetis++;
                          }
                        });
                      },
                      title: 'Emoji',
                    ),
                  ],
                ),
              ));
  }
}

// class SignatList extends StatefulWidget {
//
//   @override
//   _SignatListState createState() => _SignatListState();
// }
//
// class _SignatListState extends State<SignatList> {
//   @override
//   void initState() {
//     super.initState();
//
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return //SIGNATURE CANVAS
//       //SIGNATURE CANVAS
//       SingleChildScrollView(
//         child: ListView.builder(
//           itemCount:  _controllers.length ,
//           itemBuilder: (_,index){
//             return Signat(_controllers[index]);
//           },
//
//         ),
//       );
//   }
// }

class Signat extends StatefulWidget {
  SignatureController _basicControlers;
  bool newController = true;
  Signat(this._basicControlers);
  @override
  _SignatState createState() => _SignatState();
}

class _SignatState extends State<Signat> {



  @override
  Widget build(BuildContext context) {
    if(widget.newController == false){
      setState(() {
        widget._basicControlers.addListener(() => print('hi'));
        widget.newController=true;
      });
    }

    return //SIGNATURE CANVAS
        //SIGNATURE CANVAS
        ListView(
      children: <Widget>[
        Signature(
            controller: widget._basicControlers,
            height: height.toDouble(),
            width: width.toDouble(),
            backgroundColor: Colors.transparent),
      ],
    );
  }
}

class Sliders extends StatefulWidget {
  final int size;
  final sizevalue;
  const Sliders({Key key, this.size, this.sizevalue}) : super(key: key);
  @override
  _SlidersState createState() => _SlidersState();
}

class _SlidersState extends State<Sliders> {
  @override
  void initState() {
    slider = widget.sizevalue;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 120,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: new Text("Slider Size"),
            ),
            Divider(
              height: 1,
            ),
            new Slider(
                value: slider,
                min: 0.0,
                max: 100.0,
                onChangeEnd: (v) {
                  setState(() {
                    fontsize[widget.size] = v.toInt();
                  });
                },
                onChanged: (v) {
                  setState(() {
                    slider = v;
                    print(v.toInt());
                    fontsize[widget.size] = v.toInt();
                  });
                }),
          ],
        ));
  }
}

class ColorPiskersSlider extends StatefulWidget {
  var opicity = 0.1;
  @override
  _ColorPiskersSliderState createState() => _ColorPiskersSliderState();
}

class _ColorPiskersSliderState extends State<ColorPiskersSlider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 260,
      color: Colors.white,
      child: new Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: new Text("Slider Filter Color"),
          ),
          Divider(
            height: 1,
          ),
          SizedBox(height: 20),
          new Text("Slider Color"),
          SizedBox(height: 10),
          BarColorPicker(
              width: 300,
              thumbColor: Colors.white,
              cornerRadius: 10,
              pickMode: PickMode.Color,
              colorListener: (int value) {
                setState(() {
                  //  currentColor = Color(value);
                });
              }),
          SizedBox(height: 20),
          new Text("Slider Opicity"),
          SizedBox(height: 10),
          Slider(
              value: widget.opicity,
              min: 0.0,
              max: 1.0,
              onChanged: (v) {
                widget.opicity = v;
              })
        ],
      ),
    );
  }
}
