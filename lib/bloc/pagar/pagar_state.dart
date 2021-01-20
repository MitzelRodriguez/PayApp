part of 'pagar_bloc.dart';

@immutable
class PagarState {
  final double montoPagar;
  final String moneda;
  final bool tarjetaActiva;
  final TarjetaCredito tarjeta;

  PagarState({
    this.montoPagar = 375.60,
    this.moneda = 'MX',
    this.tarjetaActiva = false,
    this.tarjeta,
  });

  PagarState copyWith({
    double montoPagar,
    String moneda,
    bool tarjetaActiva,
    TarjetaCredito tarjeta,
  }) =>
      PagarState(
        montoPagar: montoPagar ?? this.montoPagar,
        moneda: moneda ?? this.moneda,
        tarjetaActiva: tarjetaActiva ?? this.tarjetaActiva,
        tarjeta: tarjeta ?? this.tarjeta,
      );
}

//class PagarInitial extends PagarState {}