import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay_app/bloc/pagar/pagar_bloc.dart';
import 'package:pay_app/pages/home_page.dart';
import 'package:pay_app/pages/pago_completo_page.dart';
import 'package:pay_app/services/stripe_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Inicializar stripe services
    new StripeService()..init();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PagarBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PagosApp',
        initialRoute: 'home',
        routes: {
          'home': (_) => HomePage(),
          'pago': (_) => PagoCompletoPage(),
        },
        theme: ThemeData.light().copyWith(
            primaryColor: Color(0xff284879),
            scaffoldBackgroundColor: Color(0xff21232A)),
      ),
    );
  }
}
