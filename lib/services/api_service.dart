import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'https://www.cebelca.biz/API';

  Future<http.Response> fetchTravelOrders({int page = 0}) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('api_key');

    final String url = '$baseUrl?_r=travelwar&_m=select-all-by&page=$page';

    final Map<String, String> headers = {
      'Authorization': 'Basic ${base64Encode(utf8.encode('$token:x'))}',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: '',
      );
      return response;
    } catch (e) {
      print('Error on making API call: $e');
      rethrow;
    }
  }

  Future<http.Response> fetchEmployees({int page = 0}) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('api_key');

    final String url = '$baseUrl?_r=employee&_m=select-all-by&page=$page';

    final Map<String, String> headers = {
      'Authorization': 'Basic ${base64Encode(utf8.encode('$token:x'))}',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: '',
      );
      return response;
    } catch (e) {
      print('Error on making API call: $e');
      rethrow;
    }
  }

  Future<http.Response> fetchCars({int page = 0}) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('api_key');

    final String url = '$baseUrl?_r=vehicle&_m=select-all-by&page=$page';

    final Map<String, String> headers = {
      'Authorization': 'Basic ${base64Encode(utf8.encode('$token:x'))}',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: '',
      );
      return response;
    } catch (e) {
      print('Error on making API call: $e');
      rethrow;
    }
  }

  Future<http.Response> fetchTravelOrderById(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('api_key');

    final String url =
        '$baseUrl?_f=json-wrap-multi&_r=travelwar&_m=select-one&_r2=travelwar-rel&_m2=select-of&_r3=travelwar-exp&_m3=select-of&_r4=travelwar-day&_m4=select-of&_r5=travelwar-relman&_m5=select-of&_ret=1|2|3|4|5&id_travelwar=$id&id=$id';

    final Map<String, String> headers = {
      'Authorization': 'Basic ${base64Encode(utf8.encode('$token:x'))}',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: '',
      );
      return response;
    } catch (e) {
      print('Error on making API call: $e');
      rethrow;
    }
  }

  Future<http.Response> fetchDocNumber() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('api_key');

    final String url = '$baseUrl?_r=travelwar&_m=get-next-title';

    final Map<String, String> headers = {
      'Authorization': 'Basic ${base64Encode(utf8.encode('$token:x'))}',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: '',
      );
      return response;
    } catch (e) {
      print('Error on making API call: $e');
      rethrow;
    }
  }

  Future<http.Response> newTravelOrder(Map<String, String> bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('api_key');

    final String url = '$baseUrl?_r=travelwar&_m=insert-select';

    final Map<String, String> headers = {
      'Authorization': 'Basic ${base64Encode(utf8.encode('$token:x'))}',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: bodyData,
      );
      return response;
    } catch (e) {
      print('Error on making API call: $e');
      rethrow;
    }
  }

  Future<http.Response> newCost(Map<String, String> bodyData) async {
     final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('api_key');

    final String url = '$baseUrl?_r=travelwar-exp&_m=insert-into&_m2=select-of';

    final Map<String, String> headers = {
      'Authorization': 'Basic ${base64Encode(utf8.encode('$token:x'))}',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: bodyData,
      );
      return response;
    } catch (e) {
      print('Error on making API call: $e');
      rethrow;
    }
  }
}
