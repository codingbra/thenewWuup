import 'package:flutter/material.dart';


class PollsProvider extends ChangeNotifier{
  List pollsOptions = ["", ""];
  // key are options weights are the values
  Map pollsWeights = {};

  String pollTitle = '';

  // Functions


  addPollWeights (Map value){
    pollsWeights = value;
    notifyListeners();
  }
  addPollTitle(String value){
    pollTitle = value;
    notifyListeners();
  }

  addPollOption(){
    pollsOptions.add("");
    notifyListeners();
  }

  removeOption(){
  pollsOptions.removeLast();
   notifyListeners();
  }
  // removeOptionWeight(int index){
  //   pollsWeights.remove(index);
  //   notifyListeners();
  // }

}