import 'dart:convert';

import 'package:emailjs/emailjs.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stage_app/admin/adminhome.dart';
import 'package:stage_app/admin/trees.dart';
import 'package:stage_app/admin/users.dart';
import 'package:stage_app/methods.dart';
import 'package:stage_app/signin.dart';

class FarmerListPage extends StatefulWidget {
  @override
  _FarmerListPageState createState() => _FarmerListPageState();
}

class _FarmerListPageState extends State<FarmerListPage> {
  List<String> farmers = [];
  List<Map<String, dynamic>> expertuncontacted = [];
  List<Map<String, dynamic>> expertcontacted = [];

  @override
  void initState() {
    super.initState();
    fetchFarmers();
    fetchExpertsUncontacted();
    fetchExpertscontacted();
    fetchadmin();
  }

  List<dynamic> adminList = [];

  void fetchadmin() async {
    try {
      var url =
          '${Path.globalpath}/get_admin'; // Replace with your server URL or API endpoint

      var response = await http.get(Uri.parse(url));
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var admin =
            data as List<dynamic>; // Update here to access the array directly

        setState(() {
          adminList = admin;

          print(adminList);
        });
      } else {
        print('failed to get admin email');
      }
    } catch (e) {
      print('Error: $e');
    }
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
                farmer['role'] == 'farmer' && farmer['access'] == false)
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

  Future<void> fetchExpertsUncontacted() async {
    try {
      var url = Path.globalpath + '/get-uncontacted-experts';
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var expertList = data as List<dynamic>;
        var expertData = expertList
            .map<Map<String, dynamic>>((expert) => {
                  'name': expert['name'].toString(),
                  'email': expert['email'].toString(),
                  'phone': expert['phone'].toString(),
                  'linkedin': expert['linkedin'].toString(),
                  'other_contact': expert['other_contact'].toString(),
                })
            .toList();
        setState(() {
          expertuncontacted = expertData;
        });
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Error',
              contentText: 'Failed to fetch expert data.',
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

  void sendWelcomeEmail(String expertEmail, expertname) async {
    try {
      print(expertEmail);
      await EmailJS.send(
        'service_enyog9s',
        'template_4z7ufhu',
        {
          'expert_username': expertname,
          'user_email': expertEmail,
          'admin_email': adminList[0]['email'],
        },
        const Options(
          publicKey: 'fLHQEuMDcSNX2lIB5',
          privateKey: 'Icmh8PoaoTw4h_Kex9_Gx',
        ),
      );
      print('SUCCESS!');
    } catch (error) {
      if (error is EmailJSResponseStatus) {
        print('ERROR... ${error.status}: ${error.text}');
      }
      print(error.toString());
    }
  }

  Future<void> fetchExpertscontacted() async {
    try {
      var url = Path.globalpath + '/get-contacted-experts';
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var expertList = data as List<dynamic>;
        var expertData = expertList
            .map<Map<String, dynamic>>((expert) => {
                  'name': expert['name'].toString(),
                  'email': expert['email'].toString(),
                  'phone': expert['phone'].toString(),
                  'linkedin': expert['linkedin'].toString(),
                  'other_contact': expert['other_contact'].toString(),
                })
            .toList();
        setState(() {
          expertcontacted = expertData;
        });
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Error',
              contentText: 'Failed to fetch contacted expert data.',
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

  Future<void> updateUser(String email, bool access) async {
    final url = Uri.parse(Path.globalpath + '/update-user');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'email': email, 'access': access});

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Success',
              contentText: 'User updated successfully',
              onOkPressed: () {
                press(context, FarmerListPage());
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
              contentText: 'Failed to update user',
              onOkPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialog(
            title: 'Error',
            contentText: 'An error occurred: $error',
            onOkPressed: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
    }
  }

  Future<void> updatecontacted(String email, bool contacted) async {
    final url = Uri.parse(Path.globalpath + '/update-recommandation');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'email': email, 'contacted': contacted});

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Success',
              contentText: 'contacted updated successfully',
              onOkPressed: () {
                press(context, FarmerListPage());
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
              contentText: 'Failed to update user',
              onOkPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialog(
            title: 'Error',
            contentText: 'An error occurred: $error',
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
                press(context, FarmerListPage());
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

  Future<void> droprecommandation(String email) async {
    final String serverUrl = Path.globalpath + '/drop-recommandation';

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
              contentText: 'Recommandation dropped successfully',
              onOkPressed: () {
                press(context, FarmerListPage());
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
              contentText: 'Recommandation not found',
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
              contentText: 'Failed to drop recommandation',
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
          'Notification',
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
                    'Requests',
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
                child: farmers.isEmpty
                    ? /*Container(
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
                      child:*/
                    Text(
                        'No requests',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontFamily: 'ecriture',
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                      ) //,
                    //)
                    /*Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0), // Adjust the padding as needed
                      child: Container(
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
                        child: Text(
                          'No requests',
                          style: TextStyle(
                            fontSize: 22.0,
                            fontFamily: 'ecriture',
                            color: Colors.black,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    )*/
                    : ListView.builder(
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
                                      updateUser(farmers[index], true);
                                    },
                                    child: Icon(Icons.check_circle,
                                        color: AppColors.vertfonce),
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
                                    child: Icon(Icons.delete,
                                        color: AppColors.rougefonce),
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
                    'Uncontacted Expert',
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
                child: expertuncontacted.isEmpty
                    ? Text(
                        'No recommanded expert uncontacted',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontFamily: 'ecriture',
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: expertuncontacted.length,
                        itemBuilder: (context, index) {
                          var expert = expertuncontacted[index];
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
                                  expert['name'],
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
                                      updatecontacted(expert['email'], true);
                                      sendWelcomeEmail(
                                          expert['email'], expert['name']);
                                    },
                                    child: Icon(Icons.check_circle,
                                        color: AppColors.vertfonce),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (mounted) {
                                        // Only proceed if the widget is still mounted
                                        sendWelcomeEmail(
                                            expert['email'], expert['name']);
                                        updatecontacted(expert['email'], true);
                                      }
                                    },
                                    child: Icon(Icons.message,
                                        color:
                                            Color.fromARGB(255, 179, 137, 13)),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                              leading: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      final double dialogRadius = 0.0;
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              dialogRadius),
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.all(20.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Center(
                                                child: Text(
                                                  expert['name'],
                                                  style: TextStyle(
                                                    color: AppColors.vertnormal,
                                                    fontFamily: 'titre',
                                                    fontSize: 26,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 20.0),
                                              if (expert['email'] != '')
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                          'Expert Email: ',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'ecriture',
                                                            fontSize: 22,
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                          expert['email'],
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'ecriture',
                                                            fontSize: 22,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              SizedBox(height: 20.0),
                                              if (expert['phone'] != '')
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                          'Expert Phone: ',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'ecriture',
                                                            fontSize: 22,
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                          expert['phone'],
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'ecriture',
                                                            fontSize: 22,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              SizedBox(height: 20.0),
                                              if (expert['linkedin'] != '')
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                          'Expert Linkedin: ',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'ecriture',
                                                            fontSize: 22,
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                          expert['linkedin'],
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'ecriture',
                                                            fontSize: 22,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              SizedBox(height: 20.0),
                                              if (expert['other_contact'] != '')
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                          'Other Contact: ',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'ecriture',
                                                            fontSize: 22,
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                          expert[
                                                              'other_contact'],
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'ecriture',
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
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      'OK',
                                                      style: TextStyle(
                                                        fontSize: 22.0,
                                                        fontFamily: 'ecriture',
                                                        color: AppColors
                                                            .vertnormal,
                                                        decoration:
                                                            TextDecoration.none,
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
                                child: Icon(Icons.person_3_rounded),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.only(top: 10.0, left: 30.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Contacted Expert',
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
                child: expertcontacted.isEmpty
                    ? Text(
                        'No recommanded expert contacted',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontFamily: 'ecriture',
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: expertcontacted.length,
                        itemBuilder: (context, index) {
                          var expert = expertcontacted[index];
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
                                  expert['name'],
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
                                      void onYesPressed() {
                                        droprecommandation(expert['email']);
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
                                    child: Icon(Icons.delete,
                                        color: AppColors.rougefonce),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                              leading: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      final double dialogRadius = 0.0;
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              dialogRadius),
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.all(20.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Center(
                                                child: Text(
                                                  expert['name'],
                                                  style: TextStyle(
                                                    color: AppColors.vertnormal,
                                                    fontFamily: 'titre',
                                                    fontSize: 26,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 20.0),
                                              if (expert['email'] != '')
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                          'Expert Email: ',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'ecriture',
                                                            fontSize: 22,
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                          expert['email'],
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'ecriture',
                                                            fontSize: 22,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              SizedBox(height: 20.0),
                                              if (expert['phone'] != '')
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                          'Expert Phone: ',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'ecriture',
                                                            fontSize: 22,
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                          expert['phone'],
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'ecriture',
                                                            fontSize: 22,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              SizedBox(height: 20.0),
                                              if (expert['linkedin'] != '')
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                          'Expert Linkedin: ',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'ecriture',
                                                            fontSize: 22,
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                          expert['linkedin'],
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'ecriture',
                                                            fontSize: 22,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              SizedBox(height: 20.0),
                                              if (expert['other_contact'] != '')
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                          'Other Contact: ',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'ecriture',
                                                            fontSize: 22,
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                          expert[
                                                              'other_contact'],
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'ecriture',
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
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      'OK',
                                                      style: TextStyle(
                                                        fontSize: 22.0,
                                                        fontFamily: 'ecriture',
                                                        color: AppColors
                                                            .vertnormal,
                                                        decoration:
                                                            TextDecoration.none,
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
                                child: Icon(Icons.person_3_rounded),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            )
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
                      Icon(Icons.notifications, color: AppColors.vertnormal),
                      Text(
                        "Notification",
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
