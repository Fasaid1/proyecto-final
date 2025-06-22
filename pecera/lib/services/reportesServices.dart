import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/reportesModel.dart';

class ReporteService {
  final String _baseUrl = 'http://10.0.2.2:3000/api/reporte';

  Future<ReporteInventarioComida> getReporteInventarioComida() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/inventario-comida'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody['success'] == true && responseBody['data'] != null) {
          return ReporteInventarioComida.fromJson(responseBody['data']);
        } else {
          throw Exception('Respuesta del servidor sin datos válidos');
        }
      } else {
        print(
            'Error en getReporteInventarioComida: ${response.statusCode} - ${response.body}');
        throw Exception(
            'Error al obtener el reporte de inventario del servidor');
      }
    } catch (e) {
      print('Excepción al obtener reporte de inventario: $e');
      throw Exception(
          'Excepción al conectar con el servidor para obtener reporte de inventario');
    }
  }

  Future<ReporteControlParametros> getReporteControlParametros() async {
    try {
      String url = '$_baseUrl/control-parametros';

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody['success'] == true && responseBody['data'] != null) {
          return ReporteControlParametros.fromJson(responseBody['data']);
        } else {
          throw Exception('Respuesta del servidor sin datos válidos');
        }
      } else if (response.statusCode == 400) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        String errorMessage =
            responseBody['message'] ?? 'Error en los parámetros de fecha';
        throw Exception(errorMessage);
      } else {
        print(
            'Error en getReporteControlParametros: ${response.statusCode} - ${response.body}');
        throw Exception(
            'Error al obtener el reporte de control de parámetros del servidor');
      }
    } catch (e) {
      print('Excepción al obtener reporte de control de parámetros: $e');
      if (e is Exception) {
        throw e;
      }
      throw Exception(
          'Excepción al conectar con el servidor para obtener reporte de control de parámetros');
    }
  }

  Future<Map<String, dynamic>> getEstadisticasGenerales() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/estadisticas-generales'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody['success'] == true && responseBody['data'] != null) {
          return responseBody['data'];
        } else {
          throw Exception('Respuesta del servidor sin datos válidos');
        }
      } else {
        print(
            'Error en getEstadisticasGenerales: ${response.statusCode} - ${response.body}');
        throw Exception(
            'Error al obtener las estadísticas generales del servidor');
      }
    } catch (e) {
      print('Excepción al obtener estadísticas generales: $e');
      throw Exception(
          'Excepción al conectar con el servidor para obtener estadísticas generales');
    }
  }

  bool isValidDateFormat(String date) {
    try {
      final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
      if (!regex.hasMatch(date)) {
        return false;
      }

      DateTime.parse(date);
      return true;
    } catch (e) {
      return false;
    }
  }

  String formatDateForApi(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
