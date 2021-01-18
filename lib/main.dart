import 'dart:html';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PagosApp',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pagos App'),
        ),
      ),
    );
  }
}
