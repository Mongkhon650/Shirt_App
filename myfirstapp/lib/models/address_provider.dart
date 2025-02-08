import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myfirstapp/utils/config.dart';


class Address {
  final int id;
  final String name;
  final String subDistrict;
  final String district;
  final String province;
  final String postalCode;
  final String phone;

  Address({
    required this.id,
    required this.name,
    required this.subDistrict,
    required this.district,
    required this.province,
    required this.postalCode,
    required this.phone,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['address_id'],
      name: json['name'] ?? '',
      subDistrict: json['sub_district'] ?? '',
      district: json['district'] ?? '',
      province: json['province'] ?? '',
      postalCode: json['postal_code'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}



class AddressProvider with ChangeNotifier {
  List<Address> _addresses = [];
  int? _selectedAddressIndex;

  List<Address> get addresses => _addresses;
  int? get selectedAddressIndex => _selectedAddressIndex;

  Future<void> fetchAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null || userId == 0) {
      print("User ID not found in SharedPreferences.");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse("${AppConfig.baseUrl}/api/addresses?user_id=$userId"),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          _addresses = data.map((item) => Address.fromJson(item)).toList();
        } else {
          _addresses = [];
        }
        notifyListeners();
      } else {
        print("Failed to fetch addresses: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error fetching addresses: $e");
    }
  }


  void toggleSelection(int index) {
    _selectedAddressIndex = index;
    notifyListeners();
  }

  Future<void> removeAddress(int index) async {
    if (index < 0 || index >= _addresses.length) return; // ป้องกัน index ผิดพลาด

    final addressId = _addresses[index].id; // ต้องเพิ่ม field id ใน Address class
    final response = await http.delete(
      Uri.parse("${AppConfig.baseUrl}/api/addresses/$addressId"),
    );

    if (response.statusCode == 200) {
      _addresses.removeAt(index);
      notifyListeners();
    } else {
      print("Failed to delete address: ${response.body}");
    }
  }

}