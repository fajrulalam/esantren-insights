import 'package:dotted_border/dotted_border.dart';
import 'package:esantren_insights_v1/Classes/Pembayaran6BulanTerakhirClass.dart';
import 'package:esantren_insights_v1/Objects/PembayaranObject_6BulanTerakhir.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  int jumlahSantriAktif = 207;
  int jumlahSantriIzin = 7;
  int jumlahSantriSakit = 10;
  int jumlahSantriAda = 190;
  int jumlahSantriHadirNgaji = 180;
  int jumlahLunasSPP = 165;
  int jumlahKelas = 11;
  int jumlahKelasAbsenHariIni = 10;
  late double persentasePembayarSPP = jumlahLunasSPP / jumlahSantriAktif * 100;
  late double persentaseLunasSPP = jumlahLunasSPP / jumlahSantriAktif * 100;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      "Ada": jumlahSantriAda.toDouble(),
      "Izin": jumlahSantriIzin.toDouble(),
      "Sakit": jumlahSantriSakit.toDouble(),
    };

    final List<PembayaranObject_6BulanTerakhir> chartData =
        Pembayaran_6BulanTerakhirClass.getPembayaran6BulanTerakhir();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "E-Santren Insights",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: Colors.grey,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Card(
                elevation: 2,
                child: DefaultTabController(
                  length: 2,
                  child: Container(
                    padding:
                        EdgeInsets.only(top: 12, right: 0, left: 0, bottom: 4),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TabBarView(children: [
                              JumlahSantriAktifCard_1(context),
                              Container(
                                child: Center(
                                  child: PieChart(
                                    dataMap: dataMap,
                                    chartValuesOptions: ChartValuesOptions(
                                      showChartValueBackground: true,
                                      showChartValues: true,
                                      showChartValuesInPercentage: false,
                                      showChartValuesOutside: true,
                                      decimalPlaces: 0,
                                    ),
                                    colorList: [
                                      Colors.greenAccent,
                                      Colors.orangeAccent,
                                      Colors.redAccent
                                    ],
                                  ),
                                ),
                              )
                            ]),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 24),
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: TabBar(
                                indicatorSize: TabBarIndicatorSize.values[0],
                                padding: EdgeInsets.all(0),
                                indicatorPadding: EdgeInsets.all(0),
                                indicatorColor: Colors.transparent,
                                labelColor: Colors.green[600],
                                unselectedLabelColor:
                                    Colors.grey.withOpacity(0.4),
                                tabs: [
                                  Tab(
                                    icon: Icon(Icons.circle, size: 8),
                                  ),
                                  Tab(
                                    icon: Icon(Icons.circle, size: 8),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // add your card widget content here
                        ]),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Card(
                      elevation: 2,
                      child: DefaultTabController(
                        length: 2,
                        child: Container(
                          padding: EdgeInsets.only(top: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    AbsenNgajiCard(context,
                                        title: 'Kehadiran Ngaji Hari Ini',
                                        subset: jumlahSantriHadirNgaji,
                                        total: jumlahSantriAktif),
                                    AbsenNgajiCard(context,
                                        title: 'Jumlah Absensi Kelas',
                                        total: jumlahKelas,
                                        subset: jumlahKelasAbsenHariIni)
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 24),
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: TabBar(
                                    indicatorSize:
                                        TabBarIndicatorSize.values[0],
                                    padding: EdgeInsets.all(0),
                                    indicatorPadding: EdgeInsets.all(0),
                                    indicatorColor: Colors.transparent,
                                    labelColor: Colors.green[600],
                                    unselectedLabelColor:
                                        Colors.grey.withOpacity(0.4),
                                    tabs: [
                                      Tab(
                                        icon: Icon(Icons.circle, size: 8),
                                      ),
                                      Tab(
                                        icon: Icon(Icons.circle, size: 8),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // add your card widget content here
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Card(
                      color: Colors.blueGrey.shade50,
                      elevation: 2,
                      child: Container(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Center(
                                child: Image.asset('assets/absen-ngaji.png',
                                    height: MediaQuery.of(context).size.height *
                                        0.07),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Cek Absensi',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        // add your card widget content here
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              flex: 3,
              child: Card(
                elevation: 2,
                child: DefaultTabController(
                  length: 3,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TabBarView(children: [
                            PembayaranSPPCard_1(context),
                            Container(
                              child: Center(
                                child: SfCartesianChart(
                                  legend: Legend(
                                      isVisible: true, isResponsive: true),
                                  primaryXAxis: CategoryAxis(),
                                  primaryYAxis:
                                      NumericAxis(minimum: 0, maximum: 300),
                                  series: <ChartSeries>[
                                    ColumnSeries<
                                        PembayaranObject_6BulanTerakhir,
                                        String>(
                                      name: 'Total',
                                      color: Colors.grey,
                                      dataSource: chartData,
                                      xValueMapper:
                                          (PembayaranObject_6BulanTerakhir data,
                                                  _) =>
                                              data.bulan,
                                      yValueMapper:
                                          (PembayaranObject_6BulanTerakhir data,
                                                  _) =>
                                              data.santriAktif,
                                    ),
                                    ColumnSeries<
                                        PembayaranObject_6BulanTerakhir,
                                        String>(
                                      name: 'Lunas',
                                      dataSource: chartData,
                                      dataLabelSettings: DataLabelSettings(
                                          isVisible: true,
                                          textStyle: GoogleFonts.poppins(
                                              fontSize: 10)),
                                      color: Colors.greenAccent,
                                      xValueMapper:
                                          (PembayaranObject_6BulanTerakhir data,
                                                  _) =>
                                              data.bulan,
                                      yValueMapper:
                                          (PembayaranObject_6BulanTerakhir data,
                                                  _) =>
                                              data.santriLunas,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              child: Center(
                                child: Text("Paid vs Unpaid"),
                              ),
                            ),
                          ]),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 24),
                          child: SizedBox(
                            width: 45,
                            height: 30,
                            child: TabBar(
                              indicatorSize: TabBarIndicatorSize.values[0],
                              padding: EdgeInsets.all(0),
                              indicatorPadding: EdgeInsets.all(0),
                              indicatorColor: Colors.transparent,
                              labelColor: Colors.green[600],
                              unselectedLabelColor:
                                  Colors.grey.withOpacity(0.4),
                              tabs: [
                                Tab(
                                  icon: Icon(Icons.circle, size: 8),
                                ),
                                Tab(
                                  icon: Icon(Icons.circle, size: 8),
                                ),
                                Tab(
                                  icon: Icon(Icons.circle, size: 8),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Card(
                      elevation: 2,
                      child: Container(
                        color: Colors.blueGrey.shade50,
                        padding: EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Center(
                                child: Image.asset(
                                    'assets/activity-tracker.png',
                                    height: MediaQuery.of(context).size.height *
                                        0.07),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Log Aktivitas',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        // add your card widget content here
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Card(
                      elevation: 2,
                      child: Container(
                        color: Colors.blueGrey.shade50,
                        padding: EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Center(
                                child: Image.asset('assets/team.png',
                                    height: MediaQuery.of(context).size.height *
                                        0.07),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Data Lengkap Santri',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        // add your card widget content here
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: "Pengumuman",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mosque),
            label: "Asrama",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 2,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget JumlahSantriAktifCard_1(BuildContext context) {
    return GestureDetector(
      child: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Santri Aktif',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 16),
          ),
          Text(
            jumlahSantriAktif.toString(),
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                fontSize: 36),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DetailSantri(context,
                    angka: jumlahSantriAda, keterangan: "Ada"),
                DetailSantri(context,
                    angka: jumlahSantriIzin,
                    keterangan: "Izin",
                    isMiddle: true),
                DetailSantri(context,
                    angka: jumlahSantriSakit, keterangan: "Sakit"),
              ],
            ),
          ),
        ],
      )),
    );
  }

  Widget PembayaranSPPCard_1(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Persentase Pelunasan SPP Bulan Ini',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, color: Colors.grey)),
        SizedBox(height: 8),
        Text('${persentaseLunasSPP.toStringAsFixed(1)}%',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w800,
                color: Colors.black,
                fontSize: 36)),
        Container(
          child: Center(
            child: LinearPercentIndicator(
              width: MediaQuery.of(context).size.width * 0.5,
              lineHeight: 4.0,
              animation: true,
              animationDuration: 2000,
              alignment: MainAxisAlignment.center,
              percent: persentaseLunasSPP / 100,
              linearStrokeCap: LinearStrokeCap.butt,
              backgroundColor: Colors.grey.withOpacity(0.4),
              progressColor: Colors.blueAccent.withOpacity(0.5),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text.rich(TextSpan(
            text: '',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.normal, color: Colors.grey),
            children: [
              if (persentaseLunasSPP < 50)
                TextSpan(
                    text: 'Masih hanya ',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400, fontSize: 12))
              else if (persentaseLunasSPP < 90 && persentaseLunasSPP >= 50)
                TextSpan(
                    text: 'Sebanyak ',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400, fontSize: 12))
              else if (persentaseLunasSPP >= 90)
                TextSpan(
                    text: 'Sudah ',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400, fontSize: 12)),
              if (persentaseLunasSPP < 50)
                TextSpan(
                    text: '$jumlahLunasSPP/$jumlahSantriAktif santri',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w800,
                        color: Colors.redAccent,
                        fontSize: 12))
              else if (persentaseLunasSPP < 90 && persentaseLunasSPP >= 50)
                TextSpan(
                    text: '$jumlahLunasSPP/$jumlahSantriAktif santri',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w800,
                        color: Colors.orangeAccent,
                        fontSize: 12))
              else if (persentaseLunasSPP >= 90)
                TextSpan(
                    text: '$jumlahLunasSPP/$jumlahSantriAktif santri',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w800,
                        color: Colors.green,
                        fontSize: 12)),
              TextSpan(
                  text: ' yang lunas SPP bulan ini',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                      fontSize: 12))
            ])),
      ],
    );
  }

  Widget AbsenNgajiCard(BuildContext context,
      {required String title, required int subset, required int total}) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, fontSize: 14, color: Colors.grey),
          ),
          Expanded(
            child: Center(
              child: Text.rich(TextSpan(
                  text: '$subset',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                      fontSize: 24),
                  children: [
                    TextSpan(
                        text: ' / $total',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                            fontSize: 16))
                  ])),
            ),
          ),
        ],
      ),
    );
  }
}

Widget DetailSantri(BuildContext context,
    {required int angka, required String keterangan, bool? isMiddle}) {
  Color color;

  switch (keterangan) {
    case "Ada":
      color = Colors.green;
      break;
    case "Izin":
      color = Colors.orange;
      break;
    case "Sakit":
      color = Colors.red;
      break;
    default:
      color = Colors.grey;
      break;
  }
  return Container(
    width: MediaQuery.of(context).size.width / 4.5,
    padding: EdgeInsets.only(left: 8, right: 8),
    decoration: BoxDecoration(
        border: isMiddle == true
            ? Border()
            : Border.symmetric(
                vertical: BorderSide(color: Colors.grey.shade300, width: 0.7))),
    child: Column(
      children: [
        Text(
          keterangan,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: color, fontSize: 14),
        ),
        Text(
          angka.toString(),
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400, color: color, fontSize: 14),
        ),
      ],
    ),
  );
}
