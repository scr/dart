import 'dart:svg';
import 'package:polymer/polymer.dart';

/**
 * A Polymer Abalone board element.
 */
@CustomTag('abalone-hole')
class AbaloneHole extends PolymerElement {
  AbaloneHole.created() : super.created();

  ready() {
    super.ready();
    
    var circle = new CircleElement();
    circle.attributes['cx'] = '50';
    circle.attributes['cy'] = '50';
    circle.attributes['r'] = '40';
    circle.attributes['stroke'] = 'green';
    circle.attributes['stroke-width'] = '4';
    circle.attributes['fill'] = 'yellow';
    this.$['me'].append(circle);
  }
}
