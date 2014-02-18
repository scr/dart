library kthsteps;

import 'dart:html';
import 'package:polymer/polymer.dart';

class StepState extends Observable {
  @observable List<Step> steps = toObservable([]);
  @observable int step;
  @observable int k;
  ElementList leftCells, rightCells, stepCells;
  Element startButton, resetButton, nextButton, prevButton;
  
  void add(Step step) => steps.add(step);
  
  void clear() {
    steps.clear();
    step = null;
    k = null;
  }
  
  void start(ElementList leftCells, 
             ElementList rightCells,
             ElementList stepCells,
             Element startButton,
             Element resetButton,
             Element nextButton,
             Element prevButton) {
    this.leftCells = leftCells;
    this.rightCells = rightCells;
    this.stepCells = stepCells;
    this.startButton = startButton;
    this.resetButton = resetButton;
    this.nextButton = nextButton;
    this.prevButton = prevButton;
    
    startButton.attributes['disabled'] = "1";
    resetButton.attributes.remove('disabled');
    nextButton.attributes.remove('disabled');
    prevButton.attributes.remove('disabled');

    reset();
  }
  
  void reset() {
    leftCells.forEach(Step.resetCell);
    rightCells.forEach(Step.resetCell);
    stepCells.forEach(Step.resetCell);
    step = null;
    k = null;
  }
  
  void next() {
    if (step == null) {
      step = 0;
    } else {
      steps[step].end();
      Step.resetCell(stepCells[step++]);
    }
    if (step < steps.length) {
      Step.selectCell(stepCells[step]);
      steps[step].begin();
    }
  }
  void prev() {
    if (step == null)
      return;
    
    steps[step].reset();
    Step.resetCell(stepCells[step]);
    
    if (step == 0) {
      step = null;
    } else {
      Step.selectCell(stepCells[--step]);
      steps[step].begin();
    }
  }
}

abstract class Step {
  static final List<String> classes = ['selected', 
                                       'chosen',
                                       'rejected',
                                       'notchosen',
                                       'maybe',
                                       'kth'];
  final StepState state;
  
  Step(StepState state) : state = state;

  static void resetCell(Element cell) {
    cell.classes.removeAll(classes);
  }
  static void modClass([Element cell, String className, bool on = true]) {
    if (on)
      cell.classes.add(className);
    else
      cell.classes.remove(className);
  }
  static void rejectCell([Element cell, bool on = true]) => modClass(cell, 'rejected', on);
  static void kthCell([Element cell, bool on = true]) => modClass(cell, 'kth', on);
  static void selectCell([Element cell, bool on = true]) => modClass(cell, 'selected', on);
  static void maybeCell([Element cell, bool on = true]) => modClass(cell, 'maybe', on);
  static void chooseCell([Element cell, bool on = true]) => modClass(cell, 'chosen', on);
  static void notchosenCell([Element cell, bool on = true]) => modClass(cell, 'notchosen', on);

  static void unrejectCell(Element cell) => rejectCell(cell, false);
  static void unkthCell(Element cell) => kthCell(cell, false);
  static void unselectCell(Element cell) => selectCell(cell, false);
  static void unmaybeCell(Element cell) => maybeCell(cell, false);
  static void unchooseCell(Element cell) => chooseCell(cell, false);
  static void unnotchosenCell(Element cell) => notchosenCell(cell, false);
  
  void maybeToRejectCells(List cells) {
    for (Element cell in cells) {
      if (cell.classes.remove('maybe'))
        cell.classes.add('rejected');
    }
  }
  
  // Abstract
  String toString();
  void begin();
  void end();
  void reset();
}

class Step_Recurse extends Step {
  final int leftOffset, rightOffset, k;
  
  Step_Recurse(StepState state, int leftOffset, int rightOffset, int k) 
    : super(state),
      leftOffset = leftOffset,
      rightOffset = rightOffset,
      k = k;
  
  String toString() => 'Recurse($leftOffset, $rightOffset, $k)';
  void begin() {
    state.k = k;
  }
  void end() {}
  void reset() {}
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
  void begin() {
    state.leftCells.sublist(leftOffset, leftK + 1).forEach(Step.maybeCell);
    Step.selectCell(state.leftCells[leftK]);

    state.rightCells.sublist(rightOffset, rightK + 1).forEach(Step.maybeCell);
    Step.selectCell(state.rightCells[rightK]);
  }
  void end() {
    Step.unselectCell(state.leftCells[leftK]);
    Step.unselectCell(state.rightCells[rightK]);    
  }
  void reset() {
    state.leftCells.sublist(leftOffset, leftK + 1).forEach(Step.resetCell);
    state.rightCells.sublist(rightOffset, rightK + 1).forEach(Step.resetCell);
  }
}

class Step_Reject extends Step {
  final int leftOffset, leftK, rightOffset, rightK;
  final bool isLeft;
  
  Step_Reject(StepState state, int leftOffset, int leftK, int rightOffset, int rightK, bool isLeft)
      : super(state),
        leftOffset = leftOffset,
        leftK = leftK,
        rightOffset = rightOffset,
        rightK = rightK,
        isLeft = isLeft;
  
  String toString() => 'Reject($leftOffset, $leftK, $rightOffset, $rightK, $isLeft)';
  void begin() {
    if (isLeft) {
      Step.chooseCell(state.leftCells[leftK]);
      Step.notchosenCell(state.rightCells[rightK]);
    } else {
      Step.notchosenCell(state.leftCells[leftK]);
      Step.chooseCell(state.rightCells[rightK]);
    }
  }
  
  void forceRejectCell(Element cell) {
    Step.unmaybeCell(cell);
    Step.rejectCell(cell);
  }

  void end() {
    state.leftCells[leftK].classes.removeAll(['chosen', 'notchosen']);
    state.rightCells[rightK].classes.removeAll(['chosen', 'notchosen']);
    
    if (isLeft)
      state.rightCells.sublist(rightOffset, rightK + 1).forEach(forceRejectCell);
    else
      state.leftCells.sublist(leftOffset, leftK + 1).forEach(forceRejectCell);
  }
  void reset() {
    state.leftCells.sublist(leftOffset, leftK  + 1).forEach(Step.resetCell);
    state.rightCells.sublist(rightOffset, rightK + 1).forEach(Step.resetCell);
  }
}

class Step_Kth extends Step {
  final int leftOffset, rightOffset;
  final bool isLeft;
  
  Step_Kth(StepState state, int leftOffset, int rightOffset, bool isLeft) 
    : super(state),
      leftOffset = leftOffset,
      rightOffset = rightOffset,
      isLeft = isLeft;
  
  String toString() => 'Kth($leftOffset, $rightOffset, $isLeft)';
  
  void forceKth(Element cell) {
    Step.unmaybeCell(cell);
    Step.kthCell(cell);
  }

  void begin() {
    forceKth(isLeft ? state.leftCells[leftOffset] : state.rightCells[rightOffset]);
    maybeToRejectCells(state.leftCells);
    maybeToRejectCells(state.rightCells);
  }
  void end() {}
  void reset() {
    Step.resetCell(isLeft ? state.leftCells[leftOffset] : state.rightCells[rightOffset]);
  }
}
