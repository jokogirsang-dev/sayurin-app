import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/pesanan_provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  String _metodePembayaran = 'COD';

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final pesananProv = Provider.of<PesananProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: cart.items.isEmpty
            ? const Center(
                child: Text('Keranjang kosong, tidak ada yang di-checkout.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ringkasan Belanja',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView(
                      children: cart.items.map((p) {
                        return ListTile(
                          title: Text(p.name),
                          subtitle: Text('Rp ${p.price.toStringAsFixed(0)}'),
                        );
                      }).toList(),
                    ),
                  ),
                  const Divider(),
                  Text(
                    'Total: Rp ${cart.totalHarga.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Data Pembeli',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _namaController,
                          decoration: const InputDecoration(
                            labelText: 'Nama lengkap',
                            border: OutlineInputBorder(),
                          ),
                          validator: (val) =>
                              val == null || val.isEmpty ? 'Wajib diisi' : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _alamatController,
                          decoration: const InputDecoration(
                            labelText: 'Alamat lengkap',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                          validator: (val) =>
                              val == null || val.isEmpty ? 'Wajib diisi' : null,
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Metode Pembayaran',
                            border: OutlineInputBorder(),
                          ),
                          initialValue: _metodePembayaran,
                          items: const [
                            DropdownMenuItem(
                              value: 'COD',
                              child: Text('Bayar di tempat (COD)'),
                            ),
                            DropdownMenuItem(
                              value: 'Transfer',
                              child: Text('Transfer Bank'),
                            ),
                            DropdownMenuItem(
                              value: 'E-Wallet',
                              child: Text('E-Wallet (OVO, DANA, dll)'),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _metodePembayaran = val;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;

                        // Simpan pesanan
                        pesananProv.tambahPesanan(
                          items: cart.items,
                          totalHarga: cart.totalHarga,
                        );

                        // Kosongkan keranjang
                        cart.clear();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Checkout berhasil, pesananmu sedang diproses.'),
                          ),
                        );

                        Navigator.pop(context); // kembali ke keranjang
                      },
                      child: const Text('Konfirmasi Pesanan'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
