
import 'dart:html';

import 'package:polymer/polymer.dart';

@CustomTag('slingstone-news-item')
class SlingstoneNewsItem extends PolymerElement {
  @published String title;
  @published String summary;
  @published List<Map> entities;

  localizeImage(ImageElement img, {String src}) {
    if (src == null)
      src = img.src;

    img.src = '';
    HttpRequest.request(src, responseType: 'blob')
      .then((HttpRequest request) {
        img.src = Url.createObjectUrlFromBlob(request.response);
      });
  }

  setResult(Map result) {
    title = result['title'];
    summary = result['summary'];
    entities = result['entities'];
    ImageElement image = shadowRoot.querySelector('img');
    try {
      String image_src = result['image']['original']['url'];
      localizeImage(image, src: image_src);
    } catch (ex) {
      image.remove();
    }
  }
  
  SlingstoneNewsItem.created() : super.created();
}