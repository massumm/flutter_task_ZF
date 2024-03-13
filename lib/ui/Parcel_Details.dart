import 'package:flutter/material.dart';

import '../models/Parcel.dart';

class ParcelDetailScreen extends StatelessWidget {
  final Parcel parcel;

  ParcelDetailScreen({required this.parcel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parcel Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Recipient Name: ${parcel.recipientName}'),
            Text('Recipient Phone: ${parcel.recipientPhone}'),
            Text('Recipient Address: ${parcel.recipientCity}'),
            Text('Total ammount: ${parcel.amountToCollect}'),
          ],
        ),
      ),
    );
  }
}
