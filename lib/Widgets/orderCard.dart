import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminOrderCard.dart';
import 'package:e_shop/Orders/OrderDetailsPage.dart';
import 'package:e_shop/Models/item.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';

int counter = 0;

class OrderCard extends StatelessWidget {
  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;
  OrderCard({Key key, this.itemCount, this.data, this.orderID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Route route;
        if (counter == 0) {
          counter = counter + 1;
          route =
              MaterialPageRoute(builder: (c) => OrderDetails(orderID: orderID));
        }
        Navigator.push(context, route);
      },
      child: Container(
        color: Colors.grey[300],
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        height: itemCount * 145.0,
        child: ListView.builder(
          itemCount: itemCount,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (c, index) {
            ItemModel model = ItemModel.fromJson(data[index].data);
            return sourceOrderInfo(model, context);
          },
        ),
      ),
    );
  }
}

Widget sourceOrderInfo(ItemModel model, BuildContext context,
    {Color background}) {
  width = MediaQuery.of(context).size.width;

  return Container(
    color: Colors.grey[100],
    height: 140,
    width: width,
    child: Row(
      children: [
        Image.network(
          model.thumbnailUrl,
          width: 140,
          height: 140,
        ),
        SizedBox(width: 10),
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
                        style: TextStyle(color: Colors.black45, fontSize: 8),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            AutoSizeText(
                              r"Total Price: ",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    ),
  );
}
