import 'dart:io';

import 'package:dio/dio.dart';

import '../../model/request_client_model/request_execution_input.dart';
import '../../model/request_client_model/request_response_model.dart';

class RequestExecutionService {
  final Dio _dio;

  RequestExecutionService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
              sendTimeout: const Duration(seconds: 30),
              responseType: ResponseType.plain,
              validateStatus: (_) => true, // handle manually
            ),
          );

  /// Execute HTTP request
  Future<RequestResponse> execute({
    required int requestId,
    required RequestExecutionInput input,
    Duration? timeout,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      final response = await _dio.request(
        input.url,
        data: input.body,
        queryParameters: input.queryParams,
        options: Options(
          method: input.method,
          headers: {
            ...input.headers,
            if (input.contentType != null)
              HttpHeaders.contentTypeHeader: input.contentType,
          },
          sendTimeout: timeout, // overrides if timout is passed
          receiveTimeout: timeout, // overrides if timout is passed
        ),
      );

      stopwatch.stop();

      return RequestResponse(
        id: 0,
        requestId: requestId,
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
        durationMs: stopwatch.elapsedMilliseconds,
        headers: _normalizeHeaders(response.headers.map),
        body: response.data?.toString() ?? '',
        createdAt: DateTime.now(),
      );
    } on DioException catch (e) {
      stopwatch.stop();

      return RequestResponse(
        id: 0,
        requestId: requestId,
        statusCode: e.response?.statusCode,
        statusMessage: e.response?.statusMessage,
        durationMs: stopwatch.elapsedMilliseconds,
        headers: const {},
        body: '',
        isError: true,
        errorMessage: _mapDioError(e),
        createdAt: DateTime.now(),
      );
    } catch (e) {
      stopwatch.stop();

      return RequestResponse(
        id: 0,
        requestId: requestId,
        statusCode: null,
        statusMessage: null,
        durationMs: stopwatch.elapsedMilliseconds,
        headers: const {},
        body: '',
        isError: true,
        errorMessage: e.toString(),
        createdAt: DateTime.now(),
      );
    }
  }

  /// This function is used for load-test.
  Future<RequestResponse> executeRaw({
    required RequestExecutionInput input,
    Duration timeout = const Duration(seconds: 8),
  }) async {
    return await execute(
      requestId: -1,
      input: input,
      timeout: timeout, // ✅ enforce
    );
  }

  /// Normalize headers to String -> String
  Map<String, String> _normalizeHeaders(Map<String, List<String>> raw) {
    final result = <String, String>{};
    raw.forEach((key, values) {
      result[key] = values.join(', ');
    });
    return result;
  }

  /// User-friendly error mapping
  String _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.sendTimeout:
        return 'Send timeout';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout';
      case DioExceptionType.badCertificate:
        return 'Bad SSL certificate';
      case DioExceptionType.connectionError:
        return 'Network connection error';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      case DioExceptionType.badResponse:
        return 'Invalid server response';
      case DioExceptionType.unknown:
      default:
        return e.message ?? 'Unknown error';
    }
  }
}
