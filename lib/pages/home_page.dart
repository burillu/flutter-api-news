import 'package:api_news/models/story_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<StoryModel> storyModelFuture;
  final String url =
      "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty";

  @override
  void initState() {
    super.initState();
    storyModelFuture = getStoryData();
  }

  Future<StoryModel> getStoryData() async {
    final response = await http.get(Uri.parse(
        "https://hacker-news.firebaseio.com/v0/item/8863.json?print=pretty"));

    final Map<String, dynamic> storyData = convert.jsonDecode(response.body);
    final String title = storyData["title"];
    final String author = storyData["by"];
    const int index = 1;
    return StoryModel(index: index, title: title, author: author);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          centerTitle: true,
          title: Text("Hacker News"),
        ),
        body: Center(
          child: body(),
        ));
  }

  Widget body() => FutureBuilder(
        future: storyModelFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return CircularProgressIndicator(
              color: Colors.deepOrange,
            );
          } else {
            return Center(
              child: ListTile(
                title: Text(snapshot.data!.title),
                subtitle: Text(snapshot.data!.author),
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      snapshot.data!.index.toString(),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      );
}
