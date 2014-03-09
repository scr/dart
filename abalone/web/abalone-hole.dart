import 'package:polymer/polymer.dart';
import 'dart:html';

/**
 * A Polymer Abalone board element.
 */
@CustomTag('abalone-hole')
class AbaloneHole extends PolymerElement {
  @published String color = 'transparent';
  AbaloneHole.created() : super.created();
  
  final String EMPTY_COLOR = 'transparent';

  holeClicked() {
    print('clicked');
    if (color == 'yellow')
      color = 'black';
    else
      color = 'yellow';
  }
  
  clear() {
    color = EMPTY_COLOR;
  }
  holeHovered(Event e, var detail, Node target) {
    print('hovering:' + e.toString() + ',' + detail.toString());
    print('x=' + (e as MouseEvent).client.x.toString());
    print('y=' + (e as MouseEvent).client.y.toString());
  }
  holeMoved(Event e, var detail, Node target) {
    print('move:' + e.toString() + ',' + detail.toString());
    print('x=' + (e as MouseEvent).client.x.toString());
    print('y=' + (e as MouseEvent).client.y.toString());
  }
}
