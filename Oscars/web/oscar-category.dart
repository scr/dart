import 'package:polymer/polymer.dart';
import 'dart:html';
import 'oscar-nominee.dart';

@CustomTag('oscar-category')
class OscarCategory extends PolymerElement {
  @published String name;
  @published List<String> nominees = toObservable([]);
  @observable double pointsUsed = 0.0;
  @observable double pointsLeft = 0.0;

  MutationObserver observer;
  List<OscarNominee> oscarNominees = [];

  OscarCategory.created() : super.created();
  
  @override
  enteredView() {
    super.enteredView();
    observer = new MutationObserver(_onMutation);
    observer.observe($['nominees'], childList: true);
  }
  
  onChildChange(PropertyChangeRecord record) {
    print('childchange $record');
    if (record.name == #userChecked) {
      int numNominees = oscarNominees.length;
      int numCheckedNominees = 0;
      oscarNominees.forEach((OscarNominee nominee) {
        if (nominee.checked)
          ++numCheckedNominees;
      });
      double splitScore = numNominees / numCheckedNominees;
      print(splitScore);
      double newPointsUsed = 0.0; 
      oscarNominees.forEach((OscarNominee nominee) {
        nominee.points = nominee.checked ? splitScore : 0.0;
        newPointsUsed += nominee.points;
      });
      pointsUsed = newPointsUsed;
      pointsLeft = nominees.length - newPointsUsed;
    } else if (record.name == #points) {
      double newPointsUsed = 0.0; 
      oscarNominees.forEach((OscarNominee nominee) {
        newPointsUsed += nominee.points;
      });
      pointsUsed = newPointsUsed;
      pointsLeft = nominees.length - newPointsUsed;
    }
  }

  onChildChanges(List<ChangeRecord> records) {
    records.forEach(onChildChange);
  }
  
  listen(OscarNominee to) {
    to.changes.listen(onChildChanges);
  }
  
  _onMutation(List<MutationRecord> mutations, MutationObserver observer) {
    oscarNominees.clear();
    ElementList oscar_nominees = $['nominees'].querySelectorAll('oscar-nominee');
    oscarNominees..addAll(oscar_nominees)..forEach(listen);
    pointsLeft = nominees.length - pointsUsed;
}
}