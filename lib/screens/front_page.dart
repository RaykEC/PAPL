import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../services/audio_manager.dart';
import 'prelude_page.dart';

class FrontPage extends StatefulWidget {
  const FrontPage({super.key});
  
  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  late AudioManager audioManager;
  bool _hasAttemptedToPlayAudio = false;
  
  @override
  void initState() {
    super.initState();
    audioManager = Provider.of<AudioManager>(context, listen: false);
    _initializeAudio();
  }
  
  Future<void> _initializeAudio() async {
    print('=== FRONT PAGE AUDIO INITIALIZATION ===');
    
    // Wait a brief moment for the widget tree to fully build
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Always try to play dark ambience when front page loads
    if (audioManager.isInitialized && !_hasAttemptedToPlayAudio) {
      _hasAttemptedToPlayAudio = true;
      
      try {
        print('Starting dark ambience on front page...');
        await audioManager.playDarkAmbience();
        print('Dark ambience started successfully');
      } catch (e) {
        print('Could not start dark ambience: $e');
        // This is fine - might be first visit before user interaction
      }
    } else if (!audioManager.isInitialized) {
      print('AudioManager not initialized, retrying...');
      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted && !_hasAttemptedToPlayAudio) {
        _initializeAudio();
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Stack(
        children: [
          // Background image with title and "Begin Investigation" button already included
          Image.asset(
            'assets/images/front_page.jpg',
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
          
          // Invisible button positioned over the "Begin Investigation" button in the image
          Positioned(
            // Position values should be adjusted to match exact location in your image
            bottom: screenSize.height * 0.08, // Approximately where the button appears
            left: screenSize.width * 0.3,
            right: screenSize.width * 0.3,
            child: InkWell(
              onTap: () async {
                try {
                  // Stop all audio immediately when beginning investigation
                  print('Stopping dark ambience before navigation...');
                  
                  // Use the actual method that exists in AudioManager
                  await audioManager.stopMusic();
                  
                  print('Audio stopped successfully');
                } catch (e) {
                  print('Error stopping audio: $e');
                }
                
                // Reset game state when starting a new game
                if (mounted) {
                  Provider.of<GameState>(context, listen: false).resetGame();
                  
                  // Navigate to next screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PreludePage()),
                  );
                }
              },
              child: Container(
                height: 60, // Height of the button area
                color: Colors.transparent, // Make it invisible
                child: const Center(
                  child: Text(
                    'BEGIN INVESTIGATION',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.transparent, // Invisible text for layout
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Settings and Quit buttons at the top right
          Positioned(
            top: 40,
            right: 20,
            child: Row(
              children: [
                // Audio Settings Button
                ElevatedButton.icon(
                  onPressed: () => _showAudioSettings(context),
                  icon: Icon(
                    audioManager.isMusicEnabled ? Icons.volume_up : Icons.volume_off,
                    size: 20,
                  ),
                  label: const Text('AUDIO'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[800],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
                
                const SizedBox(width: 10),
                
                // Quit Button
                ElevatedButton(
                  onPressed: () => _showQuitDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[900],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text('QUIT'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  void _showAudioSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.blueGrey[900],
              title: const Text(
                'Audio Settings',
                style: TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Music toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Music',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Switch(
                        value: audioManager.isMusicEnabled,
                        onChanged: (value) {
                          setState(() {
                            audioManager.toggleMusic();
                            if (value && !_hasAttemptedToPlayAudio) {
                              audioManager.playDarkAmbience();
                            }
                          });
                        },
                        activeColor: Colors.blue,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Volume slider
                  const Text(
                    'Volume',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Slider(
                    value: audioManager.musicVolume,
                    onChanged: audioManager.isMusicEnabled
                        ? (value) {
                            setState(() {
                              audioManager.setMusicVolume(value);
                            });
                          }
                        : null,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    label: '${(audioManager.musicVolume * 100).round()}%',
                    activeColor: Colors.blue,
                    inactiveColor: Colors.grey,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'CLOSE',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
  
  void _showQuitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[900],
          title: const Text(
            'Quit Game',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Are you sure you want to exit?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Quit',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    ).then((value) {
      if (value == true) {
        // In a real app, you would use SystemNavigator.pop() to exit
        // For web demo purposes, this dialog is sufficient
      }
    });
  }
  
  @override
  void dispose() {
    // Stop audio when leaving the front page
    audioManager.stopMusic();
    super.dispose();
  }
}