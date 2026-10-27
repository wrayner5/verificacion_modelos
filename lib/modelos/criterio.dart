
/// Un criterio de la lista de chequeo de un modelo de análisis.
class Criterio {
  Criterio({
    required this.codigo,
    required this.descripcion,
    this.cumple = false,
  });

  final String codigo;
  final String descripcion;
  bool cumple;

  /// Crea una copia independiente para guardarla en el arreglo.
  Criterio copiar() {
    return Criterio(
      codigo: codigo,
      descripcion: descripcion,
      cumple: cumple,
    );
  }
}

