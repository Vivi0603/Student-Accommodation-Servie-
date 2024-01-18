import 'dart:io';

import 'package:app/screens/chat.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/widget_functions.dart';
import '../utils/constants.dart';
import '../widgets/BorderIcon.dart';

// import 'about.dart';
// import 'Messages.dart';
// import 'Chat.dart';

class HomePage extends StatefulWidget {
  final int user_id;
  final int cluster;
  HomePage(this.user_id, this.cluster);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<dynamic>> getMatches() async {
    var body = json.encode({"id": widget.user_id, "cluster": widget.cluster});

    // print(body);

    String url = "http://10.0.2.2:3000/matches";
    final response = await http.post(Uri.parse(url), body: body, headers: {
      'Content-Type': 'application/json',
    });

    var responseData = json.decode(response.body);
    return responseData;
  }

  late Future<List<dynamic>> _matches;

  Future<void> _pullRefresh() async {
    setState(() {
      _matches = getMatches();
    });
  }

  @override
  void initState() {
    super.initState();
    _matches = getMatches();
  }

  Widget _listView(AsyncSnapshot snapshot, BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    if (snapshot.hasData) {
      List<dynamic> matches = snapshot.data as List<dynamic>;
      if (matches.isEmpty) {
        return const Center(
            child: Text("No similar users found! Check again later."));
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          Expanded(
              child: ListView(
                  children: matches
                      .map((match) => Card(
                            child: Stack(children: [
                              Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                          child: Text(match['name'][0])),
                                      title: Text(match['name']),
                                      subtitle: Text(match['location']),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text(match['bio']),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, top: 20),
                                      child: Text(
                                        'Likes',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, top: 8),
                                      child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                              children: likes_widget(
                                                  match['likes'], false))),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, top: 20),
                                      child: Text(
                                        'Dislikes',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, top: 8),
                                      child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                              children: likes_widget(
                                                  match['dislikes'], true))),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 20),
                                      child: match['type'] == 'Homeowner'
                                          ? const Text(
                                              'Room',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : null,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 8, right: 20),
                                      child: match['type'] == 'Homeowner'
                                          ? Image.file(File(match['image_url']))
                                          : null,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: Container(
                                        width: size.width / 1.2,
                                        height: size.height / 25,
                                        child: OutlinedButton(
                                          child: const Text(
                                            'Match',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                          onPressed: () {
                                            http.post(
                                                Uri.parse(
                                                    "http://10.0.2.2:3000/match"),
                                                body: json.encode({
                                                  "id": widget.user_id,
                                                  "match_id": match['user_id']
                                                }),
                                                headers: {
                                                  'Content-Type':
                                                      'application/json',
                                                }).then((res) {
                                              if (res.statusCode == 200) {
                                                _pullRefresh();
                                              } else {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title:
                                                            const Text("Error"),
                                                        content: const Text(
                                                            "Something went wrong"),
                                                        actions: [
                                                          TextButton(
                                                            child: const Text(
                                                                "OK"),
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(),
                                                          ),
                                                        ],
                                                      );
                                                    });
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ),

                                    // Row(
                                    //   children: [
                                    //     Padding(
                                    //       padding: EdgeInsets.only(
                                    //           left: size.width / 2.5, top: 8.0),
                                    //       child: Container(
                                    //         width: size.width / 6,
                                    //         height: size.height / 25,
                                    //         child: TextButton(
                                    //           child: const Text(
                                    //             'View',
                                    //             style: TextStyle(
                                    //                 color: Colors.blue),
                                    //           ),
                                    //           onPressed: () {
                                    //             Navigator.of(context).push(
                                    //                 MaterialPageRoute(
                                    //                     builder: (context) =>
                                    //                         const About()));
                                    //           },
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     Padding(
                                    //       padding:
                                    //           EdgeInsets.only(top: 8, left: 0),
                                    //       child: Container(
                                    //         width: size.width / 6,
                                    //         height: size.height / 25,
                                    //         child: TextButton(
                                    //           child: const Text(
                                    //             'Match',
                                    //             style: TextStyle(
                                    //                 color: Colors.blue),
                                    //           ),
                                    //           onPressed: () {
                                    //             http.post(
                                    //                 Uri.parse(
                                    //                     "http://10.0.2.2:3000/match"),
                                    //                 body: json.encode({
                                    //                   "id": widget.user_id,
                                    //                   "match_id":
                                    //                       match['user_id']
                                    //                 }),
                                    //                 headers: {
                                    //                   'Content-Type':
                                    //                       'application/json',
                                    //                 }).then((res) {
                                    //               if (res.statusCode == 200) {
                                    //                 _pullRefresh();
                                    //               } else {
                                    //                 showDialog(
                                    //                     context: context,
                                    //                     builder: (BuildContext
                                    //                         context) {
                                    //                       return AlertDialog(
                                    //                         title: const Text(
                                    //                             "Error"),
                                    //                         content: const Text(
                                    //                             "Something went wrong"),
                                    //                         actions: [
                                    //                           TextButton(
                                    //                             child:
                                    //                                 const Text(
                                    //                                     "OK"),
                                    //                             onPressed: () =>
                                    //                                 Navigator.of(
                                    //                                         context)
                                    //                                     .pop(),
                                    //                           ),
                                    //                         ],
                                    //                       );
                                    //                     });
                                    //               }
                                    //             });
                                    //           },
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 6),
                                  decoration: const BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ) // green shaped
                                      ),
                                  child: Text(
                                      style: TextStyle(color: Colors.white),
                                      "${match['similarity']}% MATCH"),
                                ),
                              )
                            ]),
                          ))
                      .toList())),
        ],
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    double padding = 25;

    final sidePadding = EdgeInsets.symmetric(horizontal: padding);

    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          body: Builder(
              builder: (context) => Container(
                    width: size.width,
                    height: size.height,
                    child: Stack(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          addVerticalSpace(padding),
                          Padding(
                            padding: sidePadding,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Matches",
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              // MessagesPage(user_id: widget.user_id),
                                              ChatsScreen(
                                                  user_id: widget.user_id)),
                                    );
                                  },
                                  child: const BorderIcon(
                                    height: 50,
                                    width: 50,
                                    child: Icon(
                                      Icons.message,
                                      color: COLOR_BLACK,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: sidePadding,
                              child: FutureBuilder(
                                  future: _matches,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<dynamic>> snapshot) {
                                    return RefreshIndicator(
                                        onRefresh: _pullRefresh,
                                        child: _listView(snapshot, context));
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  )),
        ),
      ),
    );
  }

  List<Widget> likes_widget(likesRaw, bool bool) {
    String likes = likesRaw;
    var likesArr = likes.split(',');
    return likesArr
        .map((e) => Container(
              decoration: BoxDecoration(
                color: bool ? Colors.grey : Colors.blue,
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              margin: const EdgeInsets.only(left: 10),
              child: Text(e),
            ))
        .toList();
  }
}
