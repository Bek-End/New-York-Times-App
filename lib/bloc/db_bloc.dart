import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:NewYorkTest/database/database_provider.dart';
import 'package:NewYorkTest/model/home_news_db_model.dart';

//events
abstract class DbEvents {}

class DbInitialEvent extends DbEvents {}

class DbOnTapEvent extends DbEvents {
  final int id;
  final HomeNewsDBModel news;
  DbOnTapEvent({this.id, this.news});
}

//states
abstract class DbStates {}

class DbInitialState extends DbStates {
  final List<HomeNewsDBModel> news;
  DbInitialState({this.news});
}

class DbOnTapState extends DbStates {
  final int id;
  final List<HomeNewsDBModel> news;
  DbOnTapState({this.id, this.news});
}

//bloc
class DbBloc {
  BehaviorSubject<DbStates> _subject = BehaviorSubject<DbStates>();
  BehaviorSubject<DbStates> get subject => _subject;

  void mapEventToState(DbEvents event) async {
    switch (event.runtimeType) {
      case DbInitialEvent:
        List<HomeNewsDBModel> homeNewsDBModel =
            await DatabaseProvider.db.getAllNews();
        _subject.sink.add(DbInitialState(news: homeNewsDBModel));
        break;
      case DbOnTapEvent:
        DbOnTapEvent onTapEvent = event;
        await DatabaseProvider.db.deleteFileFromLocaStorage(File(onTapEvent.news.path));
        await DatabaseProvider.db.delete(onTapEvent.news);
        List<HomeNewsDBModel> homeNewsDBModel =
            await DatabaseProvider.db.getAllNews();
        _subject.sink.add(DbInitialState(news: homeNewsDBModel));
        break;
    }
  }

  void dispose() {
    _subject?.close();
  }
}

final dbBloc = DbBloc();
