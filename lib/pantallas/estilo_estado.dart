import 'package:flutter/material.dart';
import '../modelos/verificacion.dart';

/// Color que representa cada estado en la interfaz.
Color colorEstado(EstadoVerificacion estado) {
  switch (estado) {
    case EstadoVerificacion.aprobado:
      return Colors.green;
    case EstadoVerificacion.conObservaciones:
      return Colors.orange;
    case EstadoVerificacion.rechazado:
      return Colors.red;
  }
}

/// Icono que representa cada estado en la interfaz.
IconData iconoEstado(EstadoVerificacion estado) {
  switch (estado) {
    case EstadoVerificacion.aprobado:
      return Icons.check_circle;
    case EstadoVerificacion.conObservaciones:
      return Icons.warning_amber;
    case EstadoVerificacion.rechazado:
      return Icons.cancel;
  }
}
