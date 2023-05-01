import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/settings_cubit.dart';
import '../class/utils.dart';

class ExchangePage extends StatefulWidget {
  const ExchangePage({super.key});

  @override
  State<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage> {
  late final SettingsCubit settings;
  String _selectedItem = "Dolar";
  int dovizIndex = 0;
  int girilenDeger = 100;
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    settings = context.read<SettingsCubit>();
    checkInternetConnection(context);
    _controller = TextEditingController(text: girilenDeger.toString());
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Döviz Çeviri'),
      ),
      body: FutureBuilder(
        future: doviz,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: settings.state.darkMode ? Colors.white : Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            // dropdownColor: Colors.black,
                            alignment: Alignment.center,
                            value: _selectedItem,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedItem = newValue.toString();
                                // print(_selectedItem);
                              });
                            },
                            items: adlar.map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 10),
                                    Image.asset("assets/images/${adlar.indexOf(item) + 1}.png", width: 25, height: 25),
                                    SizedBox(width: 5),
                                    Text(item),
                                    SizedBox(width: 5),
                                    Text(snapshot.data[turler[adlar.indexOf(item)]]["alis"].toString()),
                                    SizedBox(width: 10),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    dovizIndex = adlar.indexOf(item);
                                  });
                                  // print(adlar.indexOf(item));
                                },
                            )).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Container(
                    width: 200,
                    child: TextField(
                      cursorColor: settings.state.darkMode ? Colors.white : Colors.black,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: "Bir fiyat giriniz..",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: settings.state.darkMode ? Colors.white : Colors.black),
                          borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(7),
                        LimitRangeTextInputFormatter(0, 1000000),
                      ],
                      controller: _controller,
                      onChanged: (value) {
                          try {
                            girilenDeger = int.parse(value);
                          } catch (e) {
                            print("hata"); 
                          }
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(height: 25),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.center,
                    // spacing: 5,
                    children: [
                      Text("$girilenDeger ", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 30)),
                      Image.asset("assets/images/${dovizIndex + 1}.png", width: 30, height: 30),
                      Text(
                        " = ${(double.parse(snapshot.data[turler[dovizIndex]]["alis"]) * girilenDeger).toStringAsFixed(2)} ",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 30),
                      ),
                      Image.asset("assets/images/10.png", width: 30, height: 30),
                    ],
                  ),
                  SizedBox(height: 25),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.center,
                    children: [
                      Text("$girilenDeger ", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 30)),
                      Image.asset("assets/images/10.png", width: 30, height: 30),
                      Text(
                        " = ${(girilenDeger / double.parse(snapshot.data[turler[dovizIndex]]["alis"])).toStringAsFixed(2)} ",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 30),
                      ),
                      Image.asset("assets/images/${dovizIndex + 1}.png", width: 30, height: 30),
                    ],
                  ),
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