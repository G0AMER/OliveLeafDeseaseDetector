import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:stage_app/admin/adminhome.dart';
import 'package:stage_app/admin/requests.dart';
import 'package:stage_app/admin/trees.dart';
import 'package:stage_app/admin/users.dart';
import 'package:stage_app/farmer/farmertree.dart';
import 'package:stage_app/methods.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class treeedit extends StatefulWidget {
  final String treeName;

  const treeedit({required this.treeName});
  @override
  treeeditpage createState() => treeeditpage();
}

class treeeditpage extends State<treeedit> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController typecontroller = TextEditingController();
  TextEditingController linecontrolleur = TextEditingController();
  TextEditingController columncontrolleur = TextEditingController();

  late Widget champstype;
  late Widget champsname;

  @override
  void initState() {
    super.initState();
    namecontroller.text = widget.treeName;
    champstype = CustomTextField1(
      hintText: 'type',
      obscureText: false,
      controlleur: typecontroller,
    );
    champsname = CustomTextField1(
      hintText: 'Name',
      obscureText: false,
      controlleur: namecontroller,
    );
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

  List<String> trees = [];

  Future<void> fetchtrees() async {
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

        if (treeStatusMap.length != filteredtrees.length) {
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

  Future<void> updateTree(
      String name, Map<String, dynamic> updatedTreeData) async {
    final apiUrl = Path.globalpath + '/updatetree/$name';

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(updatedTreeData),
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Success',
              contentText: 'Tree updated successfully.',
              onOkPressed: () async {
                final storage = FlutterSecureStorage();
                final storedMapAsString =
                    await storage.read(key: 'treeStatusMap');
                print('storedMapAsString : $storedMapAsString');
                if (storedMapAsString != null) {
                  treeStatusMap = _deserializeMap(storedMapAsString);
                }
                print(treeStatusMap);
                String? treeStatus = treeStatusMap[name];
                treeStatusMap[namecontroller.text] = treeStatus!;
                treeStatusMap.remove(name);
                storage.write(
                    key: "treeStatusMap", value: treeStatusMap.toString());
                print(111111);
                press(context, treeadmin());
              },
            );
          },
        );
      } else if (response.statusCode == 404) {
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Error',
              contentText: 'Tree not found.',
              onOkPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Error',
              contentText: 'Error updating tree: ${response.statusCode}.',
              onOkPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialog(
            title: 'Error',
            contentText: 'Error occurred: $e.',
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
        backgroundColor: AppColors.topbar,
        automaticallyImplyLeading: false,
        leading: Container(width: 16),
        iconTheme: IconThemeData(
          color: AppColors.vertnormal,
        ),
        title: Text(
          'Modification',
          style: TextStyle(
            fontSize: 30.0,
            fontFamily: 'titre',
            color: AppColors.vertnormal,
            decoration: TextDecoration.none,
          ),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  press(context, treeadmin());
                },
              ),
              Text(
                'Close',
                style: TextStyle(
                  fontFamily: 'ecriture',
                  fontSize: 16.0,
                  color: AppColors.vertnormal,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 30)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tree Name',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 26.0,
                      fontFamily: 'ecriture',
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                champsname,
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tree Type',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 26.0,
                      fontFamily: 'ecriture',
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                champstype,
                SizedBox(height: 10),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Line',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'ecriture',
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextField(
                        controller: linecontrolleur,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'column',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'ecriture',
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextField(
                        controller: columncontrolleur,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await fetchtrees();
                    updateTree(widget.treeName, {
                      'type': typecontroller.text,
                      'name': namecontroller.text,
                      'line': int.parse(linecontrolleur.text),
                      'column': int.parse(columncontrolleur.text),
                    });
                  },
                  child: Text(
                    'modify',
                    style: TextStyle(
                      fontFamily: 'ecriture',
                      fontSize: 26.0,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.vertclaire,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      side: BorderSide(
                        color: AppColors.vertclaire,
                        width: 1.0,
                      ),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: AppColors.navbar,
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    press(context, Homeadmin());
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.home, color: Colors.grey),
                      Text(
                        "Home",
                        style: TextStyle(
                          fontFamily: 'ecriture',
                          fontSize: Size.navbar,
                          color: Colors.grey,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    press(context, FarmerListPage());
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.notifications, color: Colors.grey),
                      Text(
                        "Notification",
                        style: TextStyle(
                          fontFamily: 'ecriture',
                          fontSize: Size.navbar,
                          color: Colors.grey,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    press(context, Users());
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person, color: Colors.grey),
                      Text(
                        "Users",
                        style: TextStyle(
                          fontFamily: 'ecriture',
                          fontSize: Size.navbar,
                          color: Colors.grey,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    press(context, treeadmin());
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.forest,
                        color: AppColors.vertnormal,
                      ),
                      Text(
                        "Trees",
                        style: TextStyle(
                          fontFamily: 'ecriture',
                          fontSize: Size.navbar,
                          color: AppColors.vertnormal,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
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

class DropdownExample extends StatefulWidget {
  @override
  _DropdownExampleState createState() => _DropdownExampleState();
}

class _DropdownExampleState extends State<DropdownExample> {
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dropdown Example'),
      ),
      body: Container(
        constraints: BoxConstraints(maxHeight: 200.0),
        child: Center(
          child: DropdownButton<String>(
            value: _selectedItem,
            hint: Text('Select an item'),
            onChanged: (String? newValue) {
              setState(() {
                _selectedItem = newValue;
              });
            },
            items: <String>[
              'Item 1',
              'Item 2',
              'Item 3',
              'Item 4',
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class DropdownExample1 extends StatefulWidget {
  @override
  _DropdownExampleState1 createState() => _DropdownExampleState1();
}

class _DropdownExampleState1 extends State<DropdownExample1> {
  String? _selectedItem;

  List<String> _items = [
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Dropdown Example'),
        ),
        body: Container(
          width: 200,
          child: Center(
            child: DropdownButton<String>(
              value: _selectedItem,
              items: _items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedItem = newValue;
                });
              },
            ),
          ),
        ));
  }
}
