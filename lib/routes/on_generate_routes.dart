import 'package:asia_cargo_ashir_11_boss_office/pages/bilty_detailed_page.dart';
import 'package:asia_cargo_ashir_11_boss_office/pages/first_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case FirstPage.pageName:
      return CupertinoPageRoute(
        builder: (context) => const FirstPage(),
      );
    case BiltyDetailedPage.pageName:
      final args = settings.arguments as Map<String, dynamic>;
      return CupertinoPageRoute(
        builder: (context) => BiltyDetailedPage(
          biltyNumber: args['biltyNumber']?.toString() ?? 'N/A', // Convert to string
          biltyUrl: args['biltyUrl'] ?? '',
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => Container(
          color: Colors.red,
          child: const Center(
            child: Text('Wrong page'),
          ),
        ),
      );
  }
}
