import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadow_of_the_past/screens/loading_screen.dart';
import 'models/game_state.dart';
import 'services/audio_manager.dart';
import 'services/interview_service.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize audio manager
  final audioManager = AudioManager();
  await audioManager.initialize();
  

  final interviewService = InterviewService();
  
  try {
    await interviewService.loadInterviews();
    print(' CSV files loaded successfully');
  } catch (e) { 
    print(' Failed to load CSV files: $e');

  }
    
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GameState()),
        Provider<AudioManager>.value(value: audioManager),
        Provider<InterviewService>.value(value: interviewService),
      ],
      child: const ShadowsOfThePastApp(),
    ),
  );
}

class ShadowsOfThePastApp extends StatelessWidget {
  const ShadowsOfThePastApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Shadows of the Past',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          fontFamily: 'Georgia',
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              fontSize: 36.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            headlineMedium: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            bodyLarge: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
            bodyMedium: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey[800],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        home: const LoadingScreen(),
        debugShowCheckedModeBanner: false,
      );
    }
  }