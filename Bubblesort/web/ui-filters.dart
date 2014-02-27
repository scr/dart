library filters;
import 'package:polymer/polymer.dart' show ObservableList;
import 'package:polymer_expressions/filter.dart';

class StringToIntegerList extends Transformer<String, List<int>> {
  final StringToInteger asInteger = new StringToInteger();
  String forward(List<int> ints) {
  	List<String> strings = [];
  	strings.addAll(ints.map(asInteger.forward));
  	return strings.join(' ');
  }
  ObservableList reverse(String s) {
    print("converting $s");
    List<int> ints = [];
    ints.addAll(s.trim().split(' ').map(asInteger.reverse));
    return new ObservableList.from(ints);
  }
}

class StringToInteger extends Transformer<String, int> {
  final int radix;
  StringToInteger({this.radix: 10});
  String forward(int i) => '$i';
  int reverse(String s) => s == null ? null : int.parse(s, radix: radix, onError: (s) => null);
}
