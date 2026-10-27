import 'package:flutter/material.dart';

import '../datos/repositorio_verificaciones.dart';
import '../modelos/verificacion.dart';
import 'estilo_estado.dart';

/// Reporte del estado de los modelos, calculado desde el arreglo.
class PantallaReporte extends StatelessWidget {
  const PantallaReporte({
    super.key,
    required this.repositorio,
  });

  final RepositorioVerificaciones repositorio;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final promedio = repositorio.promedioGeneral;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte de verificación'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumen general',
                    style: textos.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total de verificaciones: ${repositorio.total}',
                  ),
                  Text(
                    'Cumplimiento promedio: '
                    '${promedio.toStringAsFixed(1)} %',
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: promedio / 100,
                    minHeight: 8,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final e in EstadoVerificacion.values)
                        Chip(
                          avatar: Icon(
                            iconoEstado(e),
                            color: colorEstado(e),
                          ),
                          label: Text(
                            '${e.texto}: '
                            '${repositorio.contarPorEstado(e)}',
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Estado general: ${repositorio.estadoGeneral}',
                    style: textos.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Detalle por modelo',
            style: textos.titleLarge,
          ),
          for (final v in repositorio.todas) _DetalleModelo(v),
        ],
      ),
    );
  }
}

/// Tarjeta con el resultado de una verificación.
class _DetalleModelo extends StatelessWidget {
  const _DetalleModelo(this.verificacion);

  final Verificacion verificacion;

  @override
  Widget build(BuildContext context) {
    final v = verificacion;
    final color = colorEstado(v.estado);

    return Card(
      margin: const EdgeInsets.only(top: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    v.modelo,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Icon(
                  iconoEstado(v.estado),
                  color: color,
                ),
                const SizedBox(width: 4),
                Text(
                  v.estado.texto,
                  style: TextStyle(color: color),
                ),
              ],
            ),
            Text(
              'Verificó: ${v.verificador} · ${v.fechaTexto}',
            ),
            Text(
              'Cumplimiento: ${v.criteriosCumplidos}/'
              '${v.totalCriterios} '
              '(${v.porcentaje.toStringAsFixed(0)} %)',
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: v.porcentaje / 100,
              color: color,
            ),
            if (v.pendientes.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text('Criterios no cumplidos:'),
              for (final c in v.pendientes)
                Text('• ${c.codigo}: ${c.descripcion}'),
            ],
            if (v.observaciones.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Observaciones: ${v.observaciones}'),
            ],
          ],
        ),
      ),
    );
  }
}
