import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pay_app/bloc/pagar/pagar_bloc.dart';

class TotalPayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;

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
                '255.00 USD',
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
        onPressed: () {});
  }

  //Pago con GooglePay
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
        onPressed: () {});
  }
}
