import 'package:dio/dio.dart';
import 'dart:convert';
import '../../model/product.dart';

class Request {
  static final Request _instance = Request._internal();
  factory Request() => _instance;

  Dio dio = Dio();

  Request._internal();

  Future<Product> apiRequest() async {
    try {
      Response response = await dio.get('https://api.formation-android.fr/v2/getProduct?barcode=5000159484695');
      Product data = json.decode(response.data);
      print(data);
      return data;
    } catch (e) {
      throw Exception("Une erreur s'est produite lors de la requête API.");
    }
  }
}
