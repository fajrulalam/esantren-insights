class CurrentUserObject {
  String? uid;
  String? namaLengkap;
  String? namaPanggilan;
  String? honoraryName;
  String? kodeAsrama;
  String? jenisKelamin;
  String? kotaAsal;
  String? tglLahir;
  String? role;
  String? fotoProfil;
  bool? mukim;
  List<dynamic>? mengajarKelas;

  CurrentUserObject(
      {this.uid,
        this.fotoProfil,
        this.namaLengkap,
        this.kodeAsrama,
        this.honoraryName,
        this.namaPanggilan,
        this.jenisKelamin,
        this.kotaAsal,
        this.tglLahir,
        this.mukim,
        this.role,
        this.mengajarKelas});
}
