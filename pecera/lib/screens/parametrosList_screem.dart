import 'package:flutter/material.dart';
import '../forms/control_parametros_screen.dart';
import '../models/parametroModel.dart';
import '../models/peceraModel.dart';
import '../services/controlParametrosService.dart';


class ListParametros extends StatefulWidget {
  final Pecera pecera;
  const ListParametros({super.key, required this.pecera});

  @override
  State<ListParametros> createState() => _ListParametrosState();
}

class _ListParametrosState extends State<ListParametros> {
  final ControlParametrosService _controlParametrosService =
      ControlParametrosService();
  late int _peceraId;
  List<ControlParametros> _controlParametros = [];
  bool _isLoading = true;
  String? _errorMessage;
  var pecera;

  @override
  void initState() {
    super.initState();
    _peceraId = widget.pecera.id!;
    pecera = widget.pecera;
    _loadControlParametros();
  }

  void _navigateToCrearControlParametrosScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ControlParametrosScreen(peceraId: widget.pecera.id!),
      ),
    ).then((result) {
      if (result == true) {
        _loadControlParametros();
      }
    });
  }

  Future<void> _loadControlParametros() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final controlParametros = await _controlParametrosService
          .getAllControlParametrosById(_peceraId);

      setState(() {
        _controlParametros = controlParametros;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC9F0FF),
      appBar: AppBar(
        title: Text(
          'Parámetros de ${widget.pecera.nombrePecera}',
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF009788),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF009788),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar los control de parametros',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadControlParametros,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF009788),
                foregroundColor: Colors.white,
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_controlParametros.isEmpty) {
      return _buildWelcomeMessage();
    }

    return _buildPecerasGrid();
  }

  Widget _buildWelcomeMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.water_drop,
            size: 100,
            color: const Color(0xFF009788).withOpacity(0.7),
          ),
          const SizedBox(height: 30),
          const Text(
            'PecerasApp',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: const Color(0xFF009788).withOpacity(0.3)),
            ),
            child: const Text(
              '¡No tienes parametros registrados!\nPuedes crear tu primer control de parameros para comenzar.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              _navigateToCrearControlParametrosScreen();
            },
            icon: const Icon(
              Icons.add,
              size: 28,
            ),
            label: const Text(
              'Crear mi control de parametros',
              style: TextStyle(fontSize: 18),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF009788),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPecerasGrid() {
    return RefreshIndicator(
      onRefresh: _loadControlParametros,
      color: const Color(0xFF009788),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Mis Parametros de la Pecera: \n${widget.pecera.nombrePecera}',
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: _loadControlParametros,
                      icon: const Icon(Icons.refresh_outlined, size: 30),
                      color: const Color(0xFF009788),
                    ),
                    IconButton(
                        tooltip: 'Crear Control de Parametros',
                        icon: const Icon(Icons.add_circle_outline, size: 30),
                        color: const Color(0xFF009788),
                        onPressed: () {
                          _navigateToCrearControlParametrosScreen();
                        }),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _controlParametros.length,
                itemBuilder: (context, index) {
                  return _buildControlParametrosList(_controlParametros[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlParametrosList(ControlParametros controlParametro) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ExpansionTile(
        key: ValueKey(controlParametro.id),
        title: Text(
          'Parámetro registrado: ${controlParametro.createdAt ?? 'Sin fecha'}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: const Icon(
          Icons.water_drop,
          color: Color(0xFF009788),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
              },
              children: [
                _buildTableRow('Temperatura:',
                    controlParametro.temperatura?.toString() ?? 'N/A'),
                if (controlParametro.oxigenoDisuelto != null)
                  _buildTableRow('Oxigeno Disuelto:',
                      controlParametro.oxigenoDisuelto.toString()),
                if (controlParametro.oxigenoDisuelto != null)
                  _buildTableRow(
                      'Nitratos:', controlParametro.nitratos.toString()),
                if (controlParametro.oxigenoDisuelto != null)
                  _buildTableRow(
                      'Nitritos:', controlParametro.nitritos.toString()),
                if (controlParametro.oxigenoDisuelto != null)
                  _buildTableRow(
                      'Amoniaco:', controlParametro.amoniaco.toString()),
                if (controlParametro.oxigenoDisuelto != null)
                  _buildTableRow('densidad de peces:',
                      controlParametro.densidadPeces.toString()),
                if (controlParametro.oxigenoDisuelto != null)
                  _buildTableRow(
                      'Nivel del agua:', controlParametro.nivelAgua.toString()),
              ],
            ),
          ),
          // Fila de acciones debajo de la tabla
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: Icon(Icons.delete_outline,
                      color: Colors.red[700], size: 20),
                  label: Text(
                    'Eliminar',
                    style: TextStyle(color: Colors.red[700], fontSize: 20),
                  ),
                  onPressed: () {
                    if (controlParametro.id != null) {
                      _eliminarControlParametro(controlParametro.id!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'No se puede eliminar: ID del parámetro no disponible.'),
                            backgroundColor: Colors.orange),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Text(
            label,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.deepOrange,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _eliminarControlParametro(int controlParametroId) async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación',
              style: TextStyle(color: Colors.black, fontSize: 22)),
          content: const Text(
              '¿Estás seguro de que deseas eliminar este registro de parámetros?',
              style: TextStyle(
                color: Colors.black,
                fontStyle: FontStyle.italic,
                fontSize: 18,
              )),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar',
                  style: TextStyle(
                    fontSize: 18,
                  )),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar', style: TextStyle(fontSize: 18)),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmar != true) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Color(0xFF009788)),
                SizedBox(width: 20),
                Text("Eliminando...", style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
        );
      },
    );
    try {
      bool eliminado = await _controlParametrosService
          .deleteControlParametros(controlParametroId);
      Navigator.pop(context); // Cerrar indicador de carga

      if (eliminado) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Registro de parámetros eliminado exitosamente.',
                  style: TextStyle(fontSize: 18)),
              backgroundColor: Colors.green),
        );
        _loadControlParametros();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error al eliminar el registro de parámetros.',
                  style: TextStyle(fontSize: 18)),
              backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Cerrar indicador de carga
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red),
      );
      print("Error al eliminar control de parámetro: $e");
    }
  }
}
