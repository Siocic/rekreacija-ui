import 'package:flutter/material.dart';
import 'package:rekreacija_mobile/models/appointment_insert_model.dart';
import 'package:rekreacija_mobile/screens/cancel_screen.dart';
import 'package:rekreacija_mobile/screens/homepage_screen.dart';
import 'package:rekreacija_mobile/screens/success_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PayPalScreen extends StatefulWidget {
  final AppointmentInsertModel appointmentInsertModel;

  const PayPalScreen({super.key, required this.appointmentInsertModel});

  @override
  State<StatefulWidget> createState() => _PayPalScreenState();
}

class _PayPalScreenState extends State<PayPalScreen> {
  bool isLoading = true;
  late AppointmentInsertModel _appointmentInsertModel;

  final String clientId =
      'ATAJ55wnBPhIHUV95i_H2VB91C6CROlItBnwCis_NGEvbdK-tQopun6BQmy1PEU9uLg-FQrNrg6ZzDIB';
  final String clientSecret =
      'EAsQQHUHSwCZvbiSZn4u29jbx3gHIKGj-7lAbY8c9iGRi47NZHTaXtMLHCF8VgOmkNbUb-FkRb_r6ZD0';
  final String _payPalBaseUrl = 'https://api.sandbox.paypal.com';

  @override
  void initState() {
    super.initState();
    _appointmentInsertModel = widget.appointmentInsertModel;
    startPaymentProcess();
  }

  Future<String> getAccessToken() async {
    final response =
        await http.post(Uri.parse('$_payPalBaseUrl/v1/oauth2/token'),
            headers: {
              'Authorization':
                  'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
              'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'grant_type=client_credentials');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Failed to obtain PayPal access token');
    }
  }

  Future<String> createPayment(String accessToken, double total) async {
    final response = await http.post(
      Uri.parse('$_payPalBaseUrl/v2/checkout/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'intent': 'CAPTURE',
        'purchase_units': [
          {
            'amount': {
              'currency_code': 'EUR',
              'value': total,
            },
          },
        ],
        'application_context': {
          'return_url': 'https://your-success-url.com',
          'cancel_url': 'https://your-cancel-url.com',
        }
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final approvalUrl =
          data['links'].firstWhere((link) => link['rel'] == 'approve')['href'];
      return approvalUrl;
    } else {
      throw Exception('Failed to create PayPal order');
    }
  }

  Future<void> startPaymentProcess() async {
    try {
      final accessToken = await getAccessToken();
      final orderUrl =
          await createPayment(accessToken, _appointmentInsertModel.amount!);
      redirectToPayPal(orderUrl);
    } catch (e) {
      print("Error during PayPal payment process: $e");
    }
  }

  void redirectToPayPal(String approvalUrl) {
    final webViewController = createWebViewController(approvalUrl);

    Navigator.of(context).push(MaterialPageRoute(builder: (builder) {
      return Scaffold(
        body: WebViewWidget(
          controller: webViewController,
        ),
      );
    }));
  }

  WebViewController createWebViewController(String approvalUrl) {
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
            });
          },
          onNavigationRequest: (request) {
            final url = request.url;

            if (url.startsWith('https://your-success-url.com')) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => SuccessPage(
                      appointmentInsertModel: _appointmentInsertModel),
                ),
              );
            }
            if (url.startsWith('https://your-cancel-url.com')) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const CancelScreen(),
                ),
              );
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(approvalUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: (!isLoading)
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const HomePageScreen(),
                        ),
                      );
                    },
                    child: const Text("Go back"),
                  )
                : const Center(child: CircularProgressIndicator()),
          )
        ],
      ),
    );
  }
}
