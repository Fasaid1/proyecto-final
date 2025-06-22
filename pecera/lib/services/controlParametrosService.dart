import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/parametroModel.dart';

class ControlParametrosService {
  final String _baseUrl = 'http://10.0.2.2:3000/api/controlParametro';

  Future<List<ControlParametros>> getAllControlParametrosById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/getAll/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<ControlParametros> peceras = body
            .map(
              (dynamic item) =>
                  ControlParametros.fromJson(item as Map<String, dynamic>),
            )
            .toList();
        return peceras;
      } else {
        print(
            'Error en getAllControlParametros: ${response.statusCode} - ${response.body}');
        throw Exception(
            'Error al obtener los controles de parametros del servidor.');
      }
    } catch (e) {
      print('Excepción al obtener los controles de parametros: $e');
      throw Exception(
          'Excepción al conectar con el servidor para obtener peceras.');
    }
  }

  Future<ControlParametros?> getControlParametrosById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> body = json.decode(response.body);
        return ControlParametros.fromJson(body);
      } else if (response.statusCode == 404) {
        print('Control de parametros con ID $id no encontrada.');
        return null;
      } else {
        print(
            'Error en getPeceraById: ${response.statusCode} - ${response.body}');
        throw Exception(
            'Error al obtener los controles de parametros del servidor.');
      }
    } catch (e) {
      print('Excepción al obtener los controles de parametros con ID $id: $e');
      throw Exception(
          'Excepción al conectar con el servidor para obtener los controles de parametros por ID.');
    }
  }

  Future<ControlParametros?> createControlParametros(
      ControlParametros controlParametros) async {
    try {
      final Map<String, dynamic> requestBody = {
        "peceraId": controlParametros.peceraId,
        "temperatura": controlParametros.temperatura,
        "oxigenoDisuelto": controlParametros.oxigenoDisuelto,
        "nitratos": controlParametros.nitratos,
        "nitritos": controlParametros.nitritos,
        "amoniaco": controlParametros.amoniaco,
        "densidadPeces": controlParametros.densidadPeces,
        "nivelAgua": controlParametros.nivelAgua,
        "estado": true
      };

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseBody.containsKey('controlParametros') &&
            responseBody['controlParametros'] != null) {
          return ControlParametros.fromJson(
              responseBody['controlParametros'] as Map<String, dynamic>);
        } else if (responseBody.containsKey('status') &&
            responseBody['status'] == 'error') {
          final String errorMessage = responseBody['message'] ??
              'Error conocido al crear los controles de parametros.';
          print('Error de API al crear controles de parametros: $errorMessage');
          throw Exception(errorMessage);
        } else {
          print(
              'Respuesta inesperada del servidor (éxito pero formato desconocido): ${response.body}');
          throw Exception(
              'Respuesta inesperada del servidor al crear los controles de parametros.');
        }
      } else {
        final String errorMessage =
            responseBody['message'] ?? 'Error desconocido del servidor.';
        print(
            'Error HTTP al crear los controles de parametros: ${response.statusCode} - $errorMessage');
        throw Exception(
            'Error del servidor (${response.statusCode}): $errorMessage');
      }
    } catch (e) {
      print('Excepción al crear los controles de parametros: $e');
      if (e is Exception) {
        throw e;
      }
      throw Exception(
          'Excepción al conectar con el servidor para crear controles de parametros.');
    }
  }

  Future<bool> deleteControlParametros(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Control de parametros con ID $id eliminado exitosamente.');
        return true;
      } else if (response.statusCode == 404) {
        print('Control de parametros con ID $id no encontrado para eliminar.');
        return false;
      } else {
        print(
            'Error al eliminar el control de parametros: ${response.statusCode} - ${response.body}');
        throw Exception(
            'Error del servidor al eliminar el control de parametros.');
      }
    } catch (e) {
      print('Excepción al eliminar el control de parametros con ID $id: $e');
      throw Exception(
          'Excepción al conectar con el servidor para eliminar el control de parametros.');
    }
  }
}
