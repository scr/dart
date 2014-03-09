import 'dart:svg';
import 'package:polymer/polymer.dart';
import 'abalone-row.dart';

/**
 * A Polymer Abalone board element.
 */
@CustomTag('abalone-board')
class AbaloneBoard extends PolymerElement {
  AbaloneBoard.created() : super.created();
  
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
}
