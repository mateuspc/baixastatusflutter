
import 'package:flutter_bloc/flutter_bloc.dart';

class ToggleStyleListCubit extends Cubit<bool> {
  ToggleStyleListCubit() : super(false);

  bool styleList = false;

  void changeStyleList(){
    styleList = !styleList;
    emit(styleList);
  }
}