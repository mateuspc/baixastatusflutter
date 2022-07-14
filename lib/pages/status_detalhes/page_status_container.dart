import 'package:baixar_status/models/my_status.dart';
import 'package:baixar_status/pages/status_detalhes/page_status_cubit.dart';
import 'package:baixar_status/pages/status_detalhes/page_status_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PageStatusContainer extends StatelessWidget {
  const PageStatusContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    MyStatus myStatus = ModalRoute.of(context)!.settings.arguments as MyStatus;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) {
            VideoCubit cubit = VideoCubit();
            cubit.inicializarPlayer(myStatus);
            return cubit;
          },
        )
      ],
      child: PageStatusView(),
    );
  }
}
