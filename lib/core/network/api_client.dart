import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Singleton API client that wraps Dio with auth interceptors,
/// request/response logging, and consistent error handling.
///
/// When [isDemo] is `true` (default), all HTTP methods return an error
/// immediately without making a network call. Repositories fall through
/// to their mock data, making the app fully usable offline for demos.
/// Set to `false` when connecting to a real backend.
class ApiClient {
  static ApiClient? _instance;
  late final Dio _dio;

  /// Toggle this to `false` when a real backend is available.
  static bool isDemo = true;

  ApiClient._internal({
    String? baseUrl,
    String? authToken,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? 'https://api.schoolerp.example.com/v1',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      _AuthInterceptor(authToken),
      if (kDebugMode) _LogInterceptor(),
      _ErrorInterceptor(),
    ]);
  }

  /// Initialize the singleton. Call once at app startup.
  static void init({String? baseUrl, String? authToken}) {
    _instance = ApiClient._internal(baseUrl: baseUrl, authToken: authToken);
  }

  static ApiClient get instance {
    if (_instance == null) {
      _instance = ApiClient._internal();
    }
    return _instance!;
  }

  /// Update the auth token (e.g., after login / token refresh).
  void updateToken(String? token) {
    _dio.options.headers['Authorization'] =
        token != null ? 'Bearer $token' : null;
  }

  // -- Convenience HTTP methods that return typed responses --

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    required T Function(dynamic json) fromJson,
  }) async {
    if (isDemo) return ApiResponse.error('Demo mode');
    try {
      final response = await _dio.get(path, queryParameters: queryParams);
      return ApiResponse.success(
        data: _parseData<T>(response.data, fromJson),
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  Future<ApiResponse<List<T>>> getList<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    required T Function(dynamic json) fromJson,
    String dataKey = 'data',
  }) async {
    if (isDemo) return ApiResponse.error('Demo mode');
    try {
      final response = await _dio.get(path, queryParameters: queryParams);
      final rawList = _extractList(response.data, dataKey);
      final items = rawList.map((e) => fromJson(e)).toList();
      return ApiResponse.success(data: items, statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    Map<String, dynamic>? body,
    required T Function(dynamic json) fromJson,
  }) async {
    if (isDemo) return ApiResponse.error('Demo mode');
    try {
      final response = await _dio.post(path, data: body);
      return ApiResponse.success(
        data: _parseData<T>(response.data, fromJson),
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    Map<String, dynamic>? body,
    required T Function(dynamic json) fromJson,
  }) async {
    if (isDemo) return ApiResponse.error('Demo mode');
    try {
      final response = await _dio.put(path, data: body);
      return ApiResponse.success(
        data: _parseData<T>(response.data, fromJson),
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  Future<ApiResponse<void>> delete(String path) async {
    if (isDemo) return ApiResponse.error('Demo mode');
    try {
      await _dio.delete(path);
      return ApiResponse.success(statusCode: 204);
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  // -- Helpers --

  T _parseData<T>(dynamic data, T Function(dynamic json) fromJson) {
    if (data is Map<String, dynamic>) {
      // Check for nested data key
      if (data.containsKey('data')) {
        return fromJson(data['data']);
      }
      return fromJson(data);
    }
    return fromJson(data);
  }

  List<dynamic> _extractList(dynamic data, String dataKey) {
    if (data is Map<String, dynamic> && data.containsKey(dataKey)) {
      final raw = data[dataKey];
      if (raw is List) return raw;
    }
    if (data is List) return data;
    return [];
  }

  String _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please check your internet.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        final message = e.response?.data is Map
            ? (e.response?.data as Map)['message'] ?? ''
            : '';
        if (code == 401) return 'Session expired. Please login again.';
        if (code == 403) return 'You don\'t have permission.';
        if (code == 404) return 'Resource not found.';
        if (code == 500) return 'Server error. Please try later.';
        return message.isNotEmpty ? message.toString() : 'Request failed ($code).';
      case DioExceptionType.cancel:
        return 'Request cancelled.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}

// -- Interceptors --

class _AuthInterceptor extends Interceptor {
  final String? token;

  _AuthInterceptor(this.token);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

class _LogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('[API] ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('[API] ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('[API] ERROR ${err.type} ${err.message}');
    handler.next(err);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Could trigger token refresh on 401 here
    handler.next(err);
  }
}

// -- Response Wrapper --

class ApiResponse<T> {
  final T? data;
  final String? error;
  final int? statusCode;
  final bool isSuccess;

  ApiResponse._({
    this.data,
    this.error,
    this.statusCode,
    required this.isSuccess,
  });

  factory ApiResponse.success({T? data, int? statusCode}) {
    return ApiResponse._(
      data: data,
      statusCode: statusCode,
      isSuccess: true,
    );
  }

  factory ApiResponse.error(String error, {int? statusCode}) {
    return ApiResponse._(
      error: error,
      statusCode: statusCode,
      isSuccess: false,
    );
  }
}
