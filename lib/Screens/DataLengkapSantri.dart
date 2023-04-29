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
                                '${semuaSantriAlumni[index].tglMasuk.toDate().year} -  sekarang (${semuaSantriAlumni[index].kelas})',
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
                                '${semuaSantriTidakLulus[index].tglMasuk.toDate().year} -  sekarang (${semuaSantriTidakLulus[index].kelas})',
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
}
