import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'package:e_shop/Config/config.dart';

class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
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
            title: Text(
              'E-Shop',
              style: TextStyle(
                  color: Colors.white, fontSize: 30, fontFamily: "Signatra"),
            ),
            centerTitle: true,
            bottom: TabBar(
              tabs: [
                Tab(
                    icon: Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                    text: "Login"),
                Tab(
                    icon: Icon(
                      Icons.perm_contact_cal_outlined,
                      color: Colors.white,
                    ),
                    text: "Register"),
              ],
              indicatorColor: Colors.white38,
              indicatorWeight: 4,
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green[100], Colors.red],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: TabBarView(
              children: [Login(), Register()],
            ),
          ),
        ));
  }
}
