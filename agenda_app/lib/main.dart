import 'package:flutter/material.dart';
import 'screens/paciente/paciente_list.dart';
import 'screens/profissional/profissional_list.dart';
import 'screens/sala/sala_list.dart';
import 'screens/agendamento/agendamento_list.dart';

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
      _HomeOption("Pacientes", Icons.person, PacienteListScreen()),
      _HomeOption("Profissionais", Icons.medical_services,  ProfissionalList()),
      _HomeOption("Salas", Icons.meeting_room,  SalaList()),
      _HomeOption("Agendamentos", Icons.calendar_month, AgendamentoListPage()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de Agendamentos'),
        centerTitle: true,
      ),
      body: Padding(
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: const Offset(2, 4),
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
    );
  }
}

class _HomeOption {
  final String title;
  final IconData icon;
  final Widget page;

  _HomeOption(this.title, this.icon, this.page);
}
