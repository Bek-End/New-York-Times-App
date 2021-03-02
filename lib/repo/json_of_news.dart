import 'package:dio/dio.dart';
import 'package:NewYorkTest/model/response_fromJson.dart';

class News {
  Dio _dio;
  final String apikey = "J333QfiiEoDJO29JwYpjtnUTgmon2vSv";
  final String mainUrl = "https://api.nytimes.com/";

  News() {
    _dio = Dio(BaseOptions(baseUrl: mainUrl));
  }

  Future<ResponseFromJson> getNews() async {
    String link = "svc/topstories/v2/arts.json?api-key=$apikey";
    try {
      Response response = await _dio.get(link);
      return ResponseFromJson.fromJson(response.data);
    } catch (e) {
      print("Error: $e");
      return ResponseFromJson.withError("Error: getting data");
    }
  }

  Future<void> downloadPhoto({String urlPath, String savePath}) async {
    await _dio.download(urlPath, savePath,
        onReceiveProgress: showDownloadProgress);
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }
}

final jsonNews = News();
