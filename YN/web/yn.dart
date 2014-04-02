
import 'dart:html';
import 'dart:convert';

import 'package:chrome/chrome_app.dart' as chrome;

int boundsChange = 100;

/**
 * For non-trivial uses of the Chrome Apps API, please see the
 * [chrome](http://pub.dartlang.org/packages/chrome).
 * 
 * * http://developer.chrome.com/apps/api_index.html
 */
void main() {
  //populateNews();
  populateSlingstone();
}

void localizeImage(ImageElement img, {String src}) {
  if (src == null)
    src = img.src;

  img.src = '';
  HttpRequest.request(src, responseType: 'blob')
    .then((HttpRequest request) {
      img.src = Url.createObjectUrlFromBlob(request.response);
    });
}

void populateSlingstone() {
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
          Element newsDiv = document.querySelector('#news');
          newsDiv.text = '';
          Map snippet_json = JSON.decode(snippet_data);
          List<Map> results = snippet_json['results'];
          results.forEach((result) {
            Element resultDiv = new Element.div();
            resultDiv.classes.add('item');
            
            Element titleDiv = new Element.div();
            titleDiv.classes.add('title');
            titleDiv.text = result['title'];
            resultDiv.append(titleDiv);
            
            Element contentDiv = new Element.div();
            contentDiv.classes.add('content');
            resultDiv.append(contentDiv);
            
            Element image = new Element.img();
            try {
              String image_src = result['image']['original']['url'];
              localizeImage(image, src: image_src);
              contentDiv.append(image);
            } catch (ex) {
            }
            Element summaryDiv = new Element.div();
            summaryDiv.classes.add('summary');
            summaryDiv.text = result['summary'];
            contentDiv.append(summaryDiv);
            
            Element explanationDiv = new Element.div();
            explanationDiv.classes.add('explanation');
            explanationDiv.text = elementMap[result['uuid']]['explain']['reason'];
            resultDiv.append(explanationDiv);

            Element entitiesDiv = new Element.div();
            entitiesDiv.classes.add('entities');
            List<Map> entities = result['entities'];
            if (entities != null) {
              entities.forEach((entity) {
                Element entityDiv = new Element.div();
                entityDiv.classes.add('entity');
                entityDiv.appendText(entity['name'] + ' cap=' + entity['capAbtScore'].toString());
                entitiesDiv.append(entityDiv);
              });
            }
            resultDiv.append(entitiesDiv);

            newsDiv.append(resultDiv);
          });
        });
    });
}
void populateNews() {
  HttpRequest.getString('http://query.yahooapis.com/v1/public/yql?q=select%20title%2Cdescription%20from%20rss%20where%20url%3D%22http%3A%2F%2Frss.news.yahoo.com%2Frss%2Ftopstories%22&format=json&callback=')
    .then((data) {
      Element newsDiv = document.querySelector('#news');
      newsDiv.text = '';

      Map json = JSON.decode(data);
      List<Map> items = json['query']['results']['item'];
      items.forEach((Map item) {
        Element itemDiv = new Element.div();
        itemDiv.classes.add('item');
        Element titleDiv = new Element.div();
        titleDiv.classes.add('title');
        titleDiv.text = item['title'];
        itemDiv.append(titleDiv);
        Element descriptionDiv = new Element.div();
        descriptionDiv.classes.add('description');
        descriptionDiv.appendHtml(item['description']);
        descriptionDiv.querySelectorAll('img').forEach(localizeImage);
        itemDiv.append(descriptionDiv);
        newsDiv.append(itemDiv);
      });
    });
}
