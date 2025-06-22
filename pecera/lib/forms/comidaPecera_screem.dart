import 'package:flutter/material.dart';
import '../models/comidaModel.dart';
import '../models/comidaPeceraModel.dart';
import '../models/peceraModel.dart';
import '../services/comidaService.dart';

class CrearComidaPeceraScreen extends StatefulWidget {
  final Pecera pecera;
  const CrearComidaPeceraScreen({super.key, required this.pecera});

  @override
  State<CrearComidaPeceraScreen> createState() =>
      _CrearComidaPeceraScreenState();
}

class _CrearComidaPeceraScreenState extends State<CrearComidaPeceraScreen> {
  final ComidaService _comidaService = ComidaService();
  final TextEditingController _cantidadController = TextEditingController();

  List<Comida> _comidas = [];
  Comida? _comidaSeleccionada;
  bool _isLoadingComidas = true;
  late int _peceraId;

  @override
  void dispose() {
    _cantidadController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _peceraId = widget.pecera.id!;
    _loadComidas();
  }

  Future<void> _loadComidas() async {
    try {
      setState(() {
        _isLoadingComidas = true;
      });

      List<Comida>? comidas = await _comidaService.getAllComida();

      setState(() {
        _comidas = comidas.where((comida) => comida.estado == true).toList() ?? [];
        _isLoadingComidas = false;
      });

      if (_comidas.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No hay comidas registradas. Debe crear una comida primero.',
              style: TextStyle(fontSize: 18),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoadingComidas = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar comidas: ${e.toString()}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC9F0FF),
      appBar: AppBar(
        title: const Text(
          'Asignar Comida a Pecera',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF009788),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildComidaDropdown(),
            const SizedBox(height: 16),
            _buildTextField(
              _cantidadController,
              'Cantidad (libras)',
              'Ingrese la cantidad en libras',
              isNumeric: true,
            ),
            const SizedBox(height: 20),

            // Botón guardar
            ElevatedButton(
              onPressed: _isLoadingComidas || _comidas.isEmpty
                  ? null
                  : () async {
                      if (_comidaSeleccionada == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Por favor, seleccione una comida.',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                        return;
                      }

                      if (_cantidadController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Por favor, ingrese la cantidad.',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                        return;
                      }

                      double? cantidad =
                          double.tryParse(_cantidadController.text);

                      if (cantidad == null || cantidad <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Por favor, ingrese un valor numérico válido mayor a 0.',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                        return;
                      }

                      ComidaPecera nuevaComidaPecera = ComidaPecera(
                        peceraId: _peceraId,
                        comidaId: _comidaSeleccionada!.id!,
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
                                    'Asignando comida a pecera...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );

                        ComidaPecera? comidaPeceraRegistrada =
                            await _comidaService
                                .createComidaPecera(nuevaComidaPecera);

                        Navigator.pop(context);

                        if (comidaPeceraRegistrada != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Comida asignada a pecera exitosamente!',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          );
                          _cantidadController.clear();
                          setState(() {
                            _comidaSeleccionada = null;
                          });
                          Navigator.pop(context, true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Error al asignar comida a pecera. El servicio devolvió nulo.',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')),
                        );
                        print("Error al crear comida pecera: $e");
                      }
                    },
              child: _isLoadingComidas
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Asignar Comida a Pecera',
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

  Widget _buildComidaDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: _isLoadingComidas
          ? Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: const Color(0xFF006064).withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: const Row(
                children: [
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Color(0xFF009788),
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Cargando comidas...',
                    style: TextStyle(
                      color: Color(0xFF37474F),
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            )
          : DropdownMenu<Comida>(
              width: MediaQuery.of(context).size.width - 32,
              initialSelection: _comidaSeleccionada,
              label: const Text('Seleccionar Comida'),
              hintText: 'Seleccione una comida',
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
                hintStyle: TextStyle(
                  color: const Color(0xFF006064).withOpacity(0.6),
                  fontSize: 18,
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
                      color: const Color(0xFF006064).withOpacity(0.3),
                      width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide:
                      const BorderSide(color: Color(0xFF009788), width: 2.0),
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
              onSelected: (Comida? newValue) {
                setState(() {
                  _comidaSeleccionada = newValue;
                });
              },
              dropdownMenuEntries: _comidas.map((Comida comida) {
                return DropdownMenuEntry<Comida>(
                  value: comida,
                  label: '${comida.nombreComida} - ${comida.marcaComida}',
                  style: ButtonStyle(
                    textStyle: WidgetStateProperty.all(const TextStyle(
                      fontSize: 20,
                    )),
                  ),
                  leadingIcon: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF009788).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                );
              }).toList(),
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
              color: labelColor, fontWeight: FontWeight.w500, fontSize: 18),
          floatingLabelStyle: TextStyle(
              color: floatingLabelColor,
              fontWeight: FontWeight.bold,
              fontSize: 22),
          hintText: hint,
          hintStyle:
              TextStyle(color: labelColor.withOpacity(0.6), fontSize: 18),
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
