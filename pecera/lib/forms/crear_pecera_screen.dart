import 'package:flutter/material.dart';
import '../models/peceraModel.dart';
import '../services/peceraService.dart';

class CrearPeceraScreen extends StatefulWidget {
  const CrearPeceraScreen({super.key});

  @override
  State<CrearPeceraScreen> createState() => _CrearPeceraScreenState();
}

class _CrearPeceraScreenState extends State<CrearPeceraScreen> {
  final PeceraService _peceraService = PeceraService();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _cantidadPecesController =
      TextEditingController();
  final TextEditingController _phController = TextEditingController();
  final TextEditingController _oxigenoController = TextEditingController();
  final TextEditingController _nivelAguaController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _cantidadPecesController.dispose();
    _phController.dispose();
    _oxigenoController.dispose();
    _nivelAguaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC9F0FF),
      appBar: AppBar(
        title: const Text(
          'Crear Pecera',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF009788),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _nombreController,
                    'Nombre de la pecera',
                    'Ingrese el nombre',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    _cantidadPecesController,
                    'Cantidad de peces',
                    'Ingrese cantidad',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _phController,
                    'pH',
                    'Ingrese el pH',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    _oxigenoController,
                    'Oxígeno disuelto (mg/L)',
                    'Ingrese O₂ disuelto',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _nivelAguaController,
                    'Nivel de agua (cm)',
                    'Ingrese nivel de agua',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_nombreController.text.isEmpty &&
                    _cantidadPecesController.text.isEmpty &&
                    _phController.text.isEmpty &&
                    _oxigenoController.text.isEmpty &&
                    _nivelAguaController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Por favor, complete todos los campos requeridos.')),
                  );
                  return;
                }

                String nombre = _nombreController.text;
                int? cantidadPeces =
                    int.tryParse(_cantidadPecesController.text);
                double? ph = double.tryParse(_phController.text);
                double? oxigeno = double.tryParse(_oxigenoController.text);
                double? nivelAgua = double.tryParse(_nivelAguaController.text);
                DateTime fechaSiembraActual = DateTime.now();

                if (cantidadPeces == null ||
                    ph == null ||
                    oxigeno == null ||
                    nivelAgua == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Por favor, ingrese valores numéricos válidos.')),
                  );
                  return;
                }

                Pecera nuevaPecera = Pecera(
                  nombrePecera: nombre,
                  cantidadPeces: cantidadPeces,
                  cantidadPh: ph,
                  cantidadOxigenoDisuelto: oxigeno,
                  nivelAgua: nivelAgua,
                  fechaSiembra: fechaSiembraActual,
                  estado: true,
                  esDestacada: false,
                );

                try {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => Dialog(
                            backgroundColor: Colors.transparent,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(
                                    color: Color(0xFF009788),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Creando pecera...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                  Pecera? peceraCreada =
                      await _peceraService.createPecera(nuevaPecera);
                  Navigator.pop(context);

                  if (peceraCreada != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Pecera "${peceraCreada.nombrePecera}" creada exitosamente!')),
                    );
                    _nombreController.clear();
                    _cantidadPecesController.clear();
                    _phController.clear();
                    _oxigenoController.clear();
                    _nivelAguaController.clear();
                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Error al crear la pecera. El servicio devolvió nulo.')),
                    );
                  }
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                  print("Error al crear pecera: $e");
                }
              },
              child: const Text(
                'Guardar Pecera',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF009788),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                shadowColor: Colors.black26,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String hint) {
    Color labelColor =
        const Color(0xFF006064);
    Color floatingLabelColor = const Color(0xFF009788);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: label.toLowerCase().contains("nombre")
            ? TextInputType.text
            : TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: labelColor,
            fontWeight: FontWeight.w500,
          ),
          floatingLabelStyle: TextStyle(
            color: floatingLabelColor,
            fontWeight: FontWeight.bold,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            color: labelColor.withOpacity(0.6),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: labelColor.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide:
                BorderSide(color: labelColor.withOpacity(0.4), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: floatingLabelColor, width: 2.0),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.95),
        ),
        style: const TextStyle(
          color:
              Color(0xFF37474F),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
