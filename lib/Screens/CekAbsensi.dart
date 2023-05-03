import 'package:esantren_insights_v1/Screens/CekAbsensi2_Kelas.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../Services/CustomPageRouteAnimation.dart';

class CekAbsensi extends StatefulWidget {
  static String id = 'CekAbsensi';
  const CekAbsensi({Key? key}) : super(key: key);

  @override
  State<CekAbsensi> createState() => _CekAbsensiState();
}

class _CekAbsensiState extends State<CekAbsensi> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _showHint = false;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

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
                    itemCount: 18, // number of items in the grid
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width ~/ 180,
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      childAspectRatio: 180 / 180,
                    ),
                    itemBuilder: (BuildContext context, int index) {
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
                              Navigator.of(context).push(
                                  CustomPageRoute(child: CekAbsensi2_Kelas()));
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
                                      'Kelas VII A',
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
                                        '4x absensi',
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
                                        '37 menit',
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
                                        '30 hadirin',
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
                    itemCount: 18, // number of items in the grid
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width ~/ 200,
                      crossAxisSpacing: 4.0,
                      childAspectRatio: 14 / 7,
                    ),
                    itemBuilder: (BuildContext context, int index) {
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
                                    flex: 1,
                                    child: AspectRatio(
                                        aspectRatio: 9 / 16,
                                        child: Image.network(
                                            'https://firebasestorage.googleapis.com/v0/b/e-santren.appspot.com/o/fotoProfilPengurus%2FLINE_ALBUM_Mabok%20daging_230410.jpg?alt=media&token=406e66a1-3802-498f-a49c-d143363f5d5f',
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
                                          'Cak Farrel',
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
                                              'Mukim',
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
                                              Icons.library_add_check_outlined,
                                              color: Colors.grey,
                                              size: 16,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              '4x mengajar',
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
                                              '37 menit',
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
                    break;
                  case "Minggu Ini":
                    keteranganTimeFrame = 'Rekap minggu ini (Sabtu - Jumat)';
                    break;
                  case "Bulan Ini":
                    String bulan =
                        DateFormat('MMMM', 'id_ID').format(DateTime.now());
                    keteranganTimeFrame = 'Rekap bulan $bulan';
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
}
