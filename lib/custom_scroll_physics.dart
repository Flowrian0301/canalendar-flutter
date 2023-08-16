import 'package:flutter/widgets.dart';

class CustomPageScrollPhysics extends ScrollPhysics {
  CustomPageScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  ScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageScrollPhysics(parent: buildParent(ancestor));
  }

@override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    velocity *= 5;
    print(velocity);
    return super.createBallisticSimulation(position, velocity);
  }
}