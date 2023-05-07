class AsramaObject {
  final String id;
  List<dynamic> pengasuh;
  final int didirikanPada;
  final String lokasiGeografis;
  String namaAsrama;
  String pathFotoAsrama;
  String profilSingkat;
  String jamSelesaiNgaji;
  List<dynamic> program;
  final List<dynamic> kelasNgaji;
  final List<dynamic> listFoto;

  AsramaObject(
      {required this.id,
      required this.pengasuh,
      required this.didirikanPada,
      required this.lokasiGeografis,
      required this.namaAsrama,
      required this.pathFotoAsrama,
      required this.profilSingkat,
      required this.kelasNgaji,
      required this.jamSelesaiNgaji,
      required this.program,
      required this.listFoto});
}
