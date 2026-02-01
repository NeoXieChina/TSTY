// 封装dio
import 'package:dio/dio.dart';
import 'package:tsty_app/constants/index.dart';

class DioUtils {
  final Dio _dio = Dio();

  DioUtils() {
    _dio.options
      ..baseUrl = GlobalConstants.apiBaseUrl
      ..connectTimeout = GlobalConstants.timeoutDuration
      ..receiveTimeout = GlobalConstants.timeoutDuration;

    _addInterceptors();
  }

  void _addInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 在请求发送之前做一些处理
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // 在响应到达之前做一些处理
          return handler.next(response);
        },
        onError: (error, handler) {
          // 在发生错误时做一些处理
          return handler.next(error);
        },
      ),
    );
  }

  Future<dynamic> get(String url, {Map<String, dynamic>? params}) async {
    return _handleRequest(await _dio.get(url, queryParameters: params));
  }

  Future<dynamic> post(String url, {Map<String, dynamic>? data}) async {
    try {
      Response response = await _dio.post(url, data: data);
      return response.data;
    } catch (e) {
      throw Exception('POST请求出错: $e');
    }
  }

  Future<dynamic> _handleRequest(Response<dynamic> task) async {
    try {
      Response<dynamic> result = task;
      Map<String, dynamic> handledRes = result.data as Map<String, dynamic>;
      if (handledRes["code"] == GlobalConstants.successState) {
        return handledRes["data"];
      }
      throw Exception(handledRes["message"] ?? "数据处理出错！");
    } catch (e) {
      throw Exception(e);
    }
  }
}

// 创建单例对象
final DioUtils dioUtils = DioUtils();
