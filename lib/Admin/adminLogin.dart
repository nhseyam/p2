import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';

class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdminSignInScreen(),
    );
  }
}

class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  final GlobalKey<FormState> _fromkey = GlobalKey<FormState>();
  final TextEditingController _adminIdtextEditingController =
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.green[100], Colors.red],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'images/admin.png',
                height: 240,
                width: 240,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'ADMIN',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Form(
              key: _fromkey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _adminIdtextEditingController,
                    data: (Icons.person),
                    hintText: "Admin Id",
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
                _adminIdtextEditingController.text.isNotEmpty &&
                        _passwordtextEditingController.text.isNotEmpty
                    ? loginAdmin()
                    : showDialog(
                        context: context,
                        builder: (c) {
                          return ErrorAlertDialog(message: "please fill all");
                        });
              },
              color: Colors.red,
              child: Text(
                "Access",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  loginAdmin() {
    Firestore.instance.collection('admins').getDocuments().then((snapshot) {
      snapshot.documents.forEach((result) {
        if (result.data['id'] != _adminIdtextEditingController.text.trim()) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Id is not Correct..'),
          ));
        } else if (result.data['password'] !=
            _passwordtextEditingController.text.trim()) {
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text('Password is not Correct..')));
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Wellcome Dear Admin' + result.data['name'])));

          setState(() {
            _adminIdtextEditingController.text = "";
            _passwordtextEditingController.text = "";
          });

          Route route = MaterialPageRoute(builder: (c) => UploadPage());
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }
}
