import 'package:flutter/material.dart';
import 'package:invfox_mtravelorder/helpers/helpers.dart';

Widget buildTextField(String label, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.all(8.0),
          ),
        ),
      ],
    ),
  );
}

Widget buildDateTimePickerField(
    BuildContext context, String label, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
            child: InkWell(
              onTap: () => selectDateTime(context, controller),
              child: IgnorePointer(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(8.0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildDatePickerField(
    BuildContext context, String label, TextEditingController controller) {
  // If the controller is empty, set the default value to today's date
  if (controller.text.isEmpty) {
    controller.text = _formatDate(DateTime.now());
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
            child: InkWell(
              onTap: () => _selectDate(context, controller),
              child: IgnorePointer(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(8.0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.blue, // Header background color
            onPrimary: Colors.white, // Header text color
            onSurface: Colors.black, // Body text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue, // Button text color
            ),
          ),
        ),
        child: child!,
      );
    },
  );

  if (pickedDate != null) {
    controller.text = _formatDate(pickedDate); // Update the controller with the formatted date
  }
}

String _formatDate(DateTime date) {
  return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
}

Widget buildCard({String? title, required List<Widget> children}) {
  return Card(
    elevation: 1,
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null && title.isNotEmpty) ...[
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const Divider(),
          ],
          ...children,
        ],
      ),
    ),
  );
}

Widget buildLabeledCard(String label, TextEditingController controller, bool customPadding) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        Card(
          color: Colors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: !customPadding ? const EdgeInsets.all(8.0) : const EdgeInsets.all(0),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildLabeledSelectionCard(String label, Widget child) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        Card(
          color: Colors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: child,
          ),
        ),
      ],
    ),
  );
}

Widget buildExpenseDetails(List<dynamic> expenseDetails) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: expenseDetails.map((expense) {
          final String expenseType = expense['descr'] ?? 'N/A';
          final double amount = expense['amount'] ?? 0;

          return Container(
            width: constraints.maxWidth,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1F1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vrsta stroška: $expenseType',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Znesek: €${amount.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        }).toList(),
      );
    },
  );
}

Widget buildDiaresDetails(List<dynamic> diares) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: diares.map((diare) {
      final bool breakfast = diare['food1'] == 1;
      final bool lunch = diare['food2'] == 1;
      final bool dinner = diare['food2'] == 1;

      final double loweredPrice = diare['lowered'] ?? 0;
      final double halfPrice = diare['half'] ?? 0;
      final double fullPrice = diare['full'] ?? 0;
      final double totalAmount = diare['amount'] ?? 0;

      final String startTime = diare['date_start'];
      final String endTime = diare['date_end'];

      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Država', diare['tc_name']),
              const SizedBox(height: 8),
              _buildDetailRow('Trajanje od', startTime),
              _buildDetailRow('Trajanje do', endTime),
              const SizedBox(height: 8),
              _buildDetailRow('Celotna', '${fullPrice.toStringAsFixed(2)} €'),
              _buildDetailRow('Polovična', '${halfPrice.toStringAsFixed(2)} €'),
              _buildDetailRow(
                  'Znižana', '${loweredPrice.toStringAsFixed(2)} €'),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMealRow('Zajtrk', breakfast),
                  _buildMealRow('Kosilo', lunch),
                  _buildMealRow('Večerja', dinner),
                ],
              ),
              const SizedBox(height: 8),
              _buildDetailRow('Znesek', '${totalAmount.toStringAsFixed(2)} €'),
            ],
          ),
        ),
      );
    }).toList(),
  );
}

Widget _buildMealRow(String meal, bool isAvailable) {
  return Row(
    children: [
      Text('$meal: ', style: const TextStyle(fontSize: 16)),
      Text(isAvailable ? '✓' : '✗',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isAvailable ? Colors.green : Colors.red,
          )),
    ],
  );
}

Widget _buildDetailRow(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text('$label:', style: const TextStyle(fontSize: 16)),
      Text(value, style: const TextStyle(fontSize: 16)),
    ],
  );
}
