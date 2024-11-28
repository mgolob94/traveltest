import 'dart:convert';

import 'package:invfox_mtravelorder/services/api_service.dart';

class TravelOrderService {
  final ApiService _apiService = ApiService();

  // Fetch travel orders
  Future<List<dynamic>> fetchTravelOrders() async {
    try {
      final travelOrdersResponse = await _apiService.fetchTravelOrders();
      return jsonDecode(travelOrdersResponse.body)[0];
    } catch (e) {
      throw Exception('Failed to fetch travel orders: $e');
    }
  }

  // Fetch employees
  Future<Map<int, dynamic>> fetchEmployees() async {
    try {
      final employeesResponse = await _apiService.fetchEmployees();
      final List<dynamic> parsedEmployees = jsonDecode(employeesResponse.body)[0];

      return {
        for (var employee in parsedEmployees)
          int.parse(employee['id'].toString()): employee,
      };
    } catch (e) {
      throw Exception('Failed to fetch employees: $e');
    }
  }

  // Fetch vehicles
  Future<Map<int, dynamic>> fetchVehicles() async {
    try {
      final vehiclesResponse = await _apiService.fetchCars();
      final List<dynamic> parsedVehicles = jsonDecode(vehiclesResponse.body)[0];

      return {
        for (var vehicle in parsedVehicles)
          int.parse(vehicle['id'].toString()): vehicle,
      };
    } catch (e) {
      throw Exception('Failed to fetch vehicles: $e');
    }
  }

  // Fetch all data (travel orders, employees, and vehicles)
  Future<Map<String, dynamic>> fetchAllData() async {
    try {
      final orders = await fetchTravelOrders();
      final employees = await fetchEmployees();
      final vehicles = await fetchVehicles();
      return {
        'orders': orders,
        'employees': employees,
        'vehicles': vehicles,
      };
    } catch (e) {
      throw Exception('Failed to fetch all data: $e');
    }
  }

  // Fetch a specific travel order by ID
  Future<Map<String, dynamic>> fetchTravelOrderById(int orderId) async {
    try {
      final response = await _apiService.fetchTravelOrderById(orderId);
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to fetch travel order by ID: $e');
    }
  }
}
