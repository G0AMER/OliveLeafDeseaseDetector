import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:stage_app/admin/addtree.dart';
import 'package:stage_app/admin/adminhome.dart';
import 'package:stage_app/admin/requests.dart';
import 'package:stage_app/admin/treemodificatio.dart';
import 'package:stage_app/admin/users.dart';
import 'package:stage_app/methods.dart';
import 'package:stage_app/signin.dart';

class treeadmin extends StatefulWidget {
  @override
  treeadminpage createState() => treeadminpage();
}

class treeadminpage extends State<treeadmin> {
  List<Map<String, dynamic>> trees = [];

  @override
  void initState() {
    super.initState();
    fetchTrees();
  }

  Future<void> fetchTrees() async {
    try {
      var url = Path.globalpath + '/viewtrees';
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var treeList = data as List<dynamic>;
        var treeData = treeList
            .map<Map<String, dynamic>>((tree) => {
                  'name': tree['name'].toString(),
                  'type': tree['type'].toString(),
                  'line': tree['line'].toString(),
                  'column': tree['column'].toString(),
                  'id': tree['id'].toString(),
                })
            .toList();
        setState(() {
          trees = treeData;
        });
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Error',
              contentText: 'Failed to fetch tree data.',
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
            contentText: 'An unexpected error occurred.',
            onOkPressed: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
    }
  }

  Future<void> droptree(String name) async {
    final String serverUrl = Path.globalpath + '/drop-tree';

    try {
      final response = await http.delete(Uri.parse(serverUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'name': name}));

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Success',
              contentText: 'tree dropped successfully',
              onOkPressed: () {
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
              contentText: 'tree not found.',
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
              contentText: 'Failed to drop tree.',
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
            contentText: 'Error: $e.',
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
          'Trees',
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
                icon: Icon(Icons.logout),
                onPressed: () {
                  storage.deleteAll();
                  press(context, SignIn());
                },
              ),
              Text(
                'Logout',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(
                  16.0), // Add padding around the ListView.builder
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: trees.length,
                itemBuilder: (context, index) {
                  var tree = trees[index];
                  return Container(
                    padding: EdgeInsets.all(0.0),
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              final double dialogRadius = 0.0;
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(dialogRadius),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Center(
                                        child: Text(
                                          tree['name'],
                                          style: TextStyle(
                                            color: AppColors.vertnormal,
                                            fontFamily: 'titre',
                                            fontSize: 26,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text('Tree Type: ',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'ecriture',
                                                  fontSize: 22,
                                                )),
                                          ),
                                          Expanded(
                                            child: Text(tree['type'],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'ecriture',
                                                  fontSize: 22,
                                                )),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text('Tree Line: ',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'ecriture',
                                                  fontSize: 22,
                                                )),
                                          ),
                                          Expanded(
                                            child: Text(tree['line'],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'ecriture',
                                                  fontSize: 22,
                                                )),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text('Tree Column: ',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'ecriture',
                                                  fontSize: 22,
                                                )),
                                          ),
                                          Expanded(
                                            child: Text(tree['column'],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'ecriture',
                                                  fontSize: 22,
                                                )),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              'OK',
                                              style: TextStyle(
                                                fontSize: 22.0,
                                                fontFamily: 'ecriture',
                                                color: AppColors.vertnormal,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: IconTheme(
                          data: IconThemeData(color: AppColors.vertfonce),
                          child: Icon(Icons.forest),
                        ),
                      ),
                      title: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 0.0),
                        child: Text(
                          tree['name'],
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'ecriture',
                            color: Colors.black,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      treeedit(treeName: tree['name']),
                                ),
                              );
                            },
                            child: Icon(Icons.edit),
                          ),
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              void onYesPressed() {
                                droptree(tree['name']);
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
                            child: Icon(
                              Icons.delete,
                              color: AppColors.rougefonce,
                            ),
                          ),
                          SizedBox(width: 8),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => addtree()),
                  );
                },
                child: Icon(
                  Icons.add_circle_sharp,
                  color: AppColors.vertfonce,
                  size: 30,
                ),
              ),
            ),
          ],
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
