import 'package:flutter/material.dart';
import 'package:mighty_link_app/booking_form.dart';

class Booking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: BookingForm()
    );
  }
}
