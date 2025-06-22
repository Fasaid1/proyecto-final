import 'package:flutter/material.dart';
import '../models/comidaModel.dart';
import '../services/comidaService.dart';

class CrearComidaScreen extends StatefulWidget {
  const CrearComidaScreen({super.key});

  @override
  State<CrearComidaScreen> createState() => _ComidaScreenState();
}

class _ComidaScreenState extends State<CrearComidaScreen> {
  final ComidaService _comidaService = ComidaService();
  final TextEditingController _nombreComidaController = TextEditingController();
  final TextEditingController _marcaComidaController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();

  @override
  void dispose() {
    _nombreComidaController.dispose();
    _marcaComidaController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC9F0FF),
      appBar: AppBar(
        title: const Text(
          'Registro de Comida para Peces',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF009788),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextField(
              _nombreComidaController,
              'Nombre de la Comida',
              'Ingrese el nombre de la comida',
              isNumeric: false,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              _marcaComidaController,
              'Marca de la Comida',
              'Ingrese la marca de la comida',
              isNumeric: false,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              _cantidadController,
              'Cantidad (libras)',
              'Ingrese la cantidad en libras',
              isNumeric: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_nombreComidaController.text.isEmpty ||
                    _marcaComidaController.text.isEmpty ||
                    _cantidadController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                      'Por favor, complete todos los campos.',
                      style: TextStyle(fontSize: 18),
                    )),
                  );
                  return;
                }

                double? cantidad = double.tryParse(_cantidadController.text);

                if (cantidad == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Por favor, ingrese un valor numérico válido para la cantidad.',
                            style: TextStyle(fontSize: 18))),
                  );
                  return;
                }

                Comida nuevaComida = Comida(
                  nombreComida: _nombreComidaController.text.trim(),
                  marcaComida: _marcaComidaController.text.trim(),
                  cantidad: cantidad,
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
                                    'Registrando comida...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                  Comida? comidaRegistrada =
                      await _comidaService.createComida(nuevaComida);
                  Navigator.pop(context);
                  if (comidaRegistrada != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Registro de comida creado exitosamente!',
                              style: TextStyle(fontSize: 18))),
                    );
                    _nombreComidaController.clear();
                    _marcaComidaController.clear();
                    _cantidadController.clear();
                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Error al crear el registro de comida. El servicio devolvió nulo.',
                              style: TextStyle(fontSize: 18))),
                    );
                  }
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                  print("Error al crear registro de comida: $e");
                }
              },
              child: const Text(
                'Guardar Registro de Comida',
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
      TextEditingController controller, String label, String hint,
      {bool isNumeric = false}) {
    Color labelColor = const Color(0xFF006064);
    Color floatingLabelColor = const Color(0xFF009788);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumeric
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
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
