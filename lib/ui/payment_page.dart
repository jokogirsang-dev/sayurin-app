// lib/ui/payment_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../helpers/format_currency.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    // Simulasikan biaya tambahan
    final double ongkir = 15000.0;
    final double asuransi = 2000.0;
    final double totalHarga = cart.getTotal();
    final double totalBelanja = totalHarga + ongkir + asuransi;

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAF2),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5FAF2),
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Pembayaran',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // --- Detail Pesanan ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Detail Pesanan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummaryRow('Total Harga', totalHarga),
                      _buildSummaryRow('Ongkos Kirim', ongkir),
                      _buildSummaryRow('Asuransi Pengiriman', asuransi),
                      const Divider(height: 24, thickness: 1, color: Colors.grey),
                      _buildSummaryRow(
                        'Total Belanja',
                        totalBelanja,
                        isTotal: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // --- Metode Pembayaran ---
                const Text(
                  'Metode Pembayaran',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                ..._buildPaymentMethods(context),
              ],
            ),
          ),

          // --- Footer Tombol Bayar ---
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Bayar:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Rp ${FormatCurrency.toRupiah(totalBelanja)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // Simulasikan pembayaran berhasil
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pembayaran Berhasil!')),
                      );
                      // Kosongkan keranjang
                      cart.clear();
                      // Kembali ke halaman utama atau tampilkan halaman "Pesanan Berhasil"
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Konfirmasi Pembayaran',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black87 : Colors.grey[700],
            ),
          ),
          Text(
            'Rp ${FormatCurrency.toRupiah(value)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.green : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPaymentMethods(BuildContext context) {
    return [
      _buildPaymentMethodCard(
        context,
        'QRIS',
        'Bayar dengan QR Code dari aplikasi dompet digital Anda',
        Icons.qr_code,
      ),
      _buildPaymentMethodCard(
        context,
        'Transfer Bank',
        'Transfer ke rekening bank kami',
        Icons.account_balance,
      ),
      _buildPaymentMethodCard(
        context,
        'Kartu Kredit/Debit',
        'Bayar dengan kartu kredit atau debit Anda',
        Icons.credit_card,
      ),
      _buildPaymentMethodCard(
        context,
        'Cash on Delivery (COD)',
        'Bayar saat barang sampai di rumah Anda',
        Icons.money,
      ),
    ];
  }

  Widget _buildPaymentMethodCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Radio<bool>(
          value: false,
          groupValue: false,
          onChanged: (bool? value) {
            // Di sini Anda bisa menambahkan logika untuk memilih metode pembayaran
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Metode pembayaran $title dipilih')),
            );
          },
        ),
      ),
    );
  }
}