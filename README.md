# fb_auth_login

A new flutter plugin project.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.

For iOS Please follow the [Facebook Login guide](https://developers.facebook.com/docs/facebook-login/ios/?sdk=cocoapods),
for
    1. Select an App or Create a New App in Facebook
    2. Set up Your Development Environment
    3. Register and Configure Your App with Facebook (adding bundle identifier)
    4. Configure Your Project - Configure the information property list file (info.plist) with an XML snippet that contains data about your app.


In Flutter main.dart file
    1. Create an instance
        static final FbAuthLogin fbAuthLogin = new FbAuthLogin();
    2.To Login
        final FacebookLoginResult result = await fbAuthLogin.logIn(['email']);
