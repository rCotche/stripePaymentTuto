import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stripe_payment_flutter/constant.dart';

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
      body: Column(
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
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
