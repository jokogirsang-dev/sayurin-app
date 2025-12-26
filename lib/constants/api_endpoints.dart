// lib/constants/api_endpoints.dart
// 🌐 Sentralisasi semua API endpoints

class ApiEndpoints {
  // Base URL - CHANGE berdasarkan environment
  static const String baseUrl = 'http://localhost:3000/api'; // DEV
  // static const String baseUrl = 'https://staging.hortasima.com/api'; // STAGING
  // static const String baseUrl = 'https://api.hortasima.com/api'; // PROD

  // API Version
  static const String apiVersion = '/v1';

  /// ============================================
  /// AUTHENTICATION ENDPOINTS
  /// ============================================
  static const String authLogin = '$apiVersion/auth/login';
  static const String authRegister = '$apiVersion/auth/register';
  static const String authLogout = '$apiVersion/auth/logout';
  static const String authRefreshToken = '$apiVersion/auth/refresh-token';
  static const String authVerifyEmail = '$apiVersion/auth/verify-email';
  static const String authForgotPassword = '$apiVersion/auth/forgot-password';
  static const String authResetPassword = '$apiVersion/auth/reset-password';
  static const String authEnable2FA = '$apiVersion/auth/2fa/enable';
  static const String authVerify2FA = '$apiVersion/auth/2fa/verify';

  /// ============================================
  /// USER ENDPOINTS
  /// ============================================
  static const String userProfile = '$apiVersion/users/profile';
  static const String userUpdateProfile = '$apiVersion/users/profile';
  static const String userChangePassword = '$apiVersion/users/password';
  static const String userDeleteAccount = '$apiVersion/users/account';
  static const String userAddresses = '$apiVersion/users/addresses';
  static String userAddress(String id) => '$apiVersion/users/addresses/$id';
  static const String userWishlist = '$apiVersion/users/wishlist';
  static const String userNotifications = '$apiVersion/users/notifications';

  /// ============================================
  /// PRODUCT ENDPOINTS
  /// ============================================
  static const String productList = '$apiVersion/products';
  static String productDetail(String id) => '$apiVersion/products/$id';
  static const String productSearch = '$apiVersion/products/search';
  static String productCategory(String category) =>
      '$apiVersion/products/category/$category';
  static const String productFeatured = '$apiVersion/products/featured';
  static const String productTrending = '$apiVersion/products/trending';
  static String productReviews(String productId) =>
      '$apiVersion/products/$productId/reviews';

  // Admin: Product Management
  static const String adminProductCreate = '$apiVersion/admin/products';
  static String adminProductUpdate(String id) =>
      '$apiVersion/admin/products/$id';
  static String adminProductDelete(String id) =>
      '$apiVersion/admin/products/$id';
  static const String adminProductBulkImport =
      '$apiVersion/admin/products/bulk';
  static const String adminProductAnalytics =
      '$apiVersion/admin/products/analytics';

  /// ============================================
  /// CART ENDPOINTS
  /// ============================================
  static const String cartGet = '$apiVersion/cart';
  static const String cartAdd = '$apiVersion/cart/items';
  static String cartUpdate(String itemId) => '$apiVersion/cart/items/$itemId';
  static String cartRemove(String itemId) => '$apiVersion/cart/items/$itemId';
  static const String cartClear = '$apiVersion/cart/clear';

  /// ============================================
  /// ORDER ENDPOINTS
  /// ============================================
  static const String orderCreate = '$apiVersion/orders';
  static const String orderList = '$apiVersion/orders';
  static String orderDetail(String id) => '$apiVersion/orders/$id';
  static String orderCancel(String id) => '$apiVersion/orders/$id/cancel';
  static String orderReturn(String id) => '$apiVersion/orders/$id/return';
  static String orderTrack(String id) => '$apiVersion/orders/$id/tracking';
  static String orderInvoice(String id) => '$apiVersion/orders/$id/invoice';

  // Admin: Order Management
  static const String adminOrderList = '$apiVersion/admin/orders';
  static String adminOrderDetail(String id) => '$apiVersion/admin/orders/$id';
  static String adminOrderApprove(String id) =>
      '$apiVersion/admin/orders/$id/approve';
  static String adminOrderReject(String id) =>
      '$apiVersion/admin/orders/$id/reject';
  static String adminOrderUpdateStatus(String id) =>
      '$apiVersion/admin/orders/$id/status';
  static const String adminOrderBulkProcess =
      '$apiVersion/admin/orders/bulk/process';

  /// ============================================
  /// PAYMENT ENDPOINTS
  /// ============================================
  static const String paymentInitiate = '$apiVersion/payments/initiate';
  static const String paymentVerify = '$apiVersion/payments/verify';
  static const String paymentMethods = '$apiVersion/payments/methods';
  static const String paymentHistory = '$apiVersion/payments/history';
  static String paymentCancel(String id) => '$apiVersion/payments/$id/cancel';

  /// ============================================
  /// REVIEW & RATING ENDPOINTS
  /// ============================================
  static const String reviewCreate = '$apiVersion/reviews';
  static String reviewUpdate(String id) => '$apiVersion/reviews/$id';
  static String reviewDelete(String id) => '$apiVersion/reviews/$id';
  static String reviewList(String productId) =>
      '$apiVersion/products/$productId/reviews';

  /// ============================================
  /// PROMO & VOUCHER ENDPOINTS
  /// ============================================
  static const String promoList = '$apiVersion/promos';
  static String promoDetail(String code) => '$apiVersion/promos/$code';
  static const String promoValidate = '$apiVersion/promos/validate';
  static const String voucherList = '$apiVersion/vouchers';
  static const String voucherApply = '$apiVersion/vouchers/apply';

  // Admin: Promo Management
  static const String adminPromoCreate = '$apiVersion/admin/promos';
  static String adminPromoUpdate(String id) => '$apiVersion/admin/promos/$id';
  static String adminPromoDelete(String id) => '$apiVersion/admin/promos/$id';
  static const String adminVoucherCreate = '$apiVersion/admin/vouchers';
  static String adminVoucherUpdate(String id) =>
      '$apiVersion/admin/vouchers/$id';
  static String adminVoucherDelete(String id) =>
      '$apiVersion/admin/vouchers/$id';

  /// ============================================
  /// CHAT & MESSAGE ENDPOINTS
  /// ============================================
  static const String chatList = '$apiVersion/chats';
  static String chatDetail(String id) => '$apiVersion/chats/$id';
  static const String chatSendMessage = '$apiVersion/chats/messages';
  static String chatMarkAsRead(String id) => '$apiVersion/chats/$id/read';

  // Admin: Chat Management
  static const String adminChatList = '$apiVersion/admin/chats';
  static String adminChatDetail(String id) => '$apiVersion/admin/chats/$id';
  static const String adminChatRespond = '$apiVersion/admin/chats/respond';

  /// ============================================
  /// ANALYTICS & REPORTS ENDPOINTS
  /// ============================================
  // Admin: Analytics
  static const String adminDashboard = '$apiVersion/admin/dashboard';
  static const String adminSalesReport = '$apiVersion/admin/reports/sales';
  static const String adminProductReport = '$apiVersion/admin/reports/products';
  static const String adminCustomerReport =
      '$apiVersion/admin/reports/customers';
  static const String adminFinancialReport =
      '$apiVersion/admin/reports/financial';
  static const String adminExportReport = '$apiVersion/admin/reports/export';

  /// ============================================
  /// STORE ENDPOINTS (Admin)
  /// ============================================
  static const String adminStoreInfo = '$apiVersion/admin/store';
  static const String adminStoreUpdate = '$apiVersion/admin/store';
  static const String adminStoreSettings = '$apiVersion/admin/store/settings';
  static const String adminStaffList = '$apiVersion/admin/staff';
  static const String adminStaffCreate = '$apiVersion/admin/staff';
  static String adminStaffUpdate(String id) => '$apiVersion/admin/staff/$id';
  static String adminStaffDelete(String id) => '$apiVersion/admin/staff/$id';

  /// ============================================
  /// CATEGORY ENDPOINTS
  /// ============================================
  static const String categoryList = '$apiVersion/categories';
  static String categoryDetail(String id) => '$apiVersion/categories/$id';

  // Admin: Category Management
  static const String adminCategoryCreate = '$apiVersion/admin/categories';
  static String adminCategoryUpdate(String id) =>
      '$apiVersion/admin/categories/$id';
  static String adminCategoryDelete(String id) =>
      '$apiVersion/admin/categories/$id';

  /// ============================================
  /// LOCATION ENDPOINTS
  /// ============================================
  static const String provinces = '$apiVersion/locations/provinces';
  static String cities(String provinceId) =>
      '$apiVersion/locations/provinces/$provinceId/cities';
  static String districts(String cityId) =>
      '$apiVersion/locations/cities/$cityId/districts';
  static String villages(String districtId) =>
      '$apiVersion/locations/districts/$districtId/villages';

  /// ============================================
  /// SHIPPING ENDPOINTS
  /// ============================================
  static const String shippingMethods = '$apiVersion/shipping/methods';
  static const String shippingCalculate = '$apiVersion/shipping/calculate';
  static String shippingTrack(String trackingNumber) =>
      '$apiVersion/shipping/track/$trackingNumber';

  /// ============================================
  /// HEALTH CHECK
  /// ============================================
  static const String healthCheck = '$apiVersion/health';
  static const String serverStatus = '$apiVersion/status';

  /// ============================================
  /// HELPER METHODS
  /// ============================================
  static String getFullUrl(String endpoint) => baseUrl + endpoint;

  static String getFileUrl(String filePath) => '$baseUrl/files/$filePath';

  static String getImageUrl(String imagePath) => '$baseUrl/images/$imagePath';
}
