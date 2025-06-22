import 'package:flutter/material.dart';

class GananciasScreen extends StatefulWidget {
  const GananciasScreen({super.key});

  @override
  State<GananciasScreen> createState() => _GananciasScreenState();
}

class _GananciasScreenState extends State<GananciasScreen> {
  final TextEditingController _ingresosPecesController = TextEditingController();
  final TextEditingController _ingresosCosechaController = TextEditingController();
  final TextEditingController _otrosIngresosController = TextEditingController();

  @override
  void dispose() {
    _ingresosPecesController.dispose();
    _ingresosCosechaController.dispose();
    _otrosIngresosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00B2B2), // Fondo amigable
      appBar: AppBar(
        title: const Text('Ganancias de la Pecera'),
        backgroundColor: const Color(0xFF008C8C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Campo para los ingresos por venta de peces
            _buildTextField(_ingresosPecesController, 'Ingresos por Venta de Peces (Lps)', 'Ingrese los ingresos por venta de peces'),
            // Campo para los ingresos por cosecha
            _buildTextField(_ingresosCosechaController, 'Ingresos por Cosecha (Lps)', 'Ingrese los ingresos por cosecha'),
            // Campo para otros ingresos
            _buildTextField(_otrosIngresosController, 'Otros Ingresos (Lps)', 'Ingrese otros ingresos'),
            const SizedBox(height: 20),

            // Botón para guardar los datos de las ganancias
            ElevatedButton(
              onPressed: () {
                String ingresosPeces = _ingresosPecesController.text;
                String ingresosCosecha = _ingresosCosechaController.text;
                String otrosIngresos = _otrosIngresosController.text;

                // Aquí puedes agregar la lógica para guardar estos datos o realizar alguna acción
                print("Ingresos por Peces: $ingresosPeces, Ingresos por Cosecha: $ingresosCosecha, Otros Ingresos: $otrosIngresos");

                // Limpiar los campos después de guardar
                _ingresosPecesController.clear();
                _ingresosCosechaController.clear();
                _otrosIngresosController.clear();
              },
              child: const Text('Guardar Ganancias'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008C8C),
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para crear los campos de texto reutilizables
  Widget _buildTextField(TextEditingController controller, String label, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
        ),
      ),
    );
  }
}
