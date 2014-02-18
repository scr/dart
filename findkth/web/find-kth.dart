import 'dart:html';
import 'package:polymer_expressions/filter.dart' show Transformer;
import 'package:polymer/polymer.dart';
import 'ui-filters.dart';
import 'kth-steps.dart';

/**
 * A Polymer click counter element.
 */
@CustomTag('find-kth')
class FindKth extends PolymerElement {
  @published List<int> a = toObservable([1,2,3,4,5]);
  @published List<int> b = toObservable([6,7,8,9,10]);
  @published int k = 0;
  @observable int kth = 0;
  @observable StepState stepState = new StepState(); 
  
  final Transformer asInt = new StringToInt();
  final Transformer asSpaceSepInts = new SpaceSepStringToInts();

  FindKth.created() : super.created();
  
  int min(int left, int right) {
    if (left < right)
      return left;
    else
      return right;
  }
  
  // Step helpers
  void resetSteps() => stepState.reset(a, b);
  void addRecurseStep(int leftOffset, int rightOffset, int k) =>
      stepState.steps.add(new Step_Recurse(stepState, leftOffset, rightOffset, k));
  void addCompareStep(int leftOffset, int leftK, int rightOffset, int rightK) =>
      stepState.steps.add(new Step_Compare(stepState, leftOffset, leftK, rightOffset, rightK));
  void addRejectStep(int leftOffset, int leftK, int rightOffset, int rightK, bool isA) =>
      stepState.steps.add(new Step_Reject(stepState, leftOffset, leftK, rightOffset, rightK, isA));
  void addKthStep(int k, bool isA) =>
      stepState.steps.add(new Step_Kth(stepState, k, isA));
  
  int findkth(List<int> left, int left_offset, List<int> right, int right_offset, int k) {
    addRecurseStep(left_offset, right_offset, k);

    int newk = k ~/ 2;
    int kmod = k % 2;

    if (k == 1) {
      if (left[left_offset] < right[right_offset]) {
        addKthStep(k, true);
        kthCell(this.$['a'].querySelectorAll('.cell')[left_offset]);
        return left[left_offset];
      } else {
        addKthStep(k, false);
        kthCell(this.$['b'].querySelectorAll('.cell')[right_offset]);
        return right[right_offset];
      }
    } else if (left[left_offset + newk - 1] > right[right_offset + newk + kmod - 1]) {
      addCompareStep(left_offset, left_offset + newk, right_offset, right_offset + newk + kmod);
      ElementList b_cells = this.$['b'].querySelectorAll('.cell');
      for (int i = right_offset; i < right_offset + newk + kmod; ++i) {
        b_cells[i].classes.add('rejected');
      }
      return findkth(left, left_offset, right, right_offset + newk + kmod, newk);
    } else {
      ElementList a_cells = this.$['a'].querySelectorAll('.cell');
      for (int i = left_offset; i < left_offset + newk; ++i) {
        a_cells[i].classes.add('rejected');
      }
      return findkth(left, left_offset + newk, right, right_offset, newk + kmod);
    }
  }
  
  void calc() {
    print('calc');
    reset();
    stepState.reset(
      this.$['a'].querySelectorAll('.cell'),
      this.$['b'].querySelectorAll('.cell'));

    kth = findkth(a, 0, b, 0, k);
    
    print('#steps = ' + stepState.steps.length.toString());
  }
  void rejectCell(Element cell) {
    cell.classes.add('rejected');
  }
  void kthCell(Element cell) {
    cell.classes.add('kth');
  }
  void resetCell(Element cell) {
    cell.classes.removeAll(['rejected', 'kth']);
  }
  void reset() {
    this.$['a'].querySelectorAll('.cell').forEach(resetCell);
    this.$['b'].querySelectorAll('.cell').forEach(resetCell);
  }

  void resetStep() {
    print('resetStep');
  }
  void prevStep() {
    print('prevStep');
  }
  void nextStep() {
    print('nextStep');
  }
}

