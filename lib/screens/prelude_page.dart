import 'package:flutter/material.dart';
import '../widgets/game_top_bar.dart';
import 'discovery_scene.dart';

class PreludePage extends StatefulWidget {
  const PreludePage({super.key});
  
  @override
  State<PreludePage> createState() => _PreludePageState();
}

class _PreludePageState extends State<PreludePage> {
  bool _showContinueButton = false;
  
  @override
  void initState() {
    super.initState();
    // Show continue button after a delay to let user read
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showContinueButton = true;
        });
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/images/manor_night.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blueGrey[900]!,
                      Colors.black,
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Top bar
          const GameTopBar(
            locationName: 'Thornfield Manor',
            showEvidence: false,
            showWeather: false,
          ),
          
          // Main content
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            bottom: 100,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: const SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'The Journey to Thornfield Manor',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    
                    SizedBox(height: 24),
                    
                    Text(
                      'Rain patters against the windows of Lord William Thornfield\'s manor as you settle into a chair by the fire, nursing a glass of brandy. The dinner had been splendid—a welcome respite from your journey—but you couldn\'t help but notice the tension that hung over the dining room like a shroud.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        height: 1.6,
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    Text(
                      'William, your old friend, had been gracious but distracted, his conversation faltering between anecdotes about your shared youth and long silences filled only by the clink of silverware against fine china. The other household members—Lady Victoria, James, and Dr. Harlow—had maintained polite conversation, but their words seemed carefully measured.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        height: 1.6,
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    Text(
                      '"I\'m terribly sorry I can\'t catch up properly, Edward," William had said as dinner concluded, his hand on your shoulder feeling thinner than you remembered. "These business matters... they demand my attention even at this hour. Perhaps tomorrow we can reminisce properly."',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        height: 1.6,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    Text(
                      'Mrs. Reynolds, the housekeeper, had shown you to your guest room—comfortable but drafty, with windows that rattled as the approaching storm gathered strength. You had fallen asleep to the distant rumble of thunder, grateful for the bed after days of travel.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        height: 1.6,
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    Text(
                      'Now, in the dead of night, a piercing scream tears through your dreams, jolting you awake. Your detective instincts immediately take over as you throw on your dressing gown and rush toward the source of the disturbance...',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        height: 1.6,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Continue button
          if (_showContinueButton)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const DiscoveryScene()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[800],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('CONTINUE'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}