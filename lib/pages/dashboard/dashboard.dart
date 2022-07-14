import 'dart:typed_data';

import 'package:baixar_status/pages/dashboard/cubits/dashboard_cubit.dart';
import 'package:baixar_status/pages/dashboard/cubits/toggle_style_list_cubit.dart';
import 'package:baixar_status/routes.dart';
import 'package:baixar_status/utils/permission.dart';
import 'package:baixar_status/widgets/empty_list_view.dart';
import 'package:baixar_status/widgets/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class DashboardView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('Baixar status'),
        actions: [
          BlocBuilder<ToggleStyleListCubit, bool>(
            builder: (context, state) {
              return IconButton(
                onPressed: () {
                  context.read<ToggleStyleListCubit>().changeStyleList();
                }
                , icon:Icon(state ? Icons.list : Icons.grid_view),
              );
            }
          )
        ],
      ),
      body: BlocBuilder<DashboardCubit, ListaStatusState>(
        builder: (BuildContext context, state) {

          if(state is LoadingListaStatusState){
            return const LoadingView();
          }
          if(state is ListaStatusStatePermissionNegada){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.lock),
                  SizedBox(height: 10,),
                  Text('Para acessar os status é necessário da permissão'),
                  ElevatedButton(onPressed: () async {
                    PermissionStatus status = await requestPermission(Permission.storage);
                    if(status.isGranted){
                      context.read<DashboardCubit>().loadingStatus();
                    }

                  }, child: Text('Permissão'),

                  )
                ],
              ),
            );
          }
          if(state is LoadedListaStateState){

            var list = state.status;
            if(list.isEmpty){
              return const EmptyListView();
            }
            return BlocBuilder<ToggleStyleListCubit, bool>(
              buildWhen: (previous,  current){
                return previous == true || previous == false;
              },
              builder: (context, state) {
                return GridView.builder(
                  itemBuilder: (BuildContext context, int index) {

                    var status = list[index];
                    return GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, AppRoutes.PAGE_DETAILS_STATUS, arguments: status);
                      },
                      child: Stack(
                        children: [
                          Card(
                            child: Container(
                              height: double.maxFinite,
                              width: double.maxFinite,
                              child: status.isImage ?Image.file(status.file,
                                 fit: BoxFit.cover,) : Image.memory(status.thumbnail as Uint8List,
                                 fit: BoxFit.cover,),
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                              ),
                              padding: EdgeInsets.all(7),
                              child: Text(status.isImage ? 'Imagem' : 'Vídeo', style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: state ? 1 : 2
                  ),
                  itemCount: list.length,
                );
              }
            );
          }
          return Container();

        }
      ),
    );
  }




}



