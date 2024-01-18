import 'dart:convert';
import 'package:app/auth/login.dart';
import 'package:app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RatingScreen1 extends StatefulWidget {
  int user_id;
  RatingScreen1(this.user_id);

  @override
  _RatingScreenState1 createState() => _RatingScreenState1();
}

class _RatingScreenState1 extends State<RatingScreen1> {
  double _question1Rating = 1;
  double _question2Rating = 1;
  double _question3Rating = 1;
  double _question4Rating = 1;
  double _question5Rating = 1;
  double _question6Rating = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('extraversion'),
      ),
      body: Column(
        children: <Widget>[
          const Padding(padding: EdgeInsets.all(20)),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('I am the life of the party.'),
          ),
          Slider(
            value: _question1Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question1Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question1Rating = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('I don\'t talk a lot.'),
          ),
          Slider(
            value: _question2Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question2Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question2Rating = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('I feel comfortable around people.'),
          ),
          Slider(
            value: _question3Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question3Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question3Rating = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('I keep in the background.'),
          ),
          Slider(
            value: _question4Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question4Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question4Rating = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('I start conversations.'),
          ),
          Slider(
            value: _question5Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question5Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question5Rating = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('I have little to say.'),
          ),
          Slider(
            value: _question6Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question6Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question6Rating = value;
              });
            },
          ),
          TextButton(
            onPressed: () {
              var str1 =
                  "${_question1Rating.round()},${_question2Rating.round()},${_question3Rating.round()},${_question4Rating.round()},${_question5Rating.round()},${_question6Rating.round()}";
              print(str1);

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => RatingScreen2(str1, widget.user_id)),
              );
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final int rating;
  final Function(int) onRatingChanged;

  StarRating({
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < rating
                      ? Icons.check_box
                      : Icons.check_box_outline_blank_outlined,
                ),
                color: Colors.black45,
                iconSize: 40,
                onPressed: () => onRatingChanged(index + 1),
              );
            })));
  }
}

class RatingScreen2 extends StatefulWidget {
  final String str1;
  final int user_id;
  RatingScreen2(this.str1, this.user_id);

  @override
  _RatingScreenState2 createState() => _RatingScreenState2();
}

class _RatingScreenState2 extends State<RatingScreen2> {
  double _question1Rating = 1;
  double _question2Rating = 1;
  double _question3Rating = 1;
  double _question4Rating = 1;
  double _question5Rating = 1;
  double _question6Rating = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('neuroticism'),
      ),
      body: Column(
        children: <Widget>[
          const Padding(padding: EdgeInsets.all(20)),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('I get stressed out easily.'),
          ),
          Slider(
            value: _question1Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question1Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question1Rating = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('I am relaxed most of the time.'),
          ),
          Slider(
            value: _question2Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question2Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question2Rating = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('I worry about things.'),
          ),
          Slider(
            value: _question3Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question3Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question3Rating = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('I am easily disturbed.'),
          ),
          Slider(
            value: _question4Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question4Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question4Rating = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('I change my mood a lot.'),
          ),
          Slider(
            value: _question5Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question5Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question5Rating = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('I get irritated easily.'),
          ),
          Slider(
            value: _question6Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question6Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question6Rating = value;
              });
            },
          ),
          TextButton(
            onPressed: () {
              var str2 =
                  "${_question1Rating.round()},${_question2Rating.round()},${_question3Rating.round()},${_question4Rating.round()},${_question5Rating.round()},${_question6Rating.round()}";
              print(str2);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) =>
                        RatingScreen3(widget.str1, str2, widget.user_id)),
              );
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}

class RatingScreen3 extends StatefulWidget {
  final String str1;
  final String str2;
  final int user_id;
  RatingScreen3(this.str1, this.str2, this.user_id);

  @override
  _RatingScreenState3 createState() => _RatingScreenState3();
}

class _RatingScreenState3 extends State<RatingScreen3> {
  double _question1Rating = 1;
  double _question2Rating = 1;
  double _question3Rating = 1;
  double _question4Rating = 1;
  double _question5Rating = 1;
  double _question6Rating = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('agreeableness'),
      ),
      body: Column(
        children: <Widget>[
          const Padding(padding: EdgeInsets.all(20)),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('I feel little concern for others.'),
          ),
          Slider(
            value: _question1Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question1Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question1Rating = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('I am interested in people.'),
          ),
          Slider(
            value: _question2Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question2Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question2Rating = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('I sympathize with others\' feelings.'),
          ),
          Slider(
            value: _question3Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question3Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question3Rating = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("I am not interested in other people's problems."),
          ),
          Slider(
            value: _question4Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question4Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question4Rating = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('I have a soft heart.'),
          ),
          Slider(
            value: _question5Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question5Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question5Rating = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('I take time out for others.'),
          ),
          Slider(
            value: _question6Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question6Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question6Rating = value;
              });
            },
          ),
          TextButton(
            onPressed: () {
              var str3 =
                  "${_question1Rating.round()},${_question2Rating.round()},${_question3Rating.round()},${_question4Rating.round()},${_question5Rating.round()},${_question6Rating.round()}";
              print(str3);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => RatingScreen4(
                        widget.str1, widget.str2, str3, widget.user_id)),
              );
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}

class RatingScreen4 extends StatefulWidget {
  final String str1;
  final String str2;
  final String str3;
  final int user_id;
  RatingScreen4(this.str1, this.str2, this.str3, this.user_id);

  @override
  _RatingScreenState4 createState() => _RatingScreenState4();
}

class _RatingScreenState4 extends State<RatingScreen4> {
  double _question1Rating = 1;
  double _question2Rating = 1;
  double _question3Rating = 1;
  double _question4Rating = 1;
  double _question5Rating = 1;
  double _question6Rating = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('conscientiousness'),
      ),
      body: Column(
        children: <Widget>[
          const Padding(padding: EdgeInsets.all(20)),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('I make a mess of things.'),
          ),
          Slider(
            value: _question1Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question1Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question1Rating = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
                'I often forget to put things back in their proper place.'),
          ),
          Slider(
            value: _question2Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question2Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question2Rating = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('I like order.'),
          ),
          Slider(
            value: _question3Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question3Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question3Rating = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('I shirk my duties.'),
          ),
          Slider(
            value: _question4Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question4Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question4Rating = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('I follow a schedule.'),
          ),
          Slider(
            value: _question5Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question5Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question5Rating = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('I am exacting in my work.'),
          ),
          Slider(
            value: _question6Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question6Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question6Rating = value;
              });
            },
          ),
          TextButton(
            onPressed: () {
              var str4 =
                  "${_question1Rating.round()},${_question2Rating.round()},${_question3Rating.round()},${_question4Rating.round()},${_question5Rating.round()},${_question6Rating.round()}";
              print(str4);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => RatingScreen5(widget.str1,
                        widget.str2, widget.str3, str4, widget.user_id)),
              );
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}

class RatingScreen5 extends StatefulWidget {
  final String str1;
  final String str2;
  final String str3;
  final String str4;
  final int user_id;
  RatingScreen5(this.str1, this.str2, this.str3, this.str4, this.user_id);

  @override
  _RatingScreenState5 createState() => _RatingScreenState5();
}

class _RatingScreenState5 extends State<RatingScreen5> {
  double _question1Rating = 1;
  double _question2Rating = 1;
  double _question3Rating = 1;
  double _question4Rating = 1;
  double _question5Rating = 1;
  double _question6Rating = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('openness'),
      ),
      body: Column(
        children: <Widget>[
          const Padding(padding: EdgeInsets.all(20)),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('I have a rich vocabulary.'),
          ),
          Slider(
            value: _question1Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question1Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question1Rating = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('I have a vivid imagination.'),
          ),
          Slider(
            value: _question2Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question2Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question2Rating = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('I have excellent ideas.'),
          ),
          Slider(
            value: _question3Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question3Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question3Rating = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('I am quick to understand things.'),
          ),
          Slider(
            value: _question4Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question4Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question4Rating = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('I use difficult words.'),
          ),
          Slider(
            value: _question5Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question5Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question5Rating = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('I spend time reflecting on things.'),
          ),
          Slider(
            value: _question6Rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _question6Rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _question6Rating = value;
              });
            },
          ),
          TextButton(
            onPressed: () {
              var str5 =
                  "${_question1Rating.round()},${_question2Rating.round()},${_question3Rating.round()},${_question4Rating.round()},${_question5Rating.round()},${_question6Rating.round()}";
              print(widget.str1);
              print(widget.str2);
              print(widget.str3);
              print(widget.str4);
              print(str5);
              print("user_id: ${widget.user_id}");

              var arr = [
                widget.str1,
                widget.str2,
                widget.str3,
                widget.str4,
                str5
              ];

              final Map<String, dynamic> data = new Map<String, dynamic>();
              data['data'] = arr;
              data['user_id'] = widget.user_id;

              print(data);
              String str = json.encode(data);
              print(str);

              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Processing..."),
                    content: Row(children: [
                      const CircularProgressIndicator(),
                      Container(
                          margin: const EdgeInsets.only(left: 7),
                          child: const Text("Loading...")),
                    ]),
                    // actions: [
                    //   TextButton(
                    //     child: const Text("OK"),
                    //     onPressed: () => Navigator.of(context).pop(),
                    //   ),
                    // ],
                  );
                },
              );

              http
                  .post(Uri.parse("http://10.0.2.2:3000/kmeans"),
                      headers: {"Content-Type": "application/json"}, body: str)
                  .then((res) {
                if (res.statusCode == 200) {
                  var responseJson = json.decode(res.body);
                  if (responseJson['success']) {
                    // print(responseJson);
                    // Sign up success
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => HomePage(
                            responseJson['user_id'], responseJson['cluster']),
                      ),
                    );
                  } else {
                    // Sign up failed
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Error"),
                          content: Text(responseJson['message']),
                          actions: [
                            TextButton(
                              child: const Text("OK"),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else if (res.statusCode == 401) {
                  var responseJson = json.decode(res.body);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                              "Potential fake user ${responseJson['distance']}"),
                          content: const Text('Invalid responses was detected'),
                          actions: [
                            TextButton(
                              child: const Text("OK"),
                              onPressed: () =>
                                  Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                } else {
                  // HTTP request failed
                  var responseJson = json.decode(res.body);
                  // HTTP request failed
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Error"),
                          content: Text(responseJson['message']),
                          actions: [
                            TextButton(
                              child: const Text("OK"),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        );
                      });
                }
              });
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
