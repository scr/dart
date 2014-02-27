import 'dart:html';
import 'dart:convert';
import 'package:polymer/polymer.dart';

/**
 * A Polymer click counter element.
 */
@CustomTag('oscar-entries')
class OscarEntries extends PolymerElement {
  @observable Map oscars;

  OscarEntries.created() : super.created() {
    const String url = 'oscars.json';
    HttpRequest.getString(url).then(onLoaded);
  }

  void onLoaded(String response) {
    oscars = toObservable(JSON.decode(response));
  }
}
