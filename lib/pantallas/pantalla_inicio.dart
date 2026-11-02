
import 'package:flutter/material.dart';

import '../datos/repositorio_verificaciones.dart';
import '../modelos/verificacion.dart';
import 'estilo_estado.dart';
import 'pantalla_formulario.dart';
import 'pantalla_reporte.dart';

/// Pantalla principal: lista las verificaciones del arreglo.
class PantallaInicio extends StatefulWidget {
  const PantallaInicio({
    super.key,
    required this.repositorio,
  });

  final RepositorioVerificaciones repositorio;

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  EstadoVerificacion? _filtroEstado;

  Future<void> _abrirFormulario() async {
    final nueva = await Navigator.push<Verificacion>(
      context,
      MaterialPageRoute(
        builder: (_) => const PantallaFormulario(),
      ),
    );

    if (nueva == null || !mounted) return;

    setState(() => widget.repositorio.agregar(nueva));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Se guardó: ${nueva.modelo}')),
    );
  }

  void _abrirReporte() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PantallaReporte(
          repositorio: widget.repositorio,
        ),
      ),
    );
  }

  Future<void> _confirmarEliminar(int indiceOriginal) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar verificación'),
        content: const Text('¿Desea eliminar este registro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      setState(() {
        widget.repositorio.eliminar(indiceOriginal);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final todas = widget.repositorio.todas;

    // Guardamos los índices originales para eliminar el registro correcto
    // incluso cuando la lista está filtrada.
    final indicesVisibles = <int>[];

    for (var i = 0; i < todas.length; i++) {
      if (_filtroEstado == null ||
          todas[i].estado == _filtroEstado) {
        indicesVisibles.add(i);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificación de modelos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Verificaciones registradas: ${todas.length}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: todas.isEmpty ? null : _abrirReporte,
                  icon: const Icon(Icons.assessment),
                  label: const Text('Generar reporte'),
                ),
              ],
            ),
          ),

          // Mejora propia solicitada en la Parte 2 del instructivo:
          // filtrar las verificaciones por estado.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField<EstadoVerificacion?>(
              initialValue: _filtroEstado,
              decoration: const InputDecoration(
                labelText: 'Filtrar por estado',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<EstadoVerificacion?>(
                  value: null,
                  child: Text('Todos los estados'),
                ),
                ...EstadoVerificacion.values.map(
                  (estado) => DropdownMenuItem<EstadoVerificacion?>(
                    value: estado,
                    child: Text(estado.texto),
                  ),
                ),
              ],
              onChanged: (estado) {
                setState(() => _filtroEstado = estado);
              },
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: todas.isEmpty
                ? const Center(
                    child: Text('Aún no hay verificaciones.'),
                  )
                : indicesVisibles.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay verificaciones para este estado.',
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 88),
                        itemCount: indicesVisibles.length,
                        itemBuilder: (context, i) {
                          final indiceOriginal = indicesVisibles[i];
                          final v = todas[indiceOriginal];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: ListTile(
                              leading: Icon(
                                iconoEstado(v.estado),
                                color: colorEstado(v.estado),
                              ),
                              title: Text(v.modelo),
                              subtitle: Text(
                                '${v.porcentaje.toStringAsFixed(0)} % · '
                                '${v.estado.texto}\n'
                                'Verificó: ${v.verificador}',
                              ),
                              isThreeLine: true,
                              trailing: IconButton(
                                tooltip: 'Eliminar',
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () =>
                                    _confirmarEliminar(indiceOriginal),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirFormulario,
        icon: const Icon(Icons.add),
        label: const Text('Nueva verificación'),
      ),
    );
  }
}
