import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:esantren_insights_v1/Classes/CekAbsensiClass.dart';
import 'package:esantren_insights_v1/Objects/AsramaObject.dart';
import 'package:esantren_insights_v1/Objects/CekAbsensiObject.dart';
import 'package:esantren_insights_v1/Objects/CurrentUserObject.dart';
import 'package:esantren_insights_v1/Objects/KelasNgajiObject.dart';
import 'package:esantren_insights_v1/Objects/PengajarObject.dart';
import 'package:esantren_insights_v1/Screens/CekAbsensi2_Kelas.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../Classes/CurrentUserClass.dart';
import '../Services/CustomPageRouteAnimation.dart';

class CekAbsensi extends StatefulWidget {
  static String id = 'CekAbsensi';
  final AsramaObject asramaDetailObject;
  const CekAbsensi({Key? key, required this.asramaDetailObject})
      : super(key: key);

  @override
  State<CekAbsensi> createState() => _CekAbsensiState();
}

class _CekAbsensiState extends State<CekAbsensi> with TickerProviderStateMixin {
  late CekAbsensiObject cekAbsensiObject;
  late TabController _tabController;
  bool _showHint = false;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  late CurrentUserObject userObject;

  List<PengajarObject> listPengajar = [];
  List<KelasNgajiObject> listKelas = [];

  String timeFrame = 'Hari Ini';
  String keteranganTimeFrame = 'Rekapitulasi Absensi Hari Ini';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.8, 1.0, curve: Curves.easeInOut),
      ),
    );

    getDataHarian();
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
                'Kelas',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Tab(
              child: Text(
                'Pengajar',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDropdown(),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: TabBarView(controller: _tabController, children: [
                Container(
                  child: GridView.builder(
                    itemCount: listKelas.length, // number of items in the grid
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width ~/ 180,
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      childAspectRatio: 180 / 180,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      if (listKelas.isEmpty) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return Container(
                        padding: EdgeInsets.all(12),
                        child: Card(
                          elevation: 1,
                          //give a rounded corner
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(CustomPageRoute(
                                  child: CekAbsensi2_Kelas(
                                kelas: listKelas[index].kelasNgaji,
                                userObject: userObject,
                              )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Center(
                                    child: Text(
                                      listKelas[index].kelasNgaji,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.library_add_check_outlined,
                                        color: Colors.grey,
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        '${listKelas[index].berapaKaliAbsen}x absen',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.timelapse_outlined,
                                        color: Colors.grey,
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        timeFrame == 'Hari Ini'
                                            ? getDurationHarian(
                                                listKelas[index]
                                                    .timestampSelesai!,
                                                listKelas[index].timestamp)
                                            : convertSecondsToMinutes(listKelas[
                                                        index]
                                                    .totalDurationInSeconds! ~/
                                                listKelas[index]
                                                    .berapaKaliAbsen!),
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.people_outline_rounded,
                                        color: Colors.grey,
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        timeFrame == "Hari Ini"
                                            ? listKelas[index]
                                                .hadir
                                                .length
                                                .toString()
                                            : '~${listKelas[index].hadir.length ~/ listKelas[index].berapaKaliAbsen!} peserta',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                //container with child center with child text
                Container(
                  child: GridView.builder(
                    itemCount:
                        listPengajar.length, // number of items in the grid
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width ~/ 200,
                      crossAxisSpacing: 4.0,
                      childAspectRatio: 14 / 7,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      if (listPengajar.isEmpty) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Container(
                        padding: EdgeInsets.all(16),
                        child: Card(
                          elevation: 1,
                          //give a rounded corner
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  //aspect ratio of the image is 16/9
                                  Expanded(
                                    flex: 2,
                                    child: AspectRatio(
                                        aspectRatio: 9 / 16,
                                        child: Image.network(
                                            listPengajar[index].imagePath,
                                            fit: BoxFit.cover)),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          '${listPengajar[index].honoraryName} ${listPengajar[index].namaPanggilan}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Spacer(),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.house_outlined,
                                              color: Colors.grey,
                                              size: 16,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              listPengajar[index].mukim == true
                                                  ? 'Mukim'
                                                  : 'Non-mukim',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.library_add_check_outlined,
                                              color: Colors.grey,
                                              size: 18,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              '${listPengajar[index].berapaKaliAbsen}x absen',
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Opacity(
                                          opacity: 0,
                                          child: Text(
                                            '${listPengajar[index].honoraryName} ${listPengajar[index].namaPanggilan}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.timer_outlined,
                                              color: Colors.grey,
                                              size: 16,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              timeFrame == 'Hari Ini'
                                                  ? getDurationHarian(
                                                      listPengajar[index]
                                                          .timestampSelesai!,
                                                      listPengajar[index]
                                                          .timestampMulai)
                                                  : convertSecondsToMinutes(
                                                      listPengajar[index]
                                                              .totalDurationInSeconds! ~/
                                                          listPengajar[index]
                                                              .berapaKaliAbsen!),
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.monetization_on_rounded,
                                              color: Colors.green,
                                              size: 16,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              'Rp ${NumberFormat.decimalPattern().format(listPengajar[index].berapaKaliAbsen! * widget.asramaDetailObject.honorUstadz! * 10).replaceAll(',', '.')}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget CustomDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //make a drop down
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          child: DropdownButton(
            value: timeFrame,
            borderRadius: BorderRadius.circular(8),
            items: [
              DropdownMenuItem(
                child: Text('Hari Ini'),
                value: 'Hari Ini',
              ),
              DropdownMenuItem(
                child: Text('Minggu Ini'),
                value: 'Minggu Ini',
              ),
              DropdownMenuItem(
                child: Text('Bulan Ini'),
                value: 'Bulan Ini',
              )
            ],
            onChanged: (value) {
              setState(() {
                timeFrame = value.toString();
                switch (value.toString()) {
                  case "Hari Ini":
                    keteranganTimeFrame = 'Rekap hari Ini';
                    getDataHarian();
                    break;
                  case "Minggu Ini":
                    keteranganTimeFrame = 'Rekap minggu ini (Sabtu - Jumat)';
                    getDataMingguan(userObject);
                    break;
                  case "Bulan Ini":
                    String bulan =
                        DateFormat('MMMM', 'id_ID').format(DateTime.now());
                    keteranganTimeFrame = 'Rekap bulan $bulan';
                    getDataBulanan(userObject);
                    break;
                }
              });
            },
          ),
        ),
        SizedBox(
          width: 16,
        ),
        InkWell(
          onTap: () {
            setState(() {
              _showHint = !_showHint;
            });
            _controller.forward().then((value) {
              setState(() {
                _showHint = false;
              });
              _controller.reset();
            });
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.help_outline,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        if (_showHint)
          FadeTransition(
            opacity: _opacityAnimation,
            child: Container(
              width: 150,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black54.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Center(
                  child: Text(
                    keteranganTimeFrame,
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void getDataHarian() async {
    userObject = await CurrentUserClass().getUserDetail();
    cekAbsensiObject = await CekAbsensiClass.cekAbsensiHarian(userObject);

    // CekAbsensiClass.getDataMingguan(userObject);

    setState(() {
      listKelas = cekAbsensiObject.kelasNgajiList;
      listPengajar = cekAbsensiObject.pengajarList;
    });
  }

  String getDurationHarian(Timestamp timestampSelesai, Timestamp timestamp) {
    if (timestampSelesai == null) {
      return 'masih berjalan';
    } else {
      //difference between timestampSelesai selesai and timestamp, return in the format of m minutes
      Duration difference =
          timestampSelesai.toDate().difference(timestamp.toDate());
      int minutes = difference.inMinutes;
      if (minutes < 0) {
        return 'masih berjalan';
      } else {
        return '${minutes}m';
      }
    }
  }

  String convertSecondsToMinutes(num? totalDurationInSeconds) {
    //convert seconds to minutes
    int minutes = (totalDurationInSeconds! / 60).truncate();
    // return in the format of m minutes
    return '~${minutes} menit';
  }

  void getDataMingguan(CurrentUserObject userObject) async {
    setState(() {
      listKelas = [];
      listPengajar = [];
    });

    // CurrentUserObject userObject = await CurrentUserClass().getUserDetail();
    cekAbsensiObject = await CekAbsensiClass.getDataMingguan(userObject);

    setState(() {
      listKelas = CekAbsensiClass.aggregateKelasNgajiObject(
          cekAbsensiObject.kelasNgajiList);
      listPengajar = CekAbsensiClass.aggregatePengajarObject(
          cekAbsensiObject.pengajarList);
    });
  }

  void getDataBulanan(CurrentUserObject userObject) async {
    setState(() {
      listKelas = [];
      listPengajar = [];
    });

    // CurrentUserObject userObject = await CurrentUserClass().getUserDetail();
    cekAbsensiObject = await CekAbsensiClass.getDataBulanan(userObject);

    setState(() {
      listKelas = CekAbsensiClass.aggregateKelasNgajiObject(
          cekAbsensiObject.kelasNgajiList);
      listPengajar = CekAbsensiClass.aggregatePengajarObject(
          cekAbsensiObject.pengajarList);
    });
  }
}
