import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Address/address.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/orderCard.dart';
import 'package:e_shop/Models/address.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

String getOrderId = "";

class OrderDetails extends StatelessWidget {
  final String orderID;
  OrderDetails({Key key, this.orderID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getOrderId = orderID;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: EcommerceApp.firestore
                .collection(EcommerceApp.collectionUser)
                .document(EcommerceApp.sharedPreferences
                    .getString(EcommerceApp.userUID))
                .collection(EcommerceApp.collectionOrders)
                .document(orderID)
                .get(),
            builder: (c, snapshot) {
              Map dataMap;
              if (snapshot.hasData) {
                dataMap = snapshot.data.data;
              }
              return snapshot.hasData
                  ? Container(
                      child: Column(
                        children: [
                          StatusBanner(status: dataMap[EcommerceApp.isSuccess]),
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.all(4),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  "Total Amount" +
                                      dataMap[EcommerceApp.totalAmount]
                                          .toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text("Order ID" + getOrderId,
                                style: TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                                "Order At: " +
                                    DateFormat("dd MMMM,yyyy -hh:mm aa").format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            int.parse(dataMap["orderTime"]))),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                )),
                          ),
                          Divider(height: 2),
                          FutureBuilder<QuerySnapshot>(
                            future: EcommerceApp.firestore
                                .collection("Items")
                                .where("shortInfo",
                                    whereIn: dataMap[EcommerceApp.productID])
                                .getDocuments(),
                            builder: (c, datasnapshot) {
                              return datasnapshot.hasData
                                  ? OrderCard(
                                      itemCount:
                                          datasnapshot.data.documents.length,
                                      data: datasnapshot.data.documents,
                                    )
                                  : Center(
                                      child: circularProgress(),
                                    );
                            },
                          ),
                          Divider(),
                          FutureBuilder<DocumentSnapshot>(
                            future: EcommerceApp.firestore
                                .collection(EcommerceApp.collectionUser)
                                .document(EcommerceApp.sharedPreferences
                                    .getString(EcommerceApp.userUID))
                                .collection(EcommerceApp.subCollectionAddress)
                                .document(dataMap[EcommerceApp.addressID])
                                .get(),
                            builder: (c, snap) {
                              return snap.hasData
                                  ? ShippingDetails(
                                      model:
                                          AddressModel.fromJson(snap.data.data),
                                    )
                                  : Center(
                                      child: circularProgress(),
                                    );
                            },
                          )
                        ],
                      ),
                    )
                  : Center(child: circularProgress());
            },
          ),
        ),
      ),
    );
  }
}

class StatusBanner extends StatelessWidget {
  final bool status;
  StatusBanner({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String msg;
    IconData iconData;
    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? msg = "Successfull" : msg = "Unsuccessful";
    return Container(
      height: 40,
      color: Colors.grey[300],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              SystemNavigator.pop();
            },
            child: Container(
                child: Icon(Icons.arrow_downward), color: Colors.white),
          ),
          SizedBox(width: 20),
          Text(
            "Order Placed " + msg,
            style: TextStyle(color: Colors.blue),
          ),
          SizedBox(
            width: 15,
          ),
          CircleAvatar(
            radius: 12,
            backgroundColor: Colors.green,
            child: Icon(
              iconData,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}

class ShippingDetails extends StatelessWidget {
  final AddressModel model;
  ShippingDetails({Key key, this.model});

  @override
  Widget build(BuildContext context) {
    double scereenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 90, vertical: 5),
          child: Text(
            "Shipment Delails",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          width: scereenWidth * 0.8,
          child: Table(
            children: [
              TableRow(children: [
                KeyText(msg: "Nane"),
                Text(model.name),
              ]),
              TableRow(children: [
                KeyText(msg: "Phone Number"),
                Text(model.phoneNumber),
              ]),
              TableRow(children: [
                KeyText(msg: "Home Number"),
                Text(model.homeNumber),
              ]),
              TableRow(children: [
                KeyText(msg: "City"),
                Text(model.city),
              ]),
              TableRow(children: [
                KeyText(msg: "State"),
                Text(model.state),
              ]),
              TableRow(children: [
                KeyText(msg: "Pin code"),
                Text(model.pincode),
              ]),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: InkWell(
              onTap: () {
                confirmUserItemRecevive(context, getOrderId);
              },
              child: Center(
                child: Container(
                  width: scereenWidth - 40,
                  height: scereenWidth * 0.15,
                  color: Colors.greenAccent,
                  child: Center(
                    child: Text(
                      "Items Received",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  confirmUserItemRecevive(BuildContext context, String morderId) {
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .document(morderId)
        .delete();

    getOrderId = "";

    Route route = MaterialPageRoute(builder: (c) => StoreHome());
    Navigator.pushReplacement(context, route);
    Fluttertoast.showToast(msg: "Order Has been Received. Confirmed");
  }
}
