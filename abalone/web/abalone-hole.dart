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
  holeEntered(Event e, var detail, Node target) {
    var id = (target as Element).id;
    print('enter ' + id);
  }
  holeOut(Event e, var detail, Node target) {
    var id = (target as Element).id;
    print('out ' + id);
  }
}
