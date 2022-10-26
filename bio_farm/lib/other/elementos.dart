class Ingreso {
  String concepto;
  double valor;
  double descuento;

  Ingreso(this.concepto, this.valor, this.descuento);

  double getTotal() {
    return valor - (valor * descuento);
  }
}
