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
  @published double points = 0.0;
  @published bool checked = false;
  
  final Transformer asDouble = new StringToDouble();

  OscarNominee.created() : super.created();
}