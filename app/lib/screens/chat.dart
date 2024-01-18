import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/widget_functions.dart';
import '../utils/constants.dart';
import '../widgets/BorderIcon.dart';
import 'ChatPage.dart';
import 'acceptchat.dart';
import 'rejectedchat.dart';

class Chat {
  final String name;

  Chat({required this.name});
}

class ChatsScreen extends StatefulWidget {
  final int user_id;

  const ChatsScreen({
    required this.user_id,
    super.key,
  });

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  Future<List<dynamic>> getChats() async {
    var body = json.encode({"user_id": widget.user_id});

    // print(body);

    String url = "http://10.0.2.2:3000/get-chats";
    final response = await http.post(Uri.parse(url), body: body, headers: {
      'Content-Type': 'application/json',
    });

    var responseData = json.decode(response.body);
    return responseData;
  }

  late Future<List<dynamic>> _chats;
  late Timer _everySecond;

  @override
  void initState() {
    super.initState();
    _chats = getChats();
    _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        _chats = getChats();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double padding = 25;

    final sidePadding = EdgeInsets.symmetric(horizontal: padding);

    return SafeArea(
      child: Scaffold(
          body: Column(children: [
        addVerticalSpace(padding),
        Padding(
          padding: sidePadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const BorderIcon(
                  height: 50,
                  width: 50,
                  child: Icon(
                    Icons.arrow_back,
                    color: COLOR_BLACK,
                  ),
                ),
              ),
              const Text(
                "Chats",
              ),
            ],
          ),
        ),
        Divider(),
        Expanded(
          child: Padding(
            padding: sidePadding,
            child: FutureBuilder(
                future: _chats,
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    List<dynamic> _chats = snapshot.data as List<dynamic>;
                    if (_chats.isEmpty) {
                      return const Center(
                          child: Text("Have'nt matched with anyone yet!"));
                    }
                    return ListView.builder(
                      itemCount: _chats.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            if (_chats[index]['accepted'] == 0) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        // MessagesPage(user_id: widget.user_id),
                                        RejectChatPage(
                                            name: _chats[index]['name'],
                                            user_id: widget.user_id,
                                            match_id: _chats[index]
                                                ['matched_id'])),
                              );
                            } else if (_chats[index]['accepted'] == 1) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        // MessagesPage(user_id: widget.user_id),
                                        AcceptChatPage(
                                            name: _chats[index]['name'],
                                            user_id: widget.user_id,
                                            match_id: _chats[index]
                                                ['matched_id'])),
                              );
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        // MessagesPage(user_id: widget.user_id),
                                        ChatPage(
                                            name: _chats[index]['name'],
                                            user_id: widget.user_id,
                                            match_id: _chats[index]
                                                ['matched_id'])),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  child: Text(_chats[index]['name'][0]),
                                ),
                                SizedBox(width: 16.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(_chats[index]['name']),
                                    ],
                                  ),
                                ),
                                if (_chats[index]['accepted'] == 0)
                                  Text(
                                    'Rejected',
                                    style: TextStyle(color: Colors.red[900]),
                                  ),
                                if (_chats[index]['accepted'] == 1)
                                  Text(
                                    'Accepted',
                                    style: TextStyle(color: Colors.green[900]),
                                  )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ),
      ])),
    );
  }
}
