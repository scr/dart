import 'dart:convert';
import 'dart:html';

import 'package:polymer/polymer.dart';

import 'slingstone-news-item.dart';

@CustomTag('slingstone-news')
class PolymerNews extends PolymerElement {
  PolymerNews.created() : super.created();
  
  ready() {
    super.ready();
    populateSlingstone();
  }
  
  populateSlingstone() {
    HttpRequest.getString('http://any-ts.cpu.yahoo.com:4080/score/v9/homerun/en-US/unified/ga')
      .then((data) {
        Map json = JSON.decode(data);
        List<Map> elements = json['yahoo-coke:stream']['elements'];
        List<String> uuids = [];
        Map<String, Map> elementMap = {};
        elements.forEach((element){
          uuids.add(element['id']);
          elementMap[element['id']] = element;
        });
        HttpRequest.getString('http://snippet-gq1.slingstone.yahoo.com:4080/snippet/v1/?uuids=' + uuids.join(','))
          .then((snippet_data) {
            Element newsDiv = $['news'];
            newsDiv.text = '';
            Map snippet_json = JSON.decode(snippet_data);
            List<Map> results = snippet_json['results'];
            results.forEach((result) {
              newsDiv.append((document.createElement('slingstone-news-item') as SlingstoneNewsItem)
                  ..setResult(result));
            });
          });
      });
  }
}