import 'package:dio/dio.dart';

class ApiHelper {
  static final ApiHelper _instance = ApiHelper._internal();
  factory ApiHelper() => _instance;
  ApiHelper._internal();

  final Dio _dio = Dio(BaseOptions(
    baseUrl: "",
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Add auth token
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Remove auth token
  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  // Upload file
  Future<Response> uploadFile(
    String path,
    FormData formData, {
    Options? options,
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: formData,
        options: options,
        onSendProgress: onSendProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Download file
  Future<Response> downloadFile(
    String path,
    String savePath, {
    Options? options,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.download(
        path,
        savePath,
        options: options,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}


import 'dart:async';
import 'dart:convert';
import 'package:belizepoliceresponse/core/constants/local/locale_keys.dart';
import 'package:belizepoliceresponse/core/utils/toast_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;

import '../utils/sharedPrefsHelper.dart';

class ApiHelper {
  static const String baseUrl = "https://dev.bprservice.api.redoq.host/user";

  /// Common method to handle HTTP requests
  static Future<dynamic> request({
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
    String token = await sharedPrefsHelper.getToken() ?? "";
    final Uri url = Uri.parse("$baseUrl$endpoint");
    headers ??= {
      "Content-Type": "application/json",
      "Authorization": token,
    };
    print('body - $body , token $token -- ' );
    try {
      http.Response response;

      switch (method.toUpperCase()) {
        case "GET":
          response = await http
              .get(url, headers: headers)
              .timeout(Duration(seconds: 5));
          break;
        case "POST":
          response =
              await http.post(url, headers: headers, body: jsonEncode(body));
          break;
        case "PUT":
          response =
              await http.put(url, headers: headers, body: jsonEncode(body));
          break;
        case "DELETE":
          response = await http.delete(url, headers: headers);
          break;
        default:
          throw Exception("Invalid HTTP method: $method");
      }

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 500) {
        // ToastHelper.showToast(AppLocaleKeys.somethingWentWrong.tr(),
        //     isSuccess: false);
      } else {
        // ToastHelper.showToast(AppLocaleKeys.somethingWentWrong.tr(),
        //     isSuccess: false);
        throw Exception("Error: ${response.statusCode}, ${response.body}");
      }
    } on TimeoutException {
      ToastHelper.showToast(AppLocaleKeys.timeOut, isSuccess: false);
    } catch (e) {
      throw Exception("API Request Failed: $e");
    }
  }

  /// GET request
  static Future<dynamic> get(String endpoint,
      {Map<String, String>? headers}) async {
    return await request(endpoint: endpoint, method: "GET", headers: headers);
  }

  /// POST request
  static Future<dynamic> post(String endpoint, Map<String, dynamic>? body,
      {Map<String, String>? headers}) async {
   

    return await request(
      endpoint: endpoint,
      method: "POST",
      body: body,
      headers: headers,
    );
  }

  // static Future<dynamic> post(String endpoint, Map<String, dynamic> body,
  //     {Map<String, String>? headers}) async {

  //   return await request(
  //       endpoint: endpoint, method: "POST", body: body, headers: headers);
  // }

  /// PUT request
  static Future<dynamic> put(String endpoint, Map<String, dynamic> body,
      {Map<String, String>? headers}) async {
    return await request(
        endpoint: endpoint, method: "PUT", body: body, headers: headers);
  }

  /// DELETE request
  static Future<dynamic> delete(String endpoint,
      {Map<String, String>? headers}) async {
    return await request(
        endpoint: endpoint, method: "DELETE", headers: headers);
  }
}

