import 'package:flutter/material.dart';
import '../models/peceraModel.dart';
import '../services/peceraService.dart';

class UpdatePeceraScreen extends StatefulWidget {
  final Pecera pecera;

  const UpdatePeceraScreen({super.key, required this.pecera});

  @override
  State<UpdatePeceraScreen> createState() => _UpdatePeceraScreenState();
}

class _UpdatePeceraScreenState extends State<UpdatePeceraScreen> {
  final PeceraService _peceraService = PeceraService();
  final TextEditingController _nombreController = TextEditingController();
  bool _estado = true;
  bool _esDestacada = false;

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.pecera.nombrePecera ?? '';
    _estado = widget.pecera.estado ?? true;
    _esDestacada = widget.pecera.esDestacada ?? false;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC9F0FF),
      appBar: AppBar(
        title: const Text(
          'Actualizar Pecera',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF009788),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextField(
              _nombreController,
              'Nombre de la pecera',
              'Ingrese el nombre',
            ),
            const SizedBox(height: 16),
            _buildDestacadaDropdown(),
            const SizedBox(height: 16),
            _buildEstadoDropdown(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_nombreController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Por favor, complete todos los campos requeridos.')),
                  );
                  return;
                }

                String nombre = _nombreController.text;

                Pecera peceraActualizada = Pecera(
                  id: widget.pecera.id,
                  nombrePecera: nombre,
                  cantidadPeces: widget.pecera.cantidadPeces,
                  cantidadOxigenoDisuelto:
                      widget.pecera.cantidadOxigenoDisuelto,
                  nivelAgua: widget.pecera.nivelAgua,
                  cantidadPh: widget.pecera.cantidadPh,
                  fechaSiembra: widget.pecera.fechaSiembra,
                  estado: _estado,
                  esDestacada: _esDestacada,
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
                                    'Actualizando pecera...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));

                  bool actualizada = await _peceraService.updatePecera(
                      widget.pecera.id!, peceraActualizada);
                  Navigator.pop(context); // Cerrar el diálogo de carga

                  if (actualizada) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Pecera "${peceraActualizada.nombrePecera}" actualizada exitosamente!')),
                    );
                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Error al actualizar la pecera.')),
                    );
                  }
                } catch (e) {
                  Navigator.pop(context); // Cerrar el diálogo de carga
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                  print("Error al actualizar pecera: $e");
                }
              },
              child: const Text(
                'Actualizar Pecera',
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
    Color labelColor = const Color(0xFF006064);
    Color floatingLabelColor = const Color(0xFF009788);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: label.toLowerCase().contains("nombre")
            ? TextInputType.text
            : const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: labelColor,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
          floatingLabelStyle: TextStyle(
            color: floatingLabelColor,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            color: labelColor.withOpacity(0.6),
            fontSize: 20,
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
        label: const Text('Estado de la pecera'),
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

  Widget _buildDestacadaDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownMenu<bool>(
        width: MediaQuery.of(context).size.width -
            32, // Ajusta el ancho según sea necesario
        initialSelection: _esDestacada,
        label: const Text('Pecera destacada'),
        leadingIcon: _esDestacada
            ? Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 20,
                ),
              )
            : Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.star_border,
                  color: Colors.grey,
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
            _esDestacada = newValue ?? false;
          });
        },
        dropdownMenuEntries: [
          DropdownMenuEntry<bool>(
            value: true,
            label: 'Destacada',
            style: ButtonStyle(
              textStyle: WidgetStateProperty.all(const TextStyle(
                fontSize: 22,
              )),
            ),
            leadingIcon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.star,
                color: Colors.amber,
                size: 20,
              ),
            ),
          ),
          DropdownMenuEntry<bool>(
            value: false,
            label: 'No destacada',
            style: ButtonStyle(
              textStyle: WidgetStateProperty.all(const TextStyle(
                fontSize: 22,
              )),
            ),
            leadingIcon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.star_border,
                color: Colors.grey,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
