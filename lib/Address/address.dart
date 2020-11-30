import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Models/address.dart';
import 'package:e_shop/Orders/placeOrder.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/wideButton.dart';
import 'package:e_shop/Counters/changeAddresss.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'addAddress.dart';

class Address extends StatefulWidget {
  final double tatalAmunt;
  const Address({Key key, this.tatalAmunt}) : super(key: key);
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: MyAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(9),
              child: Text(
                "Select Address",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
          Consumer<AddressChanger>(builder: (context, address, c) {
            return Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: EcommerceApp.firestore
                    .collection(EcommerceApp.collectionUser)
                    .document(EcommerceApp.sharedPreferences
                        .getString(EcommerceApp.userUID))
                    .collection(EcommerceApp.subCollectionAddress)
                    .snapshots(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? Center(child: circularProgress())
                      : snapshot.data.documents.length == 0
                          ? noAddressCard()
                          : ListView.builder(
                              itemCount: snapshot.data.documents.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return AddressCard(
                                  currentIndex: address.count,
                                  value: index,
                                  addressId:
                                      snapshot.data.documents[index].documentID,
                                  totalAmount: widget.tatalAmunt,
                                  model: AddressModel.fromJson(
                                      snapshot.data.documents[index].data),
                                );
                              },
                            );
                },
              ),
            );
          })
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Add New Address"),
        backgroundColor: Colors.red,
        icon: Icon(Icons.add_location),
        onPressed: () {
          Route route = MaterialPageRoute(builder: (c) => AddAddress());
          Navigator.pushReplacement(context, route);
        },
      ),
    ));
  }

  noAddressCard() {
    return Card(
      color: Colors.red.withOpacity(0.5),
      child: Container(
        height: 100,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_location, color: Colors.white),
            Text("No shipment Address has been Savad"),
            Text(
                "Please Add Your Shipment Address so that we can deliver product.")
          ],
        ),
      ),
    );
  }
}

class AddressCard extends StatefulWidget {
  final AddressModel model;
  final String addressId;
  final double totalAmount;
  final int currentIndex;
  final int value;

  AddressCard(
      {Key key,
      this.model,
      this.addressId,
      this.currentIndex,
      this.totalAmount,
      this.value})
      : super(key: key);

  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return InkWell(
        onTap: () {
          Provider.of<AddressChanger>(context, listen: false)
              .displayResult(widget.value);
        },
        child: Card(
          color: Colors.grey[200],
          child: Column(
            children: [
              Row(
                children: [
                  Radio(
                    groupValue: widget.currentIndex,
                    value: widget.value,
                    activeColor: Colors.red,
                    onChanged: (val) {
                      Provider.of<AddressChanger>(context, listen: false)
                          .displayResult(val);
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        width: _width * 0.8,
                        child: Table(
                          children: [
                            TableRow(children: [
                              KeyText(msg: "Nane"),
                              Text(widget.model.name),
                            ]),
                            TableRow(children: [
                              KeyText(msg: "Phone Number"),
                              Text(widget.model.phoneNumber),
                            ]),
                            TableRow(children: [
                              KeyText(msg: "Home Number"),
                              Text(widget.model.homeNumber),
                            ]),
                            TableRow(children: [
                              KeyText(msg: "City"),
                              Text(widget.model.city),
                            ]),
                            TableRow(children: [
                              KeyText(msg: "State"),
                              Text(widget.model.state),
                            ]),
                            TableRow(children: [
                              KeyText(msg: "Pin code"),
                              Text(widget.model.pincode),
                            ]),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
              widget.value == Provider.of<AddressChanger>(context).count
                  ? WideButton(
                      message: "Procced",
                      onPressed: () {
                        Route route = MaterialPageRoute(
                            builder: (c) => PaymentPage(
                                  addressId: widget.addressId,
                                  totalAmount: widget.totalAmount,
                                ));
                        Navigator.push(context, route);
                      },
                    )
                  : Container(),
            ],
          ),
        ));
  }
}

class KeyText extends StatelessWidget {
  final String msg;
  KeyText({Key key, this.msg}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(msg,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold));
  }
}
