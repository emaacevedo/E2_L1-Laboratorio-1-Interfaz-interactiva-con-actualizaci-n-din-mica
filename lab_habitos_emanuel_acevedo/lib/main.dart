import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 2 - Hábitos',
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
      ),
      home: const PanelHabitos(),
    );
  }
}

class PanelHabitos extends StatefulWidget {
  const PanelHabitos({super.key});

  @override
  State<PanelHabitos> createState() => _PanelHabitosState();
}

class _PanelHabitosState extends State<PanelHabitos> {
  // Datos fijos
  final List<String> _habitos = const [
    'Beber 2 L de agua',
    'Leer 20 minutos',
    'Caminar 30 minutos',
    'Estudiar Flutter',
    'Dormir 8 horas',
  ];

  // Estado
  late List<bool> _cumplidos;
  int _meta = 3;
  bool _enfoque = false;
  String _nota = '';

  final TextEditingController _notaCtrl = TextEditingController();

  static const int _metaInicial = 3;

  @override
  void initState() {
    super.initState();

    _cumplidos = List<bool>.filled(
      _habitos.length,
      false,
    );
  }

  @override
  void dispose() {
    _notaCtrl.dispose();
    super.dispose();
  }

  // Getters derivados

  int get _totalCumplidos {
    return _cumplidos.where((cumplido) => cumplido).length;
  }

  double get _progreso {
    if (_habitos.isEmpty) {
      return 0;
    }

    return _totalCumplidos / _habitos.length;
  }

  bool get _metaAlcanzada {
    return _totalCumplidos >= _meta;
  }

  String get _mensaje {
    final porcentaje = (_progreso * 100).round();

    if (porcentaje == 0) {
      return '¡Empecemos!';
    }

    if (porcentaje < 50) {
      return 'Buen inicio';
    }

    if (porcentaje < 100) {
      return '¡Vas muy bien!';
    }

    return '¡Día completado! 🎉';
  }

  // Acciones

  void _alternarHabito(int index) {
    setState(() {
      _cumplidos[index] = !_cumplidos[index];
    });
  }

  void _cambiarMeta(double valor) {
    setState(() {
      _meta = valor.round();
    });
  }

  void _alternarEnfoque(bool valor) {
    setState(() {
      _enfoque = valor;
    });
  }

  void _guardarNota() {
    setState(() {
      _nota = _notaCtrl.text.trim();
    });
  }

  void _reiniciarDia() {
    setState(() {
      _cumplidos = List<bool>.filled(
        _habitos.length,
        false,
      );

      _meta = _metaInicial;
      _enfoque = false;
      _nota = '';
      _notaCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final porcentaje = (_progreso * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hábitos — Cumplidos: $_totalCumplidos / ${_habitos.length}',
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // PROGRESO
          const Text(
            'Progreso del día',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          LinearProgressIndicator(
            value: _progreso,
            minHeight: 12,
          ),

          const SizedBox(height: 8),

          Text(
            '$porcentaje%',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            _mensaje,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 25),

          // META DEL DÍA
          const Text(
            'Meta del día',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          Slider(
            value: _meta.toDouble(),
            min: 1,
            max: _habitos.length.toDouble(),
            divisions: _habitos.length - 1,
            label: _meta.toString(),
            onChanged: _cambiarMeta,
          ),

          Text(
            'Meta: $_meta hábitos',
            textAlign: TextAlign.center,
          ),

          if (_metaAlcanzada)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  '🎯 Meta alcanzada',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 15),

          // MODO ENFOQUE
          SwitchListTile(
            title: const Text('Modo enfoque'),
            subtitle: const Text(
              'Ocultar hábitos ya cumplidos',
            ),
            value: _enfoque,
            onChanged: _alternarEnfoque,
          ),

          const Divider(),

          // LISTA DE HÁBITOS
          const Text(
            'Hábitos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          ...List.generate(
            _habitos.length,
            (index) {
              if (_enfoque && _cumplidos[index]) {
                return const SizedBox.shrink();
              }

              return CheckboxListTile(
                title: Text(_habitos[index]),
                value: _cumplidos[index],
                onChanged: (_) {
                  _alternarHabito(index);
                },
              );
            },
          ),

          const Divider(),

          const SizedBox(height: 10),

          // NOTA DEL DÍA
          const Text(
            'Nota del día',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          TextField(
            controller: _notaCtrl,
            decoration: const InputDecoration(
              labelText: 'Escribe una nota',
              hintText: 'Ejemplo: Día productivo',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) {
              _guardarNota();
            },
          ),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: _guardarNota,
            child: const Text('Guardar nota'),
          ),

          const SizedBox(height: 10),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _nota.isEmpty ? 'Sin nota' : _nota,
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // REINICIAR
          ElevatedButton.icon(
            onPressed: _reiniciarDia,
            icon: const Icon(Icons.refresh),
            label: const Text('Reiniciar día'),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}