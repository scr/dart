import 'dart:html';
import 'dart:convert';
import 'package:polymer/polymer.dart';
import 'package:polymer_expressions/filter.dart' show Transformer;
import 'ui-filters.dart';

/**
 * A Polymer click counter element.
 */
@CustomTag('oscar-nominee')
class OscarNominee extends PolymerElement {
  @published String name;
  double _points = 0.0;
  bool _checked = false;
  
  @reflectable bool get checked => _checked;
  @reflectable set checked(bool val) => 
      _checked = notifyPropertyChange(#checked, _checked, val);
  
  @reflectable double get points => _points;
  @reflectable set points(double val) => 
      _points = notifyPropertyChange(#points, _points, val);
  
  final Transformer asDouble = new StringToDouble();

  OscarNominee.created() : super.created();
  
  nameClicked() {
    checked = !_checked;
  }
}