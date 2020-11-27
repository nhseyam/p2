import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  bool get wantKeepAlive => true;

  File file;
  TextEditingController _descriptionTextController = TextEditingController();
  TextEditingController _priceTextController = TextEditingController();
  TextEditingController _titleTextController = TextEditingController();
  TextEditingController _shortInfoTextController = TextEditingController();
  String productId = DateTime.now().microsecondsSinceEpoch.toString();
  bool uploding = false;

  @override
  Widget build(BuildContext context) {
    return file == null ? displayAdminHomeSceren() : displayAdminFromSceren();
  }

  displayAdminHomeSceren() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.green[100], Colors.red],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.border_color),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
            Navigator.pushReplacement(context, route);
          },
        ),
        actions: [
          FlatButton(
            child: Text(
              "Log Out",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => SplashScreen());
              Navigator.pushReplacement(context, route);
            },
          ),
        ],
      ),
      body: getAdminHomeScrenBody(),
    );
  }

  getAdminHomeScrenBody() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.green[100], Colors.red],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shop_two,
              color: Colors.white,
              size: 200,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9)),
                child: Text(
                  'Add New Item',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                color: Colors.green,
                onPressed: () {
                  takeImage(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: Text(
              "Item Image",
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                child: Text("Capture with camara",
                    style: TextStyle(color: Colors.green)),
                onPressed: () {
                  capturephptowithcarema();
                },
              ),
              SimpleDialogOption(
                child: Text("Select form galary",
                    style: TextStyle(color: Colors.green)),
                onPressed: () {
                  selectwithgalary();
                },
              ),
              SimpleDialogOption(
                child: Text("Cancel", style: TextStyle(color: Colors.green)),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  capturephptowithcarema() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 680, maxWidth: 970);
    setState(() {
      file = imageFile;
    });
  }

  selectwithgalary() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 680, maxWidth: 970);
    setState(() {
      file = imageFile;
    });
  }

  displayAdminFromSceren() {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Product'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.green[100], Colors.red],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            clearFromInfo();
            Navigator.pop(context);
          },
        ),
        actions: [
          FlatButton(
            child: Text(
              "Add",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: uploding ? null : () => uploadImageAndSaveItemInfo(),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploding ? circularProgress() : Text(''),
          Container(
            height: 232,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(file), fit: BoxFit.cover))),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 12)),
          ListTile(
            leading: Icon(Icons.info),
            title: Container(
              width: 250,
              child: TextField(
                controller: _shortInfoTextController,
                decoration: InputDecoration(
                    hintText: "Short Info", border: InputBorder.none),
              ),
            ),
          ),
          Divider(
            color: Colors.black45,
          ),
          ListTile(
            leading: Icon(Icons.title),
            title: Container(
              width: 250,
              child: TextField(
                controller: _titleTextController,
                decoration: InputDecoration(
                    hintText: "Title", border: InputBorder.none),
              ),
            ),
          ),
          Divider(
            color: Colors.black45,
          ),
          ListTile(
            leading: Icon(Icons.disc_full_outlined),
            title: Container(
              width: 250,
              child: TextField(
                controller: _descriptionTextController,
                decoration: InputDecoration(
                    hintText: "DescripTion", border: InputBorder.none),
              ),
            ),
          ),
          Divider(
            color: Colors.black45,
          ),
          ListTile(
            leading: Icon(Icons.money),
            title: Container(
              width: 250,
              child: TextField(
                controller: _priceTextController,
                decoration: InputDecoration(
                    hintText: "Price", border: InputBorder.none),
                keyboardType: TextInputType.number,
              ),
            ),
          ),
          Divider(
            color: Colors.black45,
          )
        ],
      ),
    );
  }

  clearFromInfo() {
    setState(() {
      file == null;
      _descriptionTextController.clear();
      _priceTextController.clear();
      _shortInfoTextController.clear();
      _titleTextController.clear();
    });
  }

  uploadImageAndSaveItemInfo() async {
    setState(() {
      uploding = true;
    });
    String imageDownloadUrl = await uploadItemImage(file);

    saveItemInfo(imageDownloadUrl);
  }

  Future<String> uploadItemImage(mFileImage) async {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child("Items");
    StorageUploadTask uploadTask =
        storageReference.child("product_$productId.jpg").putFile(mFileImage);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveItemInfo(String downloadUrl) {
    final itemRef = Firestore.instance.collection('Items');
    itemRef.document(productId).setData({
      "shortInfo": _shortInfoTextController.text.trim(),
      "longDescription": _descriptionTextController.text.trim(),
      "price": int.parse(_priceTextController.text),
      "publishedDate": DateTime.now(),
      "thumbnailUrl": downloadUrl,
      "status": "Available",
      "title": _titleTextController.text.trim(),
    });
    setState(() {
      file = null;
      uploding = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _descriptionTextController.clear();
      _titleTextController.clear();
      _shortInfoTextController.clear();
      _priceTextController.clear();
    });
  }
}
