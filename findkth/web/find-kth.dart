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
  void addRecurseStep(int leftOffset, int rightOffset, int k) =>
      stepState.add(new Step_Recurse(stepState, leftOffset, rightOffset, k));
  void addCompareStep(int leftOffset, int leftK, int rightOffset, int rightK) =>
      stepState.add(new Step_Compare(stepState, leftOffset, leftK, rightOffset, rightK));
  void addRejectStep(int leftOffset, int leftK, int rightOffset, int rightK, bool isLeft) =>
      stepState.add(new Step_Reject(stepState, leftOffset, leftK, rightOffset, rightK, isLeft));
  void addKthStep(int leftOffset, int rightOffset, bool isLeft) =>
      stepState.add(new Step_Kth(stepState, leftOffset, rightOffset, isLeft));
  
  int findkth(List<int> left, int leftOffset, List<int> right, int rightOffset, int k) {
    addRecurseStep(leftOffset, rightOffset, k);

    int newk = k ~/ 2;
    int kmod = k % 2;

    if (k == 1) {
      addCompareStep(leftOffset, leftOffset, rightOffset, rightOffset);
      if (left[leftOffset] < right[rightOffset]) {
        addKthStep(leftOffset, rightOffset, true);
        return left[leftOffset];
      } else {
        addKthStep(leftOffset, rightOffset, false);
        return right[rightOffset];
      }
    } else if (left[leftOffset + newk - 1] > right[rightOffset + newk + kmod - 1]) {
      addCompareStep(leftOffset, leftOffset + newk - 1, rightOffset, rightOffset + newk + kmod - 1);
      addRejectStep(leftOffset, leftOffset + newk - 1, rightOffset, rightOffset + newk + kmod - 1, true);
      return findkth(left, leftOffset, right, rightOffset + newk + kmod, newk);
    } else {
      addCompareStep(leftOffset, leftOffset + newk - 1, rightOffset, rightOffset + newk + kmod - 1);
      addRejectStep(leftOffset, leftOffset + newk - 1, rightOffset, rightOffset + newk + kmod - 1, false);
      return findkth(left, leftOffset + newk, right, rightOffset, newk + kmod);
    }
  }
  
  void calc() {
    stepState.clear();

    kth = findkth(a, 0, b, 0, k);
    
    this.$['startStep'].attributes.remove('disabled');
    this.$['resetStep'].attributes['disabled'] = "1";
    this.$['nextStep'].attributes['disabled'] = "1";
    this.$['prevStep'].attributes['disabled'] = "1";
  }

  void startStep() {
    stepState.start(this.$['a'].querySelectorAll('.cell'),
                    this.$['b'].querySelectorAll('.cell'),
                    this.$['steps'].querySelectorAll('.cell'),
                    this.$['startStep'],
                    this.$['resetStep'],
                    this.$['nextStep'],
                    this.$['prevStep']);
  }
  void resetStep() {
    stepState.reset();
  }
  void prevStep() {
    stepState.prev();
  }
  void nextStep() {
    stepState.next();
  }
}

