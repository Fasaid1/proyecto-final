import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/comidaPeceraModel.dart';
import '../models/comidaModel.dart';

class ComidaService {
  final String _baseUrl = 'http://10.0.2.2:3000/api/comida';
  final String _baseUrlComidaPecera = 'http://10.0.2.2:3000/api/comidaPece';

  Future<List<Comida>> getAllComida() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<Comida> comidas = body
            .map(
              (dynamic item) => Comida.fromJson(item as Map<String, dynamic>),
            )
            .toList();
        return comidas;
      } else {
        print(
            'Error en getAllComida: ${response.statusCode} - ${response.body}');
        throw Exception('Error al obtener las comidas del servidor.');
      }
    } catch (e) {
      print('Excepción al obtener las comidas: $e');
      throw Exception(
          'Excepción al conectar con el servidor para obtener comidas.');
    }
  }

  Future<Comida?> getComidaById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> body = json.decode(response.body);
        return Comida.fromJson(body);
      } else if (response.statusCode == 404) {
        print('Comida con ID $id no encontrada.');
        return null;
      } else {
        print(
            'Error en getComidaById: ${response.statusCode} - ${response.body}');
        throw Exception('Error al obtener las comidas del servidor.');
      }
    } catch (e) {
      print('Excepción al obtener las comidas con ID $id: $e');
      throw Exception(
          'Excepción al conectar con el servidor para obtener las comidas por ID.');
    }
  }

  Future<Comida?> createComida(Comida comida) async {
    try {
      final Map<String, dynamic> requestBody = {
        "nombreComida": comida.nombreComida,
        "marcaComida": comida.marcaComida,
        "cantidad": comida.cantidad,
        "estado": true
      };

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseBody.containsKey('comida') &&
            responseBody['comida'] != null) {
          return Comida.fromJson(
              responseBody['comida'] as Map<String, dynamic>);
        } else if (responseBody.containsKey('status') &&
            responseBody['status'] == 'error') {
          final String errorMessage =
              responseBody['message'] ?? 'Error conocido al crear la comida.';
          print('Error de API al crear la comida: $errorMessage');
          throw Exception(errorMessage);
        } else {
          print(
              'Respuesta inesperada del servidor (éxito pero formato desconocido): ${response.body}');
          throw Exception(
              'Respuesta inesperada del servidor al crear la comida.');
        }
      } else {
        final String errorMessage =
            responseBody['message'] ?? 'Error desconocido del servidor.';
        print(
            'Error HTTP al crear la comida: ${response.statusCode} - $errorMessage');
        throw Exception(
            'Error del servidor (${response.statusCode}): $errorMessage');
      }
    } catch (e) {
      print('Excepción al crear la comida: $e');
      if (e is Exception) {
        throw e;
      }
      throw Exception(
          'Excepción al conectar con el servidor para crear la comida.');
    }
  }

  Future<ComidaPecera?> createComidaPecera(ComidaPecera comidaPecera) async {
    try {
      final Map<String, dynamic> requestBody = {
        "peceraId": comidaPecera.peceraId,
        "comidaId": comidaPecera.comidaId,
        "cantidad": comidaPecera.cantidad,
        "estado": true
      };

      final response = await http.post(
        Uri.parse(_baseUrlComidaPecera),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseBody.containsKey('comidaPecera') &&
            responseBody['comidaPecera'] != null) {
          return ComidaPecera.fromJson(
              responseBody['comidaPecera'] as Map<String, dynamic>);
        } else if (responseBody.containsKey('status') &&
            responseBody['status'] == 'error') {
          final String errorMessage =
              responseBody['message'] ?? 'Error conocido al crear la comida.';
          print('Error de API al crear la comida: $errorMessage');
          throw Exception(errorMessage);
        } else {
          print(
              'Respuesta inesperada del servidor (éxito pero formato desconocido): ${response.body}');
          throw Exception(
              'Respuesta inesperada del servidor al crear la comida.');
        }
      } else {
        final String errorMessage =
            responseBody['message'] ?? 'Error desconocido del servidor.';
        print(
            'Error HTTP al crear la comida: ${response.statusCode} - $errorMessage');
        throw Exception(
            'Error del servidor (${response.statusCode}): $errorMessage');
      }
    } catch (e) {
      print('Excepción al crear la comida: $e');
      if (e is Exception) {
        throw e;
      }
      throw Exception(
          'Excepción al conectar con el servidor para crear la comida.');
    }
  }

  Future<Map<String, dynamic>> deleteComida(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      Map<String, dynamic> responseData = {};
      if (response.body.isNotEmpty) {
        responseData = json.decode(response.body);
      }

      if (response.statusCode == 200) {
        print('Comida con ID $id eliminado exitosamente.');
        return {
          'success': true,
          'message': responseData['message'] ?? 'Comida eliminada exitosamente'
        };
      } else if (response.statusCode == 404) {
        print('Comida con ID $id no encontrado para eliminar.');
        print('Pecera con ID $id no encontrada para eliminar.');
        return {
          'success': false,
          'message': responseData['message'] ?? 'Comida no encontrada'
        };
      } else if (response.statusCode == 400) {
        return {
          'success': false,
          'message': responseData['message'] ?? 'No se puede eliminar la pecera'
        };
      } else {
        print(
            'Error al eliminar la comida: ${response.statusCode} - ${response.body}');
        return {
          'success': false,
          'message': responseData['message'] ??
              'Error del servidor al eliminar la pecera'
        };
      }
    } catch (e) {
      print('Excepción al eliminar la comida con ID $id: $e');
      throw Exception(
          'Excepción al conectar con el servidor para eliminar la comida.');
    }
  }

  Future<bool?> updateComida(int id, Comida comida) async {
    try {
      final Map<String, dynamic> requestBody = {
        "nombreComida": comida.nombreComida,
        "marcaComida": comida.marcaComida,
        "cantidad": comida.cantidad,
        "estado": comida.estado
      };

      final response = await http.put(
        Uri.parse('$_baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print('Respuesta del servidor: $responseBody');

        if (responseBody.containsKey('comida') &&
            responseBody['comida'] is List) {
          return true;
        } else {
          throw Exception('Respuesta inesperada del servidor.');
        }
      } else if (response.statusCode == 404) {
        print('Comida no encontrada.');
        return false;
      } else {
        print('Error al actualizar: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Excepción al actualizar comida: $e');
      throw Exception(
          'Excepción al conectar con el servidor para actualizar pecera.');
    }
  }
}
