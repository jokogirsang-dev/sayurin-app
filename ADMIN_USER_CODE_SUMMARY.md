# 👑 Admin & User System - HORTASIMA FRESH

## 📌 Overview
Sistem aplikasi ini memiliki 2 role: **Admin** dan **User** dengan fitur yang berbeda.

---

## 🔑 Akun Demo Login

### 👑 ADMIN
- **Email:** `admin@hortasima.com`
- **Password:** `12345`
- **Role:** Admin
- **Features:** Dashboard, Kelola Produk, Lihat Pesanan, Laporan

### 🛒 USER (Pembeli)
- **Email:** `jokog@gmail.com`
- **Password:** `12345`
- **Role:** User
- **Features:** Belanja, Cart, Checkout, Pesanan Saya

---

## 📁 Struktur File

### 1. **Model User** (`lib/model/user.dart`)
```dart
class User {
  final int id;
  final String name;
  final String email;
  final String role; // 'admin' atau 'user'
  
  bool get isAdmin => role == 'admin';
  bool get isUser => role == 'user';
}
```

### 2. **User Provider** (`lib/providers/user_provider.dart`)
- Mengelola authentication
- Menyimpan current user
- Provide role checking
- Getter: `isAdmin`, `isUser`, `isLoggedIn`

**Contoh Penggunaan:**
```dart
final userProv = Provider.of<UserProvider>(context);
if (userProv.isAdmin) {
  // Show admin features
}
```

### 3. **Login Page** (`lib/ui/login_page.dart`)
- Demo account tersembunyi (tekan lama untuk lihat)
- Validasi email & password
- Redirect berdasarkan role

### 4. **Admin Dashboard** (`lib/ui/admin_dashboard.dart`)
- Melihat daftar produk
- Tambah/hapus produk (simulasi CRUD)
- Manage inventory

**Features:**
- ✅ Tampil produk dari API
- ✅ Tambah produk baru
- ✅ Hapus produk
- ❌ Edit produk (belum diimplementasi)

### 5. **Pesanan Page** (`lib/ui/pesanan_page.dart`)
- Tampil berbeda untuk Admin vs User
- Admin: Lihat semua pesanan + aksi approval
- User: Lihat pesanan pribadi + tracking

**Admin Actions:**
- Lihat Detail
- Approve (Diproses → Dikemas)
- Hapus Pesanan

**User Actions:**
- Lihat Detail
- Batalkan Pesanan

---

## 🎯 Fitur Berdasarkan Role

### 👑 Admin Features
| Feature | File | Status |
|---------|------|--------|
| Dashboard | `admin_dashboard.dart` | ✅ |
| Kelola Produk (CRUD) | `admin_dashboard.dart` | ⚠️ Create hanya simulasi |
| Lihat Semua Pesanan | `pesanan_page.dart` | ✅ |
| Approve Pesanan | `pesanan_page.dart` | ✅ |
| Laporan Penjualan | `laporan_page.dart` | ✅ |
| Edit Produk | - | ❌ Belum |
| Filter Pesanan | `pesanan_page.dart` | ✅ |

### 🛒 User Features
| Feature | File | Status |
|---------|------|--------|
| Lihat Produk | `produk_page.dart` | ✅ |
| Belanja | `cart_page.dart` | ✅ |
| Checkout | `checkout_page.dart` | ✅ |
| Pesanan Saya | `pesanan_page.dart` | ✅ |
| Tracking Pesanan | `pesanan_page.dart` | ✅ |
| Profil | `profile_page.dart` | ✅ |

---

## 🔐 Authentication Flow

```
Login Page
    ↓
Input Email & Password
    ↓
UserProvider.login()
    ↓
Check Role (admin/user)
    ↓
Update CurrentUser
    ↓
Navigate to Home
    ↓
Show Different UI based on Role
```

---

## 💻 Code Examples

### Contoh 1: Check Role di Widget
```dart
Widget build(BuildContext context) {
  final userProv = Provider.of<UserProvider>(context);
  
  if (userProv.isAdmin) {
    return AdminDashboard();
  } else if (userProv.isUser) {
    return UserHomePage();
  }
  return LoginPage();
}
```

### Contoh 2: Show Different Actions
```dart
Widget _buildActionButtons(bool isAdmin) {
  if (isAdmin) {
    return Row(
      children: [
        ElevatedButton(label: 'Approve'),
        ElevatedButton(label: 'Reject'),
      ],
    );
  } else {
    return Row(
      children: [
        ElevatedButton(label: 'Track Order'),
        ElevatedButton(label: 'Cancel Order'),
      ],
    );
  }
}
```

### Contoh 3: Restrict Route untuk Admin Only
```dart
// Di pesanan_page.dart
final isAdmin = userProvider.isAdmin;

return Scaffold(
  appBar: AppBar(
    title: Text(isAdmin ? '👑 Admin Mode' : '🛒 Mode Pembeli'),
  ),
);
```

---

## 📊 Data Models

### User Model
```dart
{
  "id": 1,
  "name": "Admin Hortasima",
  "email": "admin@hortasima.com",
  "role": "admin"
}
```

### Pesanan Model
```dart
{
  "id": 1,
  "userId": 2,
  "products": [...],
  "totalPrice": 50000,
  "status": "Diproses", // Diproses, Dikemas, Dikirim, Selesai
  "createdAt": "2024-12-22"
}
```

---

## 🚀 Cara Mengintegrasikan dengan API

### Step 1: Update UserProvider
```dart
Future<bool> login({
  required String email,
  required String password,
}) async {
  final response = await http.post(
    Uri.parse('https://api.hortasima.com/login'),
    body: {
      'email': email,
      'password': password,
    },
  );
  
  if (response.statusCode == 200) {
    final userData = User.fromJson(jsonDecode(response.body));
    _currentUser = userData;
    notifyListeners();
    return true;
  }
  return false;
}
```

### Step 2: Store Token (Optional)
```dart
import 'package:shared_preferences/shared_preferences.dart';

// Save token
final prefs = await SharedPreferences.getInstance();
await prefs.setString('token', response.body['token']);

// Load token on app start
final token = prefs.getString('token');
if (token != null) {
  // Auto-login user
}
```

### Step 3: Update Admin Dashboard
```dart
// Ganti ProdukService().fetchProduk()
// dengan API call yang real
_futureProduk = ProdukService().fetchProduk(); // API call
```

---

## 🛠️ Routing Configuration

File: `lib/routes/app_routes.dart`

```dart
static Map<String, WidgetBuilder> routes = {
  '/home': (_) => const HomePage(),
  '/admin': (_) => const AdminDashboard(),
  '/pesanan': (_) => const PesananPage(),
  '/profile': (_) => const ProfilePage(),
  // ... more routes
};
```

---

## 🔍 Debugging Tips

### Lihat Role User Saat Ini
```dart
final userProv = Provider.of<UserProvider>(context);
print('Current User: ${userProv.currentUser?.name}');
print('Is Admin: ${userProv.isAdmin}');
print('Role: ${userProv.userRole}');
```

### Test Role Switching
1. Login sebagai Admin → lihat admin features
2. Logout
3. Login sebagai User → lihat user features

### Check Role di AppBar
```dart
AppBar(
  title: Text(userProvider.isAdmin ? '👑 Admin' : '🛒 User'),
)
```

---

## 📋 Checklist Features

- [x] User Model dengan role
- [x] Login dengan admin/user
- [x] UserProvider untuk state management
- [x] Admin Dashboard
- [x] Role-based UI rendering
- [x] Pesanan page dengan admin/user view
- [x] Demo accounts
- [x] Logout functionality
- [ ] Real API integration
- [ ] JWT token handling
- [ ] Edit produk (admin)
- [ ] User profile editing

---

## 🎓 Learning Path

1. **Understand User Model** → Buka `lib/model/user.dart`
2. **Understand UserProvider** → Buka `lib/providers/user_provider.dart`
3. **Try Login** → Login dengan akun demo
4. **Explore Admin Features** → Buka AdminDashboard
5. **Explore User Features** → Buka PesananPage
6. **Customize** → Edit sesuai kebutuhan

---

**Created:** December 22, 2025  
**Framework:** Flutter  
**State Management:** Provider  
**Database:** Simulasi (Hardcoded)

