import 'package:youmehungry/src/global/ui/widgets/others/containers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// Models
class OrderResponse {
  final List<PayPalLink>? links;

  OrderResponse({this.links});

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      links: (json['links'] as List<dynamic>?)
          ?.map((e) => PayPalLink.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  String? getApprovalUrl() {
    return links
        ?.firstWhere(
          (link) => link.rel == 'approve',
          orElse: () => PayPalLink(href: '', rel: ''),
        )
        .href;
  }
}

class PayPalLink {
  final String href;
  final String rel;
  final String? method;

  PayPalLink({required this.href, required this.rel, this.method});

  factory PayPalLink.fromJson(Map<String, dynamic> json) {
    return PayPalLink(
      href: json['href'] as String,
      rel: json['rel'] as String,
      method: json['method'] as String?,
    );
  }
}

class PayPalAmount {
  final String currencyCode;
  final String value;

  PayPalAmount({required this.currencyCode, required this.value});

  factory PayPalAmount.fromJson(Map<String, dynamic> json) {
    return PayPalAmount(
      currencyCode: json['currency_code'] as String,
      value: json['value'] as String,
    );
  }
}

class PayPalPaymentScreen extends StatefulWidget {
  final String link;
  final Function() onPaymentSuccess;
  final Function() onPaymentError;
  final Function()? onPaymentCancelled;

  const PayPalPaymentScreen({
    super.key,
    required this.link,
    required this.onPaymentSuccess,
    required this.onPaymentError,
    this.onPaymentCancelled,
  });

  @override
  State<PayPalPaymentScreen> createState() => _PayPalPaymentScreenState();
}

class _PayPalPaymentScreenState extends State<PayPalPaymentScreen> {
  String? _errorMessage;
  double _progress = 0;

  void _handleUrlChange(String url) {
    // Check if payment was approved
    if (url.contains('success') || url.contains('approved')) {
      Navigator.of(context).pop();
      widget.onPaymentSuccess();
    }
    // Check if payment was cancelled
    else if (url.contains('cancel')) {
      Navigator.of(context).pop();

      widget.onPaymentCancelled!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(title: "Pay With PayPal", child: _buildBody());
  }

  Widget _buildBody() {
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 64),
              const SizedBox(height: 16),
              Text('Error', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      );
    }
    return Stack(
      children: [
        InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(widget.link)),

          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            javaScriptCanOpenWindowsAutomatically: true,
            useOnLoadResource: true,
            useShouldOverrideUrlLoading: true,
            mediaPlaybackRequiresUserGesture: false,
            allowsInlineMediaPlayback: true,
            iframeAllow: "camera; microphone",
            iframeAllowFullscreen: true,
          ),
          // onWebViewCreated: (controller) {
          //   _webViewController = controller;
          // },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            final url = navigationAction.request.url.toString();
            _handleUrlChange(url);
            return NavigationActionPolicy.ALLOW;
          },

          onCreateWindow: (controller, createWindowRequest) async {
            controller.loadUrl(
              urlRequest: URLRequest(url: createWindowRequest.request.url),
            );
            return true;
          },

          onLoadStart: (controller, url) {
            if (url != null) {
              _handleUrlChange(url.toString());
            }
          },
          // onLoadStop: (controller, url) async {
          //   setState(() => _isLoading = false);
          // },
          onProgressChanged: (controller, progress) {
            setState(() {
              _progress = progress / 100;
            });
          },
          onReceivedError: (controller, request, error) {
            setState(() {
              _errorMessage = 'Failed to load PayPal: ${error.description}';
            });
          },
        ),
        if (_progress < 1.0)
          LinearProgressIndicator(
            value: _progress,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
      ],
    );
  }
}
