import 'package:polymer/polymer.dart';
import 'package:polymer_expressions/filter.dart' show Transformer;
import 'ui-filters.dart';

/**
 * A Polymer click counter element.
 */
@CustomTag('bubble-sort')
class BubbleSort extends PolymerElement {
  @published List<int> numbers = toObservable([333,6,4,3,5,1,77,2]);
  @observable int iterations = 0;
  @observable int swapIterations = 0;

  final Transformer asSpaceSepInts = new StringToIntegerList();
  final Transformer asInt = new StringToInteger();
  
  BubbleSort.created() : super.created();
  
  void swap(List<int> l, int a, int b) {
    if (a == b) return;
    
    int tmp = l[a];
    l[a] = l[b];
    l[b] = tmp;
  }
  
  void calc() {
    iterations = swapIterations = 0;
    
    for (bool swapped = true; swapped; ) {
      ++swapIterations;
      swapped = false;
      for (int i = 0; i < numbers.length - 1; ++i) {
        ++iterations;
        if (numbers[i] > numbers[i+1]) {
          swapped = true;
          swap(numbers, i, i+1);
        }
      }
    }
  }

  void calc2() {
    iterations = swapIterations = 0;
    
    ++swapIterations;
    for (int i = 0; i < numbers.length - 1; ++i) {
      for (int j = i; j >=0; --j) {
        ++iterations;
        if (numbers[j] > numbers[j + 1]) {
          swap(numbers, j, j + 1);
        } else {
          break;
        }
      }
    }
  }
  
  int partition(List<int> l, int left, int right, int pivotIndex) {
    int pivotValue = l[pivotIndex];
    swap(l, pivotIndex, right);
    int storeIndex = left;
    for (int i = left; i < right; ++i) {
      ++iterations;
      if (l[i] <= pivotValue) {
        swap(l, i, storeIndex);
        ++storeIndex;
      }
    }
    swap(l, storeIndex, right);
    return storeIndex;
  }
  
  void quicksort(List<int> l, int left, int right) {
    ++swapIterations;
    if (left < right) {
      int pivotIndex = (left + right) ~/ 2;
      int pivotNewIndex = partition(l, left, right, pivotIndex);
      quicksort(l, left, pivotNewIndex - 1);
      quicksort(l, pivotNewIndex + 1, right);
    }
  }
  
  void calc3() {
    iterations = swapIterations = 0;
    quicksort(numbers, 0, numbers.length - 1); 
  }
}

