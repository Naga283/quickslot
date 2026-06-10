import 'package:flutter/material.dart';

class PlaceholderView extends StatelessWidget {
  const PlaceholderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo/Icon Card
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(25), // 0.1 opacity
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withAlpha(38), // 0.15 opacity
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(51), // 0.2 opacity
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.schedule_rounded,
                      size: 80,
                      color: Color(0xFF00FFCC),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // App Title
                  const Text(
                    'QuickSlot',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Subtitle
                  Text(
                    'Clean Architecture & Riverpod Template',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withAlpha(178), // 0.7 opacity
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Status Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildBadge('Riverpod', true),
                      const SizedBox(width: 8),
                      _buildBadge('GoRouter', true),
                      const SizedBox(width: 8),
                      _buildBadge('Dio', true),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Instruction Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(76), // 0.3 opacity
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withAlpha(13), // 0.05 opacity
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Foundation is ready!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withAlpha(229), // 0.9 opacity
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Modify features under lib/features/ and write business models to run build_runner code generation.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withAlpha(127), // 0.5 opacity
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFF00FFCC).withAlpha(38) // 0.15 opacity
            : Colors.white.withAlpha(25), // 0.1 opacity
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: active ? const Color(0xFF00FFCC) : Colors.white24,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? const Color(0xFF00FFCC) : Colors.white70,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
