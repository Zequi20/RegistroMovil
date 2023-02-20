class Sede {
  factory Sede.fromJson(Map<String, dynamic> json) {
    return Sede(json['id_sede'], json['nombre_sede'], json['ubicacion_sede'],
        json['telefono_sede'], int.parse(json['funcionarios_sede']));
  }
  Sede(this.idSede, this.nombreSede, this.ubicacionSede, this.telefonoSede,
      this.funcionariosSede);
  int idSede;
  String nombreSede;
  String ubicacionSede;
  String telefonoSede;
  int funcionariosSede;
}
