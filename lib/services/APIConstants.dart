class ApiConstants {
  static const String baseUrl = 'http://localhost:8000/api/v1';
  static const String appUrl = 'http://localhost:8000';
  static const String dashboardEndpoint = '$baseUrl/dashboard/';
  static const String loginEndpoint = '$baseUrl/login/';
  static const String refreshTokenEndpoint = '$baseUrl/token/refresh/';
  static const String reservationEndpoint = '$baseUrl/reservations/';
  static const String passwordReissueEndpoint = '$baseUrl/forgot-password/';
  static const String deviceListEndpoint = '$baseUrl/devices/';
  static const String cartEndpoint = '$baseUrl/cart/';
  static const String categoryEndpoint = '$baseUrl/categories/';

  static String userProfile(String userId) => '$baseUrl/users/$userId/profile/';

  
  static String getImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) {
      return imagePath;
    }

    return '$appUrl$imagePath';
  }
}
