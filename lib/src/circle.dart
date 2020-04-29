import 'dart:ui';

class Circle {
  static const CIRCLE_SELECTED = 1;
  static const CIRCLE_NORMAL = 0;
  Offset offset;
  int index;
  int state = CIRCLE_NORMAL;

  Circle(this.offset, this.index);

  int getState() {
    return state;
  }

  setState(int state) {
    this.state = state;
  }

  bool isSelected() {
    return state == CIRCLE_SELECTED;
  }

  bool isUnSelected() {
    return state == CIRCLE_NORMAL;
  }
}