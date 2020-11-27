import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Address/address.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Counters/totalMoney.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double tatalAmunt;
  @override
  void initState() {
    super.initState();
    tatalAmunt = 0;
    Provider.of<TotalAmount>(context, listen: false).display(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (EcommerceApp.sharedPreferences
                  .getStringList(EcommerceApp.userCartList)
                  .length ==
              1) {
            Fluttertoast.showToast(msg: "Cart is Empty");
          } else {
            Route route = MaterialPageRoute(
                builder: (c) => Address(tatalAmunt: tatalAmunt));
            Navigator.pushReplacement(context, route);
          }
        },
        label: Text("Check Out"),
        backgroundColor: Colors.red,
        icon: Icon(Icons.navigate_next_rounded),
      ),
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(
              builder: (context, amountProvider, cartProvider, c) {
                return Padding(
                  padding: EdgeInsets.all(9),
                  child: Center(
                    child: cartProvider.count == 0
                        ? Container()
                        : Text(
                            "Total Price: ${amountProvider.totalAmnt.toString()}",
                            style: TextStyle(fontSize: 20),
                          ),
                  ),
                );
              },
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: EcommerceApp.firestore
                .collection("Items")
                .where("shortInfo",
                    whereIn: EcommerceApp.sharedPreferences
                        .getStringList(EcommerceApp.userCartList))
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : snapshot.data.documents.length == 0
                      ? beginbuildingCartlist()
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            ItemModel model = ItemModel.fromJson(
                                snapshot.data.documents[index].data);
                            if (index == 0) {
                              tatalAmunt = 0;
                              tatalAmunt = model.price + tatalAmunt;
                            } else {
                              tatalAmunt = model.price + tatalAmunt;
                            }
                            if (snapshot.data.documents.length - 1 == index) {
                              WidgetsBinding.instance.addPostFrameCallback((t) {
                                Provider.of<TotalAmount>(context, listen: false)
                                    .display(tatalAmunt);
                              });
                            }
                            return sourceInfo(model, context,
                                removeCartFunction: () =>
                                    removeItemFromUserCart(model.shortInfo));
                          },
                              childCount: snapshot.hasData
                                  ? snapshot.data.documents.length
                                  : 0),
                        );
            },
          )
        ],
      ),
    );
  }

  beginbuildingCartlist() {
    return SliverToBoxAdapter(
      child: Card(
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        child: Container(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.insert_emoticon, color: Colors.white),
              Text("Cart is Empty"),
              Text("Start adding item to your cart")
            ],
          ),
        ),
      ),
    );
  }

  removeItemFromUserCart(String shortInfoAsId) {
    List tempcartList =
        EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
    tempcartList.remove(shortInfoAsId);
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .updateData({EcommerceApp.userCartList: tempcartList}).then((v) {
      Fluttertoast.showToast(msg: "Item Removed");
      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, tempcartList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
      tatalAmunt = 0;
    });
  }
}
