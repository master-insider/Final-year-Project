// // Placeholder to prevent crashing
// class ApiClient {
//   Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
//     // Implement actual network logic here (e.g., using Dio or http package)
//     throw UnimplementedError('API GET call not implemented.');
//   }
//   Future<dynamic> post(String path, {dynamic body}) async {
//     throw UnimplementedError('API POST call not implemented.');
//   }
//   Future<dynamic> put(String path, {dynamic body}) async {
//     throw UnimplementedError('API PUT call not implemented.');
//   }
//   Future<dynamic> patch(String path, {dynamic body}) async {
//     throw UnimplementedError('API PATCH call not implemented.');
//   }
//   Future<dynamic> delete(String path) async {
//     throw UnimplementedError('API DELETE call not implemented.');
//   }
// }
// lib/core/network/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../exceptions/exceptions.dart'; // Assuming you define custom exceptions

class ApiClient {
  final String baseUrl;
  // In a real app, you would include a reference to a TokenStorage service
  // final TokenStorage tokenStorage; 

  ApiClient({this.baseUrl = 'https://api.yourbudgetapp.com'});

  Map<String, String> _getHeaders({String? token, bool includeContentType = true}) {
    final Map<String, String> headers = {};
    if (includeContentType) {
      headers['Content-Type'] = 'application/json';
    }
    // if (token != null) {
    //   headers['Authorization'] = 'Bearer $token';
    // } else {
    //   // headers['Authorization'] = 'Bearer ${tokenStorage.getToken()}';
    // }
    return headers;
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException('Unauthorized or Token Expired');
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      final errorBody = jsonDecode(response.body);
      throw ClientException(errorBody['message'] ?? 'Client error', response.statusCode);
    } else if (response.statusCode >= 500) {
      throw ServerException('Server error', response.statusCode);
    }
    throw UnknownException('Unknown error occurred');
  }

  Future<dynamic> get(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await http.get(uri, headers: _getHeaders());
    return _handleResponse(response);
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await http.post(
      uri,
      headers: _getHeaders(),
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }
  
  // Implement put, delete, patch similarly...
  Future<dynamic> put(String path, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await http.put(
      uri,
      headers: _getHeaders(),
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  Future<dynamic> delete(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await http.delete(uri, headers: _getHeaders());
    return _handleResponse(response);
  }

  Future<dynamic> patch(String path, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await http.patch(
      uri,
      headers: _getHeaders(),
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }
}