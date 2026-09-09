class ApiResponse<T> {
  final bool isSuccess;
  final T? data;
  final String? message;
  final int? statusCode;

  ApiResponse({
    required this.isSuccess,
    this.data,
    this.message,
    this.statusCode,
  });

  factory ApiResponse.success(T data, {int statusCode = 200, String? message}) {
    return ApiResponse<T>(
      isSuccess: true,
      data: data,
      statusCode: statusCode,
      message: message,
    );
  }

  factory ApiResponse.error(String message, {int? statusCode}) {
    return ApiResponse<T>(
      isSuccess: false,
      data: null,
      message: message,
      statusCode: statusCode,
    );
  }
}
