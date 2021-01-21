import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stripe_payment/stripe_payment.dart';

import 'package:pay_app/bloc/pagar/pagar_bloc.dart';
import 'package:pay_app/helpers/helpers.dart';
import 'package:pay_app/services/stripe_service.dart';

class TotalPayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    final pagarBloc = BlocProvider.of<PagarBloc>(context).state;

    return Container(
      width: size,
      height: 100,
      padding: EdgeInsets.symmetric(
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                '${pagarBloc.montoPagar}${pagarBloc.moneda}',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          BlocBuilder<PagarBloc, PagarState>(
            builder: (BuildContext context, state) {
              return _BtnPay(state);
            },
          ),
        ],
      ),
    );
  }
}

//Boton de pago

class _BtnPay extends StatelessWidget {
  final PagarState state;
  const _BtnPay(this.state);

  @override
  Widget build(BuildContext context) {
    return state.tarjetaActiva
        ? buildCardPay(context)
        : buildGooglePay(context);
  }

  //Pago con tarjeta
  Widget buildCardPay(BuildContext context) {
    return MaterialButton(
        height: 45,
        minWidth: 150,
        shape: StadiumBorder(),
        elevation: 0,
        color: Colors.black,
        child: Row(
          children: [
            Icon(
              FontAwesomeIcons.creditCard,
              color: Colors.white,
            ),
            Text(
              ' Pagar',
              style: TextStyle(color: Colors.white, fontSize: 22),
            )
          ],
        ),
        onPressed: () async {
          mostrarLoading(context);

          final stripeServices = new StripeService();
          final pagarBloc = BlocProvider.of<PagarBloc>(context).state;
          final tarjeta = pagarBloc.tarjeta;
          final mesAnio = tarjeta.expiracyDate.split('/');

          final resp = await stripeServices.pagarConTarjetaExistente(
            amount: pagarBloc.montoPagarString,
            currency: pagarBloc.moneda,
            card: CreditCard(
              number: tarjeta.cardNumber,
              expMonth: int.parse(mesAnio[0]),
              expYear: int.parse(mesAnio[1]),
            ),
          );

          Navigator.pop(context);
          if (resp.ok) {
            mostrarAlerta(
                context, 'Pago Realizado', 'Se realizo correctamente el pago');
          } else {
            mostrarAlerta(
                context, 'Ah ocurrido un error', 'Error: ${resp.msg}');
          }
        });
  }

  //Pago con GooglePay o ApplePay
  Widget buildGooglePay(BuildContext context) {
    return MaterialButton(
        height: 45,
        minWidth: 150,
        shape: StadiumBorder(),
        elevation: 0,
        color: Colors.black,
        child: Row(
          children: [
            Icon(
              FontAwesomeIcons.google,
              color: Colors.white,
            ),
            Text(
              '  Pay',
              style: TextStyle(color: Colors.white, fontSize: 22),
            )
          ],
        ),
        onPressed: () async {
          final stripeServices = new StripeService();
          final pagarBloc = BlocProvider.of<PagarBloc>(context).state;

          final resp = await stripeServices.pagarAppleGooglePay(
            amount: pagarBloc.montoPagarString,
            currency: pagarBloc.moneda,
          );

          print(resp);
        });
  }
}
