import 'package:chaty_talk/enum/view_state.dart';
import 'package:flutter/cupertino.dart';

class ImageUploadProvider with ChangeNotifier{


  ViewState viewState = ViewState.IDLE;
  ViewState get getViewState => viewState;

  void setToLoading(){
    viewState = ViewState.LOADING;
    notifyListeners();
  }
  void setToIdle(){
    viewState = ViewState.IDLE;
    notifyListeners();
  }
}