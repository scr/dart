library abaloneBoard;

import 'package:polymer/polymer.dart';
import 'abalone-row.dart';
import 'abalone-hole.dart';
import 'dart:html';
import 'dart:math';


/**
 * A Polymer Abalone board element.
 */
@CustomTag('abalone-board')
class AbaloneBoard extends PolymerElement {
  List<List<AbaloneHole>> lriRows = [];
  List<List<AbaloneHole>> tbrRows = [];
  List<List<AbaloneHole>> tblRows = [];
  
  AbaloneBoard.created() : super.created();
  
  ready() {
    super.ready();
    
    ElementList rows = shadowRoot.querySelectorAll('abalone-row');
    for (int i = 0; i < rows.length; ++i) {
      // left to right
      List<AbaloneHole> lriRow = [];
      lriRow.addAll(rows[i].holes);
      for (int j = 0; j < lriRow.length; ++j) {
        lriRow[j].lriPt = new Point(j, i);
        lriRow[j].board = this;
      }
      lriRows.add(lriRow);
      rows[i].index = i;
      rows[i].board = this;
      
      // Create top to bottom left & top to bottom right.
      tbrRows.add([]);
      tblRows.add([]);
    }
    // Populate top to bottom left
    for (int i = 0; i < rows.length; ++i) {
      int startRow = max(0, i - 4);
      int endRow = min(5 + i, 9);
      for (int j = startRow; j < endRow; ++j) {
        int colOffset = min(4 - j, 0);
        AbaloneHole hole = lriRows[j][i + colOffset];
        hole.tblPt = new Point(j - startRow, i);
        tblRows[i].add(hole);
        // print(new Point(j, i + colOffset).toString());
      }
    }
    // Populate top to bottom right
    for (int i = 0; i < rows.length; ++i) {
      int startRow = max(4 - i, 0);
      int endRow = min(4 + 9 - i, 9);
      for (int j = startRow; j < endRow; ++j) {
        int colOffset = min(j - 4, 0);
        AbaloneHole hole = lriRows[j][i + colOffset];
        hole.tbrPt = new Point(j - startRow, i);
        tbrRows[i].add(hole);
        // print(new Point(j, i + colOffset).toString());
      }
    }
  }
  
  clearRow(AbaloneRow row) => row.clear(); 
  
  setup(int numPlayers) {
    var rows = shadowRoot.querySelectorAll('abalone-row');
    rows.forEach(clearRow);
    
    switch (numPlayers) {
      case 2:
        rows[0].setColor('yellow');
        rows[1].setColor('yellow');
        rows[2].setColor('yellow', 2, 3);
        rows[6].setColor('red', 2, 3);
        rows[7].setColor('red');
        rows[8].setColor('red');
        break;
      case 3:
        rows[0].setColor('yellow', 0, 2);
        rows[1].setColor('yellow', 0, 2);
        rows[2].setColor('yellow', 0, 2);
        rows[3].setColor('yellow', 0, 2);
        rows[4].setColor('yellow', 0, 2);
        rows[5].setColor('yellow', 0, 1);

        rows[0].setColor('red', 3, 2);
        rows[1].setColor('red', 4, 2);
        rows[2].setColor('red', 5, 2);
        rows[3].setColor('red', 6, 2);
        rows[4].setColor('red', 7, 2);
        rows[5].setColor('red', 7, 1);

        rows[7].setColor('blue');
        rows[8].setColor('blue');
        break;
    }
  }
    
  holeClicked(AbaloneHole hole, String direction) {
    List<List<AbaloneHole>> rows;
    Point boardPt;
    int offset;
    switch (direction) {
      case 'tr':
        rows = tblRows;
        boardPt = hole.tblPt;
        offset = 1;
        print('clicked ' + direction);
        print('moving down left');
        break;
      case 'ri':
        rows = lriRows;
        boardPt = hole.lriPt;
        offset = -1;
        print('moving left');
        break;
      case 'br':
        rows = tbrRows;
        boardPt = hole.tbrPt;
        offset = -1;
        print('moving up left');
        break;
      case 'bl':
        rows = tblRows;
        boardPt = hole.tblPt;
        offset = -1;
        print('moving up right');
        break;
      case 'le':
        rows = lriRows;
        boardPt = hole.lriPt;
        offset = 1;
        print('moving right');
        break;
      case 'tl':
        rows = tbrRows;
        boardPt = hole.tbrPt;
        offset = 1;
        print('moving down right');
        break;
    }
    print('clicked ' + direction + ' ' + boardPt.toString() + ' ' + offset.toString());
    List<AbaloneHole> row = rows[boardPt.y];
    int newX = boardPt.x + offset;
    if (newX >= 0 && newX < row.length) {
      row[newX].color = row[boardPt.x].color;
      row[boardPt.x].clear();
    }
  }
}
