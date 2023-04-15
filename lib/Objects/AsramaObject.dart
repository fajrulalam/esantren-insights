class AsramaObject {
  final String id;
  final List<dynamic> pengasuh;
  final int didirikanPada;
  final String lokasiGeografis;
  final String namaAsrama;
  final String pathFotoAsrama;
  final String profilSingkat;
  final List<dynamic> program;
  final List<dynamic> kelasNgaji;

  AsramaObject(
      {required this.id,
      required this.pengasuh,
      required this.didirikanPada,
      required this.lokasiGeografis,
      required this.namaAsrama,
      required this.pathFotoAsrama,
      required this.profilSingkat,
      required this.kelasNgaji,
      required this.program});
}
