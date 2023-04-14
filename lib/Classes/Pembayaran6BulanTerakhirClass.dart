import '../Objects/PembayaranObject_6BulanTerakhir.dart';

class Pembayaran_6BulanTerakhirClass {
  static List<PembayaranObject_6BulanTerakhir> getPembayaran6BulanTerakhir() {
    List<PembayaranObject_6BulanTerakhir> chartData = [
      PembayaranObject_6BulanTerakhir('Nov', 207, 207),
      PembayaranObject_6BulanTerakhir('Dec', 207, 207),
      PembayaranObject_6BulanTerakhir('Jan', 207, 207),
      PembayaranObject_6BulanTerakhir('Feb', 207, 190),
      PembayaranObject_6BulanTerakhir('Mar', 207, 176),
      PembayaranObject_6BulanTerakhir('Apr', 207, 165),
    ];

    return chartData;
  }
}
