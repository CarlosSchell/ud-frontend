// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// You need the url_launcher https://pub.dev/packages/url_launcher. Import the package in you're yaml and then in your .dart

// Then use the launch function with the WhatsApp URL: launch('whatsapp://send?phone=$phonenumber')

// For the launching the WhatsApp Website use launch('https://web.whatsapp.com')

// // https://pub.dev/packages/url_launcher

// https://stackoverflow.com/questions/60947937/flutter-open-whatsapp-with-text-message

// const url = "https://wa.me/?text=YourTextHere";  // use universal strings// 

// encode message as url
// const url = "https://wa.me/?text=Your Message here";
// var encoded = Uri.encodeFull(url);

// https://pub.dev/packages/getwidget/example

// whastapp scheme

// const url = "whatsapp://send?text=Hello World!"

// _launchWhatsapp() async {
//   const url = "https://wa.me/?text=Hey buddy, try this super cool new app!";
//   if (await canLaunch(url)) {
//     await launch(url);
//   } else {
//     throw 'Could not launch $url';
//   }
// }

// const _url = 'https://flutter.dev';

// void main() => runApp(
//       const MaterialApp(
//         home: Material(
//           child: Center(
//             child: RaisedButton(
//               onPressed: _launchURL,
//               child: Text('Show Flutter homepage'),
//             ),
//           ),
//         ),
//       ),
//     );

// void _launchURL() async =>
//     await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';


// Android 
// Starting from API 30 Android requires package visibility configuration in your AndroidManifest.xml otherwise canLaunch will return false. A <queries> element must be added to your manifest as a child of the root element.

// The snippet below shows an example for an application that uses https, tel, and mailto URLs with url_launcher. See the Android documentation for examples of other queries.

// <queries>
//   <!-- If your app opens https URLs -->
//   <intent>
//     <action android:name="android.intent.action.VIEW" />
//     <data android:scheme="https" />
//   </intent>
//   <!-- If your app makes calls -->
//   <intent>
//     <action android:name="android.intent.action.DIAL" />
//     <data android:scheme="tel" />
//   </intent>
//   <!-- If your app emails -->
//   <intent>
//     <action android:name="android.intent.action.SEND" />
//     <data android:mimeType="*/*" />
//   </intent>
// </queries>