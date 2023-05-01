import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esantren_insights_v1/Objects/CurrentUserObject.dart';
import 'package:esantren_insights_v1/Objects/DataHomePageObject.dart';
import 'package:esantren_insights_v1/Screens/DataLengkapSantri.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../BottomSheets/DetailPembayaran_BS.dart';
import '../BottomSheets/DetailSantri_BS.dart';
import '../BottomSheets/KelasNgajiDetail_BS.dart';
import '../Classes/DataHomePageClass.dart';
import '../Classes/KelasNgajiClass.dart';
import '../Classes/PelunasanClass.dart';
import '../Classes/PembayaranClass.dart';
import '../Classes/SantriClass.dart';
import '../Objects/AsramaObject.dart';
import '../Objects/KelasNgajiObject.dart';
import '../Objects/PelunasanObject.dart';
import '../Objects/PembayaranObject.dart';
import '../Objects/SantriObject.dart';
import '../Screens/CekAbsensi.dart';
import 'LoaderWidget.dart';

class DashboardStatefulWidget extends StatefulWidget {
  final CurrentUserObject userObject;
  final AsramaObject asramaDetail;

  const DashboardStatefulWidget(
      {Key? key, required this.userObject, required this.asramaDetail})
      : super(key: key);

  @override
  State<DashboardStatefulWidget> createState() => _DashboardStatefulWidgetState(
        userObject,
        asramaDetail,
      );
}

class _DashboardStatefulWidgetState extends State<DashboardStatefulWidget> {
  final CurrentUserObject userObject;
  final AsramaObject asramaDetail;

  late DataHomePageObject dataHomePageObject = DataHomePageObject(
      jumlahSantriAktif: 0,
      jumlahSantriAda: 0,
      jumlahSantriIzin: 0,
      jumlahSantriSakit: 0,
      jumlahSantriHadirNgaji: 0,
      jumlahLunasSPP: 0);

  late List<int> pemasukanSPP = [0, 0, 0];
  double persentaseLunasSPP = 1;

  List<PembayaranObject_6BulanTerakhir> chartData = [];
  List<SantriObject> semuaSantriAktif = [];
  List<KelasNgajiObject> semuaKelasNgaji = [];

  _DashboardStatefulWidgetState(this.userObject, this.asramaDetail);
  // List<int> pemasukanSPP = [0, 0, 0];
  int pemasukanSPP_pointer = 0;
  int jumlahSantriMengajiHariIni = 0;
  // int jumlahKelasAbsenHariIni = 1;

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      "Ada": dataHomePageObject.jumlahSantriAda.toDouble(),
      "Izin": dataHomePageObject.jumlahSantriIzin.toDouble(),
      "Sakit": dataHomePageObject.jumlahSantriSakit.toDouble(),
    };

    int jumlahKelasAbsenHariIni = semuaKelasNgaji
        .where((element) => element.adaAbsensi == true)
        .toList()
        .length;

    return Padding(
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
                            jumlahSantriAktifCard_1(context),
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
                        padding: EdgeInsets.only(top: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TabBarView(
                                children: [
                                  AbsenNgajiCard(context,
                                      title: 'Kehadiran Ngaji Hari Ini',
                                      semuaKelasNgaji: semuaKelasNgaji,
                                      subset: jumlahSantriMengajiHariIni,
                                      total:
                                          dataHomePageObject.jumlahSantriAktif),
                                  AbsenNgajiCard(context,
                                      semuaKelasNgaji: semuaKelasNgaji,
                                      title: 'Jumlah Absensi Kelas',
                                      total: asramaDetail.kelasNgaji.length,
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
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, CekAbsensi.id,
                            arguments: userObject);
                      },
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
                                title: ChartTitle(
                                    text: 'Santri Aktif vs Lunas',
                                    textStyle: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey)),
                                legend: Legend(
                                    isVisible: false, isResponsive: true),
                                primaryXAxis: CategoryAxis(),
                                primaryYAxis:
                                    NumericAxis(minimum: 0, maximum: 300),
                                series: <ChartSeries>[
                                  ColumnSeries<PembayaranObject_6BulanTerakhir,
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
                                  ColumnSeries<PembayaranObject_6BulanTerakhir,
                                      String>(
                                    name: 'Lunas',
                                    dataSource: chartData,
                                    dataLabelSettings: DataLabelSettings(
                                        isVisible: true,
                                        textStyle:
                                            GoogleFonts.poppins(fontSize: 10)),
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
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  // increment pemasukanSPP_pointer by 1 unless it's already 2, then set it to 0
                                  pemasukanSPP_pointer =
                                      pemasukanSPP_pointer == 2
                                          ? 0
                                          : pemasukanSPP_pointer + 1;
                                });
                              },
                              child: Container(
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Pemasukan SPP',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey,
                                            fontSize: 16),
                                      ),
                                      Center(
                                        child: Text(
                                          'Rp ${NumberFormat('#,###').format(pemasukanSPP[pemasukanSPP_pointer]).replaceAll(",", ".")}',
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w800,
                                              color: Colors.green,
                                              fontSize: 32),
                                        ),
                                      ),
                                      Container(
                                        width: 250,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  pemasukanSPP_pointer = 0;
                                                });
                                              },
                                              child: Text(
                                                'Bulan Ini',
                                                style: GoogleFonts.poppins(
                                                    fontWeight:
                                                        pemasukanSPP_pointer ==
                                                                0
                                                            ? FontWeight.w600
                                                            : FontWeight.w400,
                                                    color:
                                                        pemasukanSPP_pointer ==
                                                                0
                                                            ? Colors.black
                                                            : Colors
                                                                .grey
                                                                .withOpacity(
                                                                    0.5),
                                                    fontSize: 12),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  pemasukanSPP_pointer = 1;
                                                });
                                              },
                                              child: Text(
                                                '3 Bulan',
                                                style: GoogleFonts.poppins(
                                                    fontWeight:
                                                        pemasukanSPP_pointer ==
                                                                1
                                                            ? FontWeight.w600
                                                            : FontWeight.w400,
                                                    color:
                                                        pemasukanSPP_pointer ==
                                                                1
                                                            ? Colors.black
                                                            : Colors
                                                                .grey
                                                                .withOpacity(
                                                                    0.5),
                                                    fontSize: 12),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  pemasukanSPP_pointer = 2;
                                                });
                                              },
                                              child: Text(
                                                'Tahun Ini',
                                                style: GoogleFonts.poppins(
                                                    fontWeight:
                                                        pemasukanSPP_pointer ==
                                                                2
                                                            ? FontWeight.w600
                                                            : FontWeight.w400,
                                                    color:
                                                        pemasukanSPP_pointer ==
                                                                2
                                                            ? Colors.black
                                                            : Colors
                                                                .grey
                                                                .withOpacity(
                                                                    0.5),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ]),
                              ),
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
                            unselectedLabelColor: Colors.grey.withOpacity(0.4),
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
                // Expanded(
                //   flex: 2,
                //   child: Card(
                //     elevation: 2,
                //     child: Container(
                //       color: Colors.blueGrey.shade50,
                //       padding: EdgeInsets.all(12),
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Expanded(
                //             child: Center(
                //               child: Image.asset('assets/activity-tracker.png',
                //                   height: MediaQuery.of(context).size.height *
                //                       0.07),
                //             ),
                //           ),
                //           SizedBox(height: 8),
                //           Text(
                //             'Log Aktivitas',
                //             style: GoogleFonts.poppins(
                //                 fontWeight: FontWeight.w600,
                //                 color: Colors.grey,
                //                 fontSize: 16),
                //           ),
                //         ],
                //       ),
                //       // add your card widget content here
                //     ),
                //   ),
                // ),
                Expanded(
                  flex: 3,
                  child: Card(
                    elevation: 2,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, DataLengkapSantri.id,
                            arguments: userObject);
                      },
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget PembayaranSPPCard_1(BuildContext context) {
    //make a color gradient for the progress bar. it depends on the persentase lunas spp, from red accent, orange accent, yellow accent, green accent

    Color progressBarColor = Colors.green;
    return InkWell(
      onTap: () async {
        LoaderWidget.showLoader(context);
        List<SantriObject> listSantriBelumLunas = semuaSantriAktif
            .where((element) => element.lunasSPP == false)
            .toList();
        List<PelunasanObject> pelunasanObject =
            await PelunasanClass.getDaftarPelunasan(listSantriBelumLunas);
        List<SantriObject> listSantriSudahLunas = semuaSantriAktif
            .where((element) => element.lunasSPP == true)
            .toList();
        Navigator.pop(context);
        detailPembayaranBottomSheet(context,
            santriSudahLunas: listSantriSudahLunas,
            santriBelumLunas: pelunasanObject);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 8),
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
                backgroundColor: Colors.grey.withOpacity(0.4),
                progressColor: getGradientColor(persentaseLunasSPP / 100),
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
                      text:
                          '${dataHomePageObject.jumlahLunasSPP}/${dataHomePageObject.jumlahSantriAktif} santri',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w800,
                          color: Colors.redAccent,
                          fontSize: 12))
                else if (persentaseLunasSPP < 90 && persentaseLunasSPP >= 50)
                  TextSpan(
                      text:
                          '${dataHomePageObject.jumlahLunasSPP}/${dataHomePageObject.jumlahSantriAktif} santri',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w800,
                          color: Colors.orangeAccent,
                          fontSize: 12))
                else if (persentaseLunasSPP >= 90)
                  TextSpan(
                      text:
                          '${dataHomePageObject.jumlahLunasSPP}/${dataHomePageObject.jumlahSantriAktif} santri',
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
      ),
    );
  }

  Widget jumlahSantriAktifCard_1(BuildContext context) {
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
            dataHomePageObject.jumlahSantriAktif.toString(),
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
                    angka: dataHomePageObject.jumlahSantriAda,
                    keterangan: "Ada",
                    allSantri: semuaSantriAktif),
                DetailSantri(context,
                    allSantri: semuaSantriAktif,
                    angka: dataHomePageObject.jumlahSantriIzin,
                    keterangan: "Izin",
                    isMiddle: true),
                DetailSantri(context,
                    allSantri: semuaSantriAktif,
                    angka: dataHomePageObject.jumlahSantriSakit,
                    keterangan: "Sakit"),
              ],
            ),
          ),
        ],
      )),
    );
  }

  Future<void> getPemasukanSPP() async {
    pemasukanSPP = [0, 0, 0];
    List<PembayaranObject_6BulanTerakhir> dataPembayaran =
        await Pembayaran_6BulanTerakhirClass.getPembayaranTahunIni(userObject);
    print('bulan ini ${dataPembayaran[dataPembayaran.length - 1].bulan}');
    pemasukanSPP[0] = (dataPembayaran[dataPembayaran.length - 1].santriLunas *
            dataPembayaran[dataPembayaran.length - 1].nominal!)
        .round()
        .toInt();
    print('sebelum masuk loop ${pemasukanSPP}');
    pemasukanSPP[1] = 0;
    pemasukanSPP[2] = 0;

    int index = dataPembayaran.length - 1;
    int pemasukan = 0;

    for (int index = dataPembayaran.length - 1; index > 0; index--) {
      print(dataPembayaran[index].bulan);
      pemasukan =
          (dataPembayaran[index].santriLunas * dataPembayaran[index].nominal!)
              .round()
              .toInt();
      print(pemasukan);
      if (index > dataPembayaran.length - 3) {
        print('masuk');
        print('sebelum ${pemasukanSPP[1]}');
        pemasukanSPP[1] += pemasukan;
        print('sesudah ${pemasukanSPP[1]}');
      }
      pemasukanSPP[2] += pemasukan;
    }

    setState(() {
      print(pemasukanSPP);
    });
  }

  Widget AbsenNgajiCard(BuildContext context,
      {required String title,
      required int subset,
      required int total,
      required List<KelasNgajiObject> semuaKelasNgaji}) {
    return InkWell(
      onTap: () {
        detailKelasNgajiBottomSheet(context, semuaKelasNgaji: semuaKelasNgaji);
      },
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.grey),
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
      ),
    );
  }

  Future<void> getUserDetails() async {
    // _userObject = await CurrentUserClass().getUserDetail();
    // asramaDetail = await AsramaClass.getAsramaDetail(_userObject.kodeAsrama!);
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    Stream<QuerySnapshot> _santriStream = FirebaseFirestore.instance
        .collection('SantriCollection')
        .where('kodeAsrama', isEqualTo: userObject.kodeAsrama)
        .where('statusAktif', isEqualTo: 'Aktif')
        .snapshots();

    Stream<QuerySnapshot> _invoiceStream = FirebaseFirestore.instance
        .collection('InvoiceCollection')
        .where('kodeAsrama', isEqualTo: userObject.kodeAsrama)
        .orderBy('tglInvoice', descending: true)
        .limit(12)
        .snapshots();

    Stream<QuerySnapshot> _kelasNgajiStream = FirebaseFirestore.instance
        .collection('AktivitasCollection')
        .doc(userObject.kodeAsrama)
        .collection('AbsenNgajiLogs')
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(today))
        .snapshots();

    _kelasNgajiStream.listen((QuerySnapshot snapshot) {
      semuaKelasNgaji = KelasNgajiClass.getKelasNgajiDetail(
          snapshot, asramaDetail.kelasNgaji);

      //loop through kelas ngaji, get the list of hadir[], and increment the length
      for (int i = 0; i < semuaKelasNgaji.length; i++) {
        jumlahSantriMengajiHariIni += semuaKelasNgaji[i].hadir.length;
      }
      setState(() {
        List<KelasNgajiObject> semuaKelasAktif = semuaKelasNgaji
            .where((element) => element.adaAbsensi == true)
            .toList();
        // jumlahKelasAbsenHariIni = semuaKelasAktif.length;
      });
    });

    _santriStream.listen((QuerySnapshot snapshot) async {
      semuaSantriAktif = SantriClass.getSantriList(snapshot);
      dataHomePageObject = DataHomePageClass.getDataHomePage(snapshot);

      await getPemasukanSPP();
      setState(() {
        // persentasePembayarSPP = dataHomePageObject.jumlahLunasSPP /
        //     dataHomePageObject.jumlahSantriAktif *
        //     100;
        persentaseLunasSPP = dataHomePageObject.jumlahLunasSPP /
            dataHomePageObject.jumlahSantriAktif *
            100;

        print('STATEFUL WIDGET MENJALANKAN SETSTATE');
      });
    });

    _invoiceStream.listen((QuerySnapshot snapshot) {
      chartData =
          Pembayaran_6BulanTerakhirClass.getPembayaran6BulanTerakhir(snapshot);
      // _selectedIndex = 0;
    });

    print(asramaDetail.namaAsrama);
    print(asramaDetail.lokasiGeografis);
    print(asramaDetail.profilSingkat);
  }
}

Widget DetailSantri(BuildContext context,
    {required int angka,
    required String keterangan,
    bool? isMiddle,
    required List<SantriObject> allSantri}) {
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

  return InkWell(
    onTap: () {
      detailSantriBottomSheet(context,
          keterangan: keterangan, allSantri: allSantri);
    },
    child: Container(
      width: MediaQuery.of(context).size.width / 4.5,
      padding: EdgeInsets.only(left: 8, right: 8),
      decoration: BoxDecoration(
          border: isMiddle == true
              ? Border()
              : Border.symmetric(
                  vertical:
                      BorderSide(color: Colors.grey.shade300, width: 0.7))),
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
    ),
  );
}

Color getGradientColor(double value) {
  if (value >= 1) return Colors.green;

  List<Color> colors = [Colors.redAccent, Colors.green];
  List<double> stops = [0.0, 1.0];

  // Map the value to a range between 0 and 1
  double normalizedValue = value;

  // Interpolate the gradient color based on the normalized value
  int index = (normalizedValue * (stops.length - 1)).floor();
  double t =
      (normalizedValue - stops[index]) / (stops[index + 1] - stops[index]);
  return Color.lerp(colors[index], colors[index + 1], t)!;
}
