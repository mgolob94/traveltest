import 'package:flutter/material.dart';
import 'package:invfox_mtravelorder/screens/home_screen.dart';
import 'package:invfox_mtravelorder/screens/order_details_screen.dart';

class HomeNavigator extends StatelessWidget {
  const HomeNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        Widget page = const HomeScreen(); // Default screen

        // Handle route to order details
        if (settings.name == '/orderDetails') {
          final Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
          final int? orderId = arguments['orderId'];
          final bool editingMode = arguments['editingMode'];
          page = OrderDetailsScreen(orderId: orderId, editingMode: editingMode);
        }

        return MaterialPageRoute(builder: (_) => page);
      },
    );
  }
}
