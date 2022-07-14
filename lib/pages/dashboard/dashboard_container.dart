import 'package:baixar_status/pages/dashboard/cubits/toggle_style_list_cubit.dart';
import 'package:baixar_status/pages/dashboard/dashboard.dart';
import 'package:baixar_status/pages/dashboard/cubits/dashboard_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class DashboardContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return MultiBlocProvider(
     providers: [
       BlocProvider(
         create: (BuildContext context) {
           DashboardCubit cubit = DashboardCubit();
           cubit.loadingStatus();
           return cubit;
         },
       ),
       BlocProvider(
         create: (BuildContext context) {
           ToggleStyleListCubit toggleStyle = ToggleStyleListCubit();
           return toggleStyle;
         },
       ),
     ],
     child: DashboardView(),
   );
  }

}