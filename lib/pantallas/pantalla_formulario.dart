
import 'package:flutter/material.dart';

import '../datos/catalogo_modelos.dart';
import '../modelos/modelo_analisis.dart';
import '../modelos/verificacion.dart';

/// Formulario para diligenciar la lista de chequeo de un modelo.
class PantallaFormulario extends StatefulWidget {
  const PantallaFormulario({super.key});

  @override
  State<PantallaFormulario> createState() => _PantallaFormularioState();
}

class _PantallaFormularioState extends State<PantallaFormulario> {
  final _formKey = GlobalKey<FormState>();
  final _verificadorCtrl = TextEditingController();
  final _observacionesCtrl = TextEditingController();

  final List<ModeloAnalisis> _catalogo = crearCatalogo();
  ModeloAnalisis? _modeloSeleccionado;

  @override
  void dispose() {
    _verificadorCtrl.dispose();
    _observacionesCtrl.dispose();
    super.dispose();
  }

  void _guardar() {
    // validate() ejecuta el validador de cada campo del Form.
    if (!_formKey.currentState!.validate()) return;

    final modelo = _modeloSeleccionado!;

    final verificacion = Verificacion(
      modelo: modelo.nombre,
      verificador: _verificadorCtrl.text.trim(),
      observaciones: _observacionesCtrl.text.trim(),
      fecha: DateTime.now(),
      criterios: modelo.criterios.map((c) => c.copiar()).toList(),
    );

    // Cierra el formulario y entrega el resultado.
    Navigator.pop(context, verificacion);
  }

  void _limpiar() {
    _formKey.currentState!.reset();
    _verificadorCtrl.clear();
    _observacionesCtrl.clear();

    setState(() {
      for (final modelo in _catalogo) {
        for (final criterio in modelo.criterios) {
          criterio.cumple = false;
        }
      }
      _modeloSeleccionado = null;
    });
  }

  String? _validarVerificador(String? texto) {
    if (texto == null || texto.trim().length < 3) {
      return 'Escriba un nombre de al menos 3 letras';
    }
    return null;
  }

  String? _validarObservaciones(String? texto) {
    final modelo = _modeloSeleccionado;
    final hayPendientes = modelo != null &&
        modelo.criteriosCumplidos < modelo.criterios.length;

    if (hayPendientes && (texto == null || texto.trim().isEmpty)) {
      return 'Explique qué falta en los criterios no cumplidos';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final modelo = _modeloSeleccionado;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de chequeo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<ModeloAnalisis>(
                initialValue: modelo,
                decoration: const InputDecoration(
                  labelText: 'Modelo a verificar',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final m in _catalogo)
                    DropdownMenuItem(
                      value: m,
                      child: Text(m.nombre),
                    ),
                ],
                onChanged: (m) {
                  setState(() => _modeloSeleccionado = m);
                },
                validator: (m) =>
                    m == null ? 'Seleccione un modelo' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _verificadorCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre del verificador',
                  border: OutlineInputBorder(),
                ),
                validator: _validarVerificador,
              ),
              const SizedBox(height: 16),
              if (modelo == null)
                const Text('Seleccione un modelo para ver los criterios')
              else ...[
                Text(
                  'Criterios cumplidos: '
                  '${modelo.criteriosCumplidos} '
                  'de ${modelo.criterios.length}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                for (final criterio in modelo.criterios)
                  CheckboxListTile(
                    title: Text(criterio.descripcion),
                    subtitle: Text(criterio.codigo),
                    value: criterio.cumple,
                    onChanged: (valor) {
                      setState(() {
                        criterio.cumple = valor ?? false;
                      });
                    },
                  ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: _observacionesCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Observaciones',
                  border: OutlineInputBorder(),
                ),
                validator: _validarObservaciones,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _limpiar,
                      icon: const Icon(Icons.clear),
                      label: const Text('Limpiar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _guardar,
                      icon: const Icon(Icons.save),
                      label: const Text('Guardar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

