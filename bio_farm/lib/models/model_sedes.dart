class Sede {
  factory Sede.fromJson(Map<String, dynamic> json) {
    return Sede(json['id_sede'], json['nombre_sede'], json['ubicacion_sede']);
  }
  Sede(this.idSede, this.nombreSede, this.ubicacionSede);
  int idSede;
  String nombreSede;
  String ubicacionSede;
}
