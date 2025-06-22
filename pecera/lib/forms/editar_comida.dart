import 'package:flutter/material.dart';
import '../models/comidaModel.dart';
import '../services/comidaService.dart';

class EditarComidaScreen extends StatefulWidget {
  final Comida comida;

  const EditarComidaScreen({super.key, required this.comida});

  @override
  State<EditarComidaScreen> createState() => _EditarComidaScreenState();
}

class _EditarComidaScreenState extends State<EditarComidaScreen> {
  final ComidaService _comidaService = ComidaService();
  final TextEditingController _nombreComidaController = TextEditingController();
  final TextEditingController _marcaComidaController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  bool _estado = true;

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
    _nombreComidaController.text = widget.comida.nombreComida!;
    _marcaComidaController.text = widget.comida.marcaComida!;
    _cantidadController.text = widget.comida.cantidad.toString();
    _estado = widget.comida.estado!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC9F0FF),
      appBar: AppBar(
        title: const Text(
          'Editar Comida para Peces',
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
            const SizedBox(height: 16),
            _buildEstadoDropdown(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
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

                      double? cantidad =
                          double.tryParse(_cantidadController.text);

                      if (cantidad == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Por favor, ingrese un valor numérico válido para la cantidad.',
                                  style: TextStyle(fontSize: 18))),
                        );
                        return;
                      }

                      Comida comidaEditada = Comida(
                        id: widget.comida.id, // Mantener el ID original
                        nombreComida: _nombreComidaController.text.trim(),
                        marcaComida: _marcaComidaController.text.trim(),
                        cantidad: cantidad,
                        estado: _estado,
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
                                          'Actualizando comida...',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ));

                        bool? comidaActualizada = await _comidaService
                            .updateComida(widget.comida.id!, comidaEditada);
                        Navigator.pop(context);

                        if (comidaActualizada != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Comida actualizada exitosamente!',
                                    style: TextStyle(fontSize: 18))),
                          );
                          Navigator.pop(context, comidaActualizada);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Error al actualizar la comida. El servicio devolvió nulo.',
                                    style: TextStyle(fontSize: 18))),
                          );
                        }
                      } catch (e) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')),
                        );
                        print("Error al actualizar comida: $e");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF009788),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      shadowColor: Colors.black26,
                    ),
                    child: const Text(
                      'Actualizar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
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
            fontSize: 22
          ),
          floatingLabelStyle: TextStyle(
            color: floatingLabelColor,
            fontWeight: FontWeight.bold,
            fontSize: 22
          ),
          hintText: hint,
          hintStyle: TextStyle(
            color: labelColor.withOpacity(0.6),
            fontWeight: FontWeight.w500,
            fontSize: 18
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
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _buildEstadoDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownMenu<bool>(
        width: MediaQuery.of(context).size.width - 32,
        initialSelection: _estado,
        label: const Text('Estado de la comida'),
        leadingIcon: _estado
            ? Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20,
                ),
              )
            : Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                  size: 20,
                ),
              ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(
            color: Color(0xFF006064),
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
          floatingLabelStyle: const TextStyle(
            color: Color(0xFF009788),
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
                color: const Color(0xFF006064).withOpacity(0.3), width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Color(0xFF009788), width: 2.0),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        textStyle: const TextStyle(
          color: Color(0xFF37474F),
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
        menuStyle: MenuStyle(
          elevation: WidgetStateProperty.all(8),
          backgroundColor: WidgetStateProperty.all(Colors.white),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        onSelected: (bool? newValue) {
          setState(() {
            _estado = newValue ?? true;
          });
        },
        dropdownMenuEntries: [
          DropdownMenuEntry<bool>(
            value: true,
            label: 'Activa',
            style: ButtonStyle(
              textStyle: WidgetStateProperty.all(const TextStyle(
                fontSize: 22,
              )),
            ),
            leadingIcon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 20,
              ),
            ),
          ),
          DropdownMenuEntry<bool>(
            value: false,
            label: 'Inactiva',
            style: ButtonStyle(
              textStyle: WidgetStateProperty.all(const TextStyle(
                fontSize: 22,
              )),
            ),
            leadingIcon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.cancel,
                color: Colors.red,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
