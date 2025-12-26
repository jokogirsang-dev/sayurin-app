// lib/middleware/role_middleware.dart
// 👑 Role-based access control (RBAC) middleware
// Berdasarkan flowchart "RBAC Matrix" dan role separation

import '../utils/error_handler.dart';

/// Middleware untuk handle role-based access control
class RoleMiddleware {
  /// ============================================
  /// ROLE VALIDATION
  /// ============================================

  /// Check if user has required role
  /// Support single role atau multiple roles (OR logic)
  static bool hasRole(String? userRole, dynamic requiredRoles) {
    if (userRole == null || userRole.isEmpty) {
      return false;
    }

    if (requiredRoles is String) {
      return userRole == requiredRoles;
    }

    if (requiredRoles is List<String>) {
      return requiredRoles.contains(userRole);
    }

    return false;
  }

  /// Check if user is admin (admin atau super_admin)
  static bool isAdmin(String? userRole) {
    return userRole == 'ADMIN' || userRole == 'SUPER_ADMIN';
  }

  /// Check if user is customer
  static bool isCustomer(String? userRole) {
    return userRole == 'CUSTOMER';
  }

  /// Check if user is super admin
  static bool isSuperAdmin(String? userRole) {
    return userRole == 'SUPER_ADMIN';
  }

  /// ============================================
  /// PERMISSION CHECKING
  /// ============================================

  /// Check if user has specific permission
  static bool hasPermission(String userRole, String permission) {
    final rolePermissions = _getRolePermissions(userRole);
    return rolePermissions.contains(permission);
  }

  /// Check if user has any of the required permissions
  static bool hasAnyPermission(String userRole, List<String> permissions) {
    final rolePermissions = _getRolePermissions(userRole);
    return permissions.any((p) => rolePermissions.contains(p));
  }

  /// Check if user has all of the required permissions
  static bool hasAllPermissions(String userRole, List<String> permissions) {
    final rolePermissions = _getRolePermissions(userRole);
    return permissions.every((p) => rolePermissions.contains(p));
  }

  /// Get all permissions for a role
  static List<String> _getRolePermissions(String role) {
    switch (role) {
      case 'CUSTOMER':
        return [
          'VIEW_HOME',
          'SEARCH_PRODUCTS',
          'VIEW_PRODUCT_DETAIL',
          'MANAGE_CART',
          'CREATE_ORDER',
          'VIEW_ORDER',
          'CANCEL_ORDER',
          'REVIEW_PRODUCT',
          'VIEW_PROFILE',
          'EDIT_PROFILE',
        ];

      case 'ADMIN':
        return [
          // All customer permissions
          'VIEW_HOME',
          'SEARCH_PRODUCTS',
          'VIEW_PRODUCT_DETAIL',
          'MANAGE_CART',
          'CREATE_ORDER',
          'VIEW_ORDER',
          'CANCEL_ORDER',
          'REVIEW_PRODUCT',
          'VIEW_PROFILE',
          'EDIT_PROFILE',
          // Admin specific permissions
          'VIEW_DASHBOARD',
          'MANAGE_PRODUCTS',
          'MANAGE_ORDERS',
          'VIEW_REPORTS',
          'MANAGE_USERS',
        ];

      case 'SUPER_ADMIN':
        return [
          // All permissions
          'VIEW_HOME',
          'SEARCH_PRODUCTS',
          'VIEW_PRODUCT_DETAIL',
          'MANAGE_CART',
          'CREATE_ORDER',
          'VIEW_ORDER',
          'CANCEL_ORDER',
          'REVIEW_PRODUCT',
          'VIEW_PROFILE',
          'EDIT_PROFILE',
          'VIEW_DASHBOARD',
          'MANAGE_PRODUCTS',
          'MANAGE_ORDERS',
          'VIEW_REPORTS',
          'MANAGE_USERS',
          'MANAGE_ROLES',
          'MANAGE_PERMISSIONS',
          'VIEW_ANALYTICS',
        ];

      default:
        return [];
    }
  }

  /// ============================================
  /// ROUTE ACCESS CONTROL
  /// ============================================

  /// Check if user can access route based on role
  static bool canAccessRoute(String? userRole, String routeName) {
    if (userRole == null) {
      return false;
    }

    // Public routes accessible by everyone
    final publicRoutes = [
      '/login',
      '/register',
      '/forgot-password',
      '/reset-password',
      '/about',
      '/terms',
      '/privacy',
    ];

    if (publicRoutes.contains(routeName)) {
      return true;
    }

    // Role-specific routes
    final customerRoutes = [
      '/home',
      '/search',
      '/product-detail',
      '/cart',
      '/checkout',
      '/orders',
      '/order-detail',
      '/profile',
    ];

    if (isAdmin(userRole)) {
      return true; // Admin can access all routes
    }

    if (isCustomer(userRole)) {
      return customerRoutes.contains(routeName);
    }

    return false;
  }

  /// Check if user can access specific resource (e.g., edit other user's profile)
  static bool canAccessResource(String userRole, String resourceType,
      dynamic resourceOwnerId, String? currentUserId) {
    // Super admin dapat access semua resource
    if (isSuperAdmin(userRole)) {
      return true;
    }

    // Admin can access most resources
    if (isAdmin(userRole)) {
      return resourceType != 'profile'; // Except other user's profile
    }

    // Customer hanya dapat access own resources
    if (isCustomer(userRole)) {
      return resourceOwnerId == currentUserId;
    }

    return false;
  }

  /// ============================================
  /// ACTION ACCESS CONTROL
  /// ============================================

  /// Check if user can perform specific action
  static bool canPerformAction(String userRole, String action) {
    switch (action) {
      // Create actions
      case 'create_product':
        return isAdmin(userRole);
      case 'create_order':
        return true; // All authenticated users
      case 'create_review':
        return isCustomer(userRole);

      // Edit actions
      case 'edit_product':
        return isAdmin(userRole);
      case 'edit_profile':
        return true; // All authenticated users
      case 'edit_order':
        return false; // Orders cannot be edited after creation

      // Delete actions
      case 'delete_product':
        return isSuperAdmin(userRole);
      case 'delete_order':
        return false; // Orders should not be deleted
      case 'delete_user':
        return isSuperAdmin(userRole);

      // View actions
      case 'view_analytics':
        return isAdmin(userRole);
      case 'view_reports':
        return isAdmin(userRole);
      case 'view_all_orders':
        return isAdmin(userRole);

      // Admin actions
      case 'manage_users':
        return isSuperAdmin(userRole);
      case 'manage_roles':
        return isSuperAdmin(userRole);

      default:
        return false;
    }
  }

  /// ============================================
  /// FEATURE ACCESSIBILITY
  /// ============================================

  /// Check if feature is accessible for user role
  static bool isFeatureAccessible(String userRole, String featureName) {
    switch (featureName) {
      // Customer features
      case 'home':
      case 'search':
      case 'cart':
      case 'checkout':
      case 'order_tracking':
      case 'reviews':
        return !isAdmin(userRole);

      // Admin features
      case 'admin_dashboard':
      case 'product_management':
      case 'order_management':
      case 'user_management':
      case 'reports':
      case 'analytics':
        return isAdmin(userRole);

      // Super admin only features
      case 'role_management':
      case 'permission_management':
      case 'system_settings':
        return isSuperAdmin(userRole);

      // Universal features
      case 'profile':
      case 'settings':
      case 'logout':
        return true;

      default:
        return false;
    }
  }

  /// ============================================
  /// VALIDATION & ENFORCEMENT
  /// ============================================

  /// Validate user access dan throw exception jika denied
  static void enforceRoleAccess(String? userRole, dynamic requiredRoles) {
    if (!hasRole(userRole, requiredRoles)) {
      throw AppException(
        code: 'FORBIDDEN',
        message: 'User does not have required role',
        userMessage: 'Anda tidak memiliki akses ke halaman ini.',
      );
    }
  }

  /// Enforce permission access
  static void enforcePermission(String userRole, String permission) {
    if (!hasPermission(userRole, permission)) {
      throw AppException(
        code: 'FORBIDDEN',
        message: 'User does not have required permission: $permission',
        userMessage: 'Anda tidak memiliki izin untuk melakukan aksi ini.',
      );
    }
  }

  /// ============================================
  /// HELPERS
  /// ============================================

  /// Get role display name (Indonesian)
  static String getRoleDisplayName(String role) {
    switch (role) {
      case 'CUSTOMER':
        return 'Pelanggan';
      case 'ADMIN':
        return 'Admin';
      case 'SUPER_ADMIN':
        return 'Super Admin';
      default:
        return role;
    }
  }

  /// Get all available roles
  static List<String> getAllRoles() {
    return [
      'CUSTOMER',
      'ADMIN',
      'SUPER_ADMIN',
    ];
  }

  /// Get role icon/emoji
  static String getRoleEmoji(String role) {
    switch (role) {
      case 'CUSTOMER':
        return '🛒';
      case 'ADMIN':
        return '👨‍💼';
      case 'SUPER_ADMIN':
        return '👑';
      default:
        return '👤';
    }
  }

  /// Log role access attempt
  static void logAccessAttempt(
    String? userId,
    String? userRole,
    String action,
    bool granted, {
    String? reason,
  }) {
    print('╔════════════════════════════════════════════════════════════════╗');
    print('║ ${granted ? '✅ ACCESS GRANTED' : '❌ ACCESS DENIED'}');
    print('╠════════════════════════════════════════════════════════════════╣');
    print('║ User ID: $userId');
    print('║ Role: $userRole');
    print('║ Action: $action');
    if (reason != null) {
      print('║ Reason: $reason');
    }
    print('╚════════════════════════════════════════════════════════════════╝');
  }
}

/// Extension untuk easier role checking
extension RoleExtension on String? {
  /// Check if this role is admin
  bool get isAdminRole => RoleMiddleware.isAdmin(this);

  /// Check if this role is customer
  bool get isCustomerRole => RoleMiddleware.isCustomer(this);

  /// Check if this role is super admin
  bool get isSuperAdminRole => RoleMiddleware.isSuperAdmin(this);

  /// Get display name
  String get displayName => RoleMiddleware.getRoleDisplayName(this ?? '');

  /// Get emoji
  String get emoji => RoleMiddleware.getRoleEmoji(this ?? '');

  /// Check permission
  bool hasPermission(String permission) {
    if (this == null) return false;
    return RoleMiddleware.hasPermission(this!, permission);
  }
}
