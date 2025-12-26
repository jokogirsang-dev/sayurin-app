# 🎯 HORTASIMA FLUTTER APP - COMPLETE IMPLEMENTATION ROADMAP

## 📊 PROJECT STATUS

```
PHASE 1: FOUNDATION & ARCHITECTURE ████████████████████░░░░░░░░░░░░░░ 65%
├─ ✅ App Constants (app_constants.dart)
├─ ✅ API Endpoints (api_endpoints.dart)
├─ ✅ Validators (validators.dart)
├─ ✅ Date Formatter (date_formatter.dart)
├─ ✅ Error Handler (error_handler.dart)
├─ ✅ Auth Middleware (auth_middleware.dart)
├─ ✅ Role Middleware (role_middleware.dart)
├─ ⏳ API Service (NEXT)
├─ ⏳ Local Storage Service
├─ ⏳ Main.dart Updates
└─ ⏳ Routes Refactoring

PHASE 2: CUSTOMER FEATURES ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ 0%
PHASE 3: ADMIN FEATURES ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ 0%
PHASE 4: TESTING & OPTIMIZATION ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ 0%
PHASE 5: DEPLOYMENT & MONITORING ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ 0%
```

---

## 🏗️ ARCHITECTURE OVERVIEW

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER (UI)                  │
│  home_page.dart, admin_dashboard.dart, cart_page.dart...    │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                    PROVIDER LAYER (STATE)                   │
│  user_provider.dart, cart_provider.dart, produk_provider... │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                    MIDDLEWARE LAYER (PROTECTION)            │
│  auth_middleware.dart, role_middleware.dart                 │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                    SERVICE LAYER (BUSINESS LOGIC)           │
│  api_service.dart, pesanan_service.dart, produk_service... │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                    DATA LAYER (API & STORAGE)               │
│  Backend API (Node.js/Django), Local Storage (SQLite)       │
└─────────────────────────────────────────────────────────────┘

UTILITIES & CONSTANTS (CROSS-LAYER)
├─ utils/
│  ├─ date_formatter.dart
│  ├─ error_handler.dart
│  └─ validators.dart
├─ constants/
│  ├─ app_constants.dart
│  └─ api_endpoints.dart
└─ config/
   └─ app_config.dart
```

---

## 📁 COMPLETE FILE STRUCTURE

```
lib/
├── main.dart                           # App entry point (akan diupdate)
├── assets/                             # Images, icons, fonts
├── config/                             # App configuration
│   ├── app_config.dart                 # Environment config
│   └── helpers/
├── constants/                          # Centralized constants
│   ├── app_constants.dart              # ✅ Colors, spacing, validation rules
│   └── api_endpoints.dart              # ✅ All API endpoints
├── middleware/                         # Request/Route protection
│   ├── auth_middleware.dart            # ✅ JWT verification
│   ├── role_middleware.dart            # ✅ RBAC
│   └── index.dart                      # ✅ Barrel export
├── model/                              # Data models
│   ├── pesanan.dart                    # Order model
│   ├── produk.dart                     # Product model
│   └── user.dart                       # User model (with roles)
├── providers/                          # State management
│   ├── user_provider.dart              # Auth & user state
│   ├── cart_provider.dart              # Cart state
│   ├── pesanan_provider.dart           # Order state
│   └── produk_provider.dart            # Product state
├── routes/                             # Navigation (akan diupdate)
│   └── app_routes.dart                 # Named routes with RBAC
├── service/                            # Business logic
│   ├── api_service.dart                # ⏳ HTTP client (akan direfactor)
│   ├── pesanan_service.dart            # Order API calls
│   ├── produk_service.dart             # Product API calls
│   ├── user_service.dart               # User API calls
│   └── local_storage_service.dart      # ⏳ Local data (akan dibuat)
├── ui/                                 # UI Pages (15 files)
│   ├── about_page.dart
│   ├── admin_dashboard.dart
│   ├── cart_page.dart
│   ├── checkout_page.dart
│   ├── home_page.dart
│   ├── laporan_page.dart
│   ├── login_page.dart
│   ├── payment_page.dart
│   ├── pesanan_page.dart
│   └── ... (10 more pages)
├── utils/                              # Utility functions
│   ├── date_formatter.dart             # ✅ Date formatting
│   ├── error_handler.dart              # ✅ Error handling
│   ├── validators.dart                 # ✅ Form validation
│   └── index.dart                      # ✅ Barrel export
└── widget/                             # Reusable widgets
    └── ... (custom widgets)
```

---

## 🔐 SECURITY ARCHITECTURE

```
REQUEST FLOW:
User Action (Login) → Validators.validate() → API Service
    ↓
Auth Middleware: Verify Response
    ↓
Store JWT Token (Secure)
    ↓
Set Token in Headers (Auto injection)
    ↓

SUBSEQUENT REQUESTS:
User Action → Auth Middleware: Check Token Validity
    ↓
IF expired: Refresh Token
    ↓
Role Middleware: Check Permissions
    ↓
✅ Allowed → Proceed / ❌ Denied → Show Error

PROTECTED ROUTES:
Navigate to /admin-dashboard
    ↓
Route Guard: Auth Middleware
    ↓
Role Middleware: Check isAdmin()
    ↓
✅ Customer → Redirect / ❌ Admin → Show
```

---

## 🔑 DEMO ACCOUNTS FOR TESTING

```
CUSTOMER ACCOUNT:
Email:    jokog@gmail.com
Password: 12345
Role:     CUSTOMER 🛒
Permissions:
  ✅ View home, search, product detail
  ✅ Manage cart, checkout
  ✅ Create & view orders
  ✅ Leave reviews
  ✅ Edit profile

ADMIN ACCOUNT:
Email:    admin@hortasima.com
Password: 12345
Role:     ADMIN 👨‍💼
Permissions:
  ✅ All customer permissions
  ✅ Admin dashboard access
  ✅ Product management (CRUD)
  ✅ Order management
  ✅ User management
  ✅ Reports & analytics

SUPER ADMIN ACCOUNT:
Email:    superadmin@hortasima.com
Password: 12345
Role:     SUPER_ADMIN 👑
Permissions:
  ✅ All permissions
  ✅ Role management
  ✅ System settings
  ✅ Analytics dashboard
```

---

## 📚 IMPLEMENTED UTILITIES & MIDDLEWARE

### ✅ VALIDATORS (lib/utils/validators.dart)
```dart
// Email validation
Validators.validateEmail('user@example.com')  // true

// Password strength
Validators.validatePassword('SecurePass123!')  // true

// Phone number
Validators.validatePhone('+628123456789')      // true

// Composite validation
final errors = Validators.validateForm({
  'email': 'invalid-email',
  'password': '123',
});
// Returns: {'email': 'Email tidak valid', 'password': 'Password terlalu lemah'}
```

### ✅ DATE FORMATTER (lib/utils/date_formatter.dart)
```dart
// Date formatting
DateFormatter.formatDate(DateTime.now())        // 22/12/2025
DateFormatter.formatFullDate(date)              // Sunday, 22 December 2025

// Relative time
DateFormatter.formatRelativeTime(orderTime)     // 2 jam yang lalu

// Flash sale countdown
DateFormatter.formatFlashSaleCountdown(expiryTime)  // 02:30:45
```

### ✅ ERROR HANDLER (lib/utils/error_handler.dart)
```dart
try {
  await apiService.login(email, password);
} catch (e) {
  final appError = ErrorHandler.handleError(e);
  
  // User-friendly message
  print(appError.userMessage);  // "Email atau password salah"
  
  // Check error type
  if (ErrorHandler.isNetworkError(appError)) {
    // Show retry
  } else if (ErrorHandler.isAuthError(appError)) {
    // Redirect to login
  }
}
```

### ✅ AUTH MIDDLEWARE (lib/middleware/auth_middleware.dart)
```dart
// Verify token
final payload = AuthMiddleware.verifyToken(token);

// Check token validity
if (token.isValidToken) {
  print(token.userId);    // Extract user ID
  print(token.role);      // Extract role
  print(token.email);     // Extract email
}

// Auto refresh if needed
if (AuthMiddleware.shouldRefreshToken(token)) {
  await refreshTokens();
}
```

### ✅ ROLE MIDDLEWARE (lib/middleware/role_middleware.dart)
```dart
// Check role
if (userRole.isAdminRole) {
  // Show admin menu
}

// Check permission
if (RoleMiddleware.hasPermission(userRole, 'manage_products')) {
  // Show product management
}

// Enforce access (throws exception if denied)
try {
  RoleMiddleware.enforcePermission(userRole, 'delete_product');
} on AppException catch (e) {
  // Handle unauthorized
}

// Feature accessibility
if (RoleMiddleware.isFeatureAccessible(userRole, 'admin_dashboard')) {
  // Show feature
}
```

---

## 🎯 NEXT IMPLEMENTATION TASKS

### TASK 1: API SERVICE REFACTORING
**File:** `lib/service/api_service.dart`

**What to do:**
- [ ] Create base HTTP client using Dio
- [ ] Auto token injection dari secure storage
- [ ] Integrate ErrorHandler untuk centralized error handling
- [ ] Add retry logic untuk network errors (exponential backoff)
- [ ] Request/response logging
- [ ] Timeout configuration per endpoint
- [ ] Handle 401 unauthorized (refresh token atau redirect to login)

**Key features:**
```dart
// Auto token injection
dio.interceptors.add(TokenInterceptor());

// Auto error handling
dio.interceptors.add(ErrorHandlerInterceptor());

// Retry on failure
await apiService.getWithRetry('/products', maxRetries: 3);

// Logging
apiService.enableLogging(debug: true);
```

### TASK 2: LOCAL STORAGE SERVICE
**File:** `lib/service/local_storage_service.dart`

**What to do:**
- [ ] Wrapper untuk SharedPreferences
- [ ] Secure token storage (enkripsi)
- [ ] User data caching
- [ ] Cache invalidation logic
- [ ] Persistence helpers

**Key features:**
```dart
// Store token securely
await storage.saveToken(token);

// Retrieve token
String? token = await storage.getToken();

// Cache products
await storage.cacheProducts(products);

// Get cached data
List<Product> products = await storage.getCachedProducts();

// Clear all
await storage.clearAll();
```

### TASK 3: MAIN.DART UPDATES
**File:** `lib/main.dart`

**What to do:**
- [ ] Initialize all providers
- [ ] Setup error handling
- [ ] Implement splash screen with token check
- [ ] Setup theme dengan AppConstants.AppColors
- [ ] Configure localization (Indonesian)
- [ ] Add middleware untuk protected routes
- [ ] Error boundary untuk crashes

### TASK 4: ROUTES REFACTORING
**File:** `lib/routes/app_routes.dart`

**What to do:**
- [ ] Implement named routes (GoRouter or Navigation 2.0)
- [ ] Add route guards (middleware)
- [ ] Separate routes: customer vs admin
- [ ] Implement deep linking
- [ ] Handle unauthorized redirect

### TASK 5: PROVIDERS ENHANCEMENT
**Update files:**
- [ ] `lib/providers/user_provider.dart` - Token management, auto refresh
- [ ] `lib/providers/cart_provider.dart` - Better state management, error handling
- [ ] `lib/providers/produk_provider.dart` - Pagination, filtering, error handling
- [ ] `lib/providers/pesanan_provider.dart` - Order tracking, status updates

---

## 🚀 QUICK START GUIDE

### 1. Add Dependencies
```bash
flutter pub add jwt_decoder intl
```

### 2. Update pubspec.yaml
```yaml
dependencies:
  flutter:
    sdk: flutter
  intl: ^0.19.0
  jwt_decoder: ^2.0.1
  dio: ^5.3.1
  provider: ^6.0.0
  shared_preferences: ^2.2.0
  
dev_dependencies:
  flutter_test:
    sdk: flutter
```

### 3. Import in Files
```dart
// For middleware
import 'package:sayurin/middleware/index.dart';

// For utilities
import 'package:sayurin/utils/index.dart';

// For constants
import 'package:sayurin/constants/app_constants.dart';
import 'package:sayurin/constants/api_endpoints.dart';
```

### 4. Usage Examples

**In Provider:**
```dart
class UserProvider extends ChangeNotifier {
  String? _token;
  String? _userRole;

  Future<void> login(String email, String password) async {
    try {
      // Validate input
      final errors = Validators.validateForm({
        'email': email,
        'password': password,
      });
      
      if (errors.isNotEmpty) {
        throw AppException(
          code: AppConstants.ErrorCodes.VALIDATION_ERROR,
          message: errors.values.join(', '),
        );
      }

      // Call API
      final response = await apiService.post(
        ApiEndpoints.authLogin,
        data: {'email': email, 'password': password},
      );

      // Verify & store token
      _token = response['token'];
      final payload = AuthMiddleware.verifyToken(_token!);
      _userRole = payload?['role'];

      // Store securely
      await localStorage.saveToken(_token!);
      
      notifyListeners();
    } catch (e) {
      final appError = ErrorHandler.handleError(e);
      rethrow;
    }
  }
}
```

**In UI:**
```dart
class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        // Check role permission
        if (!RoleMiddleware.isAdmin(userProvider.userRole)) {
          return UnauthorizedPage();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Admin Dashboard'),
          ),
          body: _buildDashboard(context, userProvider),
        );
      },
    );
  }

  Widget _buildDashboard(context, userProvider) {
    return ListView(
      children: [
        // Products section
        if (RoleMiddleware.hasPermission(userProvider.userRole, 'manage_products'))
          _ProductsSection(),

        // Reports section
        if (RoleMiddleware.hasPermission(userProvider.userRole, 'view_reports'))
          _ReportsSection(),

        // Users section (only Super Admin)
        if (userProvider.userRole.isSuperAdminRole)
          _UsersSection(),
      ],
    );
  }
}
```

---

## 📊 IMPLEMENTATION TIMELINE

```
Week 1:
├─ ✅ Phase 1 Foundation (Completed)
│  └─ Constants, Validators, Middleware, Utilities
└─ ⏳ API Service & Local Storage (In Progress)

Week 2:
├─ ⏳ Main.dart & Routes Refactoring
├─ ⏳ Providers Enhancement
└─ ⏳ Phase 1 Completion

Week 3:
├─ ⏳ Phase 2: Customer Features
│  ├─ Home page with recommendations
│  ├─ Product search & filter
│  ├─ Shopping cart & checkout
│  └─ Order tracking & reviews
└─ Testing & Bug Fixes

Week 4:
├─ ⏳ Phase 3: Admin Features
│  ├─ Admin dashboard
│  ├─ Product management (CRUD)
│  ├─ Order management
│  └─ Reports & analytics
└─ Testing & Integration

Week 5-6:
├─ ⏳ Phase 4: Testing & Optimization
│  ├─ Unit tests
│  ├─ Integration tests
│  ├─ Performance optimization
│  └─ Security audit
└─ ⏳ Phase 5: Deployment
```

---

## 🎓 LEARNING RESOURCES

**JWT & Authentication:**
- JWT.io - JWT documentation
- Flutter JWT tutorial - Basic JWT implementation

**RBAC & Security:**
- OWASP - Security best practices
- JWT Security - Token security guidelines

**Flutter Best Practices:**
- Flutter Architecture - Clean Code principles
- Provider package - State management

---

## 🤝 CONTRIBUTOR NOTES

### Code Standards
- ✅ Follow Dart/Flutter style guide
- ✅ Use meaningful variable names (Indonesian display text, English code)
- ✅ Add comprehensive comments
- ✅ Type hint all variables & return types
- ✅ Handle errors explicitly
- ✅ Use extensions for cleaner code

### Commit Message Format
```
[PHASE1] Implement auth_middleware.dart

- Add JWT token verification
- Add role-based route guards
- Add permission checking
- Integrate with flowchart security section

Fixes #123
```

---

## 📞 SUPPORT & DEBUGGING

### Enable Debugging
```dart
// Log authentication
AuthMiddleware.logTokenInfo(token);

// Log role access
RoleMiddleware.logAccessAttempt(userId, role, action, granted);

// Log errors
ErrorHandler.logError(appException);

// Validate email
print(Validators.validateEmail('test@example.com'));

// Format date
print(DateFormatter.formatDateTime(DateTime.now()));
```

### Common Issues & Solutions

**Issue:** Token validation fails
**Solution:** Check token not expired, use `verifyToken()` with proper error handling

**Issue:** Role check not working
**Solution:** Ensure token has 'role' field in payload, use extensions (e.g., `userRole.isAdminRole`)

**Issue:** Date formatting different on different devices
**Solution:** Use centralized `DateFormatter` for consistency

**Issue:** Error messages in English instead of Indonesian
**Solution:** Ensure error handler returns from `_getErrorMessageFromResponse()`

---

**Last Updated:** Phase 1 - Middleware & Utilities Complete
**Next Review:** After Phase 1 Completion (API Service + Routes)
