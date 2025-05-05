import 'package:flutter/material.dart';
import '../widgets/curved_app_bar_painter.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 200,
              child: CustomPaint(painter: CurvedAppBarPainter()),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'NEUROPULSE',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const Center(
            child: Text(
              'Coming Soon',
              style: TextStyle(fontSize: 32, color: Colors.deepPurple),
            ),
          ),
        ],
      ),
    );
  }
}
