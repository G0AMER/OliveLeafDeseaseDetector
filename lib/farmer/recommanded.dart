import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stage_app/methods.dart';
import 'package:http/http.dart' as http;

class RecommendPage extends StatefulWidget {
  RecommendPage();

  @override
  _RecommendPageState createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController linkedincontroller = TextEditingController();
  TextEditingController othercontactcontroller = TextEditingController();

  late Widget champsEmail;
  late Widget champsname, champsphone, champslinkedin, champsothercontact;

  @override
  void initState() {
    super.initState();
    champsEmail = TextFormField(
      style: TextStyle(
        color: Colors.black,
        fontFamily: 'ecriture',
        fontSize: 18,
      ),

      decoration: InputDecoration(
        errorStyle: TextStyle(
          fontFamily: 'ecriture',
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
          // Other text style properties
        ),
        /********/
        hintText: "Email",
        hintStyle: TextStyle(
          color: Colors.grey,
          fontFamily: 'ecriture',
          fontSize: 18,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 228, 241, 228),
            width: 1.0,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 228, 241, 228),
            width: 1.0,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 228, 241, 228),
            width: 1.0,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
      ),
      //hintText: 'Email',

      obscureText: false,
      controller: emailcontroller,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter an email address';
        } else if (!isEmailValid(value)) {
          return 'Invalid email format';
        }
        return null;
      },
    );
    champsname = CustomTextField2(
      hintText: 'Name',
      obscureText: false,
      controlleur: namecontroller,
      validator: (value) {
        namecontroller.text;
        return '';
      },
    );
    champsphone = CustomTextField2(
      hintText: 'Phone',
      obscureText: false,
      controlleur: phonecontroller,
      validator: (value) {
        phonecontroller.text;
        return '';
      },
    );
    champslinkedin = CustomTextField2(
      hintText: 'LinkedIn',
      obscureText: false,
      controlleur: linkedincontroller,
      validator: (value) {
        linkedincontroller.text;
        return '';
      },
    );
    champsothercontact = CustomTextField2(
      hintText: 'Contact',
      obscureText: false,
      controlleur: othercontactcontroller,
      validator: (value) {
        othercontactcontroller.text;
        return '';
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isEmailValid(String email) {
      print(email);
      // Email regex pattern for basic validation
      final RegExp emailRegex =
          RegExp(r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)*[a-zA-Z]{2,7}$');

      return emailRegex.hasMatch(email);
    }

    void RequestExpert(BuildContext context) async {
      String name = namecontroller.text;
      String email = emailcontroller.text;
      String phone = phonecontroller.text;
      String linkedin = linkedincontroller.text;
      String othercontact = othercontactcontroller.text;

      var url =
          Path.globalpath + '/add-recexpert'; // Replace with your server URL

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
          'linkedin': linkedin,
          'other_contact': othercontact,
          'access': false
        }),
      );

      if ((response.statusCode == 200 || response.statusCode == 201)) {
        // expert request successful
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Expert Requested',
              contentText: 'Thank you for your recommendation',
              onOkPressed: () {
                Navigator.pop(context);
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
              title: 'Expert Requesting Failed',
              contentText: 'Failed to request a new expert',
              onOkPressed: () {
                Navigator.pop(context);
              },
            );
          },
        );
      }
    }

    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(46),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recommend An Expert',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'titre',
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            SizedBox(height: 40),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'If you want to recommend an expert, fill in this form with the expert credentials.',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 17.0,
                  fontFamily: 'ecriture',
                  color: Colors.grey,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            SizedBox(height: 40),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Username',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 23.0,
                  fontFamily: 'ecriture',
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            champsname,
            SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Email Address',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 23.0,
                  fontFamily: 'ecriture',
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            champsEmail,
            SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Phone Number',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 23.0,
                  fontFamily: 'ecriture',
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            champsphone,
            SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'LinkedIn Account',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 23.0,
                  fontFamily: 'ecriture',
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            champslinkedin,
            SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Other Contact',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 23.0,
                  fontFamily: 'ecriture',
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            champsothercontact,
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (emailcontroller.text.trim().isNotEmpty &&
                    namecontroller.text.trim().isNotEmpty) {
                  if (!isEmailValid(emailcontroller.text)) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CustomAlertDialog(
                          title: 'Obligation',
                          contentText: 'This form of email is not available.',
                          onOkPressed: () {
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    );
                  } else {
                    RequestExpert(context);
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CustomAlertDialog(
                        title: 'Required Fields',
                        contentText:
                            'You must give at least the username and the email. ',
                        onOkPressed: () {
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );
                }
              },
              child: Text(
                'Recommend Expert',
                style: TextStyle(
                  fontFamily: 'ecriture',
                  fontSize: 23.0,
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
                padding: EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 24.0,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
