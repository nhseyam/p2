import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Models/address.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddAddress extends StatelessWidget {
  final fromkey = GlobalKey<FormState>();
  final scaffoldkey = GlobalKey<ScaffoldState>();
  final cName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cHomeNumber = TextEditingController();
  final cCity = TextEditingController();
  final cState = TextEditingController();
  final cPinCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldkey,
        appBar: MyAppBar(),
        drawer: MyDrawer(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (fromkey.currentState.validate()) {
              final model = AddressModel(
                      name: cName.text.trim(),
                      state: cState.text.trim(),
                      city: cCity.text.trim(),
                      homeNumber: cHomeNumber.text,
                      phoneNumber: cPhoneNumber.text,
                      pincode: cPinCode.text)
                  .toJson();
              EcommerceApp.firestore
                  .collection(EcommerceApp.collectionUser)
                  .document(EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.userUID))
                  .collection(EcommerceApp.subCollectionAddress)
                  .document(DateTime.now().millisecondsSinceEpoch.toString())
                  .setData(model)
                  .then((value) {
                final snak = SnackBar(content: Text("New address Added"));
                scaffoldkey.currentState.showSnackBar(snak);
                FocusScope.of(context).requestFocus(FocusNode());
                fromkey.currentState.reset();
              });
            }
          },
          label: Text("Done"),
          backgroundColor: Colors.red,
          icon: Icon(Icons.check),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Add New Address",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Form(
                key: fromkey,
                child: Column(
                  children: [
                    MyTextField(hint: "Name", controller: cName),
                    MyTextField(hint: "Phone Number", controller: cPhoneNumber),
                    MyTextField(hint: "HOME NUMBER", controller: cHomeNumber),
                    MyTextField(hint: "State", controller: cState),
                    MyTextField(hint: "City", controller: cCity),
                    MyTextField(hint: "Pin Code", controller: cPinCode),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;

  MyTextField({Key key, this.hint, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (value) => value.isEmpty ? "Field can not be Empty" : null,
      ),
    );
  }
}
