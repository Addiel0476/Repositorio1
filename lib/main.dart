import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const FinanzasApp());
}

class FinanzasApp extends StatelessWidget {
  const FinanzasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true),

      darkTheme: ThemeData.dark(useMaterial3: true),

      themeMode: ThemeMode.system,

      home: const MenuScreen(),
    );
  }
}

/* ================= MENU ================= */

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.only(top: 70),
          child: Text(
            "Calculadora Financiera",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            cardBoton(
              context,
              "Préstamo Consumo",
              Icons.attach_money,
              const ConsumoScreen(),
            ),

            cardBoton(context, "Hipoteca", Icons.home, const HipotecaScreen()),

            cardBoton(
              context,
              "Inversión",
              Icons.trending_up,
              const InversionScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardBoton(BuildContext c, String texto, IconData icono, Widget page) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 12),

      child: ListTile(
        leading: Icon(icono, size: 35),
        title: Text(texto, style: const TextStyle(fontSize: 18)),
        trailing: const Icon(Icons.arrow_forward),

        onTap: () {
          Navigator.push(c, MaterialPageRoute(builder: (_) => page));
        },
      ),
    );
  }
}

/* ================= CONSUMO ================= */

class ConsumoScreen extends StatefulWidget {
  const ConsumoScreen({super.key});

  @override
  State<ConsumoScreen> createState() => _ConsumoScreenState();
}

class _ConsumoScreenState extends State<ConsumoScreen> {
  final monto = TextEditingController();
  final interes = TextEditingController();
  final anos = TextEditingController();

  String tipo = "Mensual";
  double resultado = 0;

  void calcular() {
    if (monto.text.isEmpty || interes.text.isEmpty || anos.text.isEmpty) {
      mensaje("Complete todos los campos");
      return;
    }

    double P = double.parse(monto.text);
    double tasa = double.parse(interes.text) / 100;
    int years = int.parse(anos.text);

    if (years < 1) {
      mensaje("Mínimo 1 años");
      return;
    }

    int n;
    double r;

    if (tipo == "Mensual") {
      n = years * 12;
      r = tasa / 12;
    } else {
      n = years * 52;
      r = tasa / 52;
    }

    double cuota = P * r / (1 - pow(1 + r, -n));

    setState(() {
      resultado = cuota;
    });
  }

  void mensaje(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Préstamo Consumo")),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          campo("Monto", monto),
          campo("Interés %", interes),
          campo("Años", anos),

          const SizedBox(height: 10),

          DropdownButtonFormField(
            value: tipo,

            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Tipo de pago",
            ),

            items: [
              "Mensual",
              "Semanal",
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),

            onChanged: (v) => setState(() => tipo = v!),
          ),

          const SizedBox(height: 20),

          FilledButton.icon(
            onPressed: calcular,
            icon: const Icon(Icons.calculate),
            label: const Text("Calcular"),
          ),

          const SizedBox(height: 25),

          if (resultado > 0)
            Card(
              elevation: 3,

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    const Text(
                      "Resultado",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "\$${resultado.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 28,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/* ================= HIPOTECA ================= */

class HipotecaScreen extends StatefulWidget {
  const HipotecaScreen({super.key});

  @override
  State<HipotecaScreen> createState() => _HipotecaScreenState();
}

class _HipotecaScreenState extends State<HipotecaScreen> {
  final monto = TextEditingController();
  final interes = TextEditingController();
  final anos = TextEditingController();

  String tipoPropiedad = "Casa";
  double cuota = 0;

  void calcular() {
    if (monto.text.isEmpty || interes.text.isEmpty || anos.text.isEmpty) {
      mensaje("Complete todos los campos");
      return;
    }

    double P = double.parse(monto.text);
    double tasa = double.parse(interes.text) / 100;
    int years = int.parse(anos.text);

    if (years < 5) {
      mensaje("Mínimo 5 años");
      return;
    }

    int n = years * 12;
    double r = tasa / 12;

    double c = P * r / (1 - pow(1 + r, -n));

    setState(() {
      cuota = c;
    });
  }

  void mensaje(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hipoteca")),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          campo("Monto", monto),
          campo("Interés %", interes),
          campo("Años", anos),

          const SizedBox(height: 10),

          DropdownButtonFormField(
            value: tipoPropiedad,

            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Tipo de propiedad",
            ),

            items: [
              "Casa",
              "Apartamento",
              "Terreno",
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),

            onChanged: (v) => setState(() => tipoPropiedad = v!),
          ),

          const SizedBox(height: 20),

          FilledButton.icon(
            onPressed: calcular,
            icon: const Icon(Icons.calculate),
            label: const Text("Calcular"),
          ),

          const SizedBox(height: 25),

          if (cuota > 0)
            Card(
              elevation: 3,

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    Text(
                      "Propiedad: $tipoPropiedad",
                      style: const TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "\$${cuota.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 26,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/* ================= INVERSION ================= */

class InversionScreen extends StatefulWidget {
  const InversionScreen({super.key});

  @override
  State<InversionScreen> createState() => _InversionScreenState();
}

class _InversionScreenState extends State<InversionScreen> {
  final capital = TextEditingController();
  final interes = TextEditingController();
  final anos = TextEditingController();

  double total = 0;
  double ganancia = 0;

  void calcular() {
    if (capital.text.isEmpty || interes.text.isEmpty || anos.text.isEmpty) {
      mensaje("Complete todos los campos");
      return;
    }

    double P = double.parse(capital.text);
    double tasa = double.parse(interes.text) / 100;
    int years = int.parse(anos.text);

    double montoFinal = P * pow(1 + tasa, years);

    setState(() {
      total = montoFinal;
      ganancia = montoFinal - P;
    });
  }

  void mensaje(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inversión")),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          campo("Capital inicial", capital),
          campo("Interés anual %", interes),
          campo("Años", anos),

          const SizedBox(height: 20),

          FilledButton.icon(
            onPressed: calcular,
            icon: const Icon(Icons.calculate),
            label: const Text("Calcular"),
          ),

          const SizedBox(height: 25),

          if (total > 0)
            Card(
              elevation: 3,

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    Text(
                      "Total: \$${total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Ganancia: \$${ganancia.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 18, color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/* ================= CAMPO ================= */

Widget campo(String texto, TextEditingController c) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),

    child: TextField(
      controller: c,

      keyboardType: TextInputType.number,

      decoration: InputDecoration(
        labelText: texto,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
