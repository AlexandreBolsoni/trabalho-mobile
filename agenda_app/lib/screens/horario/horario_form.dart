import 'package:flutter/material.dart';
import '../../models/horario_disponivel.dart';
import '../../models/profissional.dart';
import '../../services/horario_service.dart';
import '../../services/profissional_service.dart'; // Supondo que exista

class HorarioFormScreen extends StatefulWidget {
  final HorarioDisponivel? horario;

  const HorarioFormScreen({super.key, this.horario});

  @override
  _HorarioFormScreenState createState() => _HorarioFormScreenState();
}

class _HorarioFormScreenState extends State<HorarioFormScreen> {
  final _formKey = GlobalKey<FormState>();

  List<Profissional> profissionais = [];
  Profissional? profissionalSelecionado;

  late TextEditingController dataController;
  late TextEditingController horaInicioController;
  late TextEditingController horaFimController;

  @override
  void initState() {
    super.initState();
    dataController = TextEditingController(text: widget.horario?.data ?? '');
    horaInicioController = TextEditingController(text: widget.horario?.horaInicio ?? '');
    horaFimController = TextEditingController(text: widget.horario?.horaFim ?? '');
    profissionalSelecionado = widget.horario?.profissional;
    carregarProfissionais();
  }

  void carregarProfissionais() async {
    final lista = await ProfissionalService.getProfissionais();
    setState(() {
      profissionais = lista;
      // Garante que o profissional ainda exista
      if (widget.horario?.profissional != null) {
        profissionalSelecionado = profissionais.firstWhere(
          (p) => p.id == widget.horario!.profissional!.id,
          orElse: () => profissionais.first,
        );
      }
    });
  }

  void salvar() async {
    if (_formKey.currentState!.validate() && profissionalSelecionado != null) {
      final novo = HorarioDisponivel(
        profissional: profissionalSelecionado!,
        data: dataController.text,
        horaInicio: horaInicioController.text,
        horaFim: horaFimController.text,
      );

      if (widget.horario == null) {
        await HorarioService.addHorario(novo);
      } else {
        await HorarioService.updateHorario(widget.horario!.profissional!.id!, novo);
      }

      Navigator.pop(context);
    }
  }

  InputDecoration customInput(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6EBF1),
      appBar: AppBar(
        title: Text(widget.horario == null ? 'Novo Horário' : 'Editar Horário'),
        backgroundColor: const Color(0xFF114B5F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<Profissional>(
                value: profissionalSelecionado,
                decoration: customInput('Profissional'),
                items: profissionais.map((p) {
                  return DropdownMenuItem(
                    value: p,
                    child: Text(p.nome),
                  );
                }).toList(),
                onChanged: (p) => setState(() => profissionalSelecionado = p),
                validator: (value) => value == null ? 'Selecione um profissional' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: dataController,
                decoration: customInput('Data (YYYY-MM-DD)'),
                validator: (v) => v!.isEmpty ? 'Informe a data' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: horaInicioController,
                decoration: customInput('Hora Início (HH:MM)'),
                validator: (v) => v!.isEmpty ? 'Informe a hora de início' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: horaFimController,
                decoration: customInput('Hora Fim (HH:MM)'),
                validator: (v) => v!.isEmpty ? 'Informe a hora de fim' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF028090)),
                onPressed: salvar,
                child: const Text("Salvar", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
