import 'package:baixar_status/pages/dashboard/dashboard_container.dart';
import 'package:baixar_status/pages/status_detalhes/page_status_container.dart';
import 'package:baixar_status/pages/status_detalhes/page_status_view.dart';
import 'package:baixar_status/routes.dart';
import 'package:baixar_status/styles/app_loading.dart';
import 'package:baixar_status/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

ThemeData themeData = ThemeData();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) {
    BlocOverrides.runZoned(() => runApp(BaixarStatusApp()),
        blocObserver: AppBlocObserver()
    );
  });

  configLoading();
}

class BaixarStatusApp extends StatelessWidget {
  const BaixarStatusApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          theme: themeData.copyWith(
              colorScheme: themeData.colorScheme.copyWith(
                  primary: AppStyles.primary, secondary: AppStyles.dark)),
        initialRoute: AppRoutes.PAGE_HOME,
        debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      routes: {
          AppRoutes.PAGE_HOME : (_) => DashboardContainer(),
          AppRoutes.PAGE_DETAILS_STATUS : (_) => PageStatusContainer()
        },
        );
  }
}

/// Custom [BlocObserver] that observes all bloc and cubit state changes.
class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (bloc is Cubit) print(change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}
