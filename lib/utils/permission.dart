import 'package:permission_handler/permission_handler.dart';

Future<PermissionStatus> requestPermission(Permission permission) async {
  final status = await permission.request();
  return status;
}

Future<bool> temPermissaoDeAcessoAoArmazenamento() async {

  var status = await Permission.storage.status;
  if (status.isGranted) {
   return true;
  }
  return false;
}