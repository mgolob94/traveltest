import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final DateFormat _dateFormat = DateFormat('dd.MM.yyyy HH:mm');

String formatDateTime(String? rawDateTime) {
  if (rawDateTime == null || rawDateTime.isEmpty) return '';
  final DateTime parsedDateTime = DateTime.parse(rawDateTime);
  return _dateFormat.format(parsedDateTime);
}

String formatDate(String? rawDate) {
  if (rawDate == null || rawDate.isEmpty) return '';
  final DateTime parsedDate = DateTime.parse(rawDate);
  return DateFormat('dd.MM.yyyy').format(parsedDate);
}

Future<void> selectDateTime(BuildContext context, TextEditingController controller) async {
  DateTime initialDate = DateTime.now();
  if (controller.text.isNotEmpty) {
    try {
      initialDate = _dateFormat.parse(controller.text);
    } catch (_) {}
  }

  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );

  if (pickedDate != null) {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    if (pickedTime != null) {
      final DateTime finalDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      controller.text = _dateFormat.format(finalDateTime);
    }
  }
}
