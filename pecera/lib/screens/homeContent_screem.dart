import 'package:flutter/material.dart';
import '../forms/comidaPecera_screem.dart';
import '../forms/editar_pecera_screen.dart';
import '../models/peceraModel.dart';
import '../services/peceraService.dart';
import '../forms/crear_pecera_screen.dart';
import 'parametrosList_screem.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final PeceraService _peceraService = PeceraService();
  List<Pecera> _peceras = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPeceras();
  }

  void _navigateToCrearPeceraScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CrearPeceraScreen()),
    ).then((result) {
      if (result == true) {
        _loadPeceras();
      }
    });
  }

  Future<void> _loadPeceras() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final peceras = await _peceraService.getAllPeceras();

      setState(() {
        _peceras = peceras;
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
              'Error al cargar las peceras',
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
              onPressed: _loadPeceras,
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

    if (_peceras.isEmpty) {
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
          const SizedBox(height: 15),
          const Text(
            'Bienvenido a la gestión de peceras',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
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
              '¡No tienes peceras registradas!\nPuedes crear tu primera pecera para comenzar.',
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
              _navigateToCrearPeceraScreen();
            },
            icon: const Icon(
              Icons.add,
              size: 28,
            ),
            label: const Text(
              'Crear mi primera pecera',
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
      onRefresh: _loadPeceras,
      color: const Color(0xFF009788),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mis Peceras (${_peceras.length})',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: _loadPeceras,
                      icon: const Icon(Icons.refresh_outlined, size: 30),
                      color: const Color(0xFF009788),
                    ),
                    IconButton(
                        tooltip: 'Crear Pecera',
                        icon: const Icon(Icons.add_circle_outline, size: 30),
                        color: const Color(0xFF009788),
                        onPressed: () {
                          _navigateToCrearPeceraScreen();
                        }),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: _peceras.length,
                itemBuilder: (context, index) {
                  return _buildPeceraCard(_peceras[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeceraCard(Pecera pecera) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              const Color(0xFF009788).withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      pecera.nombrePecera!,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: pecera.estado! ? Colors.green : Colors.red,
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Color(0xFF009788),
                          size: 30,
                        ),
                        onSelected: (value) {
                          _handlePeceraAction(value, pecera);
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem<String>(
                            value: 'ver_detalles',
                            child: Row(
                              children: [
                                Icon(Icons.visibility,
                                    size: 23, color: Color(0xFF009788)),
                                SizedBox(width: 8),
                                Text(
                                  'Control de parametros',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'editar',
                            child: Row(
                              children: [
                                Icon(Icons.edit,
                                    size: 23, color: Colors.orange),
                                SizedBox(width: 8),
                                Text('Editar',
                                    style: const TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: pecera.esDestacada!
                                ? 'quitar_destacada'
                                : 'destacar',
                            child: Row(
                              children: [
                                Icon(
                                  pecera.esDestacada!
                                      ? Icons.star
                                      : Icons.star_border,
                                  size: 23,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                    pecera.esDestacada!
                                        ? 'Quitar destacada'
                                        : 'Destacar',
                                    style: const TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'comida',
                            child: Row(
                              children: [
                                Icon(Icons.food_bank_outlined,
                                    size: 23, color: Colors.blue),
                                SizedBox(width: 8),
                                Text('Dar comida',
                                    style: const TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'eliminar',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 23, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Eliminar',
                                    style: const TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              if (pecera.esDestacada!)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Destacada',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.iso, '${pecera.cantidadPeces} peces'),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.calendar_month,
                  'Siembra: ${_formatDate(pecera.fechaSiembra!)}'),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: const Color(0xFF009788),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 17,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _handlePeceraAction(String action, Pecera pecera) {
    switch (action) {
      case 'ver_detalles':
        _toggleCntrolParametro(pecera);
        break;
      case 'editar':
        _toggleUpdate(pecera);
        break;
      case 'destacar':
      case 'quitar_destacada':
        _toggleDestacada(pecera);
        break;
      case 'comida':
        _toggleComida(pecera);
        break;
      case 'eliminar':
        _toggleEliminar(pecera);
        break;
    }
  }

  Future<void> _toggleUpdate(Pecera pecera) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdatePeceraScreen(pecera: pecera),
      ),
    ).then((result) {
      if (result == true) {
        _loadPeceras();
      }
    });
  }

  Future<void> _toggleComida(Pecera pecera) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CrearComidaPeceraScreen(pecera: pecera),
      ),
    ).then((result) {
      if (result == true) {
        _loadPeceras();
      }
    });
  }

  Future<void> _toggleCntrolParametro(Pecera pecera) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListParametros(pecera: pecera),
      ),
    ).then((result) {
      if (result == true) {
        _loadPeceras();
      }
    });
  }

  Future<void> _toggleDestacada(Pecera pecera) async {
    try {
      final nuevaPecera = Pecera(
        id: pecera.id,
        cantidadPh: pecera.cantidadPh,
        nivelAgua: pecera.nivelAgua,
        cantidadOxigenoDisuelto: pecera.cantidadOxigenoDisuelto,
        nombrePecera: pecera.nombrePecera,
        cantidadPeces: pecera.cantidadPeces,
        fechaSiembra: pecera.fechaSiembra,
        estado: pecera.estado,
        esDestacada: !pecera.esDestacada!,
      );

      final fueExitosa = await _peceraService.updateFeatured(
          nuevaPecera.id!, nuevaPecera.esDestacada!);
      if (fueExitosa) {
        setState(() {
          final index = _peceras.indexWhere((p) => p.id == pecera.id);
          if (index != -1) {
            _peceras[index] = nuevaPecera;
            _loadPeceras();
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(nuevaPecera.esDestacada!
                ? '${nuevaPecera.nombrePecera} ahora es destacada'
                : '${nuevaPecera.nombrePecera} ya no es destacada'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo actualizar la pecera')),
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(nuevaPecera.esDestacada!
              ? '${nuevaPecera.nombrePecera} ahora es destacada'
              : '${nuevaPecera.nombrePecera} ya no es destacada'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar: ${e.toString()}')),
      );
    }
  }

  Future<void> _toggleEliminar(Pecera pecera) async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación',
              style: TextStyle(color: Colors.black, fontSize: 22)),
          content:
              const Text('¿Estás seguro de que deseas eliminar esta pecera?',
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
      Map<String, dynamic> resultado =
          await _peceraService.deletePecera(pecera.id!);
      Navigator.pop(context);

      if (resultado['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resultado['message'],
                style: const TextStyle(fontSize: 18)),
            backgroundColor: Colors.green,
          ),
        );
        _loadPeceras(); // Recargar la lista
      } else {
        String mensaje = resultado['message'];
        if (mensaje.contains('siendo utilizada en otras partes del sistema')) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('No se puede eliminar',
                  textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.deepOrange, fontSize: 22),),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.warning, color: Colors.orange, size: 48),
                    const SizedBox(height: 16),
                    Text(mensaje,
                        style: const TextStyle(fontSize: 20),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                  ],
                ),
                actions: [
                  TextButton(
                    child:
                        const Text('Entendido', style: TextStyle(fontSize: 20)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(mensaje, style: const TextStyle(fontSize: 18)),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error inesperado: ${e.toString()}',
              style: const TextStyle(fontSize: 18)),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
      print("Error al eliminar la pecera: $e");
    }
  }
}
