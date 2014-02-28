library filters;

import 'package:polymer_expressions/filter.dart';

class SpaceSepStringToInts extends Transformer<String, List<int>> {
  final StringToInt asInt = new StringToInt();
  
  String forward(List<int> l) {
    List<String> s = [];
    s.addAll(l.map(asInt.forward));
    return s.join(' ');
  }
  
  List<int> reverse(String s) {
    List<int> ret = [];
    ret.addAll(s.trim().split(' ').map(asInt.reverse));
    return ret;
  }
}

class StringToInt extends Transformer<String, int> {
  String forward(int i) => i.toString();
  int reverse(String s) => int.parse(s);
}

class StringToDouble extends Transformer<String, double> {
  String forward(double i) => i.toString();
  double reverse(String s) => double.parse(s);
}
