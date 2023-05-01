import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
