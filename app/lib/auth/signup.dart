import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:textfield_tags/textfield_tags.dart';

// import 'package:app/screens/home.dart';
import 'package:app/screens/questions.dart';
import 'package:uuid/uuid.dart';
import '../utils/widget_functions.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late double _distanceToField;
  late TextfieldTagsController _controllerLikes;
  late TextfieldTagsController _controllerDislikes;
  final _formKey = GlobalKey<FormState>();
  late String _email, _name, _password, _bio;
  late bool imagepicker = false;
  late bool image_view = false;
  late String _image_url = "";
  String _type = "Tenant or Homeowner";
  String _location = 'Choose your location perference';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
    _controllerLikes.dispose();
    _controllerDislikes.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controllerLikes = TextfieldTagsController();
    _controllerDislikes = TextfieldTagsController();
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_type == 'Tenant or Homeowner' ||
          _location == 'Choose your location perference') {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text("Location or type is empty"),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      } else if (!_controllerLikes.hasTags) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text("Likes cannot be empty"),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      } else if (!_controllerDislikes.hasTags) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text("Dislikes cannot be empty"),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      } else if (_type == "Homeowner" && _image_url == "") {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text("Add an image"),
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
        http.post(Uri.parse("http://10.0.2.2:3000/auth/signup"), body: {
          "name": _name,
          "email": _email,
          "password": _password,
          "type": _type,
          "location": _location,
          "likes": jsonEncode(_controllerLikes.getTags),
          "dislikes": jsonEncode(_controllerDislikes.getTags),
          "bio": _bio,
          "image_url": _image_url
        }).then((res) {
          if (res.statusCode == 200) {
            var responseJson = json.decode(res.body);
            if (responseJson['success']) {
              // Sign up success
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => RatingScreen1(responseJson['user_id']),
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String dropdownvalue = 'Tenant or Homeowner';

    // List of items in our dropdown menu
    var items = [
      'Tenant or Homeowner',
      'Tenant',
      'Homeowner',
    ];

    String dropdownvalue1 = 'Choose your location perference';

    // List of items in our dropdown menu
    var items1 = [
      'Choose your location perference',
      'Mumbai',
      'Pune',
      'Bangalore',
      'Delhi'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: "Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your name";
                    }
                    return null;
                  },
                  onSaved: (value) => _name = value!,
                ),
                addVerticalSpace(8.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains("@")) {
                      return "Please enter valid email";
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value!,
                ),
                addVerticalSpace(8.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value!,
                ),
                addVerticalSpace(8.0),
                DropdownButtonFormField(
                  // Initial Value
                  value: dropdownvalue,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      _type = newValue!;
                      if (newValue == "Homeowner")
                        imagepicker = true;
                      else
                        imagepicker = false;
                    });
                  },
                ),
                addVerticalSpace(8.0),
                DropdownButtonFormField(
                  // Initial Value
                  value: dropdownvalue1,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: items1.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      _location = newValue!;
                    });
                  },
                ),
                addVerticalSpace(15.0),
                Text("Likes"),
                TextFieldTags(
                  textfieldTagsController: _controllerLikes,
                  textSeparators: const [' ', ','],
                  letterCase: LetterCase.normal,
                  validator: (String tag) {
                    if (_controllerLikes.getTags!.contains(tag)) {
                      return 'you already entered that';
                    }
                    return null;
                  },
                  inputfieldBuilder:
                      (context, tec, fn, error, onChanged, onSubmitted) {
                    return ((context, sc, tags, onTagDelete) {
                      return TextField(
                        controller: tec,
                        focusNode: fn,
                        decoration: InputDecoration(
                          isDense: true,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3.0,
                            ),
                          ),
                          // focusedBorder: const OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //     color: Color.fromARGB(255, 74, 137, 92),
                          //     width: 3.0,
                          //   ),
                          // ),

                          hintText: _controllerLikes.hasTags
                              ? ''
                              : "Enter your likes...",
                          errorText: error,
                          prefixIconConstraints:
                              BoxConstraints(maxWidth: _distanceToField * 0.74),
                          prefixIcon: tags.isNotEmpty
                              ? SingleChildScrollView(
                                  controller: sc,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                      children: tags.map((String tag) {
                                    return Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20.0),
                                        ),
                                        color: Colors.blue,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            child: Text(
                                              '$tag',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onTap: () {
                                              print("$tag selected");
                                            },
                                          ),
                                          const SizedBox(width: 4.0),
                                          InkWell(
                                            child: const Icon(
                                              Icons.cancel,
                                              size: 14.0,
                                              color: Color.fromARGB(
                                                  255, 233, 233, 233),
                                            ),
                                            onTap: () {
                                              onTagDelete(tag);
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  }).toList()),
                                )
                              : null,
                        ),
                        onChanged: onChanged,
                        onSubmitted: onSubmitted,
                      );
                    });
                  },
                ),
                addVerticalSpace(15.0),
                Text("Dislikes"),
                TextFieldTags(
                  textfieldTagsController: _controllerDislikes,
                  textSeparators: const [' ', ','],
                  letterCase: LetterCase.normal,
                  validator: (String tag) {
                    if (_controllerDislikes.getTags!.contains(tag)) {
                      return 'you already entered that';
                    }
                    return null;
                  },
                  inputfieldBuilder:
                      (context, tec, fn, error, onChanged, onSubmitted) {
                    return ((context, sc, tags, onTagDelete) {
                      return TextField(
                        controller: tec,
                        focusNode: fn,
                        decoration: InputDecoration(
                          isDense: true,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3.0,
                            ),
                          ),
                          hintText: _controllerDislikes.hasTags
                              ? ''
                              : "Enter your dislikes...",
                          errorText: error,
                          prefixIconConstraints:
                              BoxConstraints(maxWidth: _distanceToField * 0.74),
                          prefixIcon: tags.isNotEmpty
                              ? SingleChildScrollView(
                                  controller: sc,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                      children: tags.map((String tag) {
                                    return Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20.0),
                                        ),
                                        color: Colors.blue,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            child: Text(
                                              '$tag',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onTap: () {
                                              print("$tag selected");
                                            },
                                          ),
                                          const SizedBox(width: 4.0),
                                          InkWell(
                                            child: const Icon(
                                              Icons.cancel,
                                              size: 14.0,
                                              color: Color.fromARGB(
                                                  255, 233, 233, 233),
                                            ),
                                            onTap: () {
                                              onTagDelete(tag);
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  }).toList()),
                                )
                              : null,
                        ),
                        onChanged: onChanged,
                        onSubmitted: onSubmitted,
                      );
                    });
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Bio"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a bio";
                    }
                    return null;
                  },
                  onSaved: (value) => _bio = value!,
                ),
                if (imagepicker == true)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      addVerticalSpace(15.0),
                      const Text('Add the picture of the room:'),
                      TextButton(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();

                            final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery);

                            final directory =
                                await getApplicationDocumentsDirectory();
                            final String path = directory.path;

                            var uuid = const Uuid();

                            final File newImage = await File(image!.path)
                                .copy('$path/${uuid.v1()}.jpg');

                            // print('$path/${uuid.v1()}.jpg');
                            // print(newImage.path);
                            setState(() {
                              _image_url = newImage.path;
                              image_view = true;
                            });
                          },
                          child: const Icon(Icons.add_a_photo)),
                      if (image_view == true) Text(_image_url)
                    ],
                  ),
                Center(
                  child: OutlinedButton(
                    onPressed: () => _submit(context),
                    child: const Text("Sign Up"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
