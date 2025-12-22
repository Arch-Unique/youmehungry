// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// class CustomPaystackPayment extends StatefulWidget {
//   const CustomPaystackPayment({this.accessCode="",super.key});
//   final String accessCode;

//   @override
//   State<CustomPaystackPayment> createState() => _CustomPaystackPaymentState();
// }

// class _CustomPaystackPaymentState extends State<CustomPaystackPayment> {
//   InAppWebViewSettings settings = InAppWebViewSettings();

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//           body: SafeArea(
//               child: Column(children: <Widget>[
//                 Expanded(
//                   child: InAppWebView(
//                     initialData: InAppWebViewInitialData(data: """
// <!DOCTYPE html>
// <html>

// <head>
//     <!--Let browser know website is optimized for mobile-->
//     <meta name="viewport" content="width=device-width, initial-scale=1.0" />
//     <style>
//         body, html {
//             height: 100%;
//             margin: 0;
//             display: flex;
//             justify-content: center;
//             align-items: center;
//         }

//         .center {
//             display: flex;
//             justify-content: center;
//             align-items: center;
//             height: 100%;
//             width: 100%;
//         }

//         .center-button {
//             padding: 10px 20px;
//             cursor: pointer;
//             color: white;
//             font-size: 1rem;
//     font-weight: 600;
//     border-radius: 4px;
//     /* background: #44b669; */
//     background: linear-gradient(to bottom, #44b669, #40ad57);
//     border: solid 1px #49a861;
//         }
//     </style>
// </head>

// <body>
//     <div class="center">
//         <button class="center-button" onclick="payWithPaystack()">Pay With Paystack</button>
//     </div>
//     <script src="https://js.paystack.co/v2/inline.js"></script>
//     <script>
//         var isFlutterInAppWebViewReady = false;
//         window.addEventListener("flutterInAppWebViewPlatformReady", function(event) {
//           isFlutterInAppWebViewReady = true;
//         });

//         function payWithPaystack() {
//         const popup = new PaystackPop();
//             popup.resumeTransaction('${widget.accessCode}',{ 
                
//                 onSuccess: function (response) {
//                     //here send response to frontend
//                     console.log(response);
//                     if(isFlutterInAppWebViewReady){
//                       window.flutter_inappwebview.callHandler('handleResponse',response);
//                     }
                    
//                 },
//                 onCancel: function () {
//                     //when the user close the payment modal
//                     console.log("Closed");
//                     if(isFlutterInAppWebViewReady){
//                       window.flutter_inappwebview.callHandler('handleCancel',"");
//                     }
                    
//                 }
//             });
//         }
//     </script>
// </body>

// </html>

//                       """),
//                     initialSettings: settings,
//                     onWebViewCreated: (controller) {
//                       controller.addJavaScriptHandler(
//                           handlerName: 'handleCancel',
//                           callback: (args) {
//                             print("very closed");
//                           Navigator.of(context).pop({"status": false, "reference": ""});
                          
//                           });

//                           controller.addJavaScriptHandler(
//                           handlerName: 'handleResponse',
//                           callback: (args) {
//                             Navigator.of(context).pop({"status": true, "reference": args[0]["reference"]});
                          
//                           });
//                     },
//                     onConsoleMessage: (controller, consoleMessage) {
//                       print(consoleMessage);
//                     }, 
//                   ),
//                 ),
//               ]))),
//     );
//   }
// }