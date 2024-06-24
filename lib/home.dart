import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_payment_flutter/constant.dart';
import 'package:stripe_payment_flutter/payment.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //
  TextEditingController amountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  //key for validation

  //check food delivery, credit card form
  final amountFormkey = GlobalKey<FormState>();
  final nameFormkey = GlobalKey<FormState>();
  final addressFormkey = GlobalKey<FormState>();
  final cityFormkey = GlobalKey<FormState>();
  final stateFormkey = GlobalKey<FormState>();
  final countryFormkey = GlobalKey<FormState>();
  final pincodeFormkey = GlobalKey<FormState>();

  //Moi : vaut mieux utiliser un enum
  //
  List<String> currencyList = <String>[
    'USD',
    'INR',
    'EUR',
    'JPY',
    'GBP',
    'AED',
  ];

  String selectedCurrency = 'USD';

  //https://docs.page/flutter-stripe/flutter_stripe/sheet
  Future<void> initPaymentSheet() async {
    try {
      // 1. create payment intent on the server
      //final data = await _createTestPaymentSheet();

      //// 1. create payment intent on the client side by calling stripe api
      final data = await createPaymentIntent(
        name: nameController.text,
        address: addressController.text,
        pin: pincodeController.text,
        city: cityController.text,
        state: stateController.text,
        country: countryController.text,
        currency: selectedCurrency,
        amount: amountController.text,
      );

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'Test merchant',
          paymentIntentClientSecret: data['client_secret'],
          // Customer keys
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['id'],
          // Extra options
          // applePay: const PaymentSheetApplePay(
          //   merchantCountryCode: 'US',
          // ),
          // googlePay: const PaymentSheetGooglePay(
          //   merchantCountryCode: 'US',
          //   testEnv: true,
          // ),
          style: ThemeMode.dark,
        ),
      );
      // setState(() {
      //   _ready = true;
      // });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    nameController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //
            const Image(
              image: AssetImage("assets/placeholder.png"),
              height: 300,
              //I want to be as big as my parent allows (double.infinity)
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            //
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Support us with your donations",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),

                  //
                  Row(
                    children: [
                      Expanded(
                        //La propriété flex de la classe Expanded est utilisée
                        //pour contrôler la manière dont un widget enfant s'agrandit
                        //pour occuper l'espace disponible dans un conteneur parent.
                        //elle permet de spécifier la proportion de l'espace disponible
                        //que chaque widget enfant doit occuper dans un Row, Column ou Flex.

                        //Par exemple, si vous avez deux widgets dans une Row
                        //et que vous souhaitez que le premier widget occupe 1/3
                        //de l'espace et le second 2/3 de l'espace,
                        //vous pouvez utiliser la propriété flex pour le faire.

                        //Le premier Expanded a un flex de 1,
                        //ce qui signifie qu'il occupe 1 part de l'espace disponible.
                        //Le second Expanded a un flex de 2,
                        //ce qui signifie qu'il occupe 2 parts de l'espace disponible.
                        //Par conséquent, si vous ajoutez les flex (1 + 2 = 3),
                        //le premier widget occupe 1/3 de l'espace disponible
                        //tandis que le second widget occupe 2/3 de l'espace disponible.
                        flex: 5,

                        //Amount
                        child: ReusableTextField(
                          title: "Donation amount",
                          hint: "Any amount you like",
                          isNumber: true,
                          controller: amountController,
                          formkey: amountFormkey,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),

                      //DropdownMenu
                      DropdownMenu<String>(
                        inputDecorationTheme: InputDecorationTheme(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 0,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        initialSelection: currencyList.first,
                        onSelected: (String? value) {
                          //this is called when the user select an item
                          setState(() {
                            selectedCurrency = value!;
                          });
                        },

                        //currencyList : Il s'agit d'une liste contenant des chaînes de caractères
                        //(par exemple, les noms de devises comme "USD", "EUR", etc.).
                        //.map<DropdownMenuEntry<String>> : La méthode map applique une fonction à chaque élément
                        //de currencyList et retourne un nouvel iterable de type DropdownMenuEntry<String>.

                        //pour chaque element de currencylist il y a une fonction
                        //DropdownMenuEntry<String> getUnDropdownMenuEntry (String value){return;}

                        //((String value) {...}) : C'est une fonction anonyme (ou lambda)
                        //qui prend en entrée une chaîne de caractères (value)
                        //et retourne une instance de DropdownMenuEntry<String>.

                        //.toList() : Convertit l'iterable résultant en une liste.
                        dropdownMenuEntries: currencyList
                            .map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(
                              value: value, label: value);
                        }).toList(),
                      ),
                    ],
                  ),

                  //name
                  const SizedBox(
                    height: 10,
                  ),
                  ReusableTextField(
                    title: "Name",
                    hint: "Ex: john doe",
                    controller: nameController,
                    formkey: nameFormkey,
                  ),

                  //address
                  const SizedBox(
                    height: 10,
                  ),
                  ReusableTextField(
                    title: "Address",
                    hint: "Ex 123 main str",
                    controller: addressController,
                    formkey: addressFormkey,
                  ),

                  //city
                  const SizedBox(
                    height: 10,
                  ),
                  ReusableTextField(
                    title: "City",
                    hint: "Ex New delhi",
                    controller: cityController,
                    formkey: cityFormkey,
                  ),

                  //address
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: ReusableTextField(
                          title: "Address",
                          hint: "Ex 123 main str",
                          controller: addressController,
                          formkey: addressFormkey,
                        ),
                      ),

                      //state
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 5,
                        child: ReusableTextField(
                          title: "State",
                          hint: "Ex DL",
                          controller: stateController,
                          formkey: stateFormkey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,

                        //country
                        child: ReusableTextField(
                          title: "Country",
                          hint: "Ex In for India",
                          controller: countryController,
                          formkey: countryFormkey,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 5,

                        //pincode
                        child: ReusableTextField(
                          title: "Pin code",
                          hint: "Ex 12345",
                          isNumber: true,
                          controller: pincodeController,
                          formkey: pincodeFormkey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,

                    //button
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent.shade400,
                      ),
                      onPressed: () async {
                        //mettre dans une fonction
                        //pour le moment il y a pas de validation

                        if (amountFormkey.currentState!.validate() &&
                            nameFormkey.currentState!.validate() &&
                            addressFormkey.currentState!.validate() &&
                            cityFormkey.currentState!.validate() &&
                            stateFormkey.currentState!.validate() &&
                            countryFormkey.currentState!.validate() &&
                            pincodeFormkey.currentState!.validate()) {}
                      },
                      child: const Text(
                        "Proceed to pay",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
