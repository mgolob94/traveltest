import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:invfox_mtravelorder/services/api_service.dart';
import 'package:invfox_mtravelorder/services/travel_order_service.dart';
import 'package:invfox_mtravelorder/widgets.dart';
import 'package:invfox_mtravelorder/helpers/helpers.dart';

class OrderDetailsScreen extends StatefulWidget {
  int? orderId;
  bool editingMode;
  OrderDetailsScreen({super.key, this.orderId, required this.editingMode});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  List<dynamic>? orderHeader;
  List<dynamic>? expenseDetails;
  List<dynamic>? diares;
  Map<int, dynamic>? employees;
  Map<int, dynamic>? vehicles;
  bool isLoading = true;

  final TravelOrderService _travelOrderService = TravelOrderService();
  final ApiService _apiService = ApiService();

  //Potni nalog
  TextEditingController docNumController = TextEditingController();
  TextEditingController dateCreatedController = TextEditingController();
  TextEditingController vehicleController = TextEditingController();
  TextEditingController prepaymentController = TextEditingController();
  TextEditingController km1Controller = TextEditingController();
  TextEditingController datetimeStartController = TextEditingController();
  TextEditingController datetimeEndController = TextEditingController();

  //Stroški
  TextEditingController dateCostCreatedController = TextEditingController();
  TextEditingController descriptionCostController = TextEditingController();
  TextEditingController amountCostController = TextEditingController();

  int? selectedDriverId;
  int? selectedApprovedById;
  int? selectedPassengerId;

  @override
  void initState() {
    if (!widget.editingMode) {
      _clearAllFields();

      _fetchAllData();
    }
    super.initState();
    if (widget.editingMode && widget.orderId != null) {
      _fetchOrderDetails();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _clearAllFields() {
    docNumController.clear();
    dateCreatedController.clear();
    vehicleController.clear();
    prepaymentController.clear();
    km1Controller.clear();
    datetimeStartController.clear();
    datetimeEndController.clear();
    selectedDriverId = null;
    selectedApprovedById = null;
    selectedPassengerId = null;
    orderHeader = null;
    expenseDetails = null;
    diares = null;
  }

  Future<void> _fetchOrderDetails() async {
    await _fetchAllData();

    try {
      final travelOrderResponse =
          await _apiService.fetchTravelOrderById(widget.orderId!);
      final parsedResponse = jsonDecode(travelOrderResponse.body);
      print(parsedResponse);

      final allData = await _travelOrderService.fetchAllData();
      setState(() {
        orderHeader = parsedResponse[0][0];
        expenseDetails = parsedResponse[0][2];
        diares = parsedResponse[0][3];
        employees = allData['employees'];
        vehicles = allData['vehicles'];
        print(vehicles);
        isLoading = false;
        print(vehicles?[orderHeader![0]['id_vehicle']]?['regnum']);
        docNumController.text = orderHeader![0]["doc_num"] ?? '';
        dateCreatedController.text =
            formatDate(orderHeader![0]["date_created"]);
        selectedDriverId = orderHeader![0]['id_employee'];
        selectedApprovedById = orderHeader![0]['id_employee3'];
        selectedPassengerId = orderHeader![0]['id_employee2'];
        vehicleController.text =
            vehicles?[orderHeader![0]['id_vehicle']]?['regnum'] ?? 'N/A';
        prepaymentController.text = orderHeader![0]["prepayment"].toString();
        km1Controller.text = orderHeader![0]["km1"].toString();
        datetimeStartController.text =
            formatDateTime(orderHeader![0]["datetime_start"]);
        datetimeEndController.text =
            formatDateTime(orderHeader![0]["datetime_end"]);
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchAllData() async {
    try {
      final allData = await _travelOrderService.fetchAllData();
      setState(() {
        employees = allData['employees'];
        vehicles = allData['vehicles'];
      });
    } catch (e) {
      setState(() {
        employees = null;
        vehicles = null;
      });
    }
  }

  Future<void> _fetchDocNumber() async {
    final docNumberResponse = await _apiService.fetchDocNumber();
    final parsedResponse = jsonDecode(docNumberResponse.body);
    final docNumber = parsedResponse[0][0]['max_title'];

    docNumController.text = docNumber;
  }

  Future<void> _saveNewTravelOrder() async {
    final Map<String, String> bodyData = {
      'id': '',
      'id_travelwar_temp': '94211000480326',
      'id_travelwar': '0',
      'doc_num': docNumController.text,
      'date_created': dateCreatedController.text,
      'prepayment': prepaymentController.text,
      'datetime_start': datetimeStartController.text,
      'datetime_end': datetimeEndController.text,
      'km1': km1Controller.text,
      'id_employee':
          selectedDriverId != null ? selectedDriverId.toString() : '',
      'id_employee2':
          selectedPassengerId != null ? selectedPassengerId.toString() : '',
      'id_employee3':
          selectedApprovedById != null ? selectedApprovedById.toString() : '',
      'id_vehicle':
          vehicleController.text.isNotEmpty ? vehicleController.text : '',
    };

    try {
      final response = await _apiService.newTravelOrder(bodyData);
      if (response.statusCode == 200) {
        print(response.body); // Print raw response
        final parsedResponse = jsonDecode(response.body);
        print(parsedResponse.runtimeType); // Print the type of parsedResponse
        print(parsedResponse);

        // Check if parsedResponse is a list and the first element is also a list
        if (parsedResponse is List && parsedResponse.isNotEmpty) {
          if (parsedResponse[0] is List && parsedResponse[0].isNotEmpty) {
            final newOrderId =
                parsedResponse[0][0]['id']; // Access the nested 'id'

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Potni nalog uspešno shranjen.')),
            );

            // Set editing mode to true and fetch new order details
            setState(() {
              widget.orderId = newOrderId; // Set the new order ID
              widget.editingMode = true;
              orderHeader =
                  null; // Reset orderHeader to trigger fetching updated data
              isLoading = true;
            });
            await _fetchOrderDetails();
          } else {
            print('Parsed response[0] is not a List or is empty.');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Napaka pri shranjevanju potnega naloga.')),
            );
          }
        } else {
          print('Parsed response is not a List or is empty.');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Napaka pri shranjevanju potnega naloga.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Napaka pri shranjevanju potnega naloga.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Napaka: $e')),
      );
    }
  }

  Future<void> _addExpense() async {
    final Map<String, String> bodyData = {
      'id_travelwar': widget.orderId.toString(),
      'date_of': dateCostCreatedController.text,
      'descr': descriptionCostController.text,
      'amount': amountCostController.text,
    };

    try {
      final response = await _apiService.newCost(bodyData);
      if (response.statusCode == 200) {
        print(response.body); // Print raw response

        _fetchOrderDetails();

        setState(() {
          dateCostCreatedController.clear();
          descriptionCostController.clear();
          amountCostController.clear();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Napaka: $e')),
      );
    }
  }

  Future<void> _addDaily() async {
    final Map<String, String> bodyData = {
      'id_travelwar': widget.orderId.toString(),
      'date_of': dateCostCreatedController.text,
      'descr': descriptionCostController.text,
      'amount': amountCostController.text,
    };

    try {
      final response = await _apiService.newCost(bodyData);
      if (response.statusCode == 200) {
        print(response.body); // Print raw response

        _fetchOrderDetails();

        setState(() {
          dateCostCreatedController.clear();
          descriptionCostController.clear();
          amountCostController.clear();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Napaka: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Podrobnosti potnega naloga',
              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Potni nalog"),
              Tab(text: "Stroški"),
              Tab(text: "Dnevnice"),
            ],
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                color: Colors.grey[50],
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.editingMode) buildOrderDetails(),
                          if (!widget.editingMode)
                            Column(
                              children: [
                                buildOrderForm(),
                                ElevatedButton(
                                  onPressed: () async {
                                    await _fetchDocNumber();
                                    await _saveNewTravelOrder();
                                  },
                                  child: const Text("Shrani"),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    if (orderHeader != null)
                      SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: buildExpensesForm(),
                      )
                    else
                      const Center(
                        child:
                            Text('Shrani potni nalog za dodajanje stroškov.'),
                      ),
                    if (orderHeader != null)
                      SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: buildTravelDayForm(),
                      )
                    else
                      const Center(
                        child: Text('Shrani potni nalog za dodajanje dnevnic.'),
                      ),
                  ],
                ),
              ),
        floatingActionButton: widget.editingMode
            ? FloatingActionButton(
                onPressed: () {
                  // Add functionality for saving or performing actions here
                },
                child: const Icon(Icons.save),
              )
            : null,
      ),
    );
  }

  Widget buildOrderDetails() {
    return Column(
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
        buildDateTimePickerField(
            context, 'Datum izdaje', dateCreatedController),
        buildEmployeeSection(),
        buildLabeledCard('Predujem', prepaymentController,false),
        buildLabeledCard('Začetno stanje km', km1Controller, false),
        buildDateTimePickerField(
            context, 'Čas pričetka', datetimeStartController),
        buildDateTimePickerField(context, 'Čas konca', datetimeEndController),
      ],
    );
  }

  void _showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Dodaj strošek"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildDatePickerField(
                    context, 'Datum', dateCostCreatedController),
                const SizedBox(height: 8.0),
                buildLabeledCard('Opis', descriptionCostController,true),
                const SizedBox(height: 8.0),
                buildLabeledCard('Znesek', amountCostController,true),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without saving
              },
              child: const Text("Prekliči"),
            ),
            ElevatedButton(
              onPressed: () {
                _addExpense(); // Add the expense
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Dodaj"),
            ),
          ],
        );
      },
    );
  }

  void _showAddDailyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Dodaj strošek"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildLabeledCard('Cela', descriptionCostController, true),
                const SizedBox(height: 8.0),
                buildLabeledCard('Polovična', amountCostController, true),
                const SizedBox(height: 8.0),
                buildLabeledCard('Znižana', amountCostController, true),
                const SizedBox(height: 8.0),
                buildDateTimePickerField(
                    context, 'Trajanje od', dateCostCreatedController),
                buildDateTimePickerField(
                    context, 'Trajanje do', dateCostCreatedController),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without saving
              },
              child: const Text("Prekliči"),
            ),
            ElevatedButton(
              onPressed: () {
                _addExpense(); // Add the expense
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Dodaj"),
            ),
          ],
        );
      },
    );
  }

  Widget buildExpensesForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Stroški na poti',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: _showAddExpenseDialog, // Open the popup dialog
              child: const Text("Dodaj strošek"),
            ),
          ],
        ),
        if (expenseDetails != null && expenseDetails!.isNotEmpty)
          buildExpensesList()
        else
          Container(
            margin: const EdgeInsets.only(top: 15),
            child: const Text('Trenutno še niste dodali nobenega stroška'),
          )
      ],
    );
  }

  Widget buildExpensesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15.0),
        ...expenseDetails!.map((expense) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            child: ListTile(
              title: Text(
                  expense['descr'] ?? 'Ni opisa'), // Default if 'opis' is null
              subtitle: Text(
                  'Datum: ${expense['date_of'] ?? 'Ni datuma'}'), // Default for 'datum'
              trailing: Text(
                '${expense['amount'] ?? 0} €',
                style: const TextStyle(fontSize: 16),
              ), // Default for 'znesek'
            ),
          );
        }),
      ],
    );
  }

  Widget buildTravelDayForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Dnevnica',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: _showAddDailyDialog, // Open the popup dialog
              child: const Text("Dodaj dnevnico"),
            ),
          ],
        ),
        if (diares != null && diares!.isNotEmpty)
          buildDiaresDetails(diares!)
        else
          Container(
            margin: const EdgeInsets.only(top: 15),
            child: const Text('Trenutno še niste dodali nobene dnevnice.'),
          )
      ],
    );
  }

  Widget buildOrderForm() {
    return Column(
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
        buildDateTimePickerField(
            context, 'Datum izdaje', dateCreatedController),
        buildEmployeeSection(),
        buildLabeledCard('Predujem', prepaymentController, false),
        buildLabeledCard('Začetno stanje km', km1Controller, false),
        buildDateTimePickerField(
            context, 'Čas pričetka', datetimeStartController),
        buildDateTimePickerField(context, 'Čas konca', datetimeEndController),
      ],
    );
  }

  Widget buildEmployeeSection() {
    if (employees == null) {
      return const Center(child: CircularProgressIndicator());
    }

    List<DropdownMenuItem<int>> employeeItems = employees!.entries.map((entry) {
      return DropdownMenuItem<int>(
        value: entry.key,
        child: Text(entry.value['name']),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabeledSelectionCard(
          'Voznik',
          DropdownButtonFormField<int>(
            value: employeeItems.any((item) => item.value == selectedDriverId)
                ? selectedDriverId
                : null, // Ensures the value is valid
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            items: employeeItems,
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
            value:
                employeeItems.any((item) => item.value == selectedPassengerId)
                    ? selectedPassengerId
                    : null, // Ensures the value is valid
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            items: employeeItems,
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
            value:
                employeeItems.any((item) => item.value == selectedApprovedById)
                    ? selectedApprovedById
                    : null, // Ensures the value is valid
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            items: employeeItems,
            onChanged: (int? newValue) {
              setState(() {
                selectedApprovedById = newValue;
              });
            },
          ),
        ),
        const SizedBox(height: 2),
        buildLabeledSelectionCard(
          'Vozilo',
          DropdownButtonFormField<String>(
            value: vehicleController.text.isNotEmpty
                ? vehicleController.text
                : null, // Use regnum
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            items: vehicles?.entries.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.value['regnum'], // regnum is the string displayed
                child: Text(entry.value['regnum'] ?? 'Ni registracije'),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                vehicleController.text =
                    newValue ?? ''; // Update the controller
              });
            },
          ),
        ),
      ],
    );
  }
}
