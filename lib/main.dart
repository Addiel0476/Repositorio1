import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const FinanzasApp());
}

/* ================= APP ================= */

class FinanzasApp extends StatelessWidget {
  const FinanzasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: false),

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
      /* ===== APPBAR PERSONALIZADO ===== */
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),

        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color.fromARGB(255, 189, 225, 190), const Color.fromARGB(255, 200, 230, 201)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),

          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 25),

                child: Text(
                  "Calculadora Financiera",

                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

      /* ===== BODY ===== */
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade100, Colors.grey.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              const Icon(Icons.account_balance, size: 90, color: Colors.green),

              const SizedBox(height: 15),

              const Text(
                "Bienvenido",

                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 30),

              animatedButton(
                context,
                "Préstamo de Consumo",
                Icons.payments,
                const ConsumoScreen(),
              ),

              animatedButton(
                context,
                "Préstamo Hipotecario",
                Icons.house,
                const HipotecaScreen(),
              ),

              animatedButton(
                context,
                "Cálculo de Inversión",
                Icons.trending_up,
                const InversionScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* ===== BOTONES ANIMADOS ===== */

  Widget animatedButton(
    BuildContext context,
    String text,
    IconData icon,
    Widget page,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1, end: 1),
      duration: const Duration(milliseconds: 200),

      builder: (context, scale, child) {
        return GestureDetector(
          onTapDown: (_) {
            scale = 0.95;
          },

          onTapUp: (_) {
            scale = 1;
          },

          onTapCancel: () {
            scale = 1;
          },

          child: Transform.scale(
            scale: scale,

            child: Card(
              elevation: 6,
              margin: const EdgeInsets.symmetric(vertical: 10),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),

              child: ListTile(
                leading: Icon(icon, color: Colors.green, size: 30),

                title: Text(
                  text,

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                trailing: const Icon(Icons.arrow_forward_ios),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => page),
                  );
                },
              ),
            ),
          ),
        );
      },
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

          ElevatedButton.icon(
            onPressed: calcular,
            icon: const Icon(Icons.calculate),
            label: const Text("Calcular"),
          ),

          const SizedBox(height: 25),

          if (resultado > 0)
            Card(
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

  String tipo = "Casa";
  double cuota = 0;

  void calcular() {
    if (monto.text.isEmpty || interes.text.isEmpty || anos.text.isEmpty) {
      mensaje("Complete todos los campos");
      return;
    }

    double P = double.parse(monto.text);
    double tasa = double.parse(interes.text) / 100;
    int years = int.parse(anos.text);

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
            value: tipo,

            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Tipo de propiedad",
            ),

            items: [
              "Casa",
              "Apartamento",
              "Terreno",
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),

            onChanged: (v) => setState(() => tipo = v!),
          ),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: calcular,
            icon: const Icon(Icons.calculate),
            label: const Text("Calcular"),
          ),

          const SizedBox(height: 25),

          if (cuota > 0)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    Text("Propiedad: $tipo"),

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
          campo("Capital", capital),
          campo("Interés %", interes),
          campo("Años", anos),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: calcular,
            icon: const Icon(Icons.calculate),
            label: const Text("Calcular"),
          ),

          const SizedBox(height: 25),

          if (total > 0)
            Card(
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
