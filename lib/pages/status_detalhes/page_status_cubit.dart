
import 'package:baixar_status/models/my_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';


class VideoCubit extends Cubit<VideoState> {
  VideoCubit() : super(InitialVideoStatusState());

  void inicializarPlayer(MyStatus myStatus) async {

    VideoPlayerController videoPlayerController = VideoPlayerController.file(myStatus.file);
    emit(LoadingVideoStatusState());
    if(!myStatus.isImage){
      await videoPlayerController.initialize();
      emit(PlayInicializadoStatusState(myStatus, videoPlayerController));
    }else{
      emit(ShowPageStatusImageState(myStatus));
    }

  }
}

@immutable
abstract class VideoState {
  const VideoState();
}

@immutable
class InitialVideoStatusState extends VideoState{
const InitialVideoStatusState();
}

@immutable
class LoadingVideoStatusState extends VideoState{
  const LoadingVideoStatusState();
}

@immutable
class PlayInicializadoStatusState extends VideoState{

  final MyStatus myStatus;
  final VideoPlayerController videoPlayerController;
  const PlayInicializadoStatusState(this.myStatus, this.videoPlayerController);
}

@immutable
class ShowPageStatusImageState extends VideoState{
  final MyStatus myStatus;
  const ShowPageStatusImageState(this.myStatus);
}

@immutable
class FalhaInitStatusPlayer extends VideoState {
  const FalhaInitStatusPlayer();
}