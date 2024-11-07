/*import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stage_app/methods.dart';

class LeavesPage extends StatefulWidget {
  LeavesPage();

  @override
  _LeavesPageState createState() => _LeavesPageState();
}

late Map<String, String> treeStatusMap = {};

class _LeavesPageState extends State<LeavesPage> {
  List<dynamic> imagesStrings = [];
  List<String> trees = [];

  @override
  void initState() {
    super.initState();
    fetchtrees();
  }

  void fetchtrees() async {
    try {
      var url = Path.globalpath +
          '/trees'; // Replace with your server URL or API endpoint

      var response = await http.get(Uri.parse(url));
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var treeList =
            data as List<dynamic>; // Update here to access the array directly

        var filteredtrees =
            treeList.map<String>((tree) => tree['name'].toString()).toList();

        setState(() {
          trees = filteredtrees;

          print(trees);
        });
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to fetch tree list.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error: $e');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An unexpected error occurred.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> clear(String tree_name) async {
    try {
      final response = await http.post(
        Uri.parse(Path.globalpath + '/clear-tree/${tree_name}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'tree_name': tree_name
        }), // empty request payload for DELETE method
      );
      if (response.statusCode == 200) {
        print('Image sent successfully');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success!'),
              content: Text('Tree Cleared successfully.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        print('Failed to clear tree');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void fetchPictures(String selectedTreeName) async {
    try {
      final response = await http.get(
        Uri.parse(Path.globalpath + '/pictures/${selectedTreeName}'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var imagesList = data as List<dynamic>;
        bool b = false;
        for (int i = 0; i < imagesList.length; i++) {
          if (imagesList[i]['status'] == 'Disease Risk') {
            treeStatusMap[selectedTreeName] = 'Disease Risk';
            b = true;
            break;
          }
        }
        if (b == false) {
          treeStatusMap[selectedTreeName] = 'Healthy';
        }
      } else {
        print('Failed to fetch pictures');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showEditStatusDialog(BuildContext context) {
    String newStatus = status;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Tree Status'),
          content: TextField(
            onChanged: (value) {
              newStatus = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  status = newStatus;
                });
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context); // Close the dialog without saving changes
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  String status = 'Healthy';
  var color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: trees.length,
        itemBuilder: (context, index) {
          final treeName = trees[index];
          fetchPictures(treeName);
          final status =
              treeStatusMap[treeName]; // Get the status for the current tree

          print(status);
          Color color = Colors.green; // Default color
          if (status == 'Disease Risk') {
            color = Colors.orangeAccent;
          }
          return Container(
            padding: EdgeInsets.all(16),
            child: ListTile(
              leading: Icon(
                Icons.forest_rounded,
                size: 28,
                color: color,
              ),
              title: Text(treeName, style: TextStyle(fontSize: 18)),
              subtitle: Text('Tree Status: $status'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      _showEditStatusDialog_new(context, treeName);
                    },
                  ),
                  Text(
                    "Edit\nstatus",
                    style: TextStyle(fontSize: 13),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_rounded,
                      color: Color.fromRGBO(164, 15, 15, 0.824),
                    ),
                    onPressed: () {
                      clear(treeName);
                      // Add logic for clearing the tree from leaves
                    },
                  ),
                  Text(
                    "Clear\nleaves",
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
              onTap: () {
                // Navigate to the LeavesDetailPage for displaying tree details
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LeavesDetailPage(
                      treeName: treeName,

                      // Pass the status as well to the LeavesDetailPage
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showEditStatusDialog_new(BuildContext context, String treeName) {
    String newStatus =
        treeStatusMap[treeName] ?? ''; // Get the current status of the tree

    showDialog(
      context: context,
      builder: (context) {
        String? selectedStatus = newStatus;

        return AlertDialog(
          title: Text('Edit Tree Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text('Healthy'),
                value: 'Healthy',
                groupValue: selectedStatus,
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value;
                    treeStatusMap[treeName] =
                        selectedStatus!; // Update selectedStatus inside setState
                  });
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: Text('Disease Risk'),
                value: 'Disease Risk',
                groupValue: selectedStatus,
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value;
                    treeStatusMap[treeName] =
                        selectedStatus!; // Update selectedStatus inside setState
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class LeavesDetailPage extends StatefulWidget {
  final String treeName;

  LeavesDetailPage({required this.treeName});

  @override
  _LeavesDetailPageState createState() => _LeavesDetailPageState();
}

class _LeavesDetailPageState extends State<LeavesDetailPage> {
  List<dynamic> imagesList = [];

  @override
  void initState() {
    super.initState();
    fetchPictures(widget.treeName);
  }

  void fetchPictures(String selectedTreeName) async {
    try {
      final response = await http.get(
        Uri.parse(Path.globalpath + '/pictures/${selectedTreeName}'),
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

  void deleteImage(List<int> imageBytes) async {
    try {
      // Convert the image bytes to base64 string
      String base64Image = base64Encode(imageBytes);

      // Send the HTTP POST request to the server

      final response = await http.post(
        Uri.parse(Path.globalpath + '/delete-image'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image': base64Image}),
      );

      var responseBody = jsonDecode(response.body);
      print(responseBody);
      print(response.statusCode);

      if (response.statusCode == 200) {
        print('Image deleted successfully');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success!'),
              content: Text('Image deleted successfully.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        //run ai model
      } else {
        print('Failed to delete image');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // ... Add your implementation for editing tree status and clearing leaves
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Leaves Page",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'ecriture',
            fontSize: 30,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 228, 241, 228),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout_rounded),
            onPressed: () {
              Navigator.pop(context); // Navigate back to previous screen
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Navigate back to previous screen
            },
            child: Text(
              'Back',
              style: TextStyle(
                fontFamily: 'ecriture',
                fontSize: 16.0,
                color: Colors.black,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tree Name: ${widget.treeName}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: imagesList.length,
                itemBuilder: (context, index) {
                  var imageString = imagesList[index]['image'];
                  var imageBytes = base64Decode(imageString);
                  var status = imagesList[index]['status'];
                  var aiPredictedState = imagesList[index]['aiPredictedState'];
                  var expertPredictedState =
                      imagesList[index]['expertPredictedState'];
                  var expertComment = imagesList[index]['expertComment'];
                  var index1 = index + 1;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeafDetailPage(
                            imageBytes: imageBytes,
                            status: status,
                            aiPredictedState: aiPredictedState,
                            expertPredictedState: expertPredictedState,
                            expertComment: expertComment,
                            correspondingTree: widget.treeName,
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
                                SizedBox(height: 8),
                                Text(
                                  'Status: $status',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          // Delete button on the right
                          GestureDetector(
                            onTap: () => deleteImage(imageBytes),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color.fromRGBO(164, 15, 15, 0.824),
                              ),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
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

class LeafDetailPage extends StatelessWidget {
  final Uint8List imageBytes;
  final String status;
  final String aiPredictedState;
  final String expertPredictedState;
  final String expertComment;
  final String correspondingTree;

  LeafDetailPage({
    required this.imageBytes,
    required this.status,
    required this.aiPredictedState,
    required this.expertPredictedState,
    required this.expertComment,
    required this.correspondingTree,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Leaves Page",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'ecriture',
            fontSize: 30,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 228, 241, 228),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                imageBytes,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'AI Predicted State:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              aiPredictedState,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Expert Predicted State:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              expertPredictedState,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Expert Comment:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              expertComment,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Corresponding Tree:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              correspondingTree,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stage_app/farmer/farmernavbuttombar.dart';
import 'package:stage_app/methods.dart';

class LeavesPage extends StatefulWidget {
  LeavesPage();

  @override
  _LeavesPageState createState() => _LeavesPageState();
}

Map<String, String> treeStatusMap = {};

//final storage1 = FlutterSecureStorage();

class _LeavesPageState extends State<LeavesPage> {
  List<dynamic> imagesStrings = [];
  List<String> trees = [];

  @override
  void initState() {
    super.initState();
    call();
    fetchtrees();
  }

  Map<String, String> _deserializeMap(String mapString) {
    final keyValuePairs = mapString
        .substring(1, mapString.length - 1) // Remove curly braces
        .split(', ')
        .map((entry) => entry.split(': '))
        .toList();

    final Map<String, String> resultMap = {};
    for (final pair in keyValuePairs) {
      resultMap[pair[0]] = pair[1];
    }

    return resultMap;
  }

  bool compareListAndMap(List<String> list, Map<String, String> map) {
    for (var listItem in list) {
      if (!map.containsKey(listItem)) {
        print(10);
        return false; // Found a non common element
      }
    }
    print(100);
    return true; // All elements are common
  }

  void fetchtrees() async {
    try {
      var url =
          '${Path.globalpath}/trees'; // Replace with your server URL or API endpoint

      var response = await http.get(Uri.parse(url));
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var treeList =
            data as List<dynamic>; // Update here to access the array directly

        var filteredtrees =
            treeList.map<String>((tree) => tree['name'].toString()).toList();

        final storedMapAsString = await storage.read(key: 'treeStatusMap');
        if (storedMapAsString != null) {
          treeStatusMap = _deserializeMap(storedMapAsString);
        }

        if (!compareListAndMap(filteredtrees, treeStatusMap)) {
          for (int i = 0; i < filteredtrees.length; i++) {
            print("11");
            await fetchPictures(filteredtrees[i]);
          }
          storage.write(key: 'treeStatusMap', value: treeStatusMap.toString());
          storage.write(key: 'length', value: treeStatusMap.length.toString());
        }

        setState(() {
          trees = filteredtrees;
          storage.write(key: 'treeStatusMap', value: treeStatusMap.toString());
          storage.write(key: 'trees', value: jsonEncode(trees));

          print(trees);
        });
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Error',
              contentText: 'Failed to fetch trees',
              onOkPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> clear(String tree_name) async {
    try {
      final response = await http.post(
        Uri.parse('${Path.globalpath}/clear-tree/${tree_name}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'tree_name': tree_name
        }), // empty request payload for DELETE method
      );
      if (response.statusCode == 200) {
        print('Image sent successfully');
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Success',
              contentText: 'Tree cleared successfully',
              onOkPressed: () {
                fetchtrees();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            );
          },
        );
      } else {
        print('Failed to clear tree');
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Error',
              contentText: 'Failed to clear tree',
              onOkPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchPictures(String selectedTreeName) async {
    try {
      final response = await http.get(
        Uri.parse('${Path.globalpath}/pictures/${selectedTreeName}'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var imagesList = data as List<dynamic>;
        bool b = false;
        for (int i = 0; i < imagesList.length; i++) {
          if (!isHealthy(imagesList[i]['aiPredictedState']) &&
              imagesList[i]['expertPredictedState'] == '') {
            treeStatusMap[selectedTreeName] = "Sick";
            b = true;
            break;
          }
          if (imagesList[i]['expertPredictedState'] != '' &&
              !isHealthy(imagesList[i]['expertPredictedState'])) {
            treeStatusMap[selectedTreeName] = "Sick";
            b = true;
            break;
          }
        }
        if (b == false) {
          treeStatusMap[selectedTreeName] = 'Healthy';
        }
        print(treeStatusMap);
      } else {
        print('Failed to fetch pictures');
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Error',
              contentText: 'Failed to fetch leaves',
              onOkPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showEditStatusDialog(BuildContext context) {
    String newStatus = status;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Tree Status'),
          content: TextField(
            onChanged: (value) {
              newStatus = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  status = newStatus;
                });
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context); // Close the dialog without saving changes
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  int levenshteinDistance(String s1, String s2) {
    var m = s1.length;
    var n = s2.length;

    var dp = List.generate(m + 1, (i) => List<int>.filled(n + 1, 0));

    for (var i = 0; i <= m; i++) {
      for (var j = 0; j <= n; j++) {
        if (i == 0) {
          dp[i][j] = j;
        } else if (j == 0) {
          dp[i][j] = i;
        } else if (s1[i - 1] == s2[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          dp[i][j] = 1 +
              [dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]]
                  .reduce((min, e) => e < min ? e : min);
        }
      }
    }

    return dp[m][n];
  }

  bool isHealthy(String input) {
    final target = "Healthy";
    final distance = levenshteinDistance(input, target);
    // You can adjust this threshold value based on your desired similarity level
    final threshold = 3;

    return distance <= threshold;
  }

  String status = 'Healthy';
  var color;
  int l = 0;
  Future<void> call() async {
    final storedMapAsString = await storage.read(key: 'treeStatusMap');
    String? storedList = await storage.read(key: 'trees');

    if (storedMapAsString != null && storedList != null) {
      treeStatusMap = _deserializeMap(storedMapAsString);
      List<dynamic> deserializedList = jsonDecode(storedList);

      // Convert the dynamic list to a list of strings
      trees = List<String>.from(deserializedList);
      l = treeStatusMap.length;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    print(treeStatusMap);
    print("1");
    print(trees.length);

    return Scaffold(
      body: ListView.builder(
        itemCount: trees.length,
        itemBuilder: (context, index) {
          final treeName = trees[index];
          print("1");
          print(trees.length);

          final status =
              treeStatusMap[treeName]; // Get the status for the current tree

          //print(!isHealthy(status!));
          print(status! + status!);
          Color color = Color(0xFF349E74); // Default color
          if (!isHealthy(status)) {
            color = Colors.orangeAccent;
          }
          return Container(
            padding: EdgeInsets.all(16),
            child: ListTile(
              leading: Icon(
                Icons.forest_rounded,
                size: 28,
                color: color,
              ),
              title: Text(treeName, style: TextStyle(fontSize: 18)),
              subtitle: Text('Tree Status: $status'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      _showEditStatusDialog_new(context, treeName);
                    },
                  ),
                  Text(
                    "Edit\nstatus",
                    style: TextStyle(fontSize: 13),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_rounded,
                      color: Color.fromRGBO(164, 15, 15, 0.824),
                    ),
                    onPressed: () {
                      Future<void> onYesPressed() async {
                        clear(treeName);
                        try {
                          var url =
                              '${Path.globalpath}/trees'; // Replace with your server URL or API endpoint

                          var response = await http.get(Uri.parse(url));
                          print(response.statusCode);
                          print(response.body);
                          if (response.statusCode == 200) {
                            var data = jsonDecode(response.body);
                            var treeList = data as List<
                                dynamic>; // Update here to access the array directly

                            var filteredtrees = treeList
                                .map<String>((tree) => tree['name'].toString())
                                .toList();

                            final storedMapAsString =
                                await storage.read(key: 'treeStatusMap');
                            if (storedMapAsString != null) {
                              treeStatusMap =
                                  _deserializeMap(storedMapAsString);
                            }

                            print("11");
                            await fetchPictures(treeName);

                            storage.write(
                                key: 'treeStatusMap',
                                value: treeStatusMap.toString());
                            storage.write(
                                key: 'length',
                                value: treeStatusMap.length.toString());

                            setState(() {
                              trees = filteredtrees;
                              storage.write(
                                  key: 'treeStatusMap',
                                  value: treeStatusMap.toString());
                              storage.write(
                                  key: 'trees', value: jsonEncode(trees));

                              print(trees);
                            });
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CustomAlertDialog(
                                  title: 'Error',
                                  contentText: 'Failed to fetch trees',
                                  onOkPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            );
                          }
                        } catch (e) {
                          print('Error: $e');
                        }
                      }

                      void onNoPressed() {
                        Navigator.of(context).pop();
                      }

                      showDialog(
                        context: context,
                        builder: (context) {
                          return ConfirmationDialog(
                            contentText: 'Are you sure you want to proceed?',
                            onYesPressed: onYesPressed,
                            onNoPressed: onNoPressed,
                          );
                        },
                      );
                    },
                  ),
                  Text(
                    "Clear\nleaves",
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
              onTap: () {
                // Navigate to the LeavesDetailPage for displaying tree details
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LeavesDetailPage(
                      treeName: treeName,

                      // Pass the status as well to the LeavesDetailPage
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showEditStatusDialog_new(BuildContext context, String treeName) {
    String newStatus =
        treeStatusMap[treeName] ?? ''; // Get the current status of the tree

    showDialog(
      context: context,
      builder: (context) {
        String? selectedStatus = newStatus;

        return AlertDialog(
          title: Text('Edit Tree Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text('Healthy'),
                value: 'Healthy',
                groupValue: selectedStatus,
                onChanged: (value) {
                  setState(() async {
                    selectedStatus = value;
                    treeStatusMap[treeName] =
                        selectedStatus!; // Update selectedStatus inside setState
                    print(treeName);
                    await storage.write(
                        key: 'treeStatusMap', value: treeStatusMap.toString());
                    await storage.write(
                        key: 'length', value: treeStatusMap.length.toString());
                  });
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: Text('Disease Risk'),
                value: 'Disease Risk',
                groupValue: selectedStatus,
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value;
                    treeStatusMap[treeName] =
                        selectedStatus!; // Update selectedStatus inside setState
                    print(treeName);
                    storage.write(
                        key: 'treeStatusMap', value: treeStatusMap.toString());
                    storage.write(
                        key: 'length', value: treeStatusMap.length.toString());
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class LeavesDetailPage extends StatefulWidget {
  final String treeName;

  LeavesDetailPage({required this.treeName});

  @override
  _LeavesDetailPageState createState() => _LeavesDetailPageState();
}

class _LeavesDetailPageState extends State<LeavesDetailPage> {
  List<dynamic> imagesList = [];

  @override
  void initState() {
    super.initState();
    fetchPictures(widget.treeName);
  }

  void fetchPictures(String selectedTreeName) async {
    try {
      final response = await http.get(
        Uri.parse('${Path.globalpath}/picture/${selectedTreeName}'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          imagesList = data;
          // Update the imagesList with fetched data
        });
      } else {
        print('Failed to fetch pictures');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchPicture(String selectedTreeName) async {
    try {
      final response = await http.get(
        Uri.parse('${Path.globalpath}/pictures/${selectedTreeName}'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var imagesList = data as List<dynamic>;
        bool b = false;
        for (int i = 0; i < imagesList.length; i++) {
          if (!isHealthy(imagesList[i]['aiPredictedState']) &&
              imagesList[i]['expertPredictedState'] == '') {
            treeStatusMap[selectedTreeName] = "Sick";
            b = true;
            break;
          }
          if (imagesList[i]['expertPredictedState'] != '' &&
              !isHealthy(imagesList[i]['expertPredictedState'])) {
            treeStatusMap[selectedTreeName] = "Sick";
            b = true;
            break;
          }
        }
        if (b == false) {
          treeStatusMap[selectedTreeName] = 'Healthy';
        }
        print(treeStatusMap);
      } else {
        print('Failed to fetch pictures');
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Error',
              contentText: 'Failed to fetch leaves',
              onOkPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Map<String, String> _deserializeMap(String mapString) {
    final keyValuePairs = mapString
        .substring(1, mapString.length - 1) // Remove curly braces
        .split(', ')
        .map((entry) => entry.split(': '))
        .toList();

    final Map<String, String> resultMap = {};
    for (final pair in keyValuePairs) {
      resultMap[pair[0]] = pair[1];
    }

    return resultMap;
  }

  void deleteImage(List<int> imageBytes) async {
    try {
      // Convert the image bytes to base64 string
      String base64Image = base64Encode(imageBytes);

      // Send the HTTP POST request to the server

      final response = await http.post(
        Uri.parse('${Path.globalpath}/delete-image'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image': base64Image}),
      );

      var responseBody = jsonDecode(response.body);
      print(responseBody);
      print(response.statusCode);

      if (response.statusCode == 200) {
        print('Image deleted successfully');
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Success',
              contentText: 'Leaf deleted successfully',
              onOkPressed: () async {
                fetchPictures(widget.treeName);
                try {
                  final storedMapAsString =
                      await storage.read(key: 'treeStatusMap');
                  if (storedMapAsString != null) {
                    treeStatusMap = _deserializeMap(storedMapAsString);
                  }

                  await fetchPicture(widget.treeName);
                  print("11111");

                  storage.write(
                      key: 'treeStatusMap', value: treeStatusMap.toString());
                  storage.write(
                      key: 'length', value: treeStatusMap.length.toString());

                  setState(() {
                    storage.write(
                        key: 'treeStatusMap', value: treeStatusMap.toString());
                  });
                } catch (e) {
                  print('Error: $e');
                }
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            );
          },
        );
        //run ai model
      } else {
        print('Failed to delete image');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  int levenshteinDistance(String s1, String s2) {
    var m = s1.length;
    var n = s2.length;

    var dp = List.generate(m + 1, (i) => List<int>.filled(n + 1, 0));

    for (var i = 0; i <= m; i++) {
      for (var j = 0; j <= n; j++) {
        if (i == 0) {
          dp[i][j] = j;
        } else if (j == 0) {
          dp[i][j] = i;
        } else if (s1[i - 1] == s2[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          dp[i][j] = 1 +
              [dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]]
                  .reduce((min, e) => e < min ? e : min);
        }
      }
    }

    return dp[m][n];
  }

  bool isHealthy(String input) {
    final target = "Healthy";
    final distance = levenshteinDistance(input, target);
    // You can adjust this threshold value based on your desired similarity level
    final threshold = 3;

    return distance <= threshold;
  }

  Future<void> fetchTrees() async {
    try {
      final storedMapAsString = await storage.read(key: 'treeStatusMap');
      if (storedMapAsString != null) {
        treeStatusMap = _deserializeMap(storedMapAsString);
      }
      if (treeStatusMap[widget.treeName] != "Disease Risk") {
        await fetchPicture(widget.treeName);
        print("111111");
      }

      storage.write(key: 'treeStatusMap', value: treeStatusMap.toString());
      storage.write(key: 'length', value: treeStatusMap.length.toString());

      setState(() {
        storage.write(key: 'treeStatusMap', value: treeStatusMap.toString());
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  // ... Add your implementation for editing tree status and clearing leaves
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            await fetchTrees();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FarmerPage(2)),
            );
            // Custom navigation logic here
          },
        ),
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
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tree Name: ${widget.treeName}',
              style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  fontFamily: "titre"),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: imagesList.length,
                itemBuilder: (context, index) {
                  var imageString = imagesList[index]['image'];
                  var imageBytes = base64Decode(imageString);
                  var status = imagesList[index]['aiPredictedState'];
                  var aiPredictedState = imagesList[index]['aiPredictedState'];
                  var expertPredictedState =
                      imagesList[index]['expertPredictedState'];
                  var expertComment = imagesList[index]['expertComment'];
                  var index1 = index + 1;

                  if (aiPredictedState != "" && expertPredictedState == '') {
                    status = aiPredictedState;
                  }
                  if (expertPredictedState != '' &&
                      !isHealthy(expertPredictedState)) {
                    status = expertPredictedState;
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeafDetailPage(
                            imageBytes: imageBytes,
                            status: status,
                            aiPredictedState: aiPredictedState,
                            expertPredictedState: expertPredictedState,
                            expertComment: expertComment,
                            correspondingTree: widget.treeName,
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
                                SizedBox(height: 8),
                                Text(
                                  'Status: $status',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          // Delete button on the right
                          GestureDetector(
                            onTap: () {
                              void onYesPressed() {
                                deleteImage(imageBytes);
                                fetchPictures(widget.treeName);
                              }

                              void onNoPressed() {
                                Navigator.of(context).pop();
                              }

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return ConfirmationDialog(
                                    contentText:
                                        'Are you sure you want to proceed?',
                                    onYesPressed: onYesPressed,
                                    onNoPressed: onNoPressed,
                                  );
                                },
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color.fromRGBO(164, 15, 15, 0.824),
                              ),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
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

class LeafDetailPage extends StatelessWidget {
  final Uint8List imageBytes;
  final String status;
  final String aiPredictedState;
  final String expertPredictedState;
  final String expertComment;
  final String correspondingTree;

  LeafDetailPage({
    required this.imageBytes,
    required this.status,
    required this.aiPredictedState,
    required this.expertPredictedState,
    required this.expertComment,
    required this.correspondingTree,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Leaf Details",
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
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                imageBytes,
                height: 400,
                width: 400,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'AI Predicted State:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              aiPredictedState,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Expert Predicted State:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              expertPredictedState,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Expert Comment:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              expertComment,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Corresponding Tree:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              correspondingTree,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
