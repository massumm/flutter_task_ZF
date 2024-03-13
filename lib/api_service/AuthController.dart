
import 'package:get/get.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Constant.dart';
import '../models/Parcel.dart';
import '../models/User.dart';
import '../utils/Utils.dart';

class ApiController extends GetxController {
  var user = User(id: '', fullName: '', phone: '', email: '', token: '').obs;
  var parcels = <Parcel>[].obs;

  Future<void> loginUser(String phone, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
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


      String url = '$baseUrl/parcels';
      if (queryParams != null && queryParams.isNotEmpty) {
        url += '?' + Uri(queryParameters: queryParams).query;
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
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
          recipientArea: json['recipientArea']??"N/A",
          recipientAddress: json['recipientAddress']??"N/A",
          invoice: json['invoice']??"N/A",
          amountToCollect: json['amountToCollect'].toDouble()??"N/A",

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
        Uri.parse('$baseUrl/parcels/create'),
        headers: <String, String>{
          'x-auth-token': prefs.getString('auth_token') ?? token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(parcelData),
      );

      if (response.statusCode == 200) {
        // Parcel created successfully, you can handle any additional logic here
        fetchParcels('', {});
        print('Parcel created successfully');
      } else {
        PopupUtils.showPopup(json.decode(response.body)['message']);
        throw Exception('Failed to create parcel');
      }
    } catch (e) {
      print(e.toString());
    }
  }
  Future<void> updateParcel(String parcelId, Map<String, dynamic> parcelData) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String authToken = prefs.getString('auth_token') ?? "";

      final response = await http.put(
        Uri.parse('$baseUrl/parcels/update/$parcelId'),
        headers: <String, String>{
          'x-auth-token': authToken,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(parcelData),
      );

      if (response.statusCode == 200) {
        print('Parcel updated successfully');
        fetchParcels('', {});
        // Handle success if needed
      } else {
        // Handle error
        PopupUtils.showPopup(json.decode(response.body)['message']);
        print('Failed to update parcel: ${response.body}');
        throw Exception('Failed to update parcel');
      }
    } catch (e) {
      // Handle errors here
      print('Error updating parcel: $e');
      throw Exception('Error updating parcel: $e');
    }
  }

}
