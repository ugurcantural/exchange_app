import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/settings_cubit.dart';
import '../class/utils.dart';
import 'chart_page.dart';
import 'exchange_page.dart';
import 'wallet_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? timer;
  bool? dark;
  bool connect = false;
  bool isAuto = false;
  bool animation = true;
  late final SettingsCubit settings;

  void changeAnimation() {
    Timer.periodic(Duration(seconds: 2), (timer) { 
      setState(() {
        animation =! animation;
      });
    });
  }
  
  @override
  void initState() {
    super.initState();
    checkInternetConnection(context);
    changeAnimation();
    settings = context.read<SettingsCubit>();
    dark = settings.state.darkMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Döviz Kurları'),
      ),
      body: FutureBuilder(
        future: doviz,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            return RefreshIndicator(
              backgroundColor: dark! ? Colors.white : Colors.black,
                color: dark! ? Colors.black : Colors.white,
                onRefresh: () async {
                  checkInternetConnection(context);
                  // print(snapshot.data);
                },
              child: SingleChildScrollView(    
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Son Güncelleme:', style: Theme.of(context).textTheme.titleMedium),
                          SizedBox(width: 5),
                          Text(
                            "${guncelTarih!.day.toString().padLeft(2, '0')}/${guncelTarih!.month.toString().padLeft(2, '0')}/${guncelTarih!.year.toString()} ${guncelTarih!.hour.toString().padLeft(2, '0')}:${guncelTarih!.minute.toString().padLeft(2 , '0')}:${guncelTarih!.second.toString().padLeft(2 , '0')}"
                            , style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            )
                          ),
                        ],
                      ),
                      SizedBox(height:20),
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: dovizMethod("Döviz Türü"),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 4,
                            child: dovizMethod("Satış Fiyatı"),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 4,
                            child: dovizMethod("Alış Fiyatı"),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: dovizMethod("D(%)"),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: adlar.map((e) {
                          return InkWell(
                            onTap: () {
                              if (adlar.indexOf(e) <= allList.length - 1) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return ChartPage(
                                    name: adlar[adlar.indexOf(e)],
                                    satis: double.parse(snapshot.data[turler[adlar.indexOf(e)]]["satis"]),
                                    list: allList[adlar.indexOf(e)],
                                  ); 
                                }));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 1), content: Text("Grafik Bulunamadı!")));
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 25,
                                          width: 25,
                                          child: Image.asset("assets/images/${adlar.indexOf(e) + 1}.png"),
                                        ),
                                        SizedBox(width: 10),
                                        Text(adlar[adlar.indexOf(e)], style: Theme.of(context).textTheme.titleMedium,),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    flex: 4,
                                    child: dovizMethod(snapshot.data[turler[adlar.indexOf(e)]]["satis"].toString()),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    flex: 4,
                                    child: dovizMethod(snapshot.data[turler[adlar.indexOf(e)]]["alis"].toString()),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 5),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: dark! ? Colors.white : Colors.black), 
                                        borderRadius: BorderRadius.circular(10),
                                        color: double.parse(snapshot.data[turler[adlar.indexOf(e)]]["degisim"]) >= 0 ? 
                                        animation ? Colors.transparent : Colors.green  : 
                                        animation ? Colors.transparent : Colors.red,
                                      ),
                                      child: Text(snapshot.data[turler[adlar.indexOf(e)]]["degisim"].toString(), style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center)
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(), 
                          // InkWell(
                          //   child: 
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                "assets/images/kk.png",
                                height: 80,
                              ),
                            ),
                            // onTap: () async {
                            //   const url = 'https://mutabakat.netlify.app';
                            //   final uri = Uri.parse(url);
                            //   if (await canLaunchUrl(uri)) {
                            //     await launchUrl(uri);
                            //   } else {
                            //     throw 'Could not launch $url';
                            //   }
                            // },
                          // ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(height: 10),
                                  Container(
                                    height: 25,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("Otomatik güncelle(30s): "),
                                        Switch(
                                          activeColor: Colors.red,
                                          value: isAuto,
                                          onChanged: (value) {
                                            setState(() {
                                              isAuto = value;
                                            });
                                            if (isAuto == true) {
                                              timer = Timer.periodic(Duration(seconds: 30), (timer) { 
                                                doviz = DovizYukle();
                                                guncelTarih = DateTime.now();
                                                // checkInternetConnection(context);
                                                // print('on saniye');
                                              });
                                            }
                                            else {
                                              timer!.cancel();
                                              // print('güncelleme kapalı');
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    height: 25,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("Karanlık tema: "),
                                        Switch(
                                          activeColor: Colors.red,
                                          value: dark!,
                                          onChanged: (value) {
                                            setState(() {
                                              dark = value;
                                              settings.changeDarkMode(dark!);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: dark! ? Colors.white : Colors.black,
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        child: InkWell(
                                          child: Icon(Icons.currency_exchange_outlined, color: dark! ? Colors.black : Colors.white, size: 28),
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                                              return ExchangePage();
                                            }));
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: dark! ? Colors.white : Colors.black,
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        child: InkWell(
                                          child: Icon(Icons.account_balance_wallet_outlined, color: dark! ? Colors.black : Colors.white, size: 30),
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                                              return WalletPage();
                                            }));
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: dark! ? Colors.white : Colors.black),
                                        ),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: FaIcon(FontAwesomeIcons.github, color: Colors.purple,),
                                              onPressed: () => socialTap("github", "ugurcantural"),
                                            ),
                                            IconButton(
                                              icon: FaIcon(FontAwesomeIcons.linkedin, color: Colors.blue,),
                                              onPressed: () => socialTap("linkedin", "in/uğurcan-tural-202702243"),
                                            ),
                                            IconButton(
                                              icon: FaIcon(FontAwesomeIcons.instagram, color: Colors.pink,),
                                              onPressed: () => socialTap("instagram", "birugurtu"),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                    ],
                                  ),
                                ],
                              ),
                        ],
                      ),
                      // Expanded(
                      //   flex: 3,
                      //   child: ListView.builder(
                      //     // physics: NeverScrollableScrollPhysics(),
                      //     itemCount: snapshot.data.length!,
                      //     itemBuilder: (context, index) {
                      //       return Padding(
                      //         padding: const EdgeInsets.symmetric(vertical: 11),
                      //         child: Row(
                      //           children: [
                      //             Expanded(
                      //               flex: 5,
                      //               child: Row(
                      //                 children: [
                      //                   Container(
                      //                     height: 25,
                      //                     width: 25,
                      //                     child: Image.asset("assets/images/${index + 1}.png"),
                      //                   ),
                      //                   SizedBox(width: 10),
                      //                   Text(adlar[index], style: Theme.of(context).textTheme.titleMedium,),
                      //                 ],
                      //               ),
                      //             ),
                      //             SizedBox(width: 10),
                      //             Expanded(
                      //               flex: 4,
                      //               child: dovizMethod(snapshot.data[turler[index]]["satis"].toString()),
                      //             ),
                      //             SizedBox(width: 10),
                      //             Expanded(
                      //               flex: 4,
                      //               child: dovizMethod(snapshot.data[turler[index]]["alis"].toString()),
                      //             ),
                      //             SizedBox(width: 10),
                      //             Expanded(
                      //               flex: 2,
                      //               child: Container(
                      //                 padding: EdgeInsets.symmetric(vertical: 5),
                      //                 decoration: BoxDecoration(
                      //                   border: Border.all(color: Colors.white), 
                      //                   borderRadius: BorderRadius.circular(10),
                      //                   color: double.parse(snapshot.data[turler[index]]["degisim"]) >= 0 ? 
                      //                   animation ? Colors.transparent : Colors.green  : 
                      //                   animation ? Colors.transparent : Colors.red,
                      //                 ),
                      //                 child: Text(snapshot.data[turler[index]]["degisim"].toString(), style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center)
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // ),
                      // Expanded(
                      //   flex: 1,
                      //   child: SingleChildScrollView(
                      //     child: Column(
                      //       children: [
                      //         Row(
                      //           mainAxisAlignment: MainAxisAlignment.end,
                      //           children: [
                      //             Text("Otomatik güncelle(10s): "),
                      //             Switch(
                      //               activeColor: Colors.red,
                      //               value: isAuto,
                      //               onChanged: (value) {
                      //                 setState(() {
                      //                   isAuto = value;
                      //                 });
                      //                 if (isAuto == true) {
                      //                   timer = Timer.periodic(Duration(seconds: 10), (timer) { 
                      //                     doviz = DovizYukle();
                      //                     guncelTarih = DateTime.now();
                      //                     // checkInternetConnection(context);
                      //                     // print('on saniye');
                      //                   });
                      //                 }
                      //                 else {
                      //                   timer!.cancel();
                      //                   // print('güncelleme kapalı');
                      //                 }
                      //               },
                      //             ),
                      //           ],
                      //         ),
                      //         Row(
                      //           mainAxisAlignment: MainAxisAlignment.end,
                      //           children: [
                      //             Container(
                      //               decoration: BoxDecoration(
                      //                 color: Colors.white,
                      //                 borderRadius: BorderRadius.circular(50),
                      //               ),
                      //               child: IconButton(
                      //                 icon: Icon(Icons.currency_exchange_outlined, color: Colors.black, size: 28),
                      //                 onPressed: () {
                      //                   Navigator.push(context, MaterialPageRoute(builder: (context) {
                      //                     return ExchangePage();
                      //                   }));
                      //                 },
                      //               ),
                      //             ),
                      //             SizedBox(width: 20),
                      //             Container(
                      //               decoration: BoxDecoration(
                      //                 color: Colors.white,
                      //                 borderRadius: BorderRadius.circular(50),
                      //               ),
                      //               child: IconButton(
                      //                 icon: Icon(Icons.account_balance_wallet_outlined, color: Colors.black, size: 30),
                      //                 onPressed: () {
                      //                   Navigator.push(context, MaterialPageRoute(builder: (context) {
                      //                     return WalletPage();
                      //                   }));
                      //                 },
                      //               ),
                      //             ),
                      //             SizedBox(width: 10),
                      //           ],
                      //         ),
                      //         SizedBox(height: 15),
                      //         Row(
                      //           mainAxisAlignment: MainAxisAlignment.end,
                      //           children: [
                      //             Container(
                      //               decoration: BoxDecoration(
                      //                 border: Border.all(color: Colors.white),
                      //               ),
                      //               child: Row(
                      //                 children: [
                      //                   IconButton(
                      //                     icon: FaIcon(FontAwesomeIcons.github),
                      //                     onPressed: () => socialTap("github", "ugurcantural"),
                      //                   ),
                      //                   IconButton(
                      //                     icon: FaIcon(FontAwesomeIcons.linkedin),
                      //                     onPressed: () => socialTap("linkedin", "in/uğurcan-tural-202702243"),
                      //                   ),
                      //                   IconButton(
                      //                     icon: FaIcon(FontAwesomeIcons.instagram),
                      //                     onPressed: () => socialTap("instagram", "birugurtu"),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //             SizedBox(width: 10),
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
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

  Container dovizMethod(String title) {
    return Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: dark! ? Colors.white : Colors.black),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text(title, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center)
                        );
  }

  void socialTap(String platform, String url) async {
    var nativeUrl = "$platform://user?username=$url";
                          var webUrl = "https://www.$platform.com/$url";
                          if (await canLaunch(nativeUrl)) {
                            await launch(nativeUrl);
                            } else if (await canLaunch(webUrl)) {
                              await launch(webUrl);
                            } else {
                              print("$platform yok");
                            }     
  }

}
