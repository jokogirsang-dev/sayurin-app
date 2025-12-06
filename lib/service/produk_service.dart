// lib/service/produk_service.dart

import 'package:dio/dio.dart';
import '../model/produk.dart';

class ProdukService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://690b07601a446bb9cc24e535.mockapi.io',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  Future<List<Produk>> fetchProduk() async {
    try {
      final response = await _dio.get('/produk');

      if (response.statusCode == 200) {
        final data = response.data as List;
        return data
            .map((json) => Produk.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal mengambil produk: $e');
    }
  }
}
