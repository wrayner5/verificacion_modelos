
import '../modelos/verificacion.dart';

/// Almacena en un arreglo (List) los resultados de las listas
/// de chequeo y calcula los datos del reporte.
class RepositorioVerificaciones {
  final List<Verificacion> _verificaciones = [];

  /// Copia de solo lectura: las pantallas no modifican el
  /// arreglo directamente, deben usar agregar() y eliminar().
  List<Verificacion> get todas =>
      List.unmodifiable(_verificaciones);

  int get total => _verificaciones.length;

  bool get estaVacio => _verificaciones.isEmpty;

  void agregar(Verificacion verificacion) {
    _verificaciones.add(verificacion);
  }

  void eliminar(int indice) {
    _verificaciones.removeAt(indice);
  }

  int contarPorEstado(EstadoVerificacion estado) {
    return _verificaciones
        .where((v) => v.estado == estado)
        .length;
  }

  /// Promedio del porcentaje de cumplimiento.
  double get promedioGeneral {
    if (_verificaciones.isEmpty) return 0;

    final suma = _verificaciones.fold<double>(
      0,
      (acumulado, v) => acumulado + v.porcentaje,
    );

    return suma / _verificaciones.length;
  }

  /// Estado del conjunto de modelos del proyecto.
  String get estadoGeneral {
    if (_verificaciones.isEmpty) return 'Sin verificaciones';

    if (contarPorEstado(EstadoVerificacion.rechazado) > 0) {
      return 'Requiere correcciones';
    }

    if (contarPorEstado(EstadoVerificacion.conObservaciones) > 0) {
      return 'Aprobado con observaciones';
    }

    return 'Aprobado';
  }
}
