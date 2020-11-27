import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminLogin.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _fromkey = GlobalKey<FormState>();
  final TextEditingController _emailtextEditingController =
      TextEditingController();
  final TextEditingController _passwordtextEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width,
        _hight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        height: _hight,
        width: _width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'images/login.png',
                height: 240,
                width: 240,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Logn In To Account',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Form(
              key: _fromkey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _emailtextEditingController,
                    data: (Icons.email),
                    hintText: "Email",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordtextEditingController,
                    data: (Icons.lock),
                    hintText: "Password",
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                _emailtextEditingController.text.isNotEmpty &&
                        _passwordtextEditingController.text.isNotEmpty
                    ? loginUser()
                    : showDialog(
                        context: context,
                        builder: (c) {
                          return ErrorAlertDialog(message: "please fill all");
                        });
              },
              color: Colors.red,
              child: Text(
                "LogIn",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 15),
            FlatButton.icon(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminSignInPage(),
                  )),
              icon: (Icon(
                Icons.admin_panel_settings_outlined,
                color: Colors.white,
              )),
              label: Text(
                'Admin ?',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void loginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(message: 'Authenticating, Please wait..');
        });
    FirebaseUser firebaseUser;
    await _auth
        .signInWithEmailAndPassword(
            email: _emailtextEditingController.text.trim(),
            password: _passwordtextEditingController.text.trim())
        .then((authUser) {
      firebaseUser = authUser.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });
    if (firebaseUser != null) {
      readData(firebaseUser).then((s) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future readData(FirebaseUser fUser) async {
    Firestore.instance
        .collection("users")
        .document(fUser.uid)
        .get()
        .then((dataSnapshot) async {
      await EcommerceApp.sharedPreferences
          .setString("uid", dataSnapshot.data[EcommerceApp.userUID]);
      await EcommerceApp.sharedPreferences
          .setString("email", dataSnapshot.data[EcommerceApp.userEmail]);
      await EcommerceApp.sharedPreferences
          .setString("name", dataSnapshot.data[EcommerceApp.userName]);
      await EcommerceApp.sharedPreferences
          .setString("url", dataSnapshot.data[EcommerceApp.userAvatarUrl]);

      List<String> cartlist =
          dataSnapshot.data[EcommerceApp.userCartList].cast<String>();

      await EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, cartlist);
    });
  }
}
