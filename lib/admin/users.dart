import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:stage_app/admin/adminhome.dart';
import 'package:stage_app/admin/adduser.dart';
import 'package:stage_app/admin/usermodification.dart';
import 'package:stage_app/admin/requests.dart';
import 'package:stage_app/admin/trees.dart';
import 'package:stage_app/methods.dart';
import 'package:stage_app/signin.dart';

class Users extends StatefulWidget {
  @override
  userspage createState() => userspage();
}

class userspage extends State<Users> {
  final Widget add = Button(contenu: '+', destinationPage: formulaire());

  List<String> farmers = [];
  List<String> experts = [];

  @override
  void initState() {
    super.initState();
    fetchFarmers();
    fetchExperts();
  }

  void fetchFarmers() async {
    try {
      var url = Path.globalpath + '/farmers';
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var farmerList = data as List<dynamic>;
        var filteredFarmers = farmerList
            .where((farmer) =>
                farmer['role'] == 'farmer' && farmer['access'] == true)
            .map<String>((farmer) => farmer['email'].toString())
            .toList();

        setState(() {
          farmers = filteredFarmers;
        });
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Failed',
              contentText: 'failed to fetch farmer list',
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
            contentText: 'Error: $e',
            onOkPressed: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
    }
  }

  Future<void> fetchExperts() async {
    try {
      var url = Path.globalpath + '/experts';

      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var expertList = data as List<dynamic>;

        var filteredExperts = expertList
            .where((expert) =>
                expert['role'] == 'expert' && expert['access'] == true)
            .map<String>((expert) => expert['email'].toString())
            .toList();
        setState(() {
          experts = filteredExperts;
        });
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Failed',
              contentText: 'failed to fetch expert list',
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
            contentText: 'Error: $e',
            onOkPressed: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
    }
  }

  Future<void> dropUser(String email) async {
    final String serverUrl = Path.globalpath + '/drop-user';

    try {
      final response = await http.delete(Uri.parse(serverUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'email': email}));

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Success',
              contentText: 'User dropped successfully',
              onOkPressed: () {
                press(context, Users());
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
              contentText: 'User not found',
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
              contentText: 'Failed to drop user',
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
            contentText: 'Error: $e',
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
          'Users',
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
            Container(
              child: Padding(
                padding: EdgeInsets.only(
                    top: 10.0, left: 30.0), // Add space to the top and left
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Experts',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontFamily: 'titre',
                      color: AppColors.vertfonce,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.zero,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 16.0), // Padding from left and right
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: experts.length,
                  itemBuilder: (context, index) {
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
                        title: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 0.0, vertical: 0.0),
                          child: Text(
                            experts[index],
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
                                        Modification(userName: experts[index]),
                                  ),
                                );
                              },
                              child: Icon(Icons.edit),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            GestureDetector(
                              onTap: () {
                                void onYesPressed() {
                                  dropUser(experts[index]);
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
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                        leading: Icon(Icons.person_3_rounded),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.only(top: 10.0, left: 30.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Farmers',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontFamily: 'titre',
                      color: AppColors.vertfonce,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.zero,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: farmers.length,
                  itemBuilder: (context, index) {
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
                        title: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 0.0, vertical: 0.0),
                          child: Text(
                            farmers[index],
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
                                      builder: (context) => Modification(
                                          userName: farmers[index])),
                                );
                              },
                              child: Icon(Icons.edit),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            GestureDetector(
                              onTap: () {
                                void onYesPressed() {
                                  dropUser(farmers[index]);
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
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                        leading: Icon(Icons.person_3_rounded),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => formulaire()),
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
                      Icon(Icons.person, color: AppColors.vertnormal),
                      Text(
                        "Users",
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
                        color: Colors.grey,
                      ),
                      Text(
                        "Trees",
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
            ],
          ),
        ),
      ),
    );
  }
}
