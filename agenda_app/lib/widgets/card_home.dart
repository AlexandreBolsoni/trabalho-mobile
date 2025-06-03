import 'package:flutter/material.dart';

class HomeWidget extends StatelessWidget {
  HomeWidget({Key? key}) : super(key: key);

  final List<Map<String, String>> partnerClinics = [
    {
      'name': 'Clínica Vida',
      'image': 'https://cdn-icons-png.flaticon.com/512/7086/7086529.png'
    },
    {
      'name': 'Clínica Bem-Estar',
      'image': 'https://cdn-icons-png.flaticon.com/512/5405/5405400.png'
    },
    {
      'name': 'Saúde Total',
      'image': 'https://cdn-icons-png.flaticon.com/512/1431/1431236.png'
    },
    {
      'name': 'Clínica Nova Vida',
      'image': 'https://cdn-icons-png.flaticon.com/512/5405/5405432.png'
    },
    {
      'name': 'Clínica Central',
      'image': 'https://cdn-icons-png.flaticon.com/512/2965/2965567.png'
    },
    {
      'name': 'Saúde em Dia',
      'image': 'https://cdn-icons-png.flaticon.com/512/3011/3011270.png'
    },
  ];

  final List<Map<String, dynamic>> reviews = [
    {
      'user': 'João Silva',
      'stars': 5,
      'comment': 'Atendimento excelente e equipe muito simpática!',
      'avatarUrl': 'https://randomuser.me/api/portraits/men/32.jpg'
    },
    {
      'user': 'Maria Oliveira',
      'stars': 4,
      'comment': 'Clínica bem equipada e ambiente confortável.',
      'avatarUrl': 'https://randomuser.me/api/portraits/women/44.jpg'
    },
    {
      'user': 'Carlos Santos',
      'stars': 5,
      'comment': 'Consulta rápida e eficaz, recomendo!',
      'avatarUrl': 'https://randomuser.me/api/portraits/men/75.jpg'
    },
  ];

  Widget buildStars(int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < count ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Clínicas Parceiras',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 130,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: partnerClinics.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final clinic = partnerClinics[index];
                  return Container(
                    width: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4)
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12)),
                            child: Image.network(
                              clinic['image']!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            clinic['name']!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Boas-vindas
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
                ],
              ),
              child: Column(
                children: [
                  Icon(Icons.medical_services, size: 48, color: Colors.blueAccent),
                  const SizedBox(height: 12),
                  Text(
                    'Bem-vindo!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Aqui você encontra clínicas confiáveis e avaliações reais.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Benefícios
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: const [
                    Icon(Icons.schedule, color: Colors.teal),
                    SizedBox(height: 4),
                    Text("Agendamento\nRápido", textAlign: TextAlign.center),
                  ],
                ),
                Column(
                  children: const [
                    Icon(Icons.people, color: Colors.teal),
                    SizedBox(height: 4),
                    Text("Avaliações\nReais", textAlign: TextAlign.center),
                  ],
                ),
                Column(
                  children: const [
                    Icon(Icons.local_hospital, color: Colors.teal),
                    SizedBox(height: 4),
                    Text("Clínicas\nConfiáveis", textAlign: TextAlign.center),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Dica de Saúde
            Card(
              color: Colors.teal.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: Colors.teal),
                        SizedBox(width: 8),
                        Text('Dica de Saúde', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Beber pelo menos 2 litros de água por dia ajuda a manter seu corpo hidratado e saudável.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Avaliações dos Usuários
            Text(
              'Avaliações dos Usuários',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...reviews.map(
              (review) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal.shade100),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(review['avatarUrl']),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review['user'],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            buildStars(review['stars']),
                            const SizedBox(height: 8),
                            Text(
                              review['comment'],
                              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Center(
              child: Text(
                'Precisa de ajuda? Entre em contato com nossa equipe pelo suporte@medagenda.com',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
