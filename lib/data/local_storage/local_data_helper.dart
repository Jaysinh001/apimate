import '../../config/utility/utility.dart';
import 'local_db.dart';

class LocalDataHelper {
  // static Future<Driver?> getCurrentDriver() async {
  //   final driverJson = await HiveHelper.getData(KEYNAME.DRIVER.toString());

  //   if (driverJson != null && driverJson is Map<String, dynamic>) {
  //     return Driver.fromJson(driverJson);
  //   }

  //   return null;
  // }

  // static Future<void> saveCurrentDriver(Driver driver) async {
  //   await HiveHelper.saveData(KEYNAME.DRIVER.toString(), driver.toJson());
  // }

  static Future<String?> getToken() async {
    return await HiveHelper.getData(KEYNAME.TOKEN.toString());
  }

  static Future<void> saveToken({required String token}) async {
    Utility.showLog('token saved : $token');
    await HiveHelper.saveData(KEYNAME.TOKEN.toString(), token);
  }
}
