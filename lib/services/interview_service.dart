import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import '../models/game_state.dart';

// Model for interview questions
class InterviewQuestion {
  final String id;
  final String question;
  final String response;
  final String requiresEvidence; // Empty string or evidence id if required
  final String requiresInterview; // Empty string or character name if required

  InterviewQuestion({
    required this.id,
    required this.question,
    required this.response,
    required this.requiresEvidence,
    required this.requiresInterview,
  });

  // Check if this question should be available based on game state
  bool isAvailable(GameState gameState) {
    // Check if required evidence is collected
    if (requiresEvidence.isNotEmpty) {
      if (requiresEvidence == 'will' && !gameState.evidenceList[3]) {
        return false;
      }
      if (requiresEvidence == 'ledger' && !gameState.evidenceList[4]) {
        return false;
      }
      if (requiresEvidence == 'will_or_ledger' &&
          !gameState.evidenceList[3] &&
          !gameState.evidenceList[4]) {
        return false;
      }
    }

    // Check if required interview is completed
    if (requiresInterview.isNotEmpty) {
      if (requiresInterview == 'reynolds' && !gameState.reynoldsInterviewComplete) {
        return false;
      }
    }

    return true;
  }
}

// Model for each character's interview data
class CharacterInterviews {
  final String characterName;
  final List<InterviewQuestion> questions;

  CharacterInterviews({
    required this.characterName,
    required this.questions,
  });
}

// Service to load and manage interviews - CSV ONLY VERSION
class InterviewService {
  // Map of character name to their interviews
  final Map<String, CharacterInterviews> _interviews = {};
  bool _isLoaded = false;
  String? _loadError;

  // Get interviews for a specific character
  CharacterInterviews? getCharacterInterviews(String characterName) {
    return _interviews[characterName];
  }

  // Check if interviews loaded successfully
  bool get isLoaded => _isLoaded;
  String? get loadError => _loadError;

  // Load all interview CSV files
  Future<void> loadInterviews() async {
    print('🔄 Loading interview CSV files...');
    
    try {
      await _loadCharacterInterviews('Lady Victoria', 'assets/csv/lady_victoria_interviews.csv');
      await _loadCharacterInterviews('James', 'assets/csv/james_interviews.csv');
      await _loadCharacterInterviews('Dr. Harlow', 'assets/csv/dr_harlow_interviews.csv');
      await _loadCharacterInterviews('Mrs. Reynolds', 'assets/csv/mrs_reynolds_interview.csv');
      
      _isLoaded = true;
      _loadError = null;
      print('✅ All interview CSV files loaded successfully');
      
      // Print summary
      _interviews.forEach((name, interviews) {
        print('   📋 $name: ${interviews.questions.length} questions');
      });
      
    } catch (e) {
      _isLoaded = false;
      _loadError = e.toString();
      print('❌ Failed to load interview CSV files: $e');
      rethrow; // Re-throw to let main.dart handle the error
    }
  }

  // Load interviews for a specific character from CSV
  Future<void> _loadCharacterInterviews(String characterName, String assetPath) async {
    print('📖 Loading $characterName interviews from $assetPath');
    
    try {
      final String fileContent = await rootBundle.loadString(assetPath);
      
      if (fileContent.trim().isEmpty) {
        throw Exception('CSV file $assetPath is empty');
      }
      
      List<List<dynamic>> csvData = const CsvToListConverter().convert(fileContent);
      
      if (csvData.isEmpty) {
        throw Exception('No data found in CSV file $assetPath');
      }
      
      // Remove header row if it exists
      if (csvData.isNotEmpty) {
        print('   📝 Found ${csvData.length} rows (including header)');
        csvData.removeAt(0); // Remove header
      }

      List<InterviewQuestion> questions = [];

      for (int i = 0; i < csvData.length; i++) {
        var row = csvData[i];
        
        if (row.length < 5) {
          print('   ⚠️  Warning: Row ${i + 2} has only ${row.length} columns, expected 5');
          continue;
        }
        
        questions.add(InterviewQuestion(
          id: row[0].toString().trim(),
          question: row[1].toString().trim(),
          response: row[2].toString().trim(),
          requiresEvidence: row[3].toString().trim(),
          requiresInterview: row[4].toString().trim(),
        ));
      }

      if (questions.isEmpty) {
        throw Exception('No valid questions found in CSV file $assetPath');
      }

      _interviews[characterName] = CharacterInterviews(
        characterName: characterName,
        questions: questions,
      );
      
      print('   ✅ Successfully loaded ${questions.length} questions for $characterName');
      
    } catch (e) {
      print('  Error loading $characterName interviews: $e');
      throw Exception('Failed to load $characterName interviews from $assetPath: $e');
    }
  }

  // Get available questions for a character based on current game state
  List<InterviewQuestion> getAvailableQuestions(String characterName, GameState gameState) {
    final characterInterviews = _interviews[characterName];
    if (characterInterviews == null) {
      print(' No interviews found for character: $characterName');
      return [];
    }

    return characterInterviews.questions
        .where((question) => question.isAvailable(gameState))
        .toList();
  }

  // Get total number of questions for a character
  int getTotalQuestions(String characterName) {
    final characterInterviews = _interviews[characterName];
    return characterInterviews?.questions.length ?? 0;
  }

  // Check if all questions for a character are available
  bool areAllQuestionsAvailable(String characterName, GameState gameState) {
    final totalQuestions = getTotalQuestions(characterName);
    final availableQuestions = getAvailableQuestions(characterName, gameState).length;
    return totalQuestions == availableQuestions;
  }

  // Debug method to print all loaded interviews
  void printLoadedInterviews() {
    print('📊 Loaded Interviews Summary:');
    if (_interviews.isEmpty) {
      print('   No interviews loaded');
      return;
    }
    
    _interviews.forEach((characterName, interviews) {
      print('   👤 $characterName (${interviews.questions.length} questions):');
      for (var question in interviews.questions) {
        String requirements = '';
        if (question.requiresEvidence.isNotEmpty) {
          requirements += ' [Evidence: ${question.requiresEvidence}]';
        }
        if (question.requiresInterview.isNotEmpty) {
          requirements += ' [Interview: ${question.requiresInterview}]';
        }
        print('      • ${question.id}: ${question.question}$requirements');
      }
    });
  }
}