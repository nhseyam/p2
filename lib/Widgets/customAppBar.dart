import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom, Container flexibleSpace});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.green[100], Colors.red],
              end: const FractionalOffset(0.0, 0.0),
              begin: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
      ),
      centerTitle: true,
      title: Text(
        'E-Shop',
        style: TextStyle(
            color: Colors.white, fontSize: 30, fontFamily: "Signatra"),
      ),
      bottom: bottom,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.red,
              ),
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => CartPage());
                Navigator.pushReplacement(context, route);
              },
            ),
            Stack(
              children: [
                Icon(
                  Icons.brightness_1,
                  size: 20,
                  color: Colors.white,
                ),
                Positioned(
                  top: 3.0,
                  bottom: 4.0,
                  left: 4.0,
                  child: Consumer<CartItemCounter>(
                    builder: (context, counter, _) {
                      return AutoSizeText(
                        (EcommerceApp.sharedPreferences
                                    .getStringList(EcommerceApp.userCartList)
                                    .length -
                                1)
                            .toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontWeight: FontWeight.w400),
                        maxLines: 1,
                      );
                    },
                  ),
                )
              ],
            )
          ],
        )
      ],
    );
  }

  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}
