import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: const CryptoPage(),
    );
  }
}

class CryptoPage extends StatefulWidget {
  const CryptoPage({Key? key}) : super(key: key);

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  TextEditingController numberEditingController = TextEditingController();
  

  String? unitName;
  String? typeName;
  String unit = " ";
  double value = 0.0;
  double count = 0.0;
  double endValue = 0.0;
  
  String valueOutput = " ";

  List<String> typeList = ["Crypto", "Fiat", "Commodity"];
  List<String> commodityList = ["xag", "xau"];
  List<String> unitList = [];

  List<String> currencyList = [
    "btc",
    "eth",
    "ltc",
    "bch",
    "bnb",
    "eos",
    "xrp",
    "xlm",
    "link",
    "dot",
    "yfi",
    "bits",
    "sats"
    
    //fiat
    "usd",
    "aed",
    "ars",
    "aud",
    "bdt",
    "bhd",
    "bmd",
    "brl",
    "cad",
    "chf",
    "clp",
    "cny",
    "czk",
    "dkk",
    "eur",
    "gbp",
    "hkd",
    "huf",
    "idr",
    "ils",
    "inr",
    "jpy",
    "krw",
    "kwd",
    "lkr",
    "mmk",
    "mxn",
    "myr",
    "ngn",
    "nok",
    "nzd",
    "php",
    "pkr",
    "pln",
    "rub",
    "sar",
    "sek",
    "sgd",
    "thb",
    "try",
    "twd",
    "uah",
    "vef",
    "vnd",
    "zar",
    "xdr"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: AppBar(
              backgroundColor: const Color.fromARGB(255, 226, 184, 57),
              centerTitle: true,
              elevation: 20,
              title: const Text(
                "Cryptocurrency Converter", textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              )),
        ),
        body: Center(
            child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset('assets/images/billionbit cryto logo.png',
                height: 180, width: 180),
            
            
            ConstrainedBox(
                constraints: const BoxConstraints.tightFor(width: 180),
                child: TextFormField(
                    
                    decoration: const InputDecoration(
                        hintText: 'Enter bitcoin value',
                        border: OutlineInputBorder()),
                    textAlign: TextAlign.center,
                    controller: numberEditingController)),

            Scrollbar(
              child: DropdownButton(
                hint: const Text("Choose unit"),
                itemHeight: 80,
                value: unitName,
                items: currencyList.map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (unit) {
                  setState(() {
                    unitName = unit.toString();
                  });
                },
              ),
            ),

            Scrollbar(
              child: DropdownButton(
                hint: const Text("Choose type"),
                itemHeight: 80,
                value: typeName,
                items: typeList.map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (type) {
                  setState(() {
                    typeName = type.toString();
                  });
                },
              ),
            ),

            ElevatedButton(onPressed: _convert, child: const Text("Convert exchange value")),
            const Text("Result: ",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            Text(valueOutput,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ]),
        )));
  }

  Future<void> _convert() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Progress"), title: const Text("Converting..."));
    progressDialog.show();

    var url = Uri.parse('https://api.coingecko.com/api/v3/exchange_rates');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = response.body;
      var parseData = json.decode(jsonData);

      count = double.parse(numberEditingController.text);

      setState(() {
        unit = parseData['rates'][unitName]['unit'];
        value = parseData['rates'][unitName]['value'];
        endValue = count * value;
        valueOutput =
            "The conversion value is $endValue $unit";     
      });
      progressDialog.dismiss();
    }
  }
}