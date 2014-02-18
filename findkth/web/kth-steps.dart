library kthsteps;

import 'dart:html';
import 'package:polymer/polymer.dart';

class StepState extends Observable {
  @observable List<Step> steps = toObservable([]);
  @observable int step = 5;
  ElementList a, b;
  
  void reset(ElementList a, ElementList b) {
    steps.clear();
    this.a = a;
    this.b = b;
  }
}

abstract class Step {
  final List<String> classes = ['selected', 'chosen', 'rejected', 'kth'];
  final StepState state;
  
  Step(StepState state) : state = state;

  void rejectCell(Element cell) {
    cell.classes.add('rejected');
  }
  void kthCell(Element cell) {
    cell.classes.add('kth');
  }
  void resetCell(Element cell) {
    cell.classes.removeAll(classes);
  }

  // Abstract
  String toString();
  void show();
  void hide();
}

class Step_Recurse extends Step {
  final int leftOffset, rightOffset, k;
  
  Step_Recurse(StepState state, int leftOffset, int rightOffset, int k) 
    : super(state),
      leftOffset = leftOffset,
      rightOffset = rightOffset,
      k = k;
  
  String toString() => 'Recurse($leftOffset, $rightOffset, $k)';
  void show() {}
  void hide() {}
}

class Step_Kth extends Step {
  final bool isA;
  final int k;
  
  Step_Kth(StepState state, int k, bool isA) 
    : super(state),
      k = k, 
      isA = isA;
  
  String toString() => 'Kth($k, $isA)';
  
  void show() {
    kthCell(isA ? state.a[k] : state.b[k]);
  }

  void hide() {
    resetCell(isA ? state.a[k] : state.b[k]);
  }
}

class Step_Compare extends Step {
  final int leftOffset, leftK, rightOffset, rightK;
  
  Step_Compare(StepState state, int leftOffset, int leftK, int rightOffset, int rightK)
      : super(state),
        leftOffset = leftOffset,
        leftK = leftK,
        rightOffset = rightOffset,
        rightK = rightK;
  
  String toString() => 'Compare($leftOffset, $leftK, $rightOffset, $rightK)';
  void show() {}
  void hide() {}
}

class Step_Reject extends Step {
  final int leftOffset, leftK, rightOffset, rightK;
  final bool isA;
  
  Step_Reject(StepState state, int leftOffset, int leftK, int rightOffset, int rightK, bool isA)
      : super(state),
        leftOffset = leftOffset,
        leftK = leftK,
        rightOffset = rightOffset,
        rightK = rightK,
        isA = isA;
  
  String toString() => 'Compare($leftOffset, $leftK, $rightOffset, $rightK)';
  void show() {}
  void hide() {}
}