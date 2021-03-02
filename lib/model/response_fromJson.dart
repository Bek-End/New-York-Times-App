import 'internet_model.dart';

class ResponseFromJson {
  InternetModel homeNewsModel;
  String error;

  ResponseFromJson({this.homeNewsModel, this.error});

  ResponseFromJson.fromJson(var json) {
    this.homeNewsModel = InternetModel.fromJson(json);
    this.error = "";
  }

  ResponseFromJson.withError(String errorValue) {
    error = errorValue;
    homeNewsModel = InternetModel();
  }

}
