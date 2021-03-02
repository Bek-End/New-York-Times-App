import 'package:NewYorkTest/constants.dart';
import 'package:flutter/material.dart';
import 'internet_screen.dart';
import 'db_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New York Times App"),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size(40, 40),
          child: Container(
            height: 60,
            child: TabBar(
              indicatorWeight: 1,
              indicatorColor: Colors.orange,
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.public_outlined,
                    color: kColorWhite,
                  ),
                  text: "News",
                  iconMargin: EdgeInsets.all(3),
                ),
                Tab(
                  icon: Icon(
                    Icons.save_alt_outlined,
                    color: kColorWhite,
                  ),
                  text: "Saved News",
                  iconMargin: EdgeInsets.all(3),
                )
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
          physics: BouncingScrollPhysics(),
          children: [InternetScreen(), DbScreen()]),
    );
  }
}
