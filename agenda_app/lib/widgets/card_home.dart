import 'package:flutter/material.dart';

class HomeWidget extends StatelessWidget {
  HomeWidget({Key? key}) : super(key: key);

final List<Map<String, String>> partnerClinics = [
  {
    'name': 'Clínica Vida',
    'image': 'https://cdn-icons-png.flaticon.com/512/1040/1040238.png', // ícone de médico
  },
  {
    'name': 'Clínica Bem-Estar',
    'image': 'https://cdn-icons-png.flaticon.com/512/5405/5405400.png', // coração com cruz
  },
  {
    'name': 'Saúde Total',
    'image': 'https://cdn-icons-png.flaticon.com/512/1431/1431236.png', // hospital
  },
  {
    'name': 'Clínica Nova Vida',
    'image': 'https://cdn-icons-png.flaticon.com/512/5405/5405432.png', // cruz médica
  },
];



  final List<Map<String, dynamic>> reviews = [
    {
      'user': 'João Silva',
      'stars': 5,
      'comment': 'Atendimento excelente e equipe muito simpática!',
      'avatarUrl': 'https://randomuser.me/api/portraits/men/32.jpg',
    },
    {
      'user': 'Maria Oliveira',
      'stars': 4,
      'comment': 'Clínica bem equipada e ambiente confortável.',
      'avatarUrl': 'https://randomuser.me/api/portraits/women/44.jpg',
    },
    {
      'user': 'Carlos Santos',
      'stars': 5,
      'comment': 'Consulta rápida e eficaz, recomendo!',
      'avatarUrl': 'https://randomuser.me/api/portraits/men/75.jpg',
    },
  ];

  Widget buildStars(int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < count) {
          return Icon(Icons.star, color: Colors.amber, size: 18);
        } else {
          return Icon(Icons.star_border, color: Colors.amber, size: 18);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Clínicas Parceiras',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: partnerClinics.length,
              separatorBuilder: (_, __) => SizedBox(width: 12),
              itemBuilder: (context, index) {
                final clinic = partnerClinics[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Image.network(
                            clinic['image']!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            clinic['name']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Avaliações dos Usuários',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          ...reviews.map((review) {
            return Card(
              margin: EdgeInsets.only(bottom: 12),
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(review['avatarUrl']),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review['user'],
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 4),
                          buildStars(review['stars']),
                          SizedBox(height: 8),
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
            );
          }).toList(),
        ],
      ),
    );
  }
}
