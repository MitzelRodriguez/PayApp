import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pay_app/bloc/pagar/pagar_bloc.dart';

import 'package:pay_app/data/tarjeta.dart';
import 'package:pay_app/helpers/helpers.dart';
import 'package:pay_app/pages/tarjeta_page.dart';
import 'package:pay_app/widgets/total_pay_btton.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //especificar el size
    final size = MediaQuery.of(context).size;

    // ignore: close_sinks
    final pagarBloc = BlocProvider.of<PagarBloc>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Pagar'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              mostrarLoading(context);
              Future.delayed(Duration(seconds: 1));
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Stack(
        children: [
          //Carrusel cards
          Positioned(
            width: size.width,
            height: size.width,
            top: 100,
            child: PageView.builder(
                controller: PageController(
                  viewportFraction: 0.9,
                ),
                physics: BouncingScrollPhysics(),
                itemCount: tarjetas.length,
                itemBuilder: (_, i) {
                  final tarjeta = tarjetas[i];

                  return GestureDetector(
                    onTap: () {
                      pagarBloc.add(OnSeleccionarTarjeta(tarjeta));
                      Navigator.push(
                        context,
                        navegarFadeIn(context, TarjetaPage()),
                      );
                    },
                    child: Hero(
                      tag: tarjeta.cardNumber,
                      child: CreditCardWidget(
                        cardNumber: tarjeta.cardNumberHidden,
                        expiryDate: tarjeta.expiracyDate,
                        cardHolderName: tarjeta.cardHolderName,
                        cvvCode: tarjeta.cvv,
                        showBackView: false,
                      ),
                    ),
                  );
                }),
          ),

          Positioned(bottom: 0, child: TotalPayButton()),
        ],
      ),
    );
  }
}
