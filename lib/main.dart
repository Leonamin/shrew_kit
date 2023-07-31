import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';
import 'package:shrew_kit/common/config/router.dart';

final logger = Logger();

void main() {
  initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '#ShrewKit',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      routerConfig: router,
    );
  }
}
