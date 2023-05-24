import 'package:flutter/material.dart';
import 'package:touriso/screens/shared/page_layout.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Booking',
      body: Center(child: Text('this is the booking page')),
    );
  }
}
