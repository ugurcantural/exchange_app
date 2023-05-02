import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

//lenght limit stackover
class LimitRangeTextInputFormatter extends TextInputFormatter {
  LimitRangeTextInputFormatter(this.min, this.max, {this.defaultIfEmpty = false}) : assert(min < max);

  final int min;
  final int max;
  final bool defaultIfEmpty;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    int? value = int.tryParse(newValue.text);
    String? enforceValue;
    if(value != null) {
      if (value < min) {
        enforceValue = min.toString();
      } else if (value > max) {
        enforceValue = max.toString();
      }
    }
    else{
      if(defaultIfEmpty) {
        enforceValue = min.toString();
      }
    }
    // filtered interval result
    if(enforceValue != null){
      return TextEditingValue(text: enforceValue, selection: TextSelection.collapsed(offset: enforceValue.length));
    }
    // value that fit requirements
    return newValue;
  }
}