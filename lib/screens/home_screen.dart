import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:invfox_mtravelorder/screens/order_details_screen.dart';
import 'package:invfox_mtravelorder/helpers/date_utils.dart';
import 'package:invfox_mtravelorder/services/travel_order_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TravelOrderService _travelOrderService = TravelOrderService();
  bool _isLoading = true;
  bool _showFabText = true;

  List<dynamic> _travelOrders = [];
  Map<int, dynamic> _employees = {};
  Map<int, dynamic> _vehicles = {};

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchData();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_showFabText) {
        setState(() {
          _showFabText = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_showFabText) {
        setState(() {
          _showFabText = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Fetch travel orders, employees, and vehicles from API
  Future<void> _fetchData() async {
    try {
      final data = await _travelOrderService.fetchAllData();
      setState(() {
        _travelOrders = data['orders'];
        _employees = data['employees'];
        _vehicles = data['vehicles'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text(
          'Potni nalogi',
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
        centerTitle: true,
        elevation: 2.0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            )
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _travelOrders.length,
                itemBuilder: (context, index) {
                  final order = _travelOrders[index];
                  return GestureDetector(
                    onTap: () {
                      final int orderId = order['id'];
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OrderDetailsScreen(
                            orderId: orderId,
                            editingMode: true,
                          ),
                        ),
                      );
                    },
                    child: _buildTravelOrderCard(order),
                  );
                },
              ),
            ),
      floatingActionButton: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width:
            _showFabText ? 180 : 50, // Adjusts size when text is shown/hidden
        height: 50, // Keeps height consistent
        alignment:
            Alignment.center, 
      // Centers the icon when the button is smaller
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OrderDetailsScreen(
                  editingMode: false,
                ),
              ),
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25), // Ensures a circular shape
          ),
          backgroundColor: Colors.grey,
          label: AnimatedOpacity(
            opacity: _showFabText ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: _showFabText
                ? const Text('Dodaj potni nalog')
                : const SizedBox.shrink(), // Invisible when text is hidden
          ),
          icon: const Icon(
            Icons.add,
            size: 24, // Adjust icon size as needed
          ),
        ),
      ),
    );
  }

  // Widget to display each travel order as a Card
  Widget _buildTravelOrderCard(Map<String, dynamic> order) {
    final int? employeeId1 = order['id_employee'];
    final int? employeeId2 = order['id_employee2'];
    final int? employeeId3 = order['id_employee3'];

    final employee1 = _employees[employeeId1];
    final employee2 = _employees[employeeId2];
    final employee3 = _employees[employeeId3];

    final int? vehicleId = order['id_vehicle'];
    final vehicle = _vehicles[vehicleId];

    List<String> passengers = [];
    if (employee1 != null) passengers.add(employee1['name'] ?? 'N/A');
    // if (employee2 != null) passengers.add(employee2['name'] ?? 'N/A');
    // if (employee3 != null) passengers.add(employee3['name'] ?? 'N/A');

    final double? totalValue = order['total_val'];

    String passengersText =
        passengers.isNotEmpty ? passengers.join(', ') : 'N/A';
    String vehicleName = vehicle != null ? vehicle['regnum'] ?? 'N/A' : 'N/A';

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order['doc_num'] ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.directions_car,
                        color: Colors.blueGrey, size: 18),
                    const SizedBox(width: 5),
                    Text(
                      'Vozilo: $vehicleName',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Text(
                  formatDate(order['date_created']),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.people, color: Colors.blueGrey, size: 18),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    'Voznik: $passengersText',
                    style: const TextStyle(fontSize: 16),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.account_balance_wallet,
                    color: Colors.blueGrey, size: 18),
                const SizedBox(width: 5),
                Text(
                  'Znesek skupaj: $totalValue €',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
