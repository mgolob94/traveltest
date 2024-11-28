import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:invfox_mtravelorder/services/api_service.dart';
import 'package:invfox_mtravelorder/services/travel_order_service.dart';
import 'package:invfox_mtravelorder/widgets.dart';

class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({super.key});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final TravelOrderService _travelOrderService = TravelOrderService();
  final ApiService _apiService = ApiService();

  TextEditingController docNumController = TextEditingController();
  TextEditingController dateCreatedController = TextEditingController();
  TextEditingController vehicleController = TextEditingController();
  TextEditingController prepaymentController = TextEditingController();
  TextEditingController km1Controller = TextEditingController();
  TextEditingController datetimeStartController = TextEditingController();
  TextEditingController datetimeEndController = TextEditingController();

  int? selectedDriverId;
  int? selectedApprovedById;
  int? selectedPassengerId;

  Map<int, dynamic>? employees;
  Map<int, dynamic>? vehicles;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  Future<void> _initializeForm() async {
    try {
      final allData = await _travelOrderService.fetchAllData();
      setState(() {
        employees = allData['employees'];
        vehicles = allData['vehicles'];
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchDocNumber() async {
    final docNumberResponse = await _apiService.fetchDocNumber();
    final parsedResponse = jsonDecode(docNumberResponse.body);
    final docNumber = parsedResponse[0][0]['max_title'];

    docNumController.text = docNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Dodaj potni nalog', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Potni nalog št.',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                        ),
                        ElevatedButton(
                          onPressed: _fetchDocNumber,
                          child: const Text("Pridobi"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Card(
                    color: Colors.white,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: docNumController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  buildDateTimePickerField(context, 'Datum izdaje', dateCreatedController),
                  buildEmployeeSection(),
                  buildLabeledCard('Predujem', prepaymentController, false),
                  buildLabeledCard('Začetno stanje km', km1Controller,false),
                  buildDateTimePickerField(context, 'Čas pričetka', datetimeStartController),
                  buildDateTimePickerField(context, 'Čas konca', datetimeEndController),
                ],
              ),
            ),
    );
  }

  Widget buildEmployeeSection() {
    if (employees == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabeledSelectionCard(
          'Voznik',
          DropdownButtonFormField<int>(
            value: selectedDriverId,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            items: employees!.entries.map((entry) {
              return DropdownMenuItem<int>(
                value: entry.key,
                child: Text(entry.value['name']),
              );
            }).toList(),
            onChanged: (int? newValue) {
              setState(() {
                selectedDriverId = newValue;
              });
            },
          ),
        ),
        const SizedBox(height: 2),
        buildLabeledSelectionCard(
          'Sopotnik',
          DropdownButtonFormField<int>(
            value: selectedPassengerId,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            items: employees!.entries.map((entry) {
              return DropdownMenuItem<int>(
                value: entry.key,
                child: Text(entry.value['name']),
              );
            }).toList(),
            onChanged: (int? newValue) {
              setState(() {
                selectedPassengerId = newValue;
              });
            },
          ),
        ),
        const SizedBox(height: 2),
        buildLabeledSelectionCard(
          'Odobril',
          DropdownButtonFormField<int>(
            value: selectedApprovedById,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            items: employees!.entries.map((entry) {
              return DropdownMenuItem<int>(
                value: entry.key,
                child: Text(entry.value['name']),
              );
            }).toList(),
            onChanged: (int? newValue) {
              setState(() {
                selectedApprovedById = newValue;
              });
            },
          ),
        ),
        const SizedBox(height: 2),
        buildLabeledCard('Vozilo', vehicleController, false),
      ],
    );
  }
}
