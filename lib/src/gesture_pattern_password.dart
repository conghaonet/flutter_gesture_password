import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'circle.dart';
import 'circle_item_painter.dart';

class GesturePatternPassword extends StatefulWidget {
  final ValueChanged<String> successCallback;
  final ValueChanged<String> selectedCallback;
  final VoidCallback failCallback;
  final ItemAttribute attribute;
  final double height;
  final double width;

  GesturePatternPassword(
      {@required this.successCallback,
        this.failCallback,
        this.selectedCallback,
        this.attribute: const ItemAttribute(),
        this.height: 300.0,
        this.width,
      });

  @override
  _GesturePatternPasswordState createState() => new _GesturePatternPasswordState();
}

class _GesturePatternPasswordState extends State<GesturePatternPassword> {
  Offset touchPoint = Offset.zero;
  List<Circle> circleList = new List<Circle>();
  List<Circle> lineList = new List<Circle>();

  @override
  void initState() {
    num hor = (widget.width??MediaQueryData.fromWindow(ui.window).size.width) / 6;
    num ver = widget.height / 6;
    //每个圆的中心点
    for (int i = 0; i < 9; i++) {
      num tempX = (i % 3 + 1) * 2 * hor - hor;
      num tempY = (i ~/ 3 + 1) * 2 * ver - ver;
      circleList.add(new Circle(new Offset(tempX, tempY), i));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = new Size(
        widget.width??MediaQueryData.fromWindow(ui.window).size.width, widget.height);
    return new GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          RenderBox box = context.findRenderObject();
          touchPoint = box.globalToLocal(details.globalPosition);
          //防止绘画越界
          if (touchPoint.dy < 0) {
            touchPoint = new Offset(touchPoint.dx, 0.0);
          }
          if (touchPoint.dy > widget.height) {
            touchPoint = new Offset(touchPoint.dx, widget.height);
          }
          Circle circle = getOuterCircle(touchPoint);
          if (circle != null) {
//            print('circle.isUnSelected()${circle.isUnSelected()}');
            if (circle.isUnSelected()) {
              lineList.add(circle);
              circle.setState(Circle.CIRCLE_SELECTED);
              if (widget.selectedCallback != null) {
                widget.selectedCallback(getPassword());
              }

//              print('circle.isUnSelected()2222${circle.isUnSelected()}');
            }
          }
          print(lineList.length);
//          print(lineList.map((f)=>f.offset));
        });
      },
      onPanEnd: (DragEndDetails details) {
        setState(() {
          if (circleList
              .where((Circle itemCircle) => itemCircle.isSelected())
              .length >=
              4) {
            widget.successCallback(getPassword());
          } else {
            if (widget.failCallback != null) {
              widget.failCallback();
            }
          }
          touchPoint = Offset.zero;
          lineList.clear();
          for (int i = 0; i < circleList.length; i++) {
            Circle circle = circleList[i];
            circle.setState(Circle.CIRCLE_NORMAL);
          }
        });
      },
      child: new CustomPaint(
          size: size,
          painter: new CircleItemPainter(
            widget.attribute,
            touchPoint,
            circleList,
            lineList,
          )),
    );
  }

  ///判断是否在圈里
  Circle getOuterCircle(Offset offset) {
    for (int i = 0; i < 9; i++) {
      var cross = offset - circleList[i].offset;
      if (cross.dx.abs() < widget.attribute.focusDistance &&
          cross.dy.abs() < widget.attribute.focusDistance) {
        return circleList[i];
      }
    }
    return null;
  }

  String getPassword() {
    return lineList
        .map((selectedItem) => selectedItem.index.toString())
        .toList()
        .fold("", (s, str) {
      return s + str;
    });
  }
}

class ItemAttribute {
  final Color selectedColor;
  final Color normalColor;
  final double lineStrokeWidth;
  final double circleStrokeWidth;
  final double smallCircleR;
  final double bigCircleR;
  final double focusDistance;
  const ItemAttribute({
    this.normalColor = Colors.grey,
    this.selectedColor = Colors.blue,
    this.lineStrokeWidth: 2.0,
    this.circleStrokeWidth: 2.0,
    this.smallCircleR: 10.0,
    this.bigCircleR: 30.0,
    this.focusDistance: 25.0,
  });
}
