import 'package:flutter/material.dart';
import '../../services/horario_service.dart';
import '../../models/horario.dart';
import '../../services/agendamento_service.dart'; // Novo import
import '../../models/agendamento.dart'; // Novo import

class PesquisaScreen extends StatefulWidget {
  const PesquisaScreen({super.key});

  @override
  _PesquisaScreenState createState() => _PesquisaScreenState();
}

class _PesquisaScreenState extends State<PesquisaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();

  late Future<List<Horario>> _futureHorarios;
  Future<List<Agendamento>>? _futureAgendamentos; // Nova variável

  @override
  void initState() {
    super.initState();
    _futureHorarios = HorarioService.getHorarios();
  }

  void _fazerPesquisa() {
    if (_formKey.currentState!.validate()) {
      String nome = _nomeController.text.trim();

      setState(() {
        _futureAgendamentos = AgendamentoService.buscarAgendamentosPorNome(nome);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pesquisando por: $nome')),
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: Column(
          children: [
            // Seção de pesquisa
            Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.only(bottom: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Pesquise pelo seu nome',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nomeController,
                          decoration: const InputDecoration(
                            labelText: 'Nome',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.search),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Por favor, insira um nome para pesquisar';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.search,
                          onFieldSubmitted: (_) => _fazerPesquisa(),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _fazerPesquisa,
                            child: const Text('Pesquisar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Seção de resultados da pesquisa (agendamentos)
            if (_futureAgendamentos != null)
              Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.only(bottom: 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.calendar_today, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          'Agendamentos Encontrados',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Veja abaixo os agendamentos para o nome pesquisado.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 16),
                    FutureBuilder<List<Agendamento>>(
                      future: _futureAgendamentos,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Erro ao buscar agendamentos: ${snapshot.error}'),
                          );
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Text('Nenhum agendamento encontrado.');
                        } else {
                          final agendamentos = snapshot.data!;
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: agendamentos.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (context, index) {
                              final ag = agendamentos[index];
                              return ListTile(
                                leading: const Icon(Icons.event_note),
                                title: Text(
                                  '${ag.data ?? 'Data'} - ${ag.hora ?? 'Hora'}',
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (ag.profissional?.nome != null)
                                      Text('Profissional: ${ag.profissional!.nome}'),
                                    if (ag.paciente?.nome != null)
                                      Text('Paciente: ${ag.paciente!.nome}'),
                                    if (ag.sala?.nome != null)
                                      Text('Sala: ${ag.sala!.nome!}'),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

            // Seção de horários disponíveis (inalterada)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.access_time, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Horários Disponíveis',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Aqui você pode ver todos horários disponíveis no momento.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<List<Horario>>(
                    future: _futureHorarios,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Erro ao carregar horários: ${snapshot.error}',
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('Nenhum horário disponível.'),
                        );
                      } else {
                        final horarios = snapshot.data!;
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: horarios.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final horario = horarios[index];
                            return ListTile(
                              leading: const Icon(Icons.event_available),
                              title: Text(horario.data ?? 'Data indisponível'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${horario.horaInicio ?? ''} - ${horario.horaFim ?? ''}',
                                  ),
                                  if (horario.profissional?.nome != null)
                                    Text(
                                      'Profissional: ${horario.profissional!.nome}',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
