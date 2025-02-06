import 'package:count_and_short/play.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background color
          Container(color: const Color(0xFFD8DEFF)),
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          // Pop-up button at top right
          Positioned(
            right: 20,
            top: 20,
            child: IconButton(
              icon: const Icon(Icons.info_outline, size: 30, color: Colors.indigo),
              onPressed: () {
                _showInstructionPopup(context);
              },
            ),
          ),
          // Title and button in the center
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title replaced with image
                Image.asset(
                  'assets/images/logo.png',
                  width: 500,
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Play()),
                    );
                  },
                  child: Image.asset(
                    'assets/images/btn_start.png',
                    width: 300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Pop-up Function with custom width and height
  void _showInstructionPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                const Text(
                  "CARA BERMAIN",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                    fontFamily: 'Baloo',
                  ),
                ),
                const SizedBox(height: 15),
                // Instructions
                const Text(
                  "1. Pemain akan diberikan angka secara acak.\n"
                  "2. Pemain akan mengurutkan angka sesuai dari angka yang diberikan.",
                  style: TextStyle(
                    fontSize: 16, 
                    color: Colors.indigoAccent,
                    fontFamily: 'Baloo',
                    ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Close button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: const Text("Tutup", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BubbleWidget extends StatelessWidget {
  final String image;
  final double size;

  const BubbleWidget({super.key, required this.image, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        image,
        fit: BoxFit.contain,
      ),
    );
  }
}
