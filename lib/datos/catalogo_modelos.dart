
import '../modelos/criterio.dart';
import '../modelos/modelo_analisis.dart';

/// Construye un modelo a partir de un mapa código -> descripción.
ModeloAnalisis _crearModelo(
  String nombre,
  Map<String, String> criterios,
) {
  return ModeloAnalisis(
    nombre: nombre,
    criterios: criterios.entries
        .map((e) => Criterio(codigo: e.key, descripcion: e.value))
        .toList(),
  );
}

/// Devuelve los cuatro modelos de análisis con su lista de chequeo.
/// Cada llamada crea objetos nuevos, con las casillas sin marcar.
List<ModeloAnalisis> crearCatalogo() {
  return [
    _crearModelo('Modelo de casos de uso', {
      'CU-01': 'Los actores están identificados y nombrados',
      'CU-02': 'Los casos de uso inician con verbo en infinitivo',
      'CU-03': 'Cada requisito funcional tiene un caso de uso',
      'CU-04': 'Las relaciones include y extend son correctas',
      'CU-05': 'El límite del sistema está definido',
    }),
    _crearModelo('Modelo de clases', {
      'CL-01': 'Las clases corresponden a entidades del dominio',
      'CL-02': 'Cada atributo tiene tipo de dato',
      'CL-03': 'Los métodos responden a los requisitos',
      'CL-04': 'Las relaciones tienen multiplicidad',
      'CL-05': 'Los nombres de clase están en singular',
    }),
    _crearModelo('Modelo de secuencia', {
      'SE-01': 'Cada diagrama corresponde a un caso de uso',
      'SE-02': 'Los objetos existen en el diagrama de clases',
      'SE-03': 'Los mensajes corresponden a métodos',
      'SE-04': 'Se representan los flujos alternativos',
      'SE-05': 'El orden de mensajes sigue el caso de uso',
    }),
    _crearModelo('Modelo de actividades', {
      'AC-01': 'Tiene nodo inicial y al menos uno final',
      'AC-02': 'Las actividades inician con verbo de acción',
      'AC-03': 'Las decisiones tienen condiciones de guarda',
      'AC-04': 'Los carriles indican el responsable',
      'AC-05': 'El flujo corresponde al proceso requerido',
    }),
  ];
}
