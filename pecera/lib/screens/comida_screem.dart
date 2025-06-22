import 'package:flutter/material.dart';

import '../forms/crear_comida.dart';
import '../forms/editar_comida.dart';
import '../models/comidaModel.dart';
import '../services/comidaService.dart';

class ComidaScreen extends StatefulWidget {
  const ComidaScreen({super.key});

  @override
  State<ComidaScreen> createState() => _ComidaScreenState();
}

class _ComidaScreenState extends State<ComidaScreen> {
  final ComidaService _comidaService = ComidaService();
  List<Comida> _comida = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadComida();
  }

  void _navigateToCrearComidaScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CrearComidaScreen()),
    ).then((result) {
      if (result == true) {
        _loadComida();
      }
    });
  }

  void _navigateToEditarComidaScreen(Comida comida) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarComidaScreen(comida: comida),
      ),
    ).then((result) {
      if (result == true) {
        _loadComida();
      }
    });
  }

  Future<void> _deleteComida(Comida comida) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          content: Text(
            '¿Estás seguro de que quieres eliminar "${comida.nombreComida ?? 'esta comida'}"?',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontStyle: FontStyle.italic,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar',
                  style: TextStyle(fontSize: 20)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Eliminar',
                  style: TextStyle(fontSize: 20)),
            ),
          ],
        );
      },
    );

    if (confirm == true && comida.id != null) {
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
        /*setState(() {
          _isLoading = true;
        });*/

        Map<String, dynamic> resultado =
            await _comidaService.deleteComida(comida.id!);
        Navigator.pop(context);

        if (resultado['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(resultado['message'],
                  style: const TextStyle(fontSize: 18)),
              backgroundColor: Colors.green,
            ),
          );
          _loadComida();
        } else {
          String mensaje = resultado['message'];
          if (mensaje
              .contains('siendo utilizada en otras partes del sistema')) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    'No se puede eliminar',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.deepOrange, fontSize: 22),
                  ),
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
                      child: const Text('Entendido',
                          style: TextStyle(fontSize: 20)),
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

  Future<void> _loadComida() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final comida = await _comidaService.getAllComida();

      setState(() {
        _comida = comida;
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
              'Error al cargar el inventario de comida',
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
              onPressed: _loadComida,
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

    if (_comida.isEmpty) {
      return _buildWelcomeMessage();
    }

    return buildComidaPageView();
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
              '¡No tienes comida registrada en tu inventario!\nPuedes crear tu primer registro para comenzar.',
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
              _navigateToCrearComidaScreen();
            },
            icon: const Icon(
              Icons.add,
              size: 28,
            ),
            label: const Text(
              'Crear mi primer registro de comida',
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

  Widget buildComidaPageView() {
    return RefreshIndicator(
      onRefresh: _loadComida,
      color: const Color(0xFF009788),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Inventario de comida: (${_comida.length})',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: _loadComida,
                      icon: const Icon(Icons.refresh_outlined, size: 30),
                      color: const Color(0xFF009788),
                    ),
                    IconButton(
                      tooltip: 'Crear registro de comida',
                      icon: const Icon(Icons.add_circle_outline, size: 30),
                      color: const Color(0xFF009788),
                      onPressed: _navigateToCrearComidaScreen,
                    ),
                  ],
                )
              ],
            ),
          ),

          Expanded(
            child: PageView.builder(
              itemCount: (_comida.length / 2).ceil(),
              itemBuilder: (context, pageIndex) {
                final startIndex = pageIndex * 2;
                final endIndex = (startIndex + 2).clamp(0, _comida.length);
                final pageItems = _comida.sublist(startIndex, endIndex);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      for (int i = 0; i < pageItems.length; i++) ...[
                        Expanded(
                          child: _buildComidaCard(pageItems[i]),
                        ),
                        if (i < pageItems.length - 1)
                          const SizedBox(height: 16),
                      ],
                      if (pageItems.length == 1)
                        const Expanded(child: SizedBox()),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComidaCard(Comida comida) {
    final peceras = comida.peceras ?? [];

    return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Color(0xFFF8FDFF),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: const Color(0xFF009788).withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: const Color(0xFF009788).withOpacity(0.1),
            width: 1,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF009788),
                            const Color(0xFF009788).withOpacity(0.8),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF009788).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.restaurant,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comida.nombreComida ?? 'Sin nombre',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: -0.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (comida.marcaComida != null &&
                              comida.marcaComida!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              comida.marcaComida!,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Botón editar
                        Material(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            onTap: () => _navigateToEditarComidaScreen(comida),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.blue[700],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Material(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            onTap: () => _deleteComida(comida),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.red[700],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Estado al final
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: (comida.estado ?? false)
                                ? Colors.green.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: (comida.estado ?? false)
                                  ? Colors.green.withOpacity(0.3)
                                  : Colors.orange.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (comida.estado ?? false)
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                (comida.estado ?? false)
                                    ? 'Activo'
                                    : 'Inactivo',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: (comida.estado ?? false)
                                      ? Colors.green[700]
                                      : Colors.orange[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF009788).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF009788).withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.scale,
                        size: 20,
                        color: Color(0xFF009788),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Cantidad disponible:',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${comida.cantidad?.toStringAsFixed(1) ?? '0.0'} lb',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF009788),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Peceras asignadas (${peceras.length}):',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (peceras.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 20,
                                color: Colors.grey[800],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'No hay peceras asignadas',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[800],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ...peceras.asMap().entries.map((entry) {
                          final index = entry.key + 1;
                          final pecera = entry.value;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.blue.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Colors.blue[100],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$index',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue[700],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          pecera.nombrePecera ??
                                              'Pecera sin nombre',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        if (pecera.cantidadPeces != null)
                                          Text(
                                            '${pecera.cantidadPeces} peces',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (pecera.estado == true)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Activa',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green[700],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
