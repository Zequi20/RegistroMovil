class ModelFuncionarioPagos {
  factory ModelFuncionarioPagos.fromJson(Map<String, dynamic> json) {
    return ModelFuncionarioPagos(
      json['id_funcionario'],
      json['id_sede'],
      json['nombre_Sede'],
      json['nombre_funcionario'],
      json['sueldo_funcionario'],
    );
  }
  ModelFuncionarioPagos(this.idFuncionario, this.idSede, this.nombreSede,
      this.nombreFuncionario, this.sueldoFuncionario);
  int idFuncionario;
  int idSede;
  String nombreSede;
  String nombreFuncionario;
  double sueldoFuncionario;
}
