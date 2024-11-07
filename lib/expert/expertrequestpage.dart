import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stage_app/expert/expertpage.dart';
import 'package:stage_app/methods.dart';
import 'expertpage.dart';

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

List<dynamic> imagesList = [];

@override
class _RequestPageState extends State<RequestPage> {
  void fetchRequestedPictures() async {
    try {
      final response = await http.get(
        Uri.parse(Path.globalpath + '/requested-pictures'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          imagesList = data; // Update the imagesList with fetched data
        });
      } else {
        print('Failed to fetch pictures');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void initState() {
    super.initState();
    fetchRequestedPictures();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: imagesList.length,
                itemBuilder: (context, index) {
                  var imageString = imagesList[index]['image'];
                  var imageBytes = base64Decode(imageString);
                  var aiPredictedState = imagesList[index]['aiPredictedState'];
                  var treeName = imagesList[index]['tree_name'];
                  var index1 = index + 1;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeafCommentPage(
                            imageBytes: imageBytes,
                            index: index,
                            aiPredictedState: aiPredictedState,
                            correspondingTree: treeName,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Image on the left
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                8), // Adjust the radius as per your preference
                            child: Image.memory(
                              imageBytes,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 16),
                          // Status and delete button in the middle
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Leaf $index1',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '\nTree Name:\n$treeName',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          // Delete button on the right
                          Text(
                            'AI Prediction:\n$aiPredictedState',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeafCommentPage extends StatefulWidget {
  final Uint8List imageBytes;
  final String aiPredictedState;
  final String correspondingTree;
  final int index;

  LeafCommentPage(
      {required this.imageBytes,
      required this.aiPredictedState,
      required this.correspondingTree,
      required this.index});

  @override
  _LeafCommentPageState createState() => _LeafCommentPageState(
      imageBytes: imageBytes,
      aiPredictedState: aiPredictedState,
      correspondingTree: correspondingTree,
      index: index);
}

class _LeafCommentPageState extends State<LeafCommentPage> {
  final Uint8List imageBytes;
  final String aiPredictedState;
  final String correspondingTree;
  final int index;
  _LeafCommentPageState(
      {required this.imageBytes,
      required this.aiPredictedState,
      required this.correspondingTree,
      required this.index});

  TextEditingController expertPredictedStatecontroller =
      TextEditingController();
  TextEditingController expertCommentcontroller = TextEditingController();
  late Widget champsexpertComment;
  late Widget champsexpertPredictedState;

  @override
  void initState() {
    super.initState();
    champsexpertPredictedState = CustomTextField1(
      hintText: 'Expert Predicted State',
      obscureText: false,
      controller: expertPredictedStatecontroller,
      validator: (value) {
        return '';
      },
    );
    champsexpertComment = CustomTextField1(
      hintText: 'Expert Comments',
      obscureText: false,
      controller: expertCommentcontroller,
      validator: (value) {
        return '';
      },
    );
  }

  void add_comment(
      BuildContext context, List<dynamic> imagesList, int index) async {
    String expertComment = expertCommentcontroller.text;
    String expertPredictedState = expertPredictedStatecontroller.text;

    // Call the backend API to create a new user http://localhost:3001
    var url = Path.globalpath + '/add-comment'; // Replace with your server URL

    var response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'tree_name': imagesList[index]['tree_name'],
        'image': imagesList[index]['image'],
        'aiPredictedState': imagesList[index]['aiPredictedState'],
        'expertComment': expertComment,
        'expertPredictedState': expertPredictedState,
        'ask_expert': false,
      }),
    );

    if ((response.statusCode == 200 || response.statusCode == 201)) {
      // User creation successful
      var responseBody = jsonDecode(response.body);
      print(responseBody);
      showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialog(
            title: 'Success',
            contentText: 'Comment submitted',
            onOkPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExpertPage(1)),
              );
            },
          );
        },
      );
    } else {
      // User creation failed
      showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialog(
            title: 'Error',
            contentText: 'Failed to submit comment ',
            onOkPressed: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Leaves Page",
          style: TextStyle(
            fontSize: 29.0,
            fontFamily: 'titre',
            color: AppColors.vertnormal,
            decoration: TextDecoration.none,
          ),
        ),
        backgroundColor: AppColors.topbar,
        elevation: 0,
        iconTheme: IconThemeData(
          color: AppColors.vertnormal,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(46),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  imageBytes,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Corresponding Tree:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                correspondingTree,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'AI Predicted State:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                aiPredictedState,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Expert Prediction',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 23.0,
                    fontFamily: 'ecriture',
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              SizedBox(height: 5),
              champsexpertPredictedState,
              SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Expert Comments',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 23.0,
                    fontFamily: 'ecriture',
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              SizedBox(height: 5),
              champsexpertComment,
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  add_comment(context, imagesList, index);
                },
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontFamily: 'ecriture',
                    fontSize: 23.0,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: AppColors.vertnormal,
                  onPrimary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    side: BorderSide(
                      color: AppColors.vertnormal,
                      width: 1.0,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 24.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField1 extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?) validator;

  CustomTextField1({
    required this.hintText,
    required this.obscureText,
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2.0),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2.0),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
