import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/widget_functions.dart';
import '../utils/constants.dart';
import '../widgets/BorderIcon.dart';

class AcceptChatPage extends StatefulWidget {
  final String name;
  final int user_id;
  final int match_id;

  AcceptChatPage(
      {required this.name, required this.user_id, required this.match_id});

  @override
  _AcceptChatPageState createState() => _AcceptChatPageState();
}

class _AcceptChatPageState extends State<AcceptChatPage> {
  Future<List<dynamic>> userStatus() async {
    var body = json.encode({"user_id": widget.user_id});
    String url = "http://10.0.2.2:3000/user-status";
    final response = await http.post(Uri.parse(url), body: body, headers: {
      'Content-Type': 'application/json',
    });

    var responseData = json.decode(response.body);
    // print(responseData[0]['type']);
    return responseData;
  }

  Future<List<dynamic>> getChats() async {
    var body =
        json.encode({"user1_id": widget.user_id, "user2_id": widget.match_id});

    // print(body);

    String url = "http://10.0.2.2:3000/chats";
    final response = await http.post(Uri.parse(url), body: body, headers: {
      'Content-Type': 'application/json',
    });

    var responseData = json.decode(response.body);
    return responseData;
  }

  late Future<List<dynamic>> _chats;
  late Future<List<dynamic>> _status;

  late Timer _everySecond;

  @override
  void initState() {
    super.initState();
    _chats = getChats();
    _status = userStatus();
    // print(_status);

    _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        _chats = getChats();
      });
    });
  }

  // final List<ChatMessage> _messages = [];

  final TextEditingController _textController = TextEditingController();

  Future<void> _handleSubmitted(String text) async {
    _textController.clear();

    if (text == "") {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text("Cannot send empty text"),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    } else {
      var body = json.encode({
        "user1_id": widget.user_id,
        "user2_id": widget.match_id,
        "message": text
      });

      String url = "http://10.0.2.2:3000/submit-chat";

      final response = await http.post(Uri.parse(url), body: body, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        setState(() {
          _chats = getChats();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double padding = 25;

    final sidePadding = EdgeInsets.symmetric(horizontal: padding);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            addVerticalSpace(padding),
            Padding(
              padding: sidePadding,
              child: Row(
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
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(width: 16.0),
                        CircleAvatar(
                          child: Text(widget.name[0]),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.name),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            addVerticalSpace(15),
            Container(
                child: const Center(
              child: Text('The homeowner has accepted you as a match!',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            )),
            addVerticalSpace(15),
            Divider(),
            Expanded(
                child: Padding(
                    padding: sidePadding,
                    child: FutureBuilder(
                        future: _chats,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<dynamic>> snapshot) {
                          if (snapshot.hasData) {
                            List<dynamic> _chats =
                                snapshot.data as List<dynamic>;
                            if (_chats.isEmpty) {
                              return const Center(child: Text("No Chat yet"));
                            }
                            return RefreshIndicator(
                              onRefresh: _pullRefresh,
                              child: ListView.builder(
                                  reverse: true,
                                  itemCount: _chats.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      padding: const EdgeInsets.only(
                                          left: 14,
                                          right: 14,
                                          top: 10,
                                          bottom: 10),
                                      child: Align(
                                        alignment: (_chats[index]['user1_id'] ==
                                                widget.match_id
                                            ? Alignment.topLeft
                                            : Alignment.topRight),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: (_chats[index]['user2_id'] ==
                                                    widget.match_id
                                                ? Colors.grey.shade200
                                                : Colors.blue[200]),
                                          ),
                                          padding: EdgeInsets.all(16),
                                          child: Text(
                                            _chats[index]['message'],
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            );
                          } else {
                            return const Center(child: Text("No chat yet"));
                          }
                        }))),
            Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: _textController,
                        onSubmitted: _handleSubmitted,
                        decoration: const InputDecoration.collapsed(
                            hintText: 'Send a message'),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () => _handleSubmitted(_textController.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _chats = getChats();
    });
  }
}
