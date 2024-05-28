import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    zipController;
  }

  String? city;
  final zipController = TextEditingController();

  String? validateZip(String? input) {
    int? inputInt = int.tryParse(input!);
    if (input.isEmpty) {
      return "Bitte teilen Sie Ihr PLZ";
    } else if (input.length != 5) {
      return "PLZ muss 5 stellig sein";
    } else if (inputInt.runtimeType != int) {
      return "PLZ darf nur Ziffern enthalten";
    } else {
      return null;
    }
  }

  Future<String> getCityFromZip(String zip) async {
    // simuliere Dauer der Datenbank-Anfrage
    await Future.delayed(const Duration(seconds: 3));

    switch (zip) {
      case "10115":
        return 'Berlin';
      case "20095":
        return 'Hamburg';
      case "80331":
        return 'München';
      case "50667":
        return 'Köln';
      case "60311":
      case "60313":
        return 'Frankfurt am Main';
      default:
        return 'Unbekannte Stadt';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: zipController,
                  validator: validateZip,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Postleitzahl",
                    suffixText: '*',
                    suffixStyle: TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(height: 32),
                OutlinedButton(
                  onPressed: () async {
                    city = await getCityFromZip(zipController.text);
                    setState(() {});
                  },
                  child: const Text("Stadt abfragen"),
                ),
                const SizedBox(height: 32),
                FutureBuilder<String>(
                  future: getCityFromZip(zipController.text),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      return Text("Stadt: ${snapshot.data}");
                    } else if (snapshot.connectionState !=
                        ConnectionState.done) {
                      return const CircularProgressIndicator();
                    } else {
                      return const Icon(Icons.error);
                    }
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    zipController;
    super.dispose();
  }
}
