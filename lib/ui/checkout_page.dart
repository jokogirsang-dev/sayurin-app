import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/pesanan_provider.dart';
import '../providers/produk_provider.dart';
import '../providers/user_provider.dart';
import '../widget/custom_app_bar.dart';
import 'edit_profile_page.dart';
// import '../service/stripe_service.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _addrCtl = TextEditingController();
  String _kurir = 'JNE';
  String _payment = 'COD';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final userProv = Provider.of<UserProvider>(context, listen: false);
    _addrCtl.text = userProv.currentUser?.alamat ?? '';
  }

  @override
  void dispose() {
    _addrCtl.dispose();
    super.dispose();
  }

  Future<void> _placeOrder(BuildContext context) async {
    final cartProv = Provider.of<CartProvider>(context, listen: false);
    final pesananProv = Provider.of<PesananProvider>(context, listen: false);
    final userProv = Provider.of<UserProvider>(context, listen: false);
    // final total = cartProv.getTotal();

    // if (_payment == 'Stripe') {
    //   final success = await StripeService.pay(
    //     amount: total.toInt(), // rupiah
    //   );

    //   if (!success) {
    //     if (mounted) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         const SnackBar(content: Text('Pembayaran dibatalkan')),
    //       );
    //     }
    //     setState(() => _loading = false);
    //     return;
    //   }
    // }

    if (_addrCtl.text.trim().isEmpty) {
      // Try to get alamat from profile
      final profileAlamat = userProv.currentUser?.alamat ?? '';
      if (profileAlamat.trim().isNotEmpty) {
        setState(() => _addrCtl.text = profileAlamat);
      } else {
        final shouldEdit = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Alamat kosong'),
            content: const Text(
                'Alamat pengiriman belum tersedia. Ingin mengatur alamat sekarang?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Batal')),
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Atur Alamat')),
            ],
          ),
        );
        if (shouldEdit == true) {
          await Navigator.push(context,
              MaterialPageRoute(builder: (_) => const EditProfilePage()));
          final newAlamat = userProv.currentUser?.alamat ?? '';
          if (newAlamat.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Isi alamat pengiriman')));

            return;
          } else {
            setState(() => _addrCtl.text = newAlamat);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Isi alamat pengiriman')));
          return;
        }
      }
    }

    try {
      // Panggil tambahPesanan dengan items dari cart
      final items = cartProv.items;
      final total = cartProv.getTotal();

      final userProv = Provider.of<UserProvider>(context, listen: false);
      final uid = userProv.userId;
      if (uid == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Silakan login untuk melakukan pemesanan')));
        setState(() => _loading = false);
        return;
      }

      await pesananProv.tambahPesanan(
        userId: uid,
        items: items,
        totalHarga: total,
      );

      // Kurangi stok produk sesuai item yang dibeli (batch update)
      final produkProv = Provider.of<ProdukProvider>(context, listen: false);
      final Map<int, int> updates = {};
      for (final item in items) {
        try {
          final prod = produkProv.listProduk.firstWhere((p) => p.id == item.id);
          final newStock = (prod.stok - item.jumlah).clamp(0, 100000);
          updates[prod.id] =
              newStock; // last write wins (items are unique in cart)
        } catch (_) {
          // ignore if product not found in list
        }
      }
      if (updates.isNotEmpty) await produkProv.updateStocks(updates);

      // Clear cart setelah order berhasil
      cartProv.clear();

      // ✅ DEBUG: Show success with order details
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '✅ Pesanan Berhasil! ID: ${DateTime.now().millisecondsSinceEpoch}'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );
      }

      // sukses
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Pesanan Berhasil'),
          content: const Text('Pesanan Anda telah dibuat. Terima kasih!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.pushReplacementNamed(context, '/pesanan');
              },
              child: const Text('Lihat Pesanan'),
            )
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal membuat pesanan. Coba lagi.')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProv = Provider.of<CartProvider>(context);
    final total = cartProv.getTotal();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const CustomAppBar(
        title: 'Checkout',
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _addrCtl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Alamat Pengiriman',
                border: OutlineInputBorder(),
                hintText: 'Nama, Jalan, Desa, Kode Pos, No. HP',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Expanded(
                    child: Text('Pilih Kurir',
                        style: TextStyle(fontWeight: FontWeight.w700))),
                DropdownButton<String>(
                  value: _kurir,
                  items: ['JNE', 'J&T', 'POS', 'GrabExpress']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _kurir = v ?? 'JNE'),
                )
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Expanded(
                    child: Text('Metode Pembayaran',
                        style: TextStyle(fontWeight: FontWeight.w700))),
                DropdownButton<String>(
                  value: _payment,
                  items: ['COD', 'Transfer Bank', 'Midtrans']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _payment = v ?? 'COD'),
                )
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.03), blurRadius: 8)
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ringkasan Pesanan',
                      style: TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Subtotal'),
                      const Spacer(),
                      Text('Rp ${total.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.w900)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Text('Ongkos Kirim'),
                      const Spacer(),
                      Text('Rp 0',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[700])),
                    ],
                  ),
                  const Divider(height: 18),
                  Row(
                    children: [
                      const Text('Total',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w900)),
                      const Spacer(),
                      Text('Rp ${total.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF2E7D32))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : () => _placeOrder(context),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Bayar / Place Order',
                          style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
