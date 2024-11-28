// utils/date_utils.dart
import 'package:intl/intl.dart'; // Import intl for date formatting

// Helper function to format the date
String formatDate(String? dateString) {
  if (dateString == null) return 'N/A'; // Return 'N/A' if date is null

  try {
    // Assuming the input date string is in the format 'yyyy-MM-dd', adjust this if necessary
    final DateTime parsedDate = DateTime.parse(dateString);

    // Format the date as 'dd.MM.yyyy'
    final String formattedDate = DateFormat('dd.MM.yyyy').format(parsedDate);

    return formattedDate;
  } catch (e) {
    return 'N/A'; // Return 'N/A' if there is a parsing error
  }
}
