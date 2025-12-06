import '../model/pesanan.dart';

class PesananService {
  // Dummy data untuk laporan
  Future<List<Pesanan>> listOrders() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      Pesanan(
        id: '1',
        tanggal: DateTime.parse('2025-10-30'),
        items: const [],
        totalHarga: 75000,
        status: 'Selesai',
      ),
      Pesanan(
        id: '2',
        tanggal: DateTime.parse('2025-10-28'),
        items: const [],
        totalHarga: 42000,
        status: 'Dikirim',
      ),
      Pesanan(
        id: '3',
        tanggal: DateTime.parse('2025-10-25'),
        items: const [],
        totalHarga: 65000,
        status: 'Menunggu Pembayaran',
      ),
    ];
  }

  Future<void> createOrder(Pesanan pesanan) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // ignore: avoid_print
    print('Pesanan berhasil disimpan: ${pesanan.id}');
  }

  Future<void> deleteOrder(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // ignore: avoid_print
    print('Pesanan $id dihapus');
  }
}
