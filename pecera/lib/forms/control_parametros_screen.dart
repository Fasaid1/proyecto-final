import 'package:flutter/material.dart';

import '../models/parametroModel.dart';
import '../services/controlParametrosService.dart';

class ControlParametrosScreen extends StatefulWidget {
  final int peceraId;
  const ControlParametrosScreen({super.key, required this.peceraId});

  @override
  State<ControlParametrosScreen> createState() =>
      _ControlParametrosScreenState();
}

class _ControlParametrosScreenState extends State<ControlParametrosScreen> {
  final ControlParametrosService _controlParametrosService =
      ControlParametrosService();
  final TextEditingController _temperaturaController = TextEditingController();
  final TextEditingController _phController = TextEditingController();
  final TextEditingController _oxigenoController = TextEditingController();
  final TextEditingController _nitratosController = TextEditingController();
  final TextEditingController _nitritosController = TextEditingController();
  final TextEditingController _amoniacoController = TextEditingController();
  final TextEditingController _densidadPecesController =
      TextEditingController();
  final TextEditingController _nivelAguaController = TextEditingController();
  late int _peceraId;

  @override
  void dispose() {
    _temperaturaController.dispose();
    _phController.dispose();
    _oxigenoController.dispose();
    _nitratosController.dispose();
    _nitritosController.dispose();
    _amoniacoController.dispose();
    _densidadPecesController.dispose();
    _nivelAguaController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _peceraId = widget.peceraId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC9F0FF),
      appBar: AppBar(
        title: const Text(
          'Control de Parámetros de Pecera',
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
                    _temperaturaController,
                    'Temperatura (°C)',
                    'Ingrese la temperatura',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    _phController,
                    'pH',
                    'Ingrese el pH del agua',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _oxigenoController,
                    'Oxígeno disuelto (mg/L)',
                    'Ingrese el nivel de O₂',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    _nitratosController,
                    'Nitratos (mg/L)',
                    'Ingrese nivel de nitratos',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _nitritosController,
                    'Nitritos (mg/L)',
                    'Ingrese nivel de nitritos',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    _amoniacoController,
                    'Amoníaco (mg/L)',
                    'Ingrese nivel de amoníaco',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _densidadPecesController,
                    'Densidad de peces (peces/m²)',
                    'Ingrese densidad de peces',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    _nivelAguaController,
                    'Nivel de agua (cm)',
                    'Ingrese el nivel de agua',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_temperaturaController.text.isEmpty &&
                    _phController.text.isEmpty &&
                    _oxigenoController.text.isEmpty &&
                    _nitratosController.text.isEmpty &&
                    _nitritosController.text.isEmpty &&
                    _amoniacoController.text.isEmpty &&
                    _densidadPecesController.text.isEmpty &&
                    _nivelAguaController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                      'Por favor, complete al menos un campo.',
                      style: TextStyle(fontSize: 18),
                    )),
                  );
                  return;
                }

                double? temperatura =
                    double.tryParse(_temperaturaController.text);
                double? ph = double.tryParse(_phController.text);
                double? oxigeno = double.tryParse(_oxigenoController.text);
                double? nitratos = double.tryParse(_nitratosController.text);
                double? nitritos = double.tryParse(_nitritosController.text);
                double? amoniaco = double.tryParse(_amoniacoController.text);
                double? densidadPeces =
                    double.tryParse(_densidadPecesController.text);
                double? nivelAgua = double.tryParse(_nivelAguaController.text);

                if (temperatura == null ||
                    nitratos == null ||
                    ph == null ||
                    oxigeno == null ||
                    nivelAgua == null ||
                    nitritos == null ||
                    amoniaco == null ||
                    densidadPeces == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Por favor, ingrese valores numéricos válidos.')),
                  );
                  return;
                }

                ControlParametros nuevoControlParametros = ControlParametros(
                  peceraId: _peceraId,
                  temperatura: temperatura,
                  oxigenoDisuelto: oxigeno,
                  nitratos: nitratos,
                  nitritos: nitritos,
                  amoniaco: amoniaco,
                  densidadPeces: densidadPeces,
                  nivelAgua: nivelAgua,
                  estado: true,
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
                                    'Registrando parametros...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                  ControlParametros? parametrosRegistrados =
                      await _controlParametrosService
                          .createControlParametros(nuevoControlParametros);
                  Navigator.pop(context);
                  if (parametrosRegistrados != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Registro de parametros creado exitosamente!',
                              style: TextStyle(fontSize: 18))),
                    );
                    _temperaturaController.clear();
                    _phController.clear();
                    _oxigenoController.clear();
                    _nitratosController.clear();
                    _nitritosController.clear();
                    _amoniacoController.clear();
                    _densidadPecesController.clear();
                    _nivelAguaController.clear();
                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Error al crear el registro de parametros. El servicio devolvió nulo.',
                              style: TextStyle(fontSize: 18))),
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
                'Guardar Parámetros',
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

  // Widget para crear los campos de texto reutilizables
  Widget _buildTextField(
      TextEditingController controller, String label, String hint) {
    Color labelColor = const Color(0xFF006064);
    Color floatingLabelColor = const Color(0xFF009788);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
          color: Color(0xFF37474F),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
