import 'package:api_news/models/story_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<StoryModel>> storyModelFuture;
  final String urlTopSories =
      "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty";
  final String urlSingleStory =
      "https://hacker-news.firebaseio.com/v0/item/8863.json?print=pretty";

  @override
  void initState() {
    super.initState();
    storyModelFuture = getStoryData();
  }

  Future<List<StoryModel>> getStoryData() async {
    final responseTopStoriesIds = await http.get(Uri.parse(urlTopSories));
    final topStoriesIds =
        convert.jsonDecode(responseTopStoriesIds.body) as List<dynamic>;
    final responseTopTenStories = topStoriesIds.take(10).map((id) async {
      final String url =
          "https://hacker-news.firebaseio.com/v0/item/$id.json?print=pretty";
      final response = await http.get(Uri.parse(url));
      final Map<String, dynamic> storyData = convert.jsonDecode(response.body);
      final String title = storyData["title"];
      final String author = storyData["by"];
      final int vote = storyData["score"];
      const int index = 1;
      return StoryModel(index: index, title: title, author: author, vote: vote);
    }).toList();

    final topStories = await Future.wait(responseTopTenStories);
    return topStories;
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

  Widget body() => FutureBuilder<List<StoryModel>>(
        future: storyModelFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return CircularProgressIndicator(
              color: Colors.deepOrange,
            );
          } else {
            return Center(
              child: ListView.separated(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(snapshot.data![index].title),
                  subtitle: Text(snapshot.data![index].author),
                  trailing: Text(snapshot.data![index].vote.toString()),
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (index + 1).toString(),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                separatorBuilder: (context, index) => Divider(),
              ),
            );
          }
        },
      );
}
