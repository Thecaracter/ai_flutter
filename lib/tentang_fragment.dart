import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'bottom_nav_bar.dart';

class TentangFragment extends StatelessWidget {
  const TentangFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo aplikasi
          Center(
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Lottie.asset(
                      'assets/animations/splash.json', // Ganti dengan path Lottie logo Anda
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'AI Deteksi Daging Kambing',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Versi 1.0.0',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Tentang aplikasi
          _buildSection(
            'Tentang Aplikasi',
            'AI Deteksi Daging Kambing adalah aplikasi yang menggunakan teknologi kecerdasan buatan untuk membantu pengguna mengidentifikasi kualitas daging kambing melalui analisis gambar. Aplikasi ini dikembangkan untuk membantu konsumen dalam memilih daging kambing yang berkualitas baik dan aman untuk dikonsumsi.',
          ),

          const SizedBox(height: 20),

          // Cara penggunaan
          _buildSection(
            'Cara Penggunaan',
            '',
            children: [
              _buildNumberedItem(
                1,
                'Buka tab "Deteksi" dan ambil gambar daging kambing menggunakan kamera atau pilih dari galeri.',
              ),
              _buildNumberedItem(
                2,
                'Tunggu beberapa saat sementara AI menganalisis gambar.',
              ),
              _buildNumberedItem(
                3,
                'Lihat hasil analisis yang menunjukkan kualitas daging dan tingkat kepercayaan.',
              ),
              _buildNumberedItem(
                4,
                'Untuk informasi lebih lanjut tentang jenis-jenis daging kambing, kunjungi tab "Jenis".',
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Tim pengembang
          _buildSection(
            'Tim Pengembang',
            'Aplikasi ini dikembangkan oleh tim yang terdiri dari ahli di bidang pengolahan gambar, kecerdasan buatan, dan ilmu pangan untuk membantu masyarakat dalam memilih bahan makanan yang berkualitas.',
          ),

          const SizedBox(height: 20),

          // Kontak
          _buildSection(
            'Kontak',
            '',
            children: [
              _buildContactItem(
                  Icons.email, 'Email', 'support@aideteksidaging.com'),
              _buildContactItem(Icons.phone, 'Telepon', '+62 123 4567 890'),
              _buildContactItem(
                  Icons.language, 'Website', 'www.aideteksidaging.com'),
            ],
          ),

          const SizedBox(height: 30),

          // Tombol sosial media
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSocialButton(Icons.facebook),
                const SizedBox(width: 16),
                _buildSocialButton(Icons.insert_comment), // Twitter/X
                const SizedBox(width: 16),
                _buildSocialButton(Icons.camera_alt), // Instagram
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Footer
          Center(
            child: Text(
              '© 2025 AI Deteksi Daging Kambing. Semua hak dilindungi.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, {List<Widget>? children}) {
    return Container(
      width: double.infinity,
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: secondaryColor,
            ),
          ),
          if (content.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
          if (children != null) ...[
            const SizedBox(height: 10),
            ...children,
          ],
        ],
      ),
    );
  }

  Widget _buildNumberedItem(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: primaryColor),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: secondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: primaryColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}
