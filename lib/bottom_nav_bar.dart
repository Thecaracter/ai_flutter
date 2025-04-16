import 'package:flutter/material.dart';
import 'deteksi_fragment.dart';
import 'jenis_fragment.dart';
import 'tentang_fragment.dart';

// Palette warna utama yang lebih vibrant
const Color primaryColor = Color(0xFFE48C97); // Vibrant pink
const Color secondaryColor = Color(0xFFF7B6C2); // Medium pink
const Color accentColor = Colors.white; // White
const Color textColor = Color(0xFF333333); // Darker text for better contrast

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _fragments = [
    const DeteksiFragment(),
    const JenisFragment(),
    const TentangFragment(),
  ];

  final List<String> _titles = ['Deteksi', 'Jenis', 'Tentang'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: textColor,
      ),
      body: Container(
        color: secondaryColor
            .withOpacity(0.2), // Background with some transparency
        child: _fragments[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt_outlined),
              activeIcon: Icon(Icons.camera_alt),
              label: 'Deteksi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              activeIcon: Icon(Icons.category),
              label: 'Jenis',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info_outline),
              activeIcon: Icon(Icons.info),
              label: 'Tentang',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor:
              Color(0xFFD64D5C), // Vibrant dark pink for better visibility
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          showUnselectedLabels: true,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

// CustomPainter untuk gambar kambing
class GoatPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint mainColor = Paint()
      ..color = const Color(0xFFE48C97) // Vibrant pink
      ..style = PaintingStyle.fill;

    final Paint secondaryColor = Paint()
      ..color =
          const Color(0xFFD64D5C) // Darker vibrant pink for better contrast
      ..style = PaintingStyle.fill;

    final Paint outlinePaint = Paint()
      ..color = const Color(0xFFC13A49) // Strong outline color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Kepala kambing
    final Path headPath = Path()
      ..moveTo(centerX - 30, centerY)
      ..quadraticBezierTo(
          centerX - 40, centerY + 20, centerX - 30, centerY + 40)
      ..quadraticBezierTo(centerX, centerY + 55, centerX + 30, centerY + 40)
      ..quadraticBezierTo(centerX + 40, centerY + 20, centerX + 30, centerY)
      ..quadraticBezierTo(centerX + 15, centerY - 15, centerX, centerY - 20)
      ..quadraticBezierTo(centerX - 15, centerY - 15, centerX - 30, centerY);

    canvas.drawPath(headPath, mainColor);
    canvas.drawPath(headPath, outlinePaint);

    // Tanduk kiri
    final Path leftHornPath = Path()
      ..moveTo(centerX - 25, centerY - 5)
      ..quadraticBezierTo(
          centerX - 40, centerY - 25, centerX - 30, centerY - 45)
      ..quadraticBezierTo(
          centerX - 28, centerY - 25, centerX - 20, centerY - 10);

    canvas.drawPath(leftHornPath, secondaryColor);
    canvas.drawPath(leftHornPath, outlinePaint);

    // Tanduk kanan
    final Path rightHornPath = Path()
      ..moveTo(centerX + 25, centerY - 5)
      ..quadraticBezierTo(
          centerX + 40, centerY - 25, centerX + 30, centerY - 45)
      ..quadraticBezierTo(
          centerX + 28, centerY - 25, centerX + 20, centerY - 10);

    canvas.drawPath(rightHornPath, secondaryColor);
    canvas.drawPath(rightHornPath, outlinePaint);

    // Mata kiri
    canvas.drawCircle(
      Offset(centerX - 15, centerY + 10),
      5,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      Offset(centerX - 15, centerY + 10),
      3,
      Paint()..color = const Color(0xFFD64D5C), // Darker vibrant pink
    );

    // Mata kanan
    canvas.drawCircle(
      Offset(centerX + 15, centerY + 10),
      5,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      Offset(centerX + 15, centerY + 10),
      3,
      Paint()..color = const Color(0xFFD64D5C), // Darker vibrant pink
    );

    // Hidung dan mulut
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, centerY + 30),
          width: 25,
          height: 15,
        ),
        const Radius.circular(7.5),
      ),
      Paint()..color = const Color(0xFFD64D5C), // Darker vibrant pink
    );

    // Garis mulut
    canvas.drawLine(
      Offset(centerX, centerY + 30),
      Offset(centerX, centerY + 38),
      Paint()
        ..color = const Color(0xFFD64D5C) // Darker vibrant pink
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
