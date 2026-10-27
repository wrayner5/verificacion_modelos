
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
  Future<void> _abrirFormulario() async {
    // Espera el resultado que devuelve Navigator.pop del formulario.
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

  Future<void> _confirmarEliminar(int indice) async {
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

    if (confirmar == true) {
      setState(() => widget.repositorio.eliminar(indice));
    }
  }

  @override
  Widget build(BuildContext context) {
    final verificaciones = widget.repositorio.todas;

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
                    'Verificaciones registradas: '
                    '${verificaciones.length}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                ElevatedButton.icon(
                  // Con null el botón queda deshabilitado.
                  onPressed: verificaciones.isEmpty
                      ? null
                      : _abrirReporte,
                  icon: const Icon(Icons.assessment),
                  label: const Text('Generar reporte'),
                ),
              ],
            ),
          ),
          Expanded(
            child: verificaciones.isEmpty
                ? const Center(
                    child: Text('Aún no hay verificaciones.'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 88),
                    itemCount: verificaciones.length,
                    itemBuilder: (context, i) {
                      final v = verificaciones[i];

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
                            onPressed: () => _confirmarEliminar(i),
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

