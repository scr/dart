import 'package:polymer/polymer.dart';

@CustomTag('oscar-category')
class OscarCategory extends PolymerElement {
  @published String name;
  @published List<String> nominees = toObservable([]);

  OscarCategory.created() : super.created();
}