import 'dart:io';
import 'dart:math';
import 'package:NewYorkTest/database/database_provider.dart';
import 'package:NewYorkTest/model/home_news_db_model.dart';
import 'package:connectivity/connectivity.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:NewYorkTest/model/response_fromJson.dart';
import 'package:NewYorkTest/repo/json_of_news.dart';
import 'package:NewYorkTest/model/internet_model.dart';

//events
abstract class InternetEvents {}

class InternetInitialEvent extends InternetEvents {}

class InternetOnTapEvent extends InternetEvents {
  final String title;
  final String subTitle;
  final String imgUrl;
  final int index;
  InternetOnTapEvent({this.title, this.subTitle, this.imgUrl, this.index});
}

//states
abstract class InternetStates {}

class InternetInitialState extends InternetStates {
  final List<Results> results;
  InternetInitialState({this.results});
}

class InternentNoConnection extends InternetStates {}

class InternetDownloadedState extends InternetStates {
  final int index;
  final List<Results> results;
  InternetDownloadedState({this.index, this.results});
}

class InternetLoadingState extends InternetStates {
  final int index;
  final List<Results> results;
  InternetLoadingState({this.index, this.results});
}

//bloc
class InternetBloc {
  BehaviorSubject<InternetStates> _subject = BehaviorSubject<InternetStates>();
  BehaviorSubject<InternetStates> get subject => _subject;
  Connectivity connectivity = Connectivity();
  ResponseFromJson responseFromJson;

  void mapEventToState(InternetEvents event) async {
    switch (event.runtimeType) {
      case InternetInitialEvent:
        ConnectivityResult connect = await connectivity.checkConnectivity();
        if (connect == ConnectivityResult.none) {
          _subject.sink.add(InternentNoConnection());
        } else {
          responseFromJson = await jsonNews.getNews();
          _subject.sink.add(InternetInitialState(
              results: responseFromJson.homeNewsModel.results));
        }
        break;
      case InternetOnTapEvent:
        InternetOnTapEvent onTapEvent = event;
        Directory directory = await getApplicationDocumentsDirectory();
        List<HomeNewsDBModel> models = await DatabaseProvider.db.getAllNews();
        List<int> ids = [];
        List<String> urls = [];
        if (models.isNotEmpty) {
          models.forEach((element) {
            ids.add(element.id);
            urls.add(element.url);
          });
          int newId = ids.reduce(max) + 1;
          if (urls.contains(onTapEvent.imgUrl)) {
            _subject.sink.add(InternetDownloadedState(
                index: onTapEvent.index,
                results: responseFromJson.homeNewsModel.results));
            await Future.delayed(Duration(seconds: 1));
            _subject.sink.add(InternetInitialState(
                results: responseFromJson.homeNewsModel.results));
          } else {
            String savePath = join(directory.path, "image{$newId}.jpg");
            _subject.sink.add(InternetLoadingState(
                index: onTapEvent.index,
                results: responseFromJson.homeNewsModel.results));
            await jsonNews.downloadPhoto(
                savePath: savePath, urlPath: onTapEvent.imgUrl);
            _subject.sink.add(InternetInitialState(
                results: responseFromJson.homeNewsModel.results));
            HomeNewsDBModel homeNewsDBModel = HomeNewsDBModel(
                path: savePath,
                title: onTapEvent.title,
                subtitle: onTapEvent.subTitle,
                url: onTapEvent.imgUrl);
            DatabaseProvider.db.insert(homeNewsDBModel);
          }
        } else {
          String savePath = join(directory.path, "image-1.jpg");
          _subject.sink.add(InternetLoadingState(
              index: onTapEvent.index,
              results: responseFromJson.homeNewsModel.results));
          await jsonNews.downloadPhoto(
              savePath: savePath, urlPath: onTapEvent.imgUrl);
          _subject.sink.add(InternetInitialState(
              results: responseFromJson.homeNewsModel.results));
          HomeNewsDBModel homeNewsDBModel = HomeNewsDBModel(
              path: savePath,
              title: onTapEvent.title,
              subtitle: onTapEvent.subTitle,
              url: onTapEvent.imgUrl);
          DatabaseProvider.db.insert(homeNewsDBModel);
        }
        break;
    }
  }

  void dispose() {
    _subject?.close();
  }
}

final internetBloc = InternetBloc();
