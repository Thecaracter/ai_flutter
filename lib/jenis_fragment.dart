import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';

class JenisFragment extends StatelessWidget {
  const JenisFragment({super.key});

  @override
  Widget build(BuildContext context) {
    // Daftar jenis daging kambing (3 kategori: Segar, Tidak Segar, Busuk)
    final List<Map<String, dynamic>> meatTypes = [
      {
        'name': 'Daging Kambing Segar',
        'description': 'Daging kambing yang masih segar dan berkualitas baik.',
        'characteristics': [
          'Warna merah terang',
          'Tekstur kenyal dan padat',
          'Aroma daging khas tanpa bau menyengat',
          'Permukaan tidak berlendir',
          'Lemak berwarna putih (tidak menguning)',
          'Tidak ada bercak atau perubahan warna',
        ],
        'image': 'assets/images/daging-segar.JPG',
        'color': Colors.green,
      },
      {
        'name': 'Daging Kambing Tidak Segar',
        'description':
            'Daging kambing yang mengalami penurunan kualitas tetapi masih dapat dikonsumsi dengan pengolahan yang tepat.',
        'characteristics': [
          'Warna merah agak pucat atau kecoklatan',
          'Tekstur kurang kenyal',
          'Aroma mulai berubah',
          'Permukaan agak lengket atau sedikit berlendir',
          'Lemak mulai menguning',
          'Mulai ada bercak atau perubahan warna',
        ],
        'image': 'assets/images/daging-tidak-segar.JPG',
        'color': Colors.orange,
      },
      {
        'name': 'Daging Kambing Busuk',
        'description':
            'Daging kambing yang sudah tidak layak konsumsi dan harus dibuang.',
        'characteristics': [
          'Warna gelap, kehijauan, atau kebiru-biruan',
          'Tekstur lembek dan berair',
          'Aroma busuk atau sangat menyengat',
          'Permukaan berlendir yang banyak',
          'Lemak berwarna kuning atau abu-abu',
          'Terdapat bercak putih atau kehijauan (jamur)',
        ],
        'image': 'assets/images/daging-busuk.JPG',
        'color': Colors.red,
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Jenis-Jenis Daging Kambing',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pengenalan berbagai kondisi daging kambing berdasarkan kualitas dan tingkat kesegarannya.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Daftar jenis daging
          ...meatTypes
              .map((type) => _buildMeatTypeCard(context, type))
              .toList(),

          const SizedBox(height: 20),

          // Catatan informasi
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: primaryColor.withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.info_outline, color: primaryColor),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Informasi Penting',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Pendeteksian melalui aplikasi ini hanya sebagai panduan awal. Untuk hasil terbaik, selalu konsultasikan dengan ahli terkait untuk kepastian kualitas daging. Jangan mengonsumsi daging yang teridentifikasi sebagai "Busuk".',
                  style: TextStyle(
                    fontSize: 14,
                    color: secondaryColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeatTypeCard(BuildContext context, Map<String, dynamic> type) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: type['color'],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                type['name'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: secondaryColor,
                ),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            type['description'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Karakteristik:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                ...List.generate(
                  type['characteristics'].length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Text(
                            type['characteristics'][index],
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Gambar
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: type['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: type['color'].withOpacity(0.3),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      type['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image,
                                size: 40,
                                color: type['color'].withOpacity(0.6),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Gambar ${type['name']}',
                                style: TextStyle(
                                  color: type['color'].withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
