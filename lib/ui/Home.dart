import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api_service/AuthController.dart';
import '../models/Parcel.dart';
import 'Parcel_Details.dart';

class HomeScreen extends StatelessWidget {
  final ApiController apiController = Get.find();
  TextEditingController recipientNameController = TextEditingController();
  TextEditingController recipientPhoneController = TextEditingController();
  TextEditingController recipientCityController = TextEditingController();
  TextEditingController amountToCollectController = TextEditingController();

  void _showAddParcelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Parcel'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Recipient Name'),
                controller: recipientNameController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Recipient Phone'),
                controller: recipientPhoneController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Recipient City'),
                controller: recipientCityController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount to Collect'),
                controller: amountToCollectController,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                 apiController.createParcel("", {
                   'recipientName': recipientNameController.text,
                   'recipientPhone': recipientPhoneController.text,
                   'recipientCity': recipientCityController.text,
                   'amountToCollect': double.parse(amountToCollectController.text),

                 });
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parcels'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              onChanged: (value) {
                Map<String, String> queryParams = {
                  'recipientName': value,
                };

                // Call fetchParcels method with the updated query parameters
                apiController.fetchParcels("",queryParams);
                // Implement search functionality here
              },
              decoration: InputDecoration(
                labelText: 'searh the recipent name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (apiController.parcels.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                  itemCount: apiController.parcels.length,
                  itemBuilder: (context, index) {
                    Parcel parcel = apiController.parcels[index];
                    return ListTile(
                      title: Text(parcel.recipientName),
                      subtitle: Text(parcel.recipientPhone),
                      onTap: () {
                        // Navigate to parcel detail screen
                        Get.to(ParcelDetailScreen(parcel: parcel));
                      },
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddParcelDialog(context); // Call function to show add parcel dialog
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
