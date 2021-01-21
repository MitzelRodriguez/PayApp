import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:pay_app/models/payment_intent_response.dart';
import 'package:pay_app/models/stripe_custom_response.dart';
import 'package:stripe_payment/stripe_payment.dart';

class StripeService {
  //Singleton
  StripeService._privateConstructor();

  static final StripeService _intance = StripeService._privateConstructor();

  factory StripeService() => _intance;

  String _paymentApiUrl = 'https://api.stripe.com/v1/payment_intents';
  static String _secretKey =
      'sk_test_51IBld2CmPEYQHxW01VgeCeDoxeGg4dhQXMjZi82K1FdZgya9L1T7UDcQ1FvLC7aQmmtEISk8Um2hQgqsEMJBNofo00ADLC58W5';
  String _apiKey =
      'pk_test_51IBld2CmPEYQHxW0RzWPT4qu0R9uqOUuTNoVYPUEBDoLqE11HR7JT64GRg1FLMVRZ9B0hliDzbK1KgwRnXvvmoo900tzyVcU98';

  final headerOptions =
      new Options(contentType: Headers.formUrlEncodedContentType, headers: {
    'Authorization': 'Bearer ${StripeService._secretKey}',
  });

  void init() {
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: this._apiKey,
        androidPayMode: 'test',
        merchantId: 'test',
      ),
    );
  }

  Future<StripeCustomResponse> pagarConTarjetaExistente({
    @required String amount,
    @required String currency,
    @required CreditCard card,
  }) async {
    try {
      final paymentMethod =
          await StripePayment.createPaymentMethod(PaymentMethodRequest(
        card: card,
      ));

      final resp = await this._realizarPago(
        amount: amount,
        currency: currency,
        paymentMethod: paymentMethod,
      );

      return resp;
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }

  Future<StripeCustomResponse> pagarConNuevaTartjeta({
    @required String amount,
    @required String currency,
  }) async {
    try {
      final paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());

      final resp = await this._realizarPago(
        amount: amount,
        currency: currency,
        paymentMethod: paymentMethod,
      );

      return resp;
    } catch (e) {
      return StripeCustomResponse(
        ok: false,
        msg: e.toString(),
      );
    }
  }

  // ignore: missing_return
  Future<StripeCustomResponse> pagarAppleGooglePay({
    @required String amount,
    @required String currency,
  }) async {
    try {
      final newAmount = double.parse(amount) / 100;

      final token = await StripePayment.paymentRequestWithNativePay(
        androidPayOptions: AndroidPayPaymentRequest(
          currencyCode: currency,
          totalPrice: amount,
        ),
        applePayOptions: ApplePayPaymentOptions(
            countryCode: 'US',
            currencyCode: currency,
            items: [
              ApplePayItem(
                label: 'producto 1',
                amount: '$newAmount',
              ),
            ]),
      );

      final paymentMethod =
          await StripePayment.createPaymentMethod(PaymentMethodRequest(
        card: CreditCard(
          token: token.tokenId,
        ),
      ));

      final resp = await this._realizarPago(
        amount: amount,
        currency: currency,
        paymentMethod: paymentMethod,
      );

      //cerrar pantalla, despues de ralizar el pago
      await StripePayment.completeNativePayRequest();

      return resp;
    } catch (e) {
      print('Error: ${e.toString()}');
      return StripeCustomResponse(
        ok: false,
        msg: e.toString(),
      );
    }
  }

  Future<PaymentIntentResponse> _crearPaymentIntent({
    @required String amount,
    @required String currency,
  }) async {
    try {
      final dio = new Dio();
      final data = {
        'amount': amount,
        'currency': currency,
      };

      final resp =
          await dio.post(_paymentApiUrl, data: data, options: headerOptions);

      return PaymentIntentResponse.fromJson(resp.data);
    } catch (e) {
      print('Error ${e.toString()}');
      return PaymentIntentResponse(status: '400');
    }
  }

  Future<StripeCustomResponse> _realizarPago({
    @required String amount,
    @required String currency,
    @required PaymentMethod paymentMethod,
  }) async {
    try {
      //crear el intento de pago
      final paymentIntent = await this._crearPaymentIntent(
        amount: amount,
        currency: currency,
      );

      //confirmar el cobro
      final paymentResult =
          await StripePayment.confirmPaymentIntent(PaymentIntent(
        clientSecret: paymentIntent.clientSecret,
        paymentMethodId: paymentMethod.id,
      ));

      if (paymentResult.status == 'succeeded') {
        return StripeCustomResponse(ok: true);
      } else {
        return StripeCustomResponse(
            ok: false, msg: 'Fallo ${paymentResult.status}');
      }
    } catch (e) {
      print('Error: ${e.toString()}');
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }
}
