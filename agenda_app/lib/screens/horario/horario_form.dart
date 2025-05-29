import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../models/horario.dart';
import '../../models/profissional.dart';
import '../../services/horario_service.dart';
import '../../services/profissional_service.dart';

class HorarioFormScreen extends StatefulWidget {
  final Horario? horario;

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
      if (widget.horario?.profissional != null) {
        profissionalSelecionado = profissionais.firstWhere(
          (p) => p.id == widget.horario!.profissional!.id,
          orElse: () => profissionais.first,
        );
      }
    });
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    );
  }

  void _formatarData(String value) {
    String digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length >= 8) {
      String formatada = '${digits.substring(0, 4)}-${digits.substring(4, 6)}-${digits.substring(6, 8)}';
      dataController.value = TextEditingValue(
        text: formatada,
        selection: TextSelection.collapsed(offset: formatada.length),
      );
    }
  }

  void _formatarHora(TextEditingController controller, String value) {
    String digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 4) digits = digits.substring(0, 4);
    String formatada = digits;
    if (digits.length >= 3) {
      formatada = '${digits.substring(0, 2)}:${digits.substring(2)}';
    } else if (digits.length >= 1) {
      formatada = digits;
    }
    controller.value = TextEditingValue(
      text: formatada,
      selection: TextSelection.collapsed(offset: formatada.length),
    );
  }

  void salvar() async {
    if (!_formKey.currentState!.validate() || profissionalSelecionado == null) return;

    final novo = Horario(
      profissional: profissionalSelecionado!,
      data: dataController.text.trim(),
      horaInicio: horaInicioController.text.trim(),
      horaFim: horaFimController.text.trim(),
    );

    if (widget.horario == null) {
      await HorarioService.addHorario(novo);
    } else {
      await HorarioService.updateHorario(
        widget.horario!.profissional!.id,
        novo,
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6EBF1),
      appBar: AppBar(
        title: Text(widget.horario == null ? 'Novo Horário' : 'Editar Horário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<Profissional>(
                value: profissionalSelecionado,
                decoration: _inputDecoration('Profissional'),
                items: profissionais.map((p) {
                  return DropdownMenuItem(value: p, child: Text(p.nome));
                }).toList(),
                onChanged: (p) => setState(() => profissionalSelecionado = p),
                validator: (value) => value == null ? 'Selecione um profissional' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: dataController,
                decoration: _inputDecoration('Data (YYYY-MM-DD)'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: _formatarData,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Informe a data';
                  try {
                    DateFormat('yyyy-MM-dd').parseStrict(v);
                  } catch (_) {
                    return 'Data inválida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: horaInicioController,
                decoration: _inputDecoration('Hora Início (HH:MM)'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (v) => _formatarHora(horaInicioController, v),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Informe a hora de início';
                  if (!RegExp(r'^\d{2}:\d{2}$').hasMatch(v)) return 'Hora inválida';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: horaFimController,
                decoration: _inputDecoration('Hora Fim (HH:MM)'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (v) => _formatarHora(horaFimController, v),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Informe a hora de fim';
                  if (!RegExp(r'^\d{2}:\d{2}$').hasMatch(v)) return 'Hora inválida';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Salvar", style: TextStyle(fontSize: 16)),
                onPressed: salvar,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
