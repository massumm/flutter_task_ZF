import 'package:flutter_fz_task/utils/PopupUtils.dart';
import 'package:get/get.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Parcel.dart';
import '../models/User.dart';

class ApiController extends GetxController {
  var user = User(id: '', fullName: '', phone: '', email: '', token: '').obs;
  var parcels = <Parcel>[].obs;

  Future<void> loginUser(String phone, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://demo.zfcourier.xyz/api/v/1.0.0/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'phone': phone,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        user(User(
          id: responseData['user']['_id'],
          fullName: responseData['user']['fullName'],
          phone: responseData['user']['phone'],
          email: responseData['user']['email'],
          token: responseData['token'],
        ));
        //saving token to sharedpreference
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('auth_token', responseData['token']);
        fetchParcels(responseData['token'], {
        });
        Get.offAllNamed('/home');
      } else {
        PopupUtils.showPopup(json.decode(response.body)['message']);

        throw Exception('Failed to login');
      }
    } catch (e) {
      // Handle errors here
      print(e.toString());
    }
  }

  Future<void> fetchParcels(String token, Map<String, String> queryParams) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String url = 'https://demo.zfcourier.xyz/api/v/1.0.0/parcels';
      if (queryParams != null && queryParams.isNotEmpty) {
        url += '?' + Uri(queryParameters: queryParams).query;
      }

      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'x-auth-token': prefs.getString('auth_token') ?? token,
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        List<Parcel> fetchedParcels = (responseData['content'] as List)
            .map((json) => Parcel(
          id: json['_id'],
          status: json['status'],
          recipientName: json['recipientName'],
          recipientPhone: json['recipientPhone'],
          recipientCity: json['recipientCity'],
          recipientArea: json['recipientArea'],
          recipientAddress: json['recipientAddress'],
          amountToCollect: json['amountToCollect'].toDouble(),
          itemDescription: json['itemDescription'],
          itemQuantity: json['itemQuantity'],
          itemWeight: json['itemWeight'],
        ))
            .toList();
        parcels.assignAll(fetchedParcels);
        print("get all parcel");
      } else {
        PopupUtils.showPopup(json.decode(response.body)['message']);

        throw Exception('Failed to fetch parcels');
      }
    } catch (e) {
      // Handle errors here
      print(e.toString());
    }
  }
  Future<void> createParcel(String token, Map<String, dynamic> parcelData) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse('https://demo.zfcourier.xyz/api/v/1.0.0/parcels/create'),
        headers: <String, String>{
          'x-auth-token': prefs.getString('auth_token') ?? token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(parcelData),
      );

      if (response.statusCode == 200) {
        // Parcel created successfully, you can handle any additional logic here
        print('Parcel created successfully');
      } else {
        PopupUtils.showPopup(json.decode(response.body)['message']);
        throw Exception('Failed to create parcel');
      }
    } catch (e) {
      print(e.toString());
    }
  }

}
