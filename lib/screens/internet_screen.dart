import 'dart:ui';
import 'package:NewYorkTest/bloc/internet_bloc.dart';
import 'package:NewYorkTest/constants.dart';
import 'package:flutter/material.dart';
import 'package:NewYorkTest/model/internet_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class InternetScreen extends StatefulWidget {
  @override
  _InternetScreenState createState() => _InternetScreenState();
}

class _InternetScreenState extends State<InternetScreen> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    internetBloc.mapEventToState(InternetInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: internetBloc.subject.stream,
        builder: (context, AsyncSnapshot<InternetStates> snapshot) {
          InternetInitialState initialState;
          if (snapshot.hasData) {
            switch (snapshot.data.runtimeType) {
              case InternetInitialState:
                initialState = snapshot.data;
                return Container(
                  height: _size.height,
                  width: _size.width,
                  child: ListView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(
                          top: 15, right: 10, left: 10, bottom: 15),
                      children: buildNewsList(
                        initialState.results,
                        _size.width,
                        -1,
                        Icon(
                          Icons.save_alt_rounded,
                          color: Colors.black54,
                          size: 30,
                        ),
                        Icon(
                          Icons.save_alt_rounded,
                          color: kColorWhite,
                          size: 30,
                        ),
                      )),
                );
                break;
              case InternetLoadingState:
                InternetLoadingState onTapState = snapshot.data;
                return Container(
                    height: _size.height,
                    width: _size.width,
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(
                          top: 15, right: 10, left: 10, bottom: 15),
                      children: buildNewsList(
                        onTapState.results,
                        _size.width,
                        onTapState.index,
                        Container(),
                        Container(
                          height: 30,
                          width: 30,
                          child: Theme(
                            data: ThemeData(accentColor: Colors.black54),
                            child: CircularProgressIndicator(
                              backgroundColor: kColorWhite,
                            ),
                          ),
                        ),
                      ),
                    ));
                break;
              case InternetDownloadedState:
                InternetDownloadedState onTapState = snapshot.data;
                return Container(
                  height: _size.height,
                  width: _size.width,
                  child: ListView(
                      controller: controller,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(
                          top: 15, right: 10, left: 10, bottom: 15),
                      children: buildNewsList(
                        onTapState.results,
                        _size.width,
                        onTapState.index,
                        Icon(
                          Icons.sd_storage_outlined,
                          color: Colors.black54,
                          size: 30,
                        ),
                        Icon(
                          Icons.sd_storage_outlined,
                          color: Colors.orange,
                          size: 30,
                        ),
                      )),
                );
                break;
              case InternentNoConnection:
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off_outlined),
                    Text("Oops no internet connection")
                  ],
                ));
                break;
            }
          } else {
            return Center(
              child: SpinKitDoubleBounce(
                color: kColorWhite,
              ),
            );
          }
        });
  }

  List<Widget> buildNewsList(List<Results> results, double width,
      int indexToCheck, Widget icon, Widget shadow) {
    List<Widget> news = [];
    for (int i = 0; i < results.length; i++) {
      news.add(
          buildNews(results[i], width, i, indexToCheck, results, icon, shadow));
    }
    return news;
  }

  Widget buildNews(Results result, double width, int i, int indexToCheck,
      List<Results> results, Widget icon, Widget shadow) {
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
                  Image.network(result.multimedia[0].url),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Wrap(
                      children: [
                        Text(
                          result.title,
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
                        Text(result.subtitle),
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
          child: InkWell(
            onTap: () {
              internetBloc.mapEventToState(InternetOnTapEvent(
                  index: i,
                  title: result.title,
                  subTitle: result.subtitle,
                  imgUrl: result.multimedia[0].url));
            },
            child: Container(
              padding: EdgeInsets.only(top: 10, right: 10),
              child: (i == indexToCheck)
                  ? Stack(
                      children: [
                        Positioned(left: 2.0, top: 2.0, child: icon),
                        shadow
                      ],
                    )
                  : Stack(
                      children: [
                        Positioned(
                            left: 2.0,
                            top: 2.0,
                            child: Icon(
                              Icons.save_alt_rounded,
                              size: 30,
                              color: Colors.black54,
                            )),
                        Icon(
                          Icons.save_alt_rounded,
                          size: 30,
                          color: kColorWhite,
                        )
                      ],
                    ),
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    print("good buy");
    super.dispose();
  }
}
