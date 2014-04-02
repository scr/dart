
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
  populateNews();
}

void localizeImage(ImageElement img) {
  String src = img.src;
  img.src = '';
  HttpRequest.request(src, responseType: 'blob')
    .then((HttpRequest request) {
      img.src = Url.createObjectUrlFromBlob(request.response);
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
