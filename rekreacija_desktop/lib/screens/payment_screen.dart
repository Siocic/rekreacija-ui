import 'package:flutter/material.dart';
import 'package:rekreacija_desktop/screens/login.dart';
import 'package:rekreacija_desktop/widgets/content_header.dart';
import 'package:rekreacija_desktop/widgets/payment_card.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: ContentHeader(
            title: 'Payment',
            onLogout: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ),
        const SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: SizedBox(
            width: 600.0,
            height: 750.0,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: 5,
              itemBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: PaymentCard(
                      hallName: 'hallName',
                      date: '12.12.2024',
                      price: '670,00'),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
