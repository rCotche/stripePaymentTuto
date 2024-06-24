import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

//je ne doit pas mettre le type void car
//dans la fonction qd on set les valeur pour :
//paymentIntentClientSecret; customerEphemeralKeySecret; customerId
//This expression has a type of 'void' so its value can't be used.Try checking to see if you're using the correct API stripe
Future createPaymentIntent({
  required String name,
  required String address,
  required String pin,
  required String city,
  required String state,
  required String country,
  required String currency,
  required String amount,
}) async {
  //https://docs.stripe.com/api/payment_intents/create
  final url = Uri.parse("https://api.stripe.com/v1/payment_intents");
  final secretKey = dotenv.env["STRIPE_SECRET_KEY"]!;

  //
  final body = {
    'amount': amount,
    'currency': currency.toLowerCase(),
    'automatic_payment_methods[enabled]': 'true',
    'description': 'Test donation',
    'shipping[name]': name,
    'shipping[address][line1]': address,
    'shipping[address][postal_code]': pin,
    'shipping[address][city]': city,
    'shipping[address][state]': state,
    'shipping[address][country]': country,
  };

  //
  final response = await http.post(
    url,
    headers: {
      "Authorization": "Bearer $secretKey",
      'Content-Type': 'application/x-www-form-urlencoded'
    },
    body: body,
  );
  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    // debugPrint(response.body);
    // debugPrint(json);//peut pas print un map strin
    ////genre coomme en php on peut print un tableau
    return json;
  } else {
    debugPrint("error payment intent : ${response.body}");
  }
}
