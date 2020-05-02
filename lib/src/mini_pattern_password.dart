import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'circle.dart';
import 'mini_circle_view.dart';

class MiniPatternPassword extends StatefulWidget {
  final MiniItemAttribute attribute;
  final double height;

  MiniPatternPassword(
      {Key key,
        this.attribute: const MiniItemAttribute(),
        this.height: 60.0})
      : super(key: key);

  @override
  MiniPatternPasswordState createState() => new MiniPatternPasswordState();
}

class MiniPatternPasswordState extends State<MiniPatternPassword> {
  Offset touchPoint = Offset.zero;
  List<Circle> circleList = new List<Circle>();
  String selectedStr = '';

  @override
  void initState() {
    num hor = widget.height / 6;
    num ver = widget.height / 6;
    //每个圆的中心点
    for (int i = 0; i < 9; i++) {
      num tempX = (i % 3 + 1) * 2 * hor - hor;
      num tempY = (i ~/ 3 + 1) * 2 * ver - ver;
      circleList.add(new Circle(new Offset(tempX, tempY), i));
    }
    super.initState();
  }

  setSelected(String str) {
    setState(() {
      selectedStr = str;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = new Size(widget.height, widget.height);
    return new Container(
      child: new CustomPaint(
          size: size,
          painter:
          new MiniCircleView(widget.attribute, circleList, selectedStr)),
    );
  }
}



class MiniItemAttribute {
  final Color selectedColor;
  final Color normalColor;
  final double smallCircleR;
  const MiniItemAttribute({
    this.normalColor = Colors.grey,
    this.selectedColor = Colors.blue,
    this.smallCircleR: 6.0,
  });
}
