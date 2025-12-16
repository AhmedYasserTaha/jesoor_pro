import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jesoor_pro/core/api/api_consumer.dart';
import 'package:jesoor_pro/core/api/end_points.dart';
import 'package:jesoor_pro/core/api/interceptors.dart';
import 'package:jesoor_pro/core/error/exceptions.dart';

class DioConsumer implements ApiConsumer {
  final Dio client;

  DioConsumer({required this.client}) {
    client.options
      ..baseUrl = EndPoints.baseUrl
      ..responseType = ResponseType.plain
      ..followRedirects = false
      ..validateStatus = (status) {
        return status! < 500;
      };

    client.interceptors.add(AppInterceptors());
    if (kDebugMode) {
      client.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
        ),
      );
    }
  }

  @override
  Future get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await client.get(path, queryParameters: queryParameters);
      return _handleResponseAsJson(response);
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future post(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await client.post(
        path,
        data: body,
        queryParameters: queryParameters,
      );
      // Check if response status indicates an error
      if (response.statusCode != null && response.statusCode! >= 400) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
      return _handleResponseAsJson(response);
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future put(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await client.put(
        path,
        data: body,
        queryParameters: queryParameters,
      );
      return _handleResponseAsJson(response);
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future delete(
    String path, {
    body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await client.delete(
        path,
        data: body,
        queryParameters: queryParameters,
      );
      return _handleResponseAsJson(response);
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  dynamic _handleResponseAsJson(Response response) {
    // Since ResponseType.plain is used, response.data is a String
    // We need to parse it as JSON
    if (response.data is String) {
      final responseString = response.data as String;

      // Check if response is HTML (like 404 page or error page)
      if (responseString.trim().startsWith('<!DOCTYPE') ||
          responseString.trim().startsWith('<html') ||
          responseString.contains('<!DOCTYPE html>')) {
        // This means we got an HTML page instead of JSON
        // Usually happens when endpoint doesn't exist (404)
        throw const ServerException('حدث خطأ ما، يرجى المحاولة مرة أخرى');
      }

      try {
        return jsonDecode(responseString);
      } catch (e) {
        // If JSON parsing fails, show generic error message
        throw const ServerException('حدث خطأ ما، يرجى المحاولة مرة أخرى');
      }
    }
    // If it's already parsed (Map/List), return it directly
    return response.data;
  }

  dynamic _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw const ServerException('حدث خطأ ما، يرجى المحاولة مرة أخرى');
      case DioExceptionType.badResponse:
        // For all error responses, show a generic message to user
        switch (error.response?.statusCode) {
          case 400:
          case 401:
          case 403:
          case 404:
          case 409:
          case 500:
          default:
            throw const ServerException('حدث خطأ ما، يرجى المحاولة مرة أخرى');
        }
      case DioExceptionType.cancel:
        throw const ServerException('تم إلغاء الطلب');
      case DioExceptionType.unknown:
        throw const ServerException('حدث خطأ ما، يرجى المحاولة مرة أخرى');
      case DioExceptionType.badCertificate:
        throw const ServerException('حدث خطأ ما، يرجى المحاولة مرة أخرى');
      case DioExceptionType.connectionError:
        throw const NoInternetConnectionException('لا يوجد اتصال بالإنترنت');
    }
  }
}
