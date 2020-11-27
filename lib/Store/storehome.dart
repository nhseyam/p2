import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

FirebaseAuth _auth = FirebaseAuth.instance;

class _StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          appBar: MyAppBar(),
          drawer: MyDrawer(),
          body: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                  pinned: false, delegate: SearchBoxDelegate()),
              StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection("Items")
                    .limit(15)
                    .orderBy("publishedDate", descending: true)
                    .snapshots(),
                builder: (context, dataSnapshot) {
                  return !dataSnapshot.hasData
                      ? SliverToBoxAdapter(
                          child: Center(child: circularProgress()))
                      : SliverStaggeredGrid.countBuilder(
                          crossAxisCount: 1,
                          staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                          itemBuilder: (context, index) {
                            ItemModel model = ItemModel.fromJson(
                                dataSnapshot.data.documents[index].data);
                            return sourceInfo(model, context);
                          },
                          itemCount: dataSnapshot.data.documents.length,
                        );
                },
              ),
            ],
          )),
    );
  }
}

Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: () {
      Route route =
          MaterialPageRoute(builder: (c) => ProductPage(itemMOdel: model));
      Navigator.push(context, route);
    },
    splashColor: Colors.redAccent,
    child: Padding(
      padding: EdgeInsets.all(6),
      child: Container(
        height: 140,
        width: width,
        child: Row(
          children: [
            Image.network(
              model.thumbnailUrl,
              width: 140,
              height: 140,
            ),
            SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            model.title,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            model.shortInfo,
                            style:
                                TextStyle(color: Colors.black45, fontSize: 8),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.redAccent,
                        ),
                        height: 30,
                        width: 33,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "50%",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                "off",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 0),
                            child: Row(
                              children: [
                                AutoSizeText(
                                  r"Original Price: $ ",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough),
                                  maxLines: 1,
                                ),
                                AutoSizeText(
                                  (model.price + model.price).toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Row(
                              children: [
                                AutoSizeText(
                                  r"New Price: ",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                  maxLines: 1,
                                ),
                                AutoSizeText(
                                  r'$',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.green),
                                  maxLines: 1,
                                ),
                                AutoSizeText(
                                  (model.price).toString(),
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.green),
                                  maxLines: 1,
                                ),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: removeCartFunction == null
                                        ? IconButton(
                                            icon: Icon(Icons.add_shopping_cart,
                                                color: Colors.black),
                                            onPressed: () {
                                              checkItemInCart(
                                                  model.shortInfo, context);
                                            },
                                          )
                                        : IconButton(
                                            icon: Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () {
                                              removeCartFunction();
                                              Route route = MaterialPageRoute(
                                                  builder: (c) => CartPage());
                                              Navigator.pushReplacement(
                                                  context, route);
                                            },
                                          )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(
                    height: 4,
                    color: Colors.grey,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container(
    height: 15,
    width: width * .34,
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              offset: Offset(0, 5), blurRadius: 10, color: Colors.grey[200])
        ]),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      child: Image.network(
        imgPath,
        height: 15,
        width: width * .34,
        fit: BoxFit.fill,
      ),
    ),
  );
}

void checkItemInCart(String shortIfoasID, BuildContext context) {
  EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList)
          .contains(shortIfoasID)
      ? Fluttertoast.showToast(msg: "Item is alrady in Cart")
      : addItemToCart(shortIfoasID, context);
}

addItemToCart(String shortIfoID, BuildContext context) {
  List tempcartList =
      EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
  tempcartList.add(shortIfoID);

  EcommerceApp.firestore
      .collection(EcommerceApp.collectionUser)
      .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .updateData({EcommerceApp.userCartList: tempcartList}).then((v) {
    Fluttertoast.showToast(msg: "Item Add in Cart");
    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, tempcartList);
    Provider.of<CartItemCounter>(context, listen: false).displayResult();
  });
}
