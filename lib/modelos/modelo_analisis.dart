
import 'criterio.dart';

/// Un modelo de análisis (diagrama UML) con su lista de chequeo.
class ModeloAnalisis {
  ModeloAnalisis({
    required this.nombre,
    required this.criterios,
  });

  final String nombre;
  final List<Criterio> criterios;

  int get criteriosCumplidos =>
      criterios.where((c) => c.cumple).length;
}

