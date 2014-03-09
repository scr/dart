import 'package:polymer/polymer.dart';
import 'ui-filters.dart';
import 'package:polymer_expressions/filter.dart' show Transformer;
import 'abalone-board.dart';

/**
 * A Polymer Abalone game element.
 */
@CustomTag('abalone-game')
class AbaloneGame extends PolymerElement {
  @published int numPlayers = 2;
  
  final Transformer asInt = new StringToInt();

  AbaloneGame.created() : super.created();
  
  setup() => ($['board'] as AbaloneBoard).setup(numPlayers);

  @override
  ready() => setup();

  setupClicked() {
    setup();
  }
}
