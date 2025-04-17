abstract class BaseApiServices {
  Future<dynamic> getApi({required String path, String? token});
  Future<dynamic> customPathGetApi({required String path});

  Future<dynamic> postApi({required String path, String? token, var data});
}
