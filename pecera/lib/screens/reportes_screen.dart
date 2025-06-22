import 'dart:io';
import 'package:flutter/material.dart';
import '../services/reportesServices.dart';
import '../utils/reporteGenerator.dart';

class ReportesScreen extends StatefulWidget {
  const ReportesScreen({super.key});

  @override
  State<ReportesScreen> createState() => _ReportesScreenState();
}

class _ReportesScreenState extends State<ReportesScreen> {
  final ReporteService _reporteService = ReporteService();
  bool _isGenerating = false;

  void _generarReporteInventarioComida() async {
    final formato = await _mostrarDialogoSeleccionFormato();
    if (formato == null) return;

    setState(() => _isGenerating = true);

    try {
      _mostrarDialogoCargando('Obteniendo datos del inventario...');

      final reporte = await _reporteService.getReporteInventarioComida();

      Navigator.pop(context);
      _mostrarDialogoCargando('Generando reporte en $formato...');

      String filePath;
      if (formato == 'PDF') {
        filePath = await ReporteGenerator.generarReporteInventarioPDF(reporte);
      } else {
        filePath =
            await ReporteGenerator.generarReporteInventarioExcel(reporte);
      }

      Navigator.pop(context);

      await _mostrarDialogoExito(
        'Reporte de Inventario',
        'El reporte se ha generado exitosamente en formato $formato',
        filePath,
      );
    } catch (e) {
      Navigator.pop(context);
      _mostrarDialogoError(
          'Error al generar reporte de inventario: ${e.toString()}');
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  void _generarReporteControlParametros() async {
    final configuracion = await _mostrarDialogoConfiguracionParametros();
    if (configuracion == null) return;

    setState(() => _isGenerating = true);

    try {
      _mostrarDialogoCargando('Obteniendo datos de control de parámetros...');

      final reporte = await _reporteService.getReporteControlParametros( );

      Navigator.pop(context);
      _mostrarDialogoCargando(
          'Generando reporte en ${configuracion['formato']}...');

      String filePath;
      if (configuracion['formato'] == 'PDF') {
        filePath = await ReporteGenerator.generarReporteParametrosPDF(reporte);
      } else {
        filePath =
            await ReporteGenerator.generarReporteParametrosExcel(reporte);
      }

      Navigator.pop(context);

      await _mostrarDialogoExito(
        'Reporte de Control de Parámetros',
        'El reporte se ha generado exitosamente en formato ${configuracion['formato']}',
        filePath,
      );
    } catch (e) {
      Navigator.pop(context);
      _mostrarDialogoError(
          'Error al generar reporte de parámetros: ${e.toString()}');
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  Future<String?> _mostrarDialogoSeleccionFormato() async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.file_download, color: Colors.blue[600]),
              const SizedBox(width: 10),
              const Text('Seleccionar Formato'),
            ],
          ),
          content: const Text(
            'Formato del reporte a generar',
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop('PDF'),
              icon: const Icon(Icons.picture_as_pdf, size: 20),
              label: const Text('PDF', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop('Excel'),
              icon: const Icon(Icons.table_chart, size: 20),
              label: const Text('Excel', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar', style: TextStyle(fontSize: 18)),
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>?> _mostrarDialogoConfiguracionParametros() async {
    DateTime? fechaInicio;
    DateTime? fechaFin;
    String? formato;

    return await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.settings, color: Colors.blue[600]),
                  const SizedBox(width: 10),
                  const Text('Reporte de Parametros'),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Formato del reporte:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => setState(() => formato = 'PDF'),
                            icon: const Icon(Icons.picture_as_pdf),
                            label: const Text('PDF'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: formato == 'PDF'
                                  ? Colors.red[600]
                                  : Colors.grey[300],
                              foregroundColor: formato == 'PDF'
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => setState(() => formato = 'Excel'),
                            icon: const Icon(Icons.table_chart),
                            label: const Text('Excel'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: formato == 'Excel'
                                  ? Colors.green[600]
                                  : Colors.grey[300],
                              foregroundColor: formato == 'Excel'
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar', style: TextStyle(fontSize: 16)),
                ),
                ElevatedButton(
                  onPressed: formato != null
                      ? () {
                          Navigator.of(context).pop({
                            'fechaInicio': fechaInicio,
                            'fechaFin': fechaFin,
                            'formato': formato,
                          });
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF009788),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Generar', style: TextStyle(fontSize: 16)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _mostrarDialogoCargando(String mensaje) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: Color(0xFF009788)),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    mensaje,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _mostrarDialogoExito(
      String titulo, String mensaje, String filePath) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green[600], size: 28),
              const SizedBox(width: 10),
              Expanded(child: Text(titulo, style: const TextStyle(fontSize: 20))),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(mensaje, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.folder, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Guardado en: ${ReporteGenerator.obtenerUbicacionLegible(filePath)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.insert_drive_file,
                            color: Colors.grey[500], size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Archivo: ${filePath.split('/').last}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (Platform.isAndroid) ...[
                  ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await ReporteGenerator.abrirArchivo(filePath);
                    },
                    icon: const Icon(Icons.open_in_new, size: 20),
                    label: const Text('Abrir', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await ReporteGenerator.compartirArchivo(filePath, titulo);
                  },
                  icon: const Icon(Icons.share, size: 20),
                  label: const Text('Compartir', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF009788),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Center(
                child: Text('Cerrar', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoError(String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red[600], size: 28),
              const SizedBox(width: 10),
              const Text('Error'),
            ],
          ),
          content: Text(
            mensaje,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
              ),
              child: const Text('Cerrar', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC9F0FF),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 30),
            _buildReporteCard(
              title: 'Reporte de Inventario de Comida',
              description:
                  'Genera un reporte completo del inventario actual de comida, incluyendo cantidades, estados y asignaciones a peceras.',
              icon: Icons.restaurant,
              color: const Color(0xFF009788),
              onTap: _isGenerating ? null : _generarReporteInventarioComida,
            ),
            const SizedBox(height: 20),
            _buildReporteCard(
              title: 'Reporte de Control de Parámetros',
              description:
                  'Genera un reporte detallado del control de parámetros de todas las peceras, incluyendo historial y tendencias.',
              icon: Icons.analytics,
              color: Colors.blue[600]!,
              onTap: _isGenerating ? null : _generarReporteControlParametros,
            ),
            const SizedBox(height: 30),
            _buildInfoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
        ],
        border: Border.all(
          color: const Color(0xFF009788).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
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
              Icons.assignment,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Reportes del Sistema',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Genera reportes detallados de tu sistema de peceras',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReporteCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
  }) {
    final bool isDisabled = onTap == null;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isDisabled ? Colors.grey[200]! : Colors.white,
            isDisabled ? Colors.grey[100]! : const Color(0xFFF8FDFF),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, isDisabled ? 0.03 : 0.08),

            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          if (!isDisabled) ...[
            BoxShadow(
              color: color.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ],
        border: Border.all(
          color: (isDisabled ? Colors.grey[300]! : color).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDisabled
                              ? [Colors.grey[400]!, Colors.grey[300]!]
                              : [color, color.withOpacity(0.8)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          if (!isDisabled) ...[
                            BoxShadow(
                              color: color.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ],
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDisabled ? Colors.grey[600] : Colors.black87,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    if (_isGenerating) ...[
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF009788),
                        ),
                      ),
                    ] else ...[
                      Icon(
                        Icons.arrow_forward_ios,
                        color: (isDisabled ? Colors.grey[400]! : color)
                            .withOpacity(0.7),
                        size: 20,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDisabled ? Colors.grey[500] : Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: (isDisabled ? Colors.grey[300]! : color)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (isDisabled ? Colors.grey[400]! : color)
                          .withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.file_download,
                        color: isDisabled ? Colors.grey[500] : color,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isGenerating ? 'Generando...' : 'Generar Reporte',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDisabled ? Colors.grey[500] : color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
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
              Icon(
                Icons.info_outline,
                color: Colors.blue[600],
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Información sobre Reportes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          //Informacion al pie de la sección reportes
          const SizedBox(height: 16),
          _buildInfoItem('Los reportes se generan en formato PDF o Excel'),
          const SizedBox(height: 8),
          _buildInfoItem('Incluyen datos actualizados en tiempo real'),
          const SizedBox(height: 8),
          _buildInfoItem('Se pueden compartir y exportar fácilmente'),
          const SizedBox(height: 8),
          _buildInfoItem(
              'Los reportes de parámetros permiten filtrar por fechas'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.blue[600],
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
