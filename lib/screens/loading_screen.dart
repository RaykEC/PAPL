import 'package:flutter/material.dart';
import 'front_page.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _showContinueButton = false;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,  
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _startLoadingSequence();
  }
  
  Future<void> _startLoadingSequence() async {
    _animationController.forward();
    await Future.delayed(const Duration(milliseconds: 3000));
    
    if (mounted) {
      setState(() {
        _showContinueButton = true;
      });
    }
  }
  
  Future<void> _onContinuePressed() async {
    // This click satisfies browser's user interaction requirement
    print('User interaction completed - audio will now be allowed');
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FrontPage()),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: const Text(
                    'UOP PAPL Assignment',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
            
            const SizedBox(height: 50),
            
            if (_showContinueButton)
              AnimatedOpacity(
                opacity: _showContinueButton ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 800),
                child: Column(
                  children: [
                    const Text(
                      'Click to continue',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _onContinuePressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey[800],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('CONTINUE'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}