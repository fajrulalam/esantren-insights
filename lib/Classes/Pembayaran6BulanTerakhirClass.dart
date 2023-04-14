import '../Objects/PembayaranObject_6BulanTerakhir.dart';

class Pembayaran_6BulanTerakhirClass {
  static List<PembayaranObject_6BulanTerakhir> getPembayaran6BulanTerakhir() {
    List<PembayaranObject_6BulanTerakhir> chartData = [
      PembayaranObject_6BulanTerakhir('November', 207, 207),
      PembayaranObject_6BulanTerakhir('Decemr', 207, 207),
      PembayaranObject_6BulanTerakhir('January', 207, 207),
      PembayaranObject_6BulanTerakhir('February', 207, 190),
      PembayaranObject_6BulanTerakhir('March', 207, 176),
      PembayaranObject_6BulanTerakhir('April', 207, 165),
    ];

    return chartData;
  }
}
