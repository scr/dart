library abaloneHole;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'abalone-row.dart';
import 'abalone-board.dart';

/**
 * A Polymer Abalone board element.
 */
@CustomTag('abalone-hole')
class AbaloneHole extends PolymerElement {
  Point lriPt, tblPt, tbrPt;
  
  @published String color = 'transparent';
  AbaloneBoard board;

  AbaloneHole.created() : super.created();
  
  final String EMPTY_COLOR = 'transparent';
  
  holeClicked(Event e, var detail, Node target) {
    board.holeClicked(this,  (target as Element).id);
  }
  
  // TODO(scr): only allow clicking if valid.
  
  clear() {
    color = EMPTY_COLOR;
  }
}
