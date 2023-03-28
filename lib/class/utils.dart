import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

  DateTime? guncelTarih;
  List<double> kurlar = [0, 0, 0, 0, 0, 0, 0, 0, 0];

  List<String> turler = ["USD", "EUR", "GBP", "GA", "C", "GAG", "BTC", "ETH", "XU100"];
  List<String> adlar = ["Dolar", "Euro", "Sterlin", "Gram", "Çeyrek", "Gümüş", "Bitcoin", "Etherium", "Bist100"];

  Future<dynamic>? doviz;

  Future<dynamic> DovizYukle() async {
    try {
      var response = await Dio().get('https://api.genelpara.com/embed/para-birimleri.json');
      return response.data;
    } catch (e) {
      print("Hata $e");
    }
  }

  checkInternetConnection(BuildContext context) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        Timer(Duration(seconds: 10), () => checkInternetConnection(context));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            // backgroundColor: Colors.black,
            content: Text('Bağlantı kurulmaya çalışılıyor..')
          )
        );
      }
      else {
        doviz = DovizYukle();
        guncelTarih = DateTime.now();
      }
  }

  class progressWidget extends StatelessWidget {
  const progressWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("İnternet bağlantısı bekleniyor..", style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 10),
          CircularProgressIndicator(
            color: Colors.white,
            backgroundColor: Colors.black,
          ),
        ],
      ),
    );
  }
}