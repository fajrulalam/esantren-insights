import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esantren_insights_v1/Objects/CurrentUserObject.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Classes/SantriClass.dart';
import '../Objects/SantriObject.dart';

class DataLengkapSantri extends StatefulWidget {
  static String id = 'DataLengkapSantri';
  final CurrentUserObject userObject;
  const DataLengkapSantri({Key? key, required this.userObject})
      : super(key: key);

  @override
  State<DataLengkapSantri> createState() => _DataLengkapSantriState();
}

class _DataLengkapSantriState extends State<DataLengkapSantri>
    with TickerProviderStateMixin {
  bool _isContainerCollapsed = false;

  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  final controller3 = TextEditingController();

  List<SantriObject> semuaSantri = [];
  List<SantriObject> semuaSantriAktif = [];
  List<SantriObject> semuaSantriAlumni = [];
  List<SantriObject> semuaSantriTidakLulus = [];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    getData();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Lengkap Santri'),
        leading: const BackButton(
          color: Colors.grey,
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Text(
                'Aktif',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Tab(
              child: Text(
                'Alumni',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Tab(
              child: Text(
                'Tidak Lulus',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: controller1,
              decoration: InputDecoration(
                hintText: 'Cari Nama Santri',
                //add rounded border
                border: _isContainerCollapsed
                    ? null
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
              ),
              onChanged: (value) {
                search(value);
              },
            ),
            Container(
              height: MediaQuery.of(context).size.height - 210,
              child: Flex(direction: Axis.vertical, children: [
                if (semuaSantriAktif.isEmpty)
                  Expanded(child: Center(child: CircularProgressIndicator()))
                else
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        AktifTab(),
                        AlumniTab(),
                        TidakLulusTab(),
                      ],
                    ),
                  ),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget AktifTab() {
    if (semuaSantriAktif.isEmpty) {
      return Center(
        child: Text(
          'Belum ada santri aktif',
          style: GoogleFonts.poppins(fontSize: 24),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
          itemCount: semuaSantriAktif.length,
          itemBuilder: (BuildContext context, int index) {
            // return a list tile of santri name, id, and statusAktif. when clicked it should return a bottom sheet with santri details

            Color indicatorColor = Colors.green;
            if (semuaSantriAktif[index].statusKehadiran == 'Sakit') {
              indicatorColor = Colors.redAccent;
            } else if (semuaSantriAktif[index].statusKehadiran == 'Pulang') {
              indicatorColor = Colors.orange;
            }

            return InkWell(
              onTap: () {
                //open bottom sheet
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 300,
                        child: Column(
                          children: [
                            Text(semuaSantriAktif[index].nama),
                            Text(semuaSantriAktif[index].id),
                            Text(semuaSantriAktif[index].kelas),
                          ],
                        ),
                      );
                    });
              },
              child: Container(
                padding: EdgeInsets.only(right: 8, left: 8, top: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 9,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //two text widgets one is the title (nama) and the other is the subtitle
                              Text(
                                semuaSantriAktif[index].nama,
                                style: GoogleFonts.notoSans(
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '${semuaSantriAktif[index].tglMasuk.toDate().year} -  sekarang (${semuaSantriAktif[index].kelas})',
                                style: GoogleFonts.notoSans(
                                    fontWeight: FontWeight.w300, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: //create a circle container with a green background color
                              Container(
                            height: 6,
                            width: 6,
                            decoration: BoxDecoration(
                              color: indicatorColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: indicatorColor.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Divider(
                      height: 1,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  void getData() async {
    Stream<QuerySnapshot> _santriStream = FirebaseFirestore.instance
        .collection('SantriCollection')
        .where('kodeAsrama', isEqualTo: widget.userObject.kodeAsrama)
        .snapshots();

    _santriStream.listen((snapshot) {
      setState(() {
        semuaSantri = SantriClass.getSantriList(snapshot);
        semuaSantriAktif = semuaSantri
            .where((element) => element.statusAktif == 'Aktif')
            .toList();
        semuaSantriAlumni = semuaSantri
            .where((element) => element.statusAktif == 'Alumni')
            .toList();
        semuaSantriTidakLulus = semuaSantri
            .where((element) =>
                element.statusAktif != 'Aktif' &&
                element.statusAktif != 'Alumni')
            .toList();
      });
    });

    print(semuaSantriAktif.length);
  }

  void search(String value) {
    print(value);
    setState(() {
      semuaSantriAktif = semuaSantri
          .where((element) =>
              element.nama.toLowerCase().contains(value.toLowerCase()) &&
              element.statusAktif == 'Aktif')
          .toList();

      semuaSantriAlumni = semuaSantri
          .where((element) =>
              element.nama.toLowerCase().contains(value.toLowerCase()) &&
              element.statusAktif == 'Alumni')
          .toList();

      semuaSantriAlumni = semuaSantri
          .where((element) =>
              element.nama.toLowerCase().contains(value.toLowerCase()) &&
              (element.statusAktif != 'Alumni' &&
                  element.statusAktif != 'Aktif'))
          .toList();
    });
  }

  tabBarViews() {}

  Widget AlumniTab() {
    if (semuaSantriAlumni.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Belum ada santri yang terdata sebagai alumni',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 24),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
          itemCount: semuaSantriAlumni.length,
          itemBuilder: (BuildContext context, int index) {
            // return a list tile of santri name, id, and statusAktif. when clicked it should return a bottom sheet with santri details

            Color indicatorColor = Colors.green;
            if (semuaSantriAlumni[index].statusKehadiran == 'Sakit') {
              indicatorColor = Colors.redAccent;
            } else if (semuaSantriAlumni[index].statusKehadiran == 'Pulang') {
              indicatorColor = Colors.orange;
            }

            return InkWell(
              onTap: () {
                //open bottom sheet
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 300,
                        child: Column(
                          children: [
                            Text(semuaSantriAlumni[index].nama),
                            Text(semuaSantriAlumni[index].id),
                            Text(semuaSantriAlumni[index].kelas),
                          ],
                        ),
                      );
                    });
              },
              child: Container(
                padding: EdgeInsets.only(right: 8, left: 8, top: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 9,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //two text widgets one is the title (nama) and the other is the subtitle
                              Text(
                                semuaSantriAlumni[index].nama,
                                style: GoogleFonts.notoSans(
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '${semuaSantriTidakLulus[index].tglMasuk.toDate().year} -  ${getMonth(semuaSantriTidakLulus[index].tglKeluar.toDate().month.toString())} ${semuaSantriTidakLulus[index].tglKeluar.toDate().year}',
                                style: GoogleFonts.notoSans(
                                    fontWeight: FontWeight.w300, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Divider(
                      height: 1,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget TidakLulusTab() {
    if (semuaSantriTidakLulus.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Belum ada santri yang keluar/dikeluarkan',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 24),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
          itemCount: semuaSantriTidakLulus.length,
          itemBuilder: (BuildContext context, int index) {
            // return a list tile of santri name, id, and statusAktif. when clicked it should return a bottom sheet with santri details

            Color indicatorColor = Colors.green;
            if (semuaSantriTidakLulus[index].statusKehadiran == 'Sakit') {
              indicatorColor = Colors.redAccent;
            } else if (semuaSantriTidakLulus[index].statusKehadiran ==
                'Pulang') {
              indicatorColor = Colors.orange;
            }

            Widget iconImage =
                Image.asset('assets/logout.png', fit: BoxFit.fitHeight);
            if (semuaSantriTidakLulus[index].statusAktif == 'Dikeluarkan') {
              iconImage = ColorFiltered(
                colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
                child: Image.asset(
                  'assets/kick.png',
                  fit: BoxFit.fitHeight,
                ),
              );
            }

            return InkWell(
              onTap: () {
                //open bottom sheet
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 300,
                        child: Column(
                          children: [
                            Text(semuaSantriTidakLulus[index].nama),
                            Text(semuaSantriTidakLulus[index].id),
                            Text(semuaSantriTidakLulus[index].kelas),
                          ],
                        ),
                      );
                    });
              },
              child: Container(
                padding: EdgeInsets.only(right: 8, left: 8, top: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 9,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //two text widgets one is the title (nama) and the other is the subtitle
                              Text(
                                semuaSantriTidakLulus[index].nama,
                                style: GoogleFonts.notoSans(
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '${semuaSantriTidakLulus[index].tglMasuk.toDate().year} -  ${getMonth(semuaSantriTidakLulus[index].tglKeluar.toDate().month.toString())} ${semuaSantriTidakLulus[index].tglKeluar.toDate().year}',
                                style: GoogleFonts.notoSans(
                                    fontWeight: FontWeight.w300, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: //create a circle container with a green background color
                              Container(
                            height: 16,
                            width: 16,
                            child: iconImage,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Divider(
                      height: 1,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  String getMonth(String monthInt) {
    String monthName = '';

    switch (monthInt) {
      //make a case of 1 - 12 and return the month name
      case '1':
        monthName = 'Januari';
        return monthName;
        break;
      case '2':
        monthName = 'Februari';
        return monthName;
        break;
      case '3':
        monthName = 'Maret';
        return monthName;
        break;
      case '4':
        monthName = 'April';
        return monthName;
        break;
      case '5':
        monthName = 'Mei';
        return monthName;
        break;
      case '6':
        monthName = 'Juni';
        return monthName;
        break;
      case '7':
        monthName = 'Juli';
        return monthName;
        break;
      case '8':
        monthName = 'Agustus';
        return monthName;
        break;
      case '9':
        monthName = 'September';
        return monthName;
        break;
      case '10':
        monthName = 'Oktober';
        return monthName;
        break;
      case '11':
        monthName = 'November';
        return monthName;
        break;
      case '12':
        monthName = 'Desember';
        return monthName;
        break;
      default:
        return monthName;
    }
  }
}
