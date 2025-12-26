# 🚀 QUICK START REFERENCE GUIDE

## 📦 WHAT'S BEEN CREATED

7 Core Infrastructure Files + 4 Documentation Files

```
lib/
├── constants/
│   ├── app_constants.dart      ✅ Colors, spacing, errors, roles
│   └── api_endpoints.dart      ✅ All API endpoints
├── middleware/
│   ├── auth_middleware.dart    ✅ JWT verification & refresh
│   ├── role_middleware.dart    ✅ RBAC enforcement
│   └── index.dart              ✅ Barrel exports
└── utils/
    ├── date_formatter.dart     ✅ Date/time formatting
    ├── error_handler.dart      ✅ Error handling & logging
    ├── validators.dart         ✅ Form validation
    └── index.dart              ✅ Barrel exports
```

---

## 🎯 QUICK CODE EXAMPLES

### 1️⃣ VALIDATE USER INPUT

```dart
import 'package:sayurin/utils/validators.dart';

// Validate single field
bool isValidEmail = Validators.validateEmail('user@example.com');

// Validate form
final errors = Validators.validateForm({
  'email': emailInput,
  'password': passwordInput,
  'name': nameInput,
});

if (errors.isNotEmpty) {
  // Show errors
  errors.forEach((field, message) {
    print('$field: $message');
  });
}
```

### 2️⃣ FORMAT DATES & TIMES

```dart
import 'package:sayurin/utils/date_formatter.dart';

// Current date
DateFormatter.formatDate(DateTime.now());           // 22/12/2025

// Relative time
DateFormatter.formatRelativeTime(orderTime);       // 2 jam yang lalu

// Flash sale countdown
DateFormatter.formatFlashSaleCountdown(expiryTime);// 02:30:45

// Order timestamp
DateFormatter.formatOrderTime(orderTime);          // Pesanan dibuat 3 jam yang lalu
```

### 3️⃣ HANDLE ERRORS

```dart
import 'package:sayurin/utils/error_handler.dart';

try {
  await apiService.login(email, password);
} catch (e) {
  final appError = ErrorHandler.handleError(e);
  
  // Show user-friendly message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(appError.userMessage))
  );
  
  // Check error type
  if (ErrorHandler.isNetworkError(appError)) {
    // Show retry button
  } else if (ErrorHandler.isAuthError(appError)) {
    // Redirect to login
  }
}
```

### 4️⃣ VERIFY & MANAGE TOKENS

```dart
import 'package:sayurin/middleware/auth_middleware.dart';

// Verify token
try {
  final payload = AuthMiddleware.verifyToken(token);
  print('User ID: ${payload['userId']}');
  print('Role: ${payload['role']}');
} on AppException catch (e) {
  // Handle invalid token
  print(e.userMessage); // "Token tidak valid. Silakan login kembali."
}

// Check if needs refresh
if (AuthMiddleware.shouldRefreshToken(token)) {
  await refreshToken();
}

// Using extensions (cleaner)
if (token.isValidToken) {
  print('User: ${token.userId}');
  print('Role: ${token.role}');
  print('Expires in: ${token.remainingTime}');
}
```

### 5️⃣ CHECK USER ROLE & PERMISSIONS

```dart
import 'package:sayurin/middleware/role_middleware.dart';

// Check role
if (RoleMiddleware.isAdmin(userRole)) {
  // Show admin features
}

// Check permission
if (RoleMiddleware.hasPermission(userRole, 'manage_products')) {
  // Show product management button
}

// Enforce access (throws exception if denied)
try {
  RoleMiddleware.enforcePermission(userRole, 'delete_product');
} on AppException catch (e) {
  print(e.userMessage); // "Anda tidak memiliki izin untuk melakukan aksi ini."
}

// Using extensions (cleaner)
if (userRole.isAdminRole) {
  // Admin only code
}

if (userRole.hasPermission('view_analytics')) {
  // Show analytics
}
```

### 6️⃣ USE CONSTANTS

```dart
import 'package:sayurin/constants/app_constants.dart';

// Colors
Color primaryColor = AppConstants.AppColors.primary;
Color errorColor = AppConstants.AppColors.error;

// Spacing
double padding = AppConstants.AppSpacing.m;  // 16px
double margin = AppConstants.AppSpacing.lg;  // 24px

// Typography
TextStyle heading = TextStyle(
  fontSize: AppConstants.AppTypography.headingLarge,
  fontWeight: FontWeight.bold,
);

// Error codes
String errorCode = AppConstants.ErrorCodes.UNAUTHORIZED;

// Validation rules
int minPasswordLength = AppConstants.AppValidation.passwordMinLength;

// User roles
String customerRole = AppConstants.UserRoles.CUSTOMER;
String adminRole = AppConstants.UserRoles.ADMIN;
```

### 7️⃣ USE API ENDPOINTS

```dart
import 'package:sayurin/constants/api_endpoints.dart';

// Base URL configuration
String baseUrl = ApiEndpoints.baseUrl;
// Change for different environments:
// - localhost: 'http://localhost:3000'
// - staging: 'https://staging-api.hortasima.com'
// - production: 'https://api.hortasima.com'

// Use endpoints
String loginUrl = ApiEndpoints.authLogin;           // /v1/auth/login
String productsUrl = ApiEndpoints.productsList;    // /v1/products
String ordersUrl = ApiEndpoints.ordersList;        // /v1/orders
String cartUrl = ApiEndpoints.cartAdd;             // /v1/cart/add
```

---

## 📊 ROLE PERMISSIONS SUMMARY

```
┌─────────────────────────┬──────────┬─────────┬──────────────┐
│ Feature                 │ Customer │  Admin  │ Super Admin  │
├─────────────────────────┼──────────┼─────────┼──────────────┤
│ View Home               │    ✅    │   ✅    │      ✅      │
│ Search Products         │    ✅    │   ✅    │      ✅      │
│ Create Order            │    ✅    │   ✅    │      ✅      │
│ View Dashboard          │    ❌    │   ✅    │      ✅      │
│ Manage Products         │    ❌    │   ✅    │      ✅      │
│ Manage Orders           │    ❌    │   ✅    │      ✅      │
│ View Reports            │    ❌    │   ✅    │      ✅      │
│ Manage Users            │    ❌    │   ❌    │      ✅      │
│ Manage Roles            │    ❌    │   ❌    │      ✅      │
└─────────────────────────┴──────────┴─────────┴──────────────┘

Demo Accounts:
Customer:   jokog@gmail.com / 12345
Admin:      admin@hortasima.com / 12345
Super Admin: superadmin@hortasima.com / 12345
```

---

## 🔧 COMMON TASKS

### Task 1: Validate Email in Form
```dart
String email = emailController.text;
if (!Validators.validateEmail(email)) {
  setState(() => emailError = 'Email tidak valid');
}
```

### Task 2: Show Relative Time for Order
```dart
Text(DateFormatter.formatRelativeTime(order.createdAt))
// Output: "2 jam yang lalu"
```

### Task 3: Protect Admin Feature
```dart
if (!RoleMiddleware.isAdmin(userRole)) {
  return Scaffold(
    body: Center(
      child: Text('Anda tidak memiliki akses ke halaman ini'),
    ),
  );
}
```

### Task 4: Handle API Error
```dart
try {
  await productService.deleteProduct(productId);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Produk berhasil dihapus'))
  );
} catch (e) {
  final error = ErrorHandler.handleError(e);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(error.userMessage ?? error.message))
  );
}
```

### Task 5: Check Permission Before Action
```dart
if (!RoleMiddleware.hasPermission(userRole, 'manage_products')) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Anda tidak memiliki izin untuk melakukan aksi ini'))
  );
  return;
}
// Proceed with action
```

### Task 6: Format Date for Display
```dart
// In list
Text(DateFormatter.formatDate(product.createdAt))   // 22/12/2025

// In details
Text(DateFormatter.formatFullDateTime(order.createdAt))
// Sunday, 22 December 2025 14:30
```

### Task 7: Refresh Expired Token
```dart
if (AuthMiddleware.shouldRefreshToken(token)) {
  try {
    final newToken = await authService.refreshToken();
    await localStorage.saveToken(newToken);
  } catch (e) {
    // Redirect to login
    Navigator.pushReplacementNamed(context, '/login');
  }
}
```

---

## ⚠️ COMMON MISTAKES TO AVOID

❌ **DON'T:** Hardcode colors in UI
```dart
// WRONG
Color color = Color(0xFF2196F3);

// RIGHT
Color color = AppConstants.AppColors.primary;
```

❌ **DON'T:** Inline validation logic
```dart
// WRONG
if (email.contains('@') && email.contains('.')) { ... }

// RIGHT
if (Validators.validateEmail(email)) { ... }
```

❌ **DON'T:** Show technical error messages
```dart
// WRONG
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text(e.toString()))
);

// RIGHT
final appError = ErrorHandler.handleError(e);
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text(appError.userMessage))
);
```

❌ **DON'T:** Use role directly without middleware
```dart
// WRONG
if (user['role'] == 'admin') { ... }

// RIGHT
if (RoleMiddleware.isAdmin(userRole)) { ... }
```

❌ **DON'T:** Forget to verify token before use
```dart
// WRONG
final userId = payload['userId'];

// RIGHT
try {
  final payload = AuthMiddleware.verifyToken(token);
  final userId = payload['userId'];
} catch (e) {
  // Handle error
}
```

---

## 📱 IMPORTS QUICK REFERENCE

```dart
// Constants
import 'package:sayurin/constants/app_constants.dart';
import 'package:sayurin/constants/api_endpoints.dart';

// Utilities
import 'package:sayurin/utils/index.dart'; // All utilities
// or individual imports:
import 'package:sayurin/utils/validators.dart';
import 'package:sayurin/utils/date_formatter.dart';
import 'package:sayurin/utils/error_handler.dart';

// Middleware
import 'package:sayurin/middleware/index.dart'; // All middleware
// or individual imports:
import 'package:sayurin/middleware/auth_middleware.dart';
import 'package:sayurin/middleware/role_middleware.dart';
```

---

## 🎓 KEY CONCEPTS

### JWT Token Structure
```
Token = Header.Payload.Signature
├─ Header: Algorithm info
├─ Payload: userId, email, role, iat (issued at), exp (expiration)
└─ Signature: HMAC-SHA256
```

### Error Code Categories
```
Network:    NO_INTERNET, TIMEOUT, SERVICE_UNAVAILABLE
Auth:       UNAUTHORIZED, FORBIDDEN, TOKEN_EXPIRED
Validation: INVALID_REQUEST, VALIDATION_ERROR
Server:     SERVER_ERROR, UNKNOWN_ERROR
```

### Role Hierarchy
```
CUSTOMER (🛒)
├─ Basic permissions
└─ Shopping features

ADMIN (👨‍💼)
├─ All customer permissions
└─ Management features

SUPER_ADMIN (👑)
├─ All permissions
└─ System administration
```

### Permission Types (Sample)
```
Customer:     VIEW_HOME, SEARCH_PRODUCTS, CREATE_ORDER, REVIEW_PRODUCT
Admin:        + MANAGE_PRODUCTS, MANAGE_ORDERS, VIEW_REPORTS
Super Admin:  + MANAGE_USERS, MANAGE_ROLES, VIEW_ANALYTICS
```

---

## 🔍 DEBUGGING TIPS

### Enable Token Logging
```dart
AuthMiddleware.logTokenInfo(token);
// Output: User ID, Email, Role, Expiration, Remaining time
```

### Enable Role Access Logging
```dart
RoleMiddleware.logAccessAttempt(userId, role, action, granted);
// Output: Access granted or denied with reason
```

### Enable Error Logging
```dart
ErrorHandler.logError(appError);
// Output: Detailed error info for debugging
```

### Check Token Validity
```dart
print('Token valid: ${token.isValidToken}');
print('Token expired: ${token.isExpired}');
print('Remaining: ${token.remainingTime}');
```

---

## 📞 WHERE TO FIND WHAT

| Need                  | File                          | Method/Property         |
|---------------------|-------------------------------|------------------------|
| Colors              | app_constants.dart            | AppColors.*             |
| Spacing             | app_constants.dart            | AppSpacing.*            |
| Error codes         | app_constants.dart            | ErrorCodes.*            |
| Validation          | validators.dart               | Validators.validate*()  |
| Date formatting     | date_formatter.dart           | DateFormatter.format*() |
| Error handling      | error_handler.dart            | ErrorHandler.handle*()  |
| Token verification  | auth_middleware.dart          | AuthMiddleware.*()      |
| Role checking       | role_middleware.dart          | RoleMiddleware.*()      |
| API endpoints       | api_endpoints.dart            | ApiEndpoints.*          |

---

## ✅ READY TO USE

All files are **production-ready** and can be used immediately in:
- ✅ User authentication flow
- ✅ Customer pages (home, search, cart, checkout)
- ✅ Admin dashboard
- ✅ Error handling
- ✅ Form validation
- ✅ Date/time display
- ✅ Role-based feature toggling

---

## 📚 FOR MORE DETAILS

| Question                    | See Document                |
|-----------------------------|---------------------------|
| How does auth work?         | HORTASIMA_FLOWCHART.md    |
| What's the full roadmap?    | IMPLEMENTATION_ROADMAP.md |
| Architecture details?       | ARCHITECTURE_DIAGRAMS.md  |
| Phase 1 completion status?  | PHASE1_CHECKLIST.md       |
| Usage examples?             | PHASE1_IMPLEMENTATION.md  |
| Summary of this phase?      | PHASE1_COMPLETE_SUMMARY.md|

---

**You are now ready to build upon this foundation! 🚀**

**Next step: API Service Refactoring to complete Phase 1**
