import 'dart:io';

import 'package:flutter/material.dart';
import 'package:NewYorkTest/bloc/db_bloc.dart';
import 'package:NewYorkTest/model/home_news_db_model.dart';

class DbScreen extends StatefulWidget {
  @override
  _DbScreenState createState() => _DbScreenState();
}

class _DbScreenState extends State<DbScreen> {
  @override
  void initState() {
    super.initState();
    dbBloc.mapEventToState(DbInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: dbBloc.subject.stream,
        builder: (context, AsyncSnapshot<DbStates> snapshot) {
          if (snapshot.hasData) {
            DbInitialState initialState;
            switch (snapshot.data.runtimeType) {
              case DbInitialState:
                initialState = snapshot.data;
                return Container(
                  height: _size.height,
                  width: _size.width,
                  child: ListView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(
                          top: 15, right: 10, left: 10, bottom: 15),
                      children:
                          buildNewsList(initialState.news, _size.width, -1)),
                );
            }
          } else {
            return Container();
          }
        });
  }

  List<Widget> buildNewsList(
      List<HomeNewsDBModel> homeNewsDBModels, double width, int indexToCheck) {
    List<Widget> news = [];
    for (int i = 0; i < homeNewsDBModels.length; i++) {
      news.add(buildNews(
          homeNewsDBModels[i], width, i, indexToCheck, homeNewsDBModels));
    }
    return news;
  }

  Widget buildNews(HomeNewsDBModel homeNewsDBModel, double width, int i,
      int indexToCheck, List<HomeNewsDBModel> homeNewsDBModels) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Card(
          child: Container(
            child: Container(
              width: width - 52,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.file(File(homeNewsDBModel.path)),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Wrap(
                      children: [
                        Text(
                          homeNewsDBModel.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Wrap(
                      children: [
                        Text(homeNewsDBModel.subtitle),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
              icon: Stack(
                children: [
                  Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.black54,
                    size: 30,
                  ),
                  Positioned(
                      right: 2.0,
                      bottom: 2.0,
                      child: Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.orange,
                        size: 30,
                      )),
                ],
              ),
              onPressed: () {
                dbBloc.mapEventToState(DbOnTapEvent(
                    id: homeNewsDBModel.id, news: homeNewsDBModel));
              }),
        )
      ],
    );
  }
}
