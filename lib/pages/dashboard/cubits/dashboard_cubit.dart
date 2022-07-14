import 'dart:io';
import 'dart:typed_data';
import 'package:baixar_status/models/my_status.dart';
import 'package:baixar_status/utils/permission.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class DashboardCubit extends Cubit<ListaStatusState> {
  DashboardCubit() : super(InitialListaStatusState());
  bool modeList = false;
  List<MyStatus> res = [];

  void changeModeList(bool value){
    modeList = value;
    emit(LoadedListaStateState(res));
  }
  void loadingStatus() async {

    emit(LoadingListaStatusState());

    await Future.delayed(Duration(seconds: 4));

    var temPermissaoDeArmazenamento = await temPermissaoDeAcessoAoArmazenamento();
    if(!temPermissaoDeArmazenamento){
      PermissionStatus status = await requestPermission(Permission.storage);
      print(status);

      if(!status.isGranted){
        emit(ListaStatusStatePermissionNegada());
        return;
      }

    }
    List<MyStatus> list = [];
    try{
      list = await _getListStatus();
    } on FileSystemException catch(e){
      print('Você não tem permissão para acessar o armazenamento');
    }

    emit(LoadedListaStateState(list));
  }

  Future<List<MyStatus>> _getListStatus() async {
    var directory = Directory('/storage/emulated/0/Whatsapp/Media/.Statuses');

    var status = directory.listSync().map(
            (e)  {
          return MyStatus(
              file: File(e.path),
              isImage: e.path.endsWith('.jpg') ? true : false
          );
        }
    ).toList();
     List<MyStatus> list = [];

    for(int i = 0; i < status.length; i++){
      if(status[i].file.path.endsWith('.mp4')){
       Uint8List res =  await createThumbnails(status[i].file);

       MyStatus myStatus = status[i];
       myStatus.thumbnail = res;
       list.add(myStatus);
      }else if(status[i].file.path.endsWith('.jpg')){
        list.add(status[i]);

      }
    }
    return list;
  }
}
createThumbnails(FileSystemEntity file) async {
  var uint8List = await VideoThumbnail.thumbnailData(
      video: file.path,
      imageFormat: ImageFormat.JPEG,
      quality: 100);
  return uint8List;

}


@immutable
abstract class ListaStatusState {
  const ListaStatusState();
}

@immutable
class InitialListaStatusState extends ListaStatusState{
  const InitialListaStatusState();
}

@immutable
class LoadingListaStatusState extends ListaStatusState{
  const LoadingListaStatusState();
}

@immutable
class LoadedListaStateState extends ListaStatusState {

  final List<MyStatus> status;

  const LoadedListaStateState(this.status);
}

@immutable
class ListaStatusStatePermissionNegada extends ListaStatusState {
  const ListaStatusStatePermissionNegada();
}

@immutable
abstract class FatalErrorListaStatusState extends ListaStatusState {
  const FatalErrorListaStatusState();
}