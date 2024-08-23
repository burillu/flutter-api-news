import 'package:api_news/models/story_model.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StoryModel storyModel;
  final String url =
      "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty";

  @override
  void initState() {
    super.initState();

    final Map<String, dynamic> storyData = convert.jsonDecode(jsonData);

    final String title = storyData["title"];
    final String author = storyData["by"];
    const int index = 1;
    setState(() {
      storyModel = StoryModel(index: index, title: title, author: author);
    });
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
        child: ListTile(
          title: Text(storyModel.title),
          subtitle: Text(storyModel.author),
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                storyModel.index.toString(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
