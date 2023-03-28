import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../class/utils.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {

  double toplamTl = 0;
  List<double> toplamBakiye = [0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<int> moneys = [0, 0, 0, 0, 0, 0, 0, 0, 0];

  void Lira() {
    toplamTl = 0;
    for (var i = 0; i < 9; i++) {
      if(toplamBakiye[i] < 0)
      {
        toplamBakiye[i] = 0;
      }
      else {
        toplamTl += toplamBakiye[i];
      }
    }
  }

  List<TextEditingController> _controllers = List<TextEditingController>.generate(9, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    checkInternetConnection(context);
    Getir();
  }

  @override
  void dispose() {
    super.dispose();
    for (final control in _controllers) {
      control.dispose();
    }
  }

  void Getir() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myMoneyList = prefs.getString('myMoneys');
    if (myMoneyList == null) {
      List<int> moneys = [0, 0, 0, 0, 0, 0, 0, 0, 0];
    }
    else{
      List<dynamic> myParsedList = jsonDecode(myMoneyList);
      List<int> myIntList = List<int>.from(myParsedList);
      moneys = myIntList;
    }
    for (var i = 0; i < 9; i++) {
      if (moneys[i] == 0 || moneys[i] == null) {
        _controllers[i].text = "";
      }
      else {
        _controllers[i].text = moneys[i].toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cüzdanım'),
        actions: [
          IconButton(
            icon: Icon(Icons.save_outlined),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.black,
                    title: Text("Kaydet"),
                    content: Text("Cüzdan kayıt edilsin mi?"),
                    actions: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        child: Text("Vazgeç"),
                        onPressed: () => Navigator.pop(context),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black
                        ),
                        child: Text("Kaydet"),
                        onPressed: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setString('myMoneys', jsonEncode(moneys));
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Başarıyla kayıt edildi!")));
                        },
                      )
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: doviz,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            kurlar.removeRange(0, 9);
            for (var i = 0; i < 9; i++) {
              kurlar.add((double.parse(snapshot.data[turler[i]]["alis"])));
            }
            for (var i = 0; i < 9; i++) {
              toplamBakiye[i] = moneys[i] * kurlar[i];
            }
            Lira();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  //bakiye
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Toplam bakiye", style: TextStyle(fontSize: 8, color: Colors.grey),),
                          Text(
                            "${toplamTl.toStringAsFixed(2)}",
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 5),
                      Image.asset(
                        "assets/images/10.png",
                        width: 30,
                        height: 30,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 9,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[900],
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Column(
                                    children: [
                                      Image.asset("assets/images/${index + 1}.png", width: 25, height: 25),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: InkWell(
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.grey),
                                                  borderRadius: BorderRadius.circular(50)
                                                ),
                                                child: Icon(Icons.exposure_minus_1_outlined, color: Colors.grey),
                                              ),
                                              onTap: () {
                                                if (moneys[index] <= 1) {
                                                  moneys[index] = 0;
                                                  toplamBakiye[index] = 0;
                                                  // _controllers[index].text = moneys[index].toString();
                                                  _controllers[index].text = "";
                                                }
                                                else {
                                                  moneys[index] -= 1;
                                                  _controllers[index].text = moneys[index].toString();
                                                  toplamBakiye[index] -= kurlar[index];
                                                }
                                                Lira();
                                                setState(() { });
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            flex: 4,
                                            child: TextField(
                                              controller: _controllers[index],
                                              cursorColor: Colors.white,
                                              textAlign: TextAlign.center,
                                              textAlignVertical: TextAlignVertical.center,
                                              decoration: InputDecoration(
                                                hintText: adlar[index],
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.grey),
                                                  borderRadius: BorderRadius.circular(20)
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.white),
                                                  borderRadius: BorderRadius.circular(20)
                                                ),
                                              ),
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(7),
                                                LimitRangeTextInputFormatter(0, 1000000),
                                              ],
                                              onChanged: (value) {
                                                  try {
                                                    if (_controllers[index].text.isNotEmpty) {
                                                      moneys[index] = int.parse(value);
                                                      toplamBakiye[index] = (moneys[index] * kurlar[index]);
                                                    }
                                                    else {
                                                      moneys[index] = 0;
                                                      toplamBakiye[index] = 0;
                                                    }
                                                    Lira();
                                                  } catch (e) {
                                                    print("hata"); 
                                                  }
                                                  setState(() {});
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            flex: 1,
                                            child: InkWell(
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.grey),
                                                  borderRadius: BorderRadius.circular(50)
                                                ),
                                                child: Icon(Icons.plus_one_outlined, color: Colors.grey),
                                              ),
                                              onTap: () {
                                                if (moneys[index] >= 1000000) {
                                                  moneys[index] = 1000000;
                                                  _controllers[index].text = moneys[index].toString();
                                                }
                                                else {
                                                  moneys[index] += 1;
                                                  _controllers[index].text = moneys[index].toString();
                                                  toplamBakiye[index] += kurlar[index];
                                                  Lira();
                                                }
                                                setState(() { });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          }
          else {
            return progressWidget();
          }
        },
      ),
    );
  }
}

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