import 'package:flutter/material.dart';
import 'screens/paciente/paciente_list.dart';
import 'screens/profissional/profissional_list.dart';
import 'screens/sala/sala_list.dart';
import 'screens/agendamento/agendamento_list.dart';
import 'screens/horario/horario_list.dart'; // <- importe a tela de horários

void main() {
  runApp(const ClinicaApp());
}

class ClinicaApp extends StatelessWidget {
  const ClinicaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clínica App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_HomeOption> options = [
      _HomeOption("Pacientes", Icons.person, const PacienteListScreen()),
      _HomeOption("Profissionais", Icons.medical_services, const ProfissionalList()),
      _HomeOption("Salas", Icons.meeting_room, const SalaList()),
      _HomeOption("Agendamentos", Icons.calendar_month, const AgendamentoListPage()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de Agendamentos'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: options.map((option) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => option.page),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade100,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(2, 4),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(option.icon, size: 48, color: Colors.indigo.shade800),
                          const SizedBox(height: 12),
                          Text(
                            option.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.indigo.shade900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Botão de Horários Disponíveis
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
                icon: const Icon(Icons.access_time, size: 28, color: Colors.white),
                label: const Text(
                  'Horários Disponíveis',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HorarioListScreen()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeOption {
  final String title;
  final IconData icon;
  final Widget page;

  _HomeOption(this.title, this.icon, this.page);
}
