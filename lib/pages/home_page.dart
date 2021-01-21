import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pay_app/bloc/pagar/pagar_bloc.dart';

import 'package:pay_app/data/tarjetas.dart';
import 'package:pay_app/helpers/helpers.dart';
import 'package:pay_app/pages/tarjeta_page.dart';
import 'package:pay_app/services/stripe_service.dart';
import 'package:pay_app/widgets/total_pay_btton.dart';

class HomePage extends StatelessWidget {
  final stripeServices = new StripeService();

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
              final amount = pagarBloc.state.montoPagarString;
              final currency = pagarBloc.state.moneda;

              final resp = await this.stripeServices.pagarConNuevaTartjeta(
                    amount: amount,
                    currency: currency,
                  );

              Navigator.pop(context);

              if (resp.ok) {
                mostrarAlerta(context, 'Tarjeta Ok', 'Todo correcto');
              } else {
                mostrarAlerta(context, 'Algo salio mal', resp.msg);
              }
            },
          )
        ],
      ),
      body: Stack(
        children: [
          //Carrusel cards
          Positioned(
            width: size.width,
            height: size.height,
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
                          context, navegarFadeIn(context, TarjetaPage()));
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
