import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CekAbsensi2_Kelas extends StatefulWidget {
  static String id = 'cekabsensi2_kelas';
  const CekAbsensi2_Kelas({Key? key}) : super(key: key);

  @override
  State<CekAbsensi2_Kelas> createState() => _CekAbsensi2_KelasState();
}

class _CekAbsensi2_KelasState extends State<CekAbsensi2_Kelas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Absensi Kelas VII A'),
        leading: BackButton(
          color: Colors.grey,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(itemBuilder: (context, index) {
              return Container(
                child: Card(
                    child: InkWell(
                  onTap: () {
                    //show modal bottom sheet here
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return Container(
                              height: MediaQuery.of(context).size.height * 0.9,
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  //title text
                                  Container(
                                    height: 50,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.arrow_left,
                                              color: Colors.grey,
                                              size: 24,
                                            )),
                                        Center(
                                          child: Text(
                                            'Rabu, 03 Mei 2023',
                                            style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.arrow_right,
                                              color: Colors.grey,
                                              size: 24,
                                            )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.65,
                                    ),
                                    child: Image.network(
                                      'https://firebasestorage.googleapis.com/v0/b/e-santren.appspot.com/o/fotoAbsenNgaji%2F2023%2FVII%20A%2Fscaled_a7a7fefe-6641-4265-9f80-880ca264d2992918831928340895541.jpg?alt=media&token=9c136970-381a-4feb-90bf-070b9a21a324',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        // padding: EdgeInsets.only(right: 36),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Hadir',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.green),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              '16',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.green),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        // padding: EdgeInsets.only(right: 36),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Sakit/Izin',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.orange),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              '16',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.orange),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        // padding: EdgeInsets.only(right: 36),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Alfa',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.redAccent),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              '16',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.redAccent),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //       bottom: 8.0, left: 16),
                                  //   child: Row(
                                  //     children: [
                                  //       Text('Daftar Hadir',
                                  //           textAlign: TextAlign.left,
                                  //           style: GoogleFonts.notoSans(
                                  //               fontSize: 16,
                                  //               fontWeight: FontWeight.w600,
                                  //               color: Colors.black)),
                                  //     ],
                                  //   ),
                                  // ),
                                  DottedBorder(
                                    color: Colors.grey,
                                    strokeWidth: 1,
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.4,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: 16,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            padding: EdgeInsets.only(bottom: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    '1',
                                                    textAlign: TextAlign.right,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Container(
                                                  child: Text(
                                                    'Rizky Maulana',
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Container(
                                                  child: Text(
                                                    'Hadir',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.green),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ));
                        });
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                        child: Row(
                          children: [
                            Text(
                              'Rabu, 3 Mei 2023',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600),
                            ),
                            Spacer(),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '16',
                                    style: GoogleFonts.poppins(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '/17',
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding:
                            EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person,
                                    size: 12, color: Colors.grey),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  'Cak Farrel',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Icon(
                                  Icons.timelapse_outlined,
                                  size: 12,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  '37 menit',
                                  style: GoogleFonts.poppins(
                                      fontSize: 12, color: Colors.grey),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
              );
            }),
          ),
        ],
      ),
    );
  }
}
