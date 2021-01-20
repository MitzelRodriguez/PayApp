class StripeServices {
  //Singleton
  StripeServices._privateConstructor();

  static final StripeServices _instance = StripeServices._privateConstructor();

  factory StripeServices() => _instance;

  String _paymentApiUrl = '';
}
