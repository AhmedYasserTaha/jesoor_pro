import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jesoor_pro/core/api/api_consumer.dart';
import 'package:jesoor_pro/core/api/end_points.dart';
import 'package:jesoor_pro/core/api/interceptors.dart';
import 'package:jesoor_pro/core/error/exceptions.dart';
import 'package:jesoor_pro/core/utils/strings.dart';

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
      // 302/307 redirect usually means error (like phone already registered or ISP redirect)
      if (response.statusCode != null &&
          (response.statusCode! >= 400 ||
              response.statusCode == 302 ||
              response.statusCode == 307)) {
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

      // Check for ISP redirect (307) - check headers first
      if (response.statusCode == 307) {
        final location = response.headers.value('location') ?? '';
        if (location.contains('tedata') ||
            location.contains('VDSL-Redirection') ||
            location.contains('redirection') ||
            location.contains('megaplusredirection')) {
          throw NoInternetConnectionException(Strings.noInternetConnection);
        }
        // Generic 307 redirect - treat as connection issue
        throw NoInternetConnectionException(Strings.noInternetConnection);
      }

      // Check if response is HTML (like 404 page, error page, or redirect page)
      if (responseString.trim().startsWith('<!DOCTYPE') ||
          responseString.trim().startsWith('<html') ||
          responseString.contains('<!DOCTYPE html>') ||
          responseString.contains('Redirecting to') ||
          responseString.contains('VDSL-Redirection') ||
          responseString.contains('tedata') ||
          responseString.contains('megaplusredirection')) {
        // This means we got an HTML page instead of JSON
        // Usually happens when endpoint doesn't exist (404) or redirect (302/307)
        // Check for ISP redirect indicators in response body
        if (responseString.contains('tedata') ||
            responseString.contains('VDSL-Redirection') ||
            responseString.contains('megaplusredirection')) {
          // ISP redirect - connection issue
          throw NoInternetConnectionException(Strings.noInternetConnection);
        }
        // For 302 redirects, it usually means the resource already exists (like phone already registered)
        if (response.statusCode == 302) {
          // Check if this is a send-otp request - redirect usually means phone already registered
          if (response.requestOptions.path.contains('send-otp')) {
            throw ServerException(Strings.phoneAlreadyRegistered);
          }
        }
        throw ServerException(Strings.errorOccurred);
      }

      try {
        return jsonDecode(responseString);
      } catch (e) {
        // If JSON parsing fails, show generic error message
        throw ServerException(Strings.errorOccurred);
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
        throw ServerException(Strings.errorOccurred);
      case DioExceptionType.badResponse:
        // Try to extract error message from response
        String errorMessage = Strings.errorOccurred;
        if (error.response?.data != null) {
          try {
            final responseData = error.response!.data;
            Map<String, dynamic>? jsonData;

            if (responseData is String) {
              jsonData = jsonDecode(responseData) as Map<String, dynamic>?;
            } else if (responseData is Map) {
              jsonData = responseData as Map<String, dynamic>?;
            }

            if (jsonData != null) {
              // Try common error message fields
              if (jsonData.containsKey('message')) {
                errorMessage = jsonData['message'].toString();
              } else if (jsonData.containsKey('error')) {
                errorMessage = jsonData['error'].toString();
              } else if (jsonData.containsKey('errors')) {
                final errors = jsonData['errors'];
                if (errors is Map && errors.isNotEmpty) {
                  // Get first error message
                  final firstError = errors.values.first;
                  if (firstError is List && firstError.isNotEmpty) {
                    errorMessage = firstError.first.toString();
                  } else if (firstError is String) {
                    errorMessage = firstError;
                  }
                }
              }
            }
          } catch (e) {
            // If parsing fails, use default message
            errorMessage = Strings.errorOccurred;
          }
        }

        switch (error.response?.statusCode) {
          case 302:
            // 302 redirect usually means resource already exists (like phone already registered)
            if (error.response?.requestOptions.path.contains('send-otp') ==
                true) {
              throw ServerException(Strings.phoneAlreadyRegistered);
            }
            throw ServerException(errorMessage);
          case 307:
            // 307 redirect from ISP usually means connection issue
            throw NoInternetConnectionException(Strings.noInternetConnection);
          case 400:
          case 401:
          case 403:
          case 404:
          case 409:
          case 500:
          default:
            throw ServerException(errorMessage);
        }
      case DioExceptionType.cancel:
        throw ServerException(Strings.requestCancelled);
      case DioExceptionType.unknown:
        // Check if it's an SSL certificate error
        final errorMessage = error.error?.toString() ?? '';
        if (errorMessage.contains('CERTIFICATE_VERIFY_FAILED') ||
            errorMessage.contains('HandshakeException') ||
            errorMessage.contains('handshake')) {
          throw ServerException(
            'خطأ في التحقق من شهادة SSL. يرجى التحقق من اتصال الإنترنت.',
          );
        }
        throw ServerException(Strings.errorOccurred);
      case DioExceptionType.badCertificate:
        // SSL certificate verification failed - usually means self-signed certificate or invalid cert
        throw ServerException(
          'خطأ في التحقق من شهادة SSL. يرجى التحقق من اتصال الإنترنت.',
        );
      case DioExceptionType.connectionError:
        throw NoInternetConnectionException(Strings.noInternetConnection);
    }
  }
}
