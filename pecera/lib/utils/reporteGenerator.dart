import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/reportesModel.dart';

class ReporteGenerator {
  static Future<String> generarReporteInventarioPDF(
      ReporteInventarioComida reporte) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Container(
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: PdfColors.teal50,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'REPORTE DE INVENTARIO DE COMIDA',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.teal800,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'Fecha de generación: ${_formatearFecha(reporte.estadisticas?.fechaGeneracion)}',
                      style: const pw.TextStyle(
                          fontSize: 12, color: PdfColors.grey700),
                    ),
                  ],
                ),
              ),
            ),

            pw.SizedBox(height: 20),

            pw.Container(
              padding: const pw.EdgeInsets.all(15),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'ESTADÍSTICAS GENERALES',
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                              'Total de comidas: ${reporte.estadisticas?.totalComidas ?? 0}'),
                          pw.Text(
                              'Comidas activas: ${reporte.estadisticas?.comidasActivas ?? 0}'),
                          pw.Text(
                              'Comidas inactivas: ${reporte.estadisticas?.comidasInactivas ?? 0}'),
                        ],
                      ),
                      pw.Text(
                        'Stock total: ${reporte.estadisticas?.cantidadTotalStock?.toStringAsFixed(2) ?? "0.00"} lb',
                        style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.teal),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 20),

            pw.Container(
              padding:
                  const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: pw.BoxDecoration(
                color: PdfColors.teal800,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Text(
                'DETALLE COMPLETO DEL INVENTARIO POR COMIDA',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ),
            pw.SizedBox(height: 15),

            ...reporte.inventario?.map((comida) => _buildComidaPDF(comida)) ??
                [],
          ];
        },
      ),
    );

    return await _guardarArchivo(
        await pdf.save(), 'reporte_inventario_comida.pdf');
  }

  static Future<String> generarReporteInventarioExcel(
      ReporteInventarioComida reporte) async {
    var excel = Excel.createExcel();
    Sheet sheet = excel['Inventario de Comida'];

    excel.delete('Sheet1');

    List<String> headers = [
      'ID',
      'Nombre',
      'Marca',
      'Cantidad Actual (lb)',
      'Estado',
      'Fecha Creación',
      'Última Actualización',
      'Peceras Asignadas'
    ];

    for (int i = 0; i < headers.length; i++) {
      var cell =
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = CellStyle(
        fontFamily: getFontFamily(FontFamily.Calibri),
        fontSize: 12,
        bold: true,
        backgroundColorHex: ExcelColor.fromHexString('#009788'),
        fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
      );
    }

    int currentRow = 2;
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow))
        .value = TextCellValue('ESTADÍSTICAS GENERALES');
    currentRow++;
    sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow))
            .value =
        TextCellValue(
            'Total comidas: ${reporte.estadisticas?.totalComidas ?? 0}');
    currentRow++;
    sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow))
            .value =
        TextCellValue(
            'Comidas activas: ${reporte.estadisticas?.comidasActivas ?? 0}');
    currentRow++;
    sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow))
            .value =
        TextCellValue(
            'Stock total: ${reporte.estadisticas?.cantidadTotalStock?.toStringAsFixed(2) ?? "0.00"} lb');
    currentRow += 2;

    for (var comida in reporte.inventario ?? []) {
      String pecerasText = comida.peceras
              ?.map((p) => '${p.nombrePecera} (${p.cantidadIngresada} lb)')
              .join(', ') ??
          '';

      List<dynamic> rowData = [
        comida.id,
        comida.nombreComida,
        comida.marcaComida,
        comida.cantidadActual,
        comida.estado == true ? 'Activo' : 'Inactivo',
        _formatearFecha(comida.createdAt),
        _formatearFecha(comida.updatedAt),
        pecerasText,
      ];

      for (int i = 0; i < rowData.length; i++) {
        var cellValue = rowData[i];
        var cell = sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: i, rowIndex: currentRow));

        if (cellValue == null) {
          cell.value = TextCellValue('N/A');
        } else if (cellValue is String) {
          cell.value = TextCellValue(cellValue);
        } else if (cellValue is int) {
          cell.value = IntCellValue(cellValue);
        } else if (cellValue is double) {
          cell.value = DoubleCellValue(cellValue);
        } else if (cellValue is num) {
          cell.value = DoubleCellValue(cellValue.toDouble());
        } else {
          cell.value = TextCellValue(cellValue.toString());
        }
      }
      currentRow++;
    }

    return await _guardarArchivoExcel(excel, 'reporte_inventario_comida.xlsx');
  }

  static Future<String> generarReporteParametrosPDF(
      ReporteControlParametros reporte) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Container(
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: PdfColors.blue50,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'REPORTE DE CONTROL DE PARÁMETROS',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue800,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'Período: ${_formatearFecha(reporte.estadisticas?.fechaInicio)} - ${_formatearFecha(reporte.estadisticas?.fechaFin)}',
                      style: const pw.TextStyle(
                          fontSize: 12, color: PdfColors.grey700),
                    ),
                    pw.Text(
                      'Fecha de generación: ${_formatearFecha(reporte.estadisticas?.fechaGeneracion)}',
                      style: const pw.TextStyle(
                          fontSize: 12, color: PdfColors.grey700),
                    ),
                  ],
                ),
              ),
            ),

            pw.SizedBox(height: 20),

            pw.Container(
              padding: const pw.EdgeInsets.all(15),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'ESTADÍSTICAS GENERALES',
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                              'Total peceras: ${reporte.estadisticas?.totalPeceras ?? 0}'),
                          pw.Text(
                              'Peceras destacadas: ${reporte.estadisticas?.pecerasDestacadas ?? 0}'),
                          pw.Text(
                              'Total peces: ${reporte.estadisticas?.totalPeces ?? 0}'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 20),

            pw.Text(
              'DETALLE POR PECERAS',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),

            ...reporte.peceras?.map((pecera) => _buildPeceraPDF(pecera)) ?? [],
          ];
        },
      ),
    );

    return await _guardarArchivo(
        await pdf.save(), 'reporte_control_parametros.pdf');
  }

  static Future<String> generarReporteParametrosExcel(
      ReporteControlParametros reporte) async {
    var excel = Excel.createExcel();
    Sheet sheet = excel['Control de Parámetros'];

    excel.delete('Sheet1');

    List<String> headers = [
      'Pecera',
      'Cantidad Peces',
      'pH Actual',
      'Oxígeno Disuelto',
      'Nivel Agua',
      'Total Mediciones',
      'Última Medición',
      'Promedio Temperatura',
      'Promedio Oxígeno'
    ];

    for (int i = 0; i < headers.length; i++) {
      var cell =
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = CellStyle(
        fontFamily: getFontFamily(FontFamily.Calibri),
        fontSize: 12,
        bold: true,
        backgroundColorHex: ExcelColor.fromHexString('#1565C0'),
        fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
      );
    }

    int currentRow = 2;
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow))
        .value = TextCellValue('ESTADÍSTICAS GENERALES');
    currentRow++;
    sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow))
            .value =
        TextCellValue(
            'Total peceras: ${reporte.estadisticas?.totalPeceras ?? 0}');
    currentRow++;
    sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow))
            .value =
        TextCellValue('Total peces: ${reporte.estadisticas?.totalPeces ?? 0}');
    currentRow += 2;

    for (var pecera in reporte.peceras ?? []) {
      List<dynamic> rowData = [
        pecera.nombrePecera,
        pecera.cantidadPeces,
        pecera.parametrosActuales?.cantidadPh,
        pecera.parametrosActuales?.cantidadOxigenoDisuelto,
        pecera.parametrosActuales?.nivelAgua,
        pecera.estadisticas?.totalMediciones,
        _formatearFecha(pecera.estadisticas?.ultimaMedicion),
        pecera.estadisticas?.promedios?.temperatura,
        pecera.estadisticas?.promedios?.oxigenoDisuelto,
      ];

      for (int i = 0; i < rowData.length; i++) {
        var cellValue = rowData[i];
        var cell = sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: i, rowIndex: currentRow));

        if (cellValue == null) {
          cell.value = TextCellValue('N/A');
        } else if (cellValue is String) {
          cell.value = TextCellValue(cellValue);
        } else if (cellValue is int) {
          cell.value = IntCellValue(cellValue);
        } else if (cellValue is double) {
          cell.value = DoubleCellValue(cellValue);
        } else if (cellValue is num) {
          cell.value = DoubleCellValue(cellValue.toDouble());
        } else {
          cell.value = TextCellValue(cellValue.toString());
        }
      }
      currentRow++;
    }

    return await _guardarArchivoExcel(excel, 'reporte_control_parametros.xlsx');
  }

  static pw.Widget _buildComidaPDF(ComidaInventario comida) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 15),
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                '${comida.nombreComida} - ${comida.marcaComida}',
                style:
                    pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                '${comida.cantidadActual?.toStringAsFixed(2)} lb',
                style: pw.TextStyle(fontSize: 12, color: PdfColors.teal),
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Text('Estado: ${comida.estado == true ? "Activo" : "Inactivo"}'),
          if (comida.peceras?.isNotEmpty == true) ...[
            pw.SizedBox(height: 8),
            pw.Text(
              'Peceras asignadas:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            ...comida.peceras!.map((pecera) => pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 10, top: 2),
                  child: pw.Text(
                      '• ${pecera.nombrePecera}: ${pecera.cantidadIngresada} lb'),
                )),
          ],
        ],
      ),
    );
  }

  static pw.Widget _buildPeceraPDF(PeceraParametros pecera) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 20),
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Header de la pecera
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: pecera.esDestacada == true
                  ? PdfColors.amber50
                  : PdfColors.blue50,
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  '${pecera.nombrePecera} (${pecera.cantidadPeces} peces)',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
                if (pecera.esDestacada == true)
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.amber,
                      borderRadius: pw.BorderRadius.circular(4),
                    ),
                    child: pw.Text(
                      'DESTACADA',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          pw.SizedBox(height: 12),

          pw.Text('Fecha de siembra: ${pecera.fechaSiembra ?? "N/A"}'),
          pw.Text('Estado: ${pecera.estado == true ? "Activa" : "Inactiva"}'),

          pw.SizedBox(height: 12),

          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'PARÁMETROS ACTUALES',
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                    'pH: ${pecera.parametrosActuales?.cantidadPh?.toStringAsFixed(2) ?? "N/A"}'),
                pw.Text(
                    'Oxígeno Disuelto: ${pecera.parametrosActuales?.cantidadOxigenoDisuelto?.toStringAsFixed(2) ?? "N/A"} mg/L'),
                pw.Text(
                    'Nivel de Agua: ${pecera.parametrosActuales?.nivelAgua?.toStringAsFixed(2) ?? "N/A"} cm'),
              ],
            ),
          ),

          pw.SizedBox(height: 12),

          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.blue50,
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'ESTADÍSTICAS',
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                    'Total de mediciones: ${pecera.estadisticas?.totalMediciones ?? 0}'),
                if (pecera.estadisticas?.ultimaMedicion != null)
                  pw.Text(
                      'Última medición: ${_formatearFecha(pecera.estadisticas?.ultimaMedicion)}'),
                pw.SizedBox(height: 8),
                pw.Text(
                  'PROMEDIOS:',
                  style: pw.TextStyle(
                      fontSize: 10, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                    'Temperatura: ${pecera.estadisticas?.promedios?.temperatura ?? "0"} °C'),
                pw.Text(
                    'Oxígeno Disuelto: ${pecera.estadisticas?.promedios?.oxigenoDisuelto ?? "0"} mg/L'),
                pw.Text(
                    'Nitritos: ${pecera.estadisticas?.promedios?.nitritos ?? "0"} mg/L'),
                pw.Text(
                    'Nitratos: ${pecera.estadisticas?.promedios?.nitratos ?? "0"} mg/L'),
                pw.Text(
                    'Amoniaco: ${pecera.estadisticas?.promedios?.amoniaco ?? "0"} mg/L'),
              ],
            ),
          ),

          if (pecera.historialControles?.isNotEmpty == true) ...[
            pw.SizedBox(height: 15),
            pw.Text(
              'HISTORIAL DE CONTROLES',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),

            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              columnWidths: {
                0: const pw.FlexColumnWidth(1.5),
                1: const pw.FlexColumnWidth(1),
                2: const pw.FlexColumnWidth(1),
                3: const pw.FlexColumnWidth(1),
                4: const pw.FlexColumnWidth(1),
                5: const pw.FlexColumnWidth(1),
                6: const pw.FlexColumnWidth(1),
                7: const pw.FlexColumnWidth(1),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    _buildTableCell('Fecha', isHeader: true),
                    _buildTableCell('Temp °C', isHeader: true),
                    _buildTableCell('O₂ mg/L', isHeader: true),
                    _buildTableCell('Nitritos', isHeader: true),
                    _buildTableCell('Nitratos', isHeader: true),
                    _buildTableCell('Amoniaco', isHeader: true),
                    _buildTableCell('Densidad', isHeader: true),
                    _buildTableCell('N. Agua', isHeader: true),
                  ],
                ),

                ...pecera.historialControles!.map((control) => pw.TableRow(
                      children: [
                        _buildTableCell(_formatearFecha(control.createdAt)),
                        _buildTableCell('${control.temperatura ?? "N/A"}'),
                        _buildTableCell('${control.oxigenoDisuelto ?? "N/A"}'),
                        _buildTableCell('${control.nitritos ?? "N/A"}'),
                        _buildTableCell('${control.nitratos ?? "N/A"}'),
                        _buildTableCell('${control.amoniaco ?? "N/A"}'),
                        _buildTableCell('${control.densidadPeces ?? "N/A"}'),
                        _buildTableCell('${control.nivelAgua ?? "N/A"}'),
                      ],
                    )),
              ],
            ),
          ] else ...[
            pw.SizedBox(height: 12),
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.orange50,
                borderRadius: pw.BorderRadius.circular(6),
                border: pw.Border.all(color: PdfColors.orange200),
              ),
              child: pw.Text(
                'No hay historial de controles registrado para esta pecera.',
                style: const pw.TextStyle(
                    fontSize: 12, color: PdfColors.orange700),
                textAlign: pw.TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  static pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 8 : 7,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  static String _formatearFecha(DateTime? fecha) {
    if (fecha == null) return 'N/A';
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
  }



  static Future<String> _obtenerRutaDescarga() async {
    if (Platform.isAndroid) {
      Directory? downloadsDir;

      if (await Permission.storage.isGranted ||
          await Permission.manageExternalStorage.isGranted) {
        downloadsDir = Directory('/storage/emulated/0/Download');
        if (!await downloadsDir.exists()) {
          downloadsDir = Directory('/storage/emulated/0/Downloads');
        }
        if (!await downloadsDir.exists()) {
          downloadsDir = await getApplicationDocumentsDirectory();
        }
      } else {
        downloadsDir = await getApplicationDocumentsDirectory();
      }

      return downloadsDir.path;
    } else {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    }
  }

  static Future<String> _guardarArchivo(
      Uint8List bytes, String fileName) async {
    try {

      String downloadPath = await _obtenerRutaDescarga();

      String finalFileName = fileName;
      File file = File('$downloadPath/$finalFileName');
      int counter = 1;

      while (await file.exists()) {
        String nameWithoutExt = fileName.split('.').first;
        String extension = fileName.split('.').last;
        finalFileName = '${nameWithoutExt}_$counter.$extension';
        file = File('$downloadPath/$finalFileName');
        counter++;
      }

      await file.writeAsBytes(bytes);

      return file.path;
    } catch (e) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes);
      return file.path;
    }
  }

  static Future<String> _guardarArchivoExcel(
      Excel excel, String fileName) async {
    try {

      String downloadPath = await _obtenerRutaDescarga();

      String finalFileName = fileName;
      File file = File('$downloadPath/$finalFileName');
      int counter = 1;

      while (await file.exists()) {
        String nameWithoutExt = fileName.split('.').first;
        String extension = fileName.split('.').last;
        finalFileName = '${nameWithoutExt}_$counter.$extension';
        file = File('$downloadPath/$finalFileName');
        counter++;
      }

      await file.writeAsBytes(excel.save()!);

      return file.path;
    } catch (e) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(excel.save()!);
      return file.path;
    }
  }

  static Future<void> compartirArchivo(String filePath, String title) async {
    await Share.shareXFiles([XFile(filePath)], text: title);
  }

  static Future<bool> abrirArchivo(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await Share.shareXFiles([XFile(filePath)]);
        return true;
      }
      return false;
    } catch (e) {
      print('Error al abrir archivo: $e');
      return false;
    }
  }

  static String obtenerUbicacionLegible(String filePath) {
    if (filePath.contains('/storage/emulated/0/Download')) {
      return 'Carpeta de Descargas';
    } else if (filePath.contains('/storage/emulated/0/Downloads')) {
      return 'Carpeta de Descargas';
    } else if (filePath.contains('Documents')) {
      return 'Carpeta de Documentos de la app';
    } else {
      return 'Almacenamiento interno';
    }
  }
}
