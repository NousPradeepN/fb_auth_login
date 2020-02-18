import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:fb_auth_login/fb_auth_login.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final FbAuthLogin fbAuthLogin = new FbAuthLogin();
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<Null> _login() async {
    final FacebookLoginResult result = await fbAuthLogin.logIn(['email']);
    switch(result.status){
      case FacebookLoginStatus.loggedIn:
        print('logged in');
        final FacebookAccessToken accessToken = result.accessToken;
        print('Token : ${accessToken.token} \n userId: ${accessToken.userId} \n permissions: ${accessToken.permissions}\n declined permissions: ${accessToken.declinedPermissions} \n expires: ${accessToken.expires}');
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Cancelled by user');
        break;
      case FacebookLoginStatus.error:
        print('error: ${result.errorMessage}');
        break;
    }
  }

  Future<Null> _logOut() async {
    await fbAuthLogin.logOut();
    print("loggedout");
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FbAuthLogin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('Running on: $_platformVersion\n'),
              RaisedButton(
                onPressed: _login,
                child: Text('Log in'),
              ),
              RaisedButton(
                onPressed: _logOut,
                child: Text('Log Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
