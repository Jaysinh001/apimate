import '../../config/utility/utility.dart';
import 'local_db.dart';

class LocalDataHelper {
  static Future<String?> getToken() async {
    return await HiveHelper.getData(KEYNAME.TOKEN.toString());
  }

  static Future<void> saveToken({required String token}) async {
    Utility.showLog('token saved : $token');
    await HiveHelper.saveData(KEYNAME.TOKEN.toString(), token);
  }
}
