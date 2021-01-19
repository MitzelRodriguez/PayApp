import 'package:flutter/material.dart';
import 'package:pay_app/pages/home_page.dart';
import 'package:pay_app/pages/pago_completo_page.dart';
import 'package:pay_app/pages/tarjeta_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PagosApp',
      initialRoute: 'home',
      routes: {
        'home': (_) => HomePage(),
        'pago': (_) => PagoCompletoPage(),
        'tarjetas': (_) => TarjetaPage(),
      },
      theme: ThemeData.light().copyWith(
          primaryColor: Color(0xff284879),
          scaffoldBackgroundColor: Color(0xff21232A)),
    );
  }
}
