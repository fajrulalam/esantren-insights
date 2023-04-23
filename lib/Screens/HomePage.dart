import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:esantren_insights_v1/BottomSheets/DetailPembayaran_BS.dart';
import 'package:esantren_insights_v1/Classes/PelunasanClass.dart';
import 'package:esantren_insights_v1/Classes/PembayaranClass.dart';
import 'package:esantren_insights_v1/Objects/AsramaObject.dart';
import 'package:esantren_insights_v1/Objects/PelunasanObject.dart';
import 'package:esantren_insights_v1/Objects/PembayaranObject.dart';
import 'package:esantren_insights_v1/Screens/ProfilAsrama.dart';
import 'package:esantren_insights_v1/Screens/SettingAsrama.dart';
import 'package:esantren_insights_v1/Widgets/DashboardStatefulWidget.dart';
import 'package:esantren_insights_v1/Widgets/LoaderWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../BottomSheets/DetailSantri_BS.dart';
import '../BottomSheets/KelasNgajiDetail_BS.dart';
import '../Classes/AsramaClass.dart';
import '../Classes/CurrentUserClass.dart';
import '../Classes/DataHomePageClass.dart';
import '../Classes/KelasNgajiClass.dart';
import '../Classes/SantriClass.dart';
import '../Objects/CurrentUserObject.dart';
import '../Objects/DataHomePageObject.dart';
import '../Objects/KelasNgajiObject.dart';
import '../Objects/SantriObject.dart';
import '../Services/Authentication.dart';
import '../Widgets/DashboardWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late CurrentUserObject _userObject = CurrentUserObject();

  int _selectedIndex = -1;

  // int jumlahKelas = 18;
  List<int> pemasukanSPP = [];
  // int jumlahKelasAbsenHariIni = 1;
  // late double persentasePembayarSPP = 1;
  late double persentaseLunasSPP = 1;

  AsramaObject asramaDetail = AsramaObject(
      listFoto: [],
      kelasNgaji: ['a', 'b'],
      id: 'id',
      pengasuh: ['a', 'b'],
      didirikanPada: 2000,
      lokasiGeografis: 'lokasiGeografis',
      namaAsrama: 'namaAsrama',
      pathFotoAsrama: 'pathFotoAsrama',
      profilSingkat: 'profilSingkat',
      program: ['a']);
  late DataHomePageObject dataHomePageObject = DataHomePageObject(
      jumlahSantriAktif: 0,
      jumlahSantriAda: 0,
      jumlahSantriIzin: 0,
      jumlahSantriSakit: 0,
      jumlahSantriHadirNgaji: 0,
      jumlahLunasSPP: 0);

  Future<void> getUserDetails() async {
    _userObject = await CurrentUserClass().getUserDetail();
    asramaDetail = await AsramaClass.getAsramaDetail(_userObject.kodeAsrama!);
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    setState(() {
      _selectedIndex = 0;
    });

    // Stream<QuerySnapshot> _santriStream = FirebaseFirestore.instance
    //     .collection('SantriCollection')
    //     .where('statusAktif', isEqualTo: 'Aktif')
    //     .snapshots();
    //
    // Stream<QuerySnapshot> _invoiceStream = FirebaseFirestore.instance
    //     .collection('InvoiceCollection')
    //     .where('kodeAsrama', isEqualTo: _userObject.kodeAsrama)
    //     .orderBy('tglInvoice', descending: true)
    //     .limit(12)
    //     .snapshots();
    //
    // Stream<QuerySnapshot> _kelasNgajiStream = FirebaseFirestore.instance
    //     .collection('AktivitasCollection')
    //     .doc(_userObject.kodeAsrama)
    //     .collection('AbsenNgajiLogs')
    //     .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(today))
    //     .snapshots();
    //
    // _kelasNgajiStream.listen((QuerySnapshot snapshot) {
    //   semuaKelasNgaji = KelasNgajiClass.getKelasNgajiDetail(
    //       snapshot, asramaDetail.kelasNgaji);
    //   setState(() {
    //     List<KelasNgajiObject> semuaKelasAktif = semuaKelasNgaji
    //         .where((element) => element.adaAbsensi == true)
    //         .toList();
    //     // jumlahKelasAbsenHariIni = semuaKelasAktif.length;
    //   });
    // });
    //
    // _santriStream.listen((QuerySnapshot snapshot) async {
    //   semuaSantriAktif = SantriClass.getSantriList(snapshot);
    //   dataHomePageObject = DataHomePageClass.getDataHomePage(snapshot);
    //
    //   await getPemasukanSPP();
    //   setState(() {
    //     // persentasePembayarSPP = dataHomePageObject.jumlahLunasSPP /
    //     //     dataHomePageObject.jumlahSantriAktif *
    //     //     100;
    //     persentaseLunasSPP = dataHomePageObject.jumlahLunasSPP /
    //         dataHomePageObject.jumlahSantriAktif *
    //         100;
    //   });
    // });
    //
    // _invoiceStream.listen((QuerySnapshot snapshot) {
    //   chartData =
    //       Pembayaran_6BulanTerakhirClass.getPembayaran6BulanTerakhir(snapshot);
    //   _selectedIndex = 0;
    // });
    //
    // print(asramaDetail.namaAsrama);
    // print(asramaDetail.lokasiGeografis);
    // print(asramaDetail.profilSingkat);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Auth().signOut();
    // Navigator.pushReplacementNamed(context, '/home');
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    // _santriStream.toList().then((value) => print('Print this $value'));

    // final List<PembayaranObject_6BulanTerakhir> chartData =
    //     Pembayaran_6BulanTerakhirClass.getPembayaran6BulanTerakhir();
    // print(chartData);

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
      body: Body(),
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
        currentIndex: _selectedIndex == -1 ? 0 : _selectedIndex,
        selectedItemColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 2,
        onTap: (index) async {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget Body() {
    if (_selectedIndex == 0) {
      return DashboardStatefulWidget(
        userObject: _userObject,
        asramaDetail: asramaDetail,
      );
      //   // // } else if (_selectedIndex == 1) {
      //   // //   // return Pengumuman();
      //   // // } else if (_selectedIndex == 2) {
      //   //   // return Asrama();
    } else if (_selectedIndex == 2) {
      return SettingAsrama(userObject: _userObject, asramaDetail: asramaDetail);
    } else {
      // LoaderWidget.showLoader(context);
      return Center(child: CircularProgressIndicator());
    }
  }

  Future<void> getPemasukanSPP() async {
    pemasukanSPP = [0, 0, 0];
    List<PembayaranObject_6BulanTerakhir> dataPembayaran =
        await Pembayaran_6BulanTerakhirClass.getPembayaranTahunIni(_userObject);
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
}
