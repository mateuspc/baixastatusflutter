import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:baixar_status/models/my_status.dart';
import 'package:baixar_status/pages/status_detalhes/page_status_cubit.dart';
import 'package:baixar_status/utils/app_converter.dart';
import 'package:baixar_status/widgets/loading_view.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class PageStatusView extends StatefulWidget {

  @override
  State<PageStatusView> createState() => _PageStatusViewState();
}

class _PageStatusViewState extends State<PageStatusView> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chawieController;

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<VideoCubit, VideoState>(
      builder: (context, state) {

        bool isVideo = state is PlayInicializadoStatusState;
        bool isImage = state is ShowPageStatusImageState;
        MyStatus? myStatus;

        if(isVideo){
          myStatus = state.myStatus;

          videoPlayerController = state.videoPlayerController;
          chawieController = ChewieController(
            videoPlayerController: state.videoPlayerController,
            autoPlay: true,
            looping: true,
          );
        }else if(isImage){
          myStatus = state.myStatus;
        }

        if(state is LoadingVideoStatusState){
          return LoadingView();
        }

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            actions: [
              OutlinedButton.icon(
                onPressed: () async {
                  await EasyLoading.show(
                    status: 'Carregando...',
                    maskType: EasyLoadingMaskType.black,
                  );
                  if(state is ShowPageStatusImageState){
                    var states = state.myStatus;
                    Uint8List bytes = getBytesFromFile((states.file.path));
                    await ImageGallerySaver.saveImage(bytes);
                    await EasyLoading.showToast('Imagem foi salva na galeria',
                        duration: Duration(seconds: 3),
                        toastPosition: EasyLoadingToastPosition.center
                    );

                  }else if(state is PlayInicializadoStatusState){
                    var states = state.myStatus;

                    await ImageGallerySaver.saveFile(states.file.path).then((res) async {
                      await EasyLoading.showToast('Vídeo foi salvo na galeria',
                          duration: Duration(seconds: 3),
                          toastPosition: EasyLoadingToastPosition.center
                      );
                    }).catchError((error){
                      print("Error");
                    });
                  }

                },
                label: const Text('Salvar',
                  style: TextStyle(
                    color: Colors.white
                  ),), icon: Icon(Icons.download, color: Colors.white,),
              ),
              OutlinedButton.icon(
                onPressed: () async {
                  if(videoPlayerController != null ){
                    videoPlayerController!.pause();
                  }
                  if(chawieController != null){
                    chawieController!.pause();
                  }
                  EasyLoading.show(
                    status: 'Carregando...',
                    maskType: EasyLoadingMaskType.black,
                  );
                    if(state is ShowPageStatusImageState) {
                      var states = state.myStatus;
                      await Share.shareFiles([states.file.path]);
                      EasyLoading.dismiss();
                    }
                   if(state is PlayInicializadoStatusState){
                     var states = state.myStatus;
                     await Share.shareFiles([states.file.path]);
                     EasyLoading.dismiss();

                   }
                },
                label: Text('Compartilhar',
                  style: TextStyle(
                      color: Colors.white
                  ),), icon: Icon(Icons.share, color: Colors.white,),
              ),
            ],
          ),
          body: Center(
            child: !isVideo ?
              Image.file(myStatus!.file)
              : Chewie(
              controller: chawieController!,
            ),
          ),
        );
      }, listener: (BuildContext context, state) {

    },
    );
  }

  @override
  void dispose() {
    super.dispose();
    if(videoPlayerController != null) videoPlayerController!.dispose();
    if(chawieController != null ) chawieController!.dispose();
  }
}
