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
  String _pointsString = "0.0";
  bool _checked = false;
  
  @reflectable bool get checked => _checked;
  @reflectable set checked(bool val) {
    notifyPropertyChange(#userChecked, _checked, val);
    _checked = notifyPropertyChange(#checked, _checked, val);
  }
  
  @reflectable bool get programChecked => _checked;
  @reflectable set programChecked(bool val) {
    _checked = notifyPropertyChange(#checked, _checked, val);
  }
  
  @reflectable get pointsString => _pointsString;
  @reflectable set pointsString(String val) {
    try {
      _points = notifyPropertyChange(#points, _points, double.parse(val));
      _pointsString = notifyPropertyChange(#pointsString, _pointsString, val);
    } on FormatException {
      notifyPropertyChange(#points, _points, _points);
      notifyPropertyChange(#pointsString, _pointsString, _pointsString);
    }
  }
  @reflectable get points => _points;
  @reflectable set points(double val) {
    _points = notifyPropertyChange(#points, _points, val);
    _pointsString = notifyPropertyChange(#pointsString, _pointsString, val.toString());
  }
  
  final Transformer asDouble = new StringToDouble();

  OscarNominee.created() : super.created();
  
  nameClicked() {
    checked = !_checked;
  }
  pointsChanged(p) {
    programChecked = (points != 0.0);
  }
}