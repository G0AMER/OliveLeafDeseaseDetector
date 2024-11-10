import 'package:flutter/material.dart';
//import 'package:stage_app/WelcomePage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stage_app/admin/adminhome.dart';
import 'package:stage_app/farmer/farmernavbuttombar.dart';

void press(BuildContext context, Widget destinationPage) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => destinationPage),
  );
}

/*void onSuccess(BuildContext context, String message, String isAdmin) {
  // Navigate to the WelcomePage with the appropriate message and isAdmin value
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => WelcomePage(message, isAdmin: isAdmin)),
  );
}*/

/*void onAdminSuccess(BuildContext context, String message, String isAdmin) {
  // Navigate to the WelcomePage with the appropriate message and isAdmin value
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => WelcomePage(message, isAdmin: isAdmin)),
  );
}*/

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;

  const CustomTextField(
      {Key? key, required this.hintText, required this.obscureText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'ecriture',
          fontSize: 18,
        ),
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
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
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
        ),
      ),
    );
  }
}

class CustomTextField1 extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controlleur;
  const CustomTextField1(
      {Key? key,
      required this.hintText,
      required this.obscureText,
      required this.controlleur})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: controlleur,
        /********/
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'ecriture',
          fontSize: 18,
        ),
        obscureText: obscureText,
        decoration: InputDecoration(
          /********/
          hintText: hintText,
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
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final String contenu;
  final Widget destinationPage;
  void _press(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destinationPage),
    );
  }

  const Button({
    Key? key,
    required this.contenu,
    required this.destinationPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: () => _press(context),
        child: Text(
          contenu,
          style: TextStyle(
            fontFamily: 'ecriture',
            fontSize: 26.0,
            color: Colors.black,
            decoration: TextDecoration.none,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 228, 241, 228),
          onPrimary: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
            side: BorderSide(
              color: Color.fromARGB(255, 228, 241, 228),
              width: 1.0,
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
        ),
      ),
    );
  }
}

final storage = FlutterSecureStorage();
void checkRememberedCredentials(BuildContext context) async {
  String? email = await storage.read(key: 'email');
  String? password = await storage.read(key: 'password');
  String? role = await storage.read(key: 'role');
  if (email != null && password != null && role != null) {
    if (role == 'admin') {
      press(context, Homeadmin());
    } else {
      press(context, FarmerPage(0));
    }
  }
}

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String contentText;
  final VoidCallback onOkPressed;

  CustomAlertDialog({
    required this.title,
    required this.contentText,
    required this.onOkPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 26.0,
          fontFamily: 'titre',
          color: AppColors.vertnormal,
          decoration: TextDecoration.none,
        ),
      ),
      content: Text(
        contentText,
        style: TextStyle(
          fontSize: 22.0,
          fontFamily: 'ecriture',
          color: Colors.black,
          decoration: TextDecoration.none,
        ),
      ),
      actions: [
        TextButton(
          onPressed: onOkPressed,
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
    );
  }
}

//showdialog for confirmation delete
class ConfirmationDialog extends StatelessWidget {
  final String contentText;
  final VoidCallback onYesPressed;
  final VoidCallback onNoPressed;

  ConfirmationDialog({
    required this.contentText,
    required this.onYesPressed,
    required this.onNoPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Confirmation',
        style: TextStyle(
          fontSize: 26.0,
          fontFamily: 'titre',
          color: AppColors.vertnormal,
          decoration: TextDecoration.none,
        ),
      ),
      content: Text(
        contentText,
        style: TextStyle(
          fontSize: 22.0,
          fontFamily: 'ecriture',
          color: Colors.black,
          decoration: TextDecoration.none,
        ),
      ),
      actions: [
        TextButton(
          onPressed: onYesPressed,
          child: Text(
            'Yes',
            style: TextStyle(
              fontSize: 22.0,
              fontFamily: 'ecriture',
              color: AppColors.vertnormal,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        TextButton(
          onPressed: onNoPressed,
          child: Text(
            'No',
            style: TextStyle(
              fontSize: 22.0,
              fontFamily: 'ecriture',
              color: AppColors.rougefonce,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}

//identify colors:
class AppColors {
  static const Color vertclaire = Color(0xFFEAF4F5);
  static const Color navbar = Colors.white /*Color(0xFFEAF4F5)*/;
  static const Color topbar = Colors.white /*Color(0xFFEAF4F5)*/;
  static const Color vertnormal = Color(0xFF349E74);
  static const Color vertfonce = Color(0xFF2B664F);
  static const Color rougefonce = Color(0xFF840000);
  static const Color vertinitial = Color.fromARGB(255, 228, 241, 228);
}

class Path {
  static const String globalpath = 'http://192.168.1.34:3001';
}

class Size {
  static const double navbar = 14;
}

/////////////
bool isEmailValid(String email) {
  print(email);
  // Email regex pattern for basic validation
  final RegExp emailRegex =
      RegExp(r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)*[a-zA-Z]{2,7}$');

  return emailRegex.hasMatch(email);
}

class CustomTextField2 extends StatelessWidget {
  final String hintText;

  /********/
  final bool obscureText;
  final TextEditingController controlleur;
  /*******/

  const CustomTextField2(
      {Key? key,
      required this.hintText,
      required this.obscureText,
      required this.controlleur,
      required String? Function(dynamic value) validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: controlleur,
        /********/
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'ecriture',
          fontSize: 18,
        ),
        obscureText: obscureText,
        decoration: InputDecoration(
          /********/
          hintText: hintText,
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
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
        ),
      ),
    );
  }
}

class CustomTextField13 extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controlleur;
  const CustomTextField13(
      {Key? key,
      required this.hintText,
      required this.obscureText,
      required this.controlleur,
      required String Function(dynamic value) validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: controlleur,
        /********/
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'ecriture',
          fontSize: 18,
        ),
        obscureText: obscureText,
        decoration: InputDecoration(
          /********/
          hintText: hintText,
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
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
        ),
      ),
    );
  }
}
