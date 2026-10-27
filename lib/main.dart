
import 'package:flutter/material.dart';

import 'datos/repositorio_verificaciones.dart';
import 'pantallas/pantalla_inicio.dart';

void main() {
  runApp(
    VerificacionApp(
      repositorio: RepositorioVerificaciones(),
    ),
  );
}

class VerificacionApp extends StatelessWidget {
  const VerificacionApp({
    super.key,
    required this.repositorio,
  });

  final RepositorioVerificaciones repositorio;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verificación de modelos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
      ),
      home: PantallaInicio(
        repositorio: repositorio,
      ),
    );
  }
}
