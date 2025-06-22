import 'package:flutter/material.dart';

class GastosScreen extends StatefulWidget {
  const GastosScreen({super.key});

  @override
  State<GastosScreen> createState() => _GastosScreenState();
}

class _GastosScreenState extends State<GastosScreen> {
  final TextEditingController _comidaController = TextEditingController();
  final TextEditingController _empleadosController = TextEditingController();
  final TextEditingController _energiaController = TextEditingController();
  final TextEditingController _otrosController = TextEditingController();

  @override
  void dispose() {
    _comidaController.dispose();
    _empleadosController.dispose();
    _energiaController.dispose();
    _otrosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00B2B2),  // Fondo amigable
      appBar: AppBar(
        title: const Text('Gastos de la Pecera'),
        backgroundColor: const Color(0xFF008C8C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Campo para el gasto de comida
            _buildTextField(_comidaController, 'Gasto en Comida (Lps)', 'Ingrese el gasto de comida'),
            // Campo para el gasto en empleados
            _buildTextField(_empleadosController, 'Gasto en Empleados (Lps)', 'Ingrese el gasto en empleados'),
            // Campo para el gasto en energía
            _buildTextField(_energiaController, 'Gasto en Energía (Lps)', 'Ingrese el gasto de energía'),
            // Campo para otros gastos
            _buildTextField(_otrosController, 'Otros Gastos (Lps)', 'Ingrese otros gastos'),
            const SizedBox(height: 20),

            // Botón para guardar los datos de los gastos
            ElevatedButton(
              onPressed: () {
                String comida = _comidaController.text;
                String empleados = _empleadosController.text;
                String energia = _energiaController.text;
                String otros = _otrosController.text;

                // Aquí puedes agregar la lógica para guardar estos datos o realizar alguna acción
                print("Comida: $comida, Empleados: $empleados, Energía: $energia, Otros Gastos: $otros");

                // Limpiar los campos después de guardar
                _comidaController.clear();
                _empleadosController.clear();
                _energiaController.clear();
                _otrosController.clear();
              },
              child: const Text('Guardar Gastos'),
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
