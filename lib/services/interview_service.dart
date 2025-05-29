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

// Service to load and manage interviews
class InterviewService {
  // Map of character name to their interviews
  final Map<String, CharacterInterviews> _interviews = {};

  // Get interviews for a specific character
  CharacterInterviews? getCharacterInterviews(String characterName) {
    return _interviews[characterName];
  }

  // Load all interview CSV files
  Future<void> loadInterviews() async {
    await _loadCharacterInterviews('lady_victoria', 'assets/csv/lady_victoria_interviews.csv');
    await _loadCharacterInterviews('james', 'assets/csv/james_interviews.csv');
    await _loadCharacterInterviews('dr_harlow', 'assets/csv/dr_harlow_interviews.csv');
    await _loadCharacterInterviews('mrs_reynolds', 'assets/csv/mrs_reynolds_interviews.csv');
  }

  // Load interviews for a specific character from CSV
  Future<void> _loadCharacterInterviews(String characterName, String assetPath) async {
    try {
      final String fileContent = await rootBundle.loadString(assetPath);
      List<List<dynamic>> csvData = const CsvToListConverter().convert(fileContent);
      
      // Remove header row
      csvData.removeAt(0);

      List<InterviewQuestion> questions = [];

      for (var row in csvData) {
        if (row.length >= 5) {
          questions.add(InterviewQuestion(
            id: row[0].toString(),
            question: row[1].toString(),
            response: row[2].toString(),
            requiresEvidence: row[3].toString(),
            requiresInterview: row[4].toString(),
          ));
        }
      }

      _interviews[characterName] = CharacterInterviews(
        characterName: characterName,
        questions: questions,
      );
    } catch (e) {
      print('Error loading interview data for $characterName: $e');
      
      // Load fallback data if CSV loading fails
      _loadFallbackData(characterName);
    }
  }

  // Fallback interview data for development/testing
  void _loadFallbackData(String characterName) {
    switch (characterName) {
      case 'lady_victoria':
        _interviews[characterName] = CharacterInterviews(
          characterName: characterName,
          questions: [
            InterviewQuestion(
              id: 'business_troubles',
              question: 'Were you aware of your husband\'s recent business difficulties?',
              response: 'William was always discreet about business matters, but yes, I knew something was troubling him. He hadn\'t been sleeping well for days. I suggested he speak with Dr. Harlow about it, but he insisted it would pass once a certain transaction was completed. I fear now it never will.',
              requiresEvidence: '',
              requiresInterview: '',
            ),
            InterviewQuestion(
              id: 'will_changes',
              question: 'What can you tell me about the recent changes to your husband\'s will?',
              response: 'Yes, William informed me of the adjustments. He was concerned about James\'s drinking habits and wanted to ensure the estate would be properly managed. The changes regarding Dr. Harlow were recent—William was concerned about the direction of Thomas\'s research. He said he could no longer justify the expense given our financial situation.',
              requiresEvidence: 'will',
              requiresInterview: '',
            ),
            InterviewQuestion(
              id: 'chamomile_tea',
              question: 'Did you request chamomile tea be prepared for your husband last night?',
              response: 'Yes, I did. William has been so tense lately, I thought it might help him relax. He usually takes his heart medication in the evening, and I know he prefers to have something warm to swallow the pills with rather than plain water. Mrs. Reynolds knows how to prepare it just as he likes.',
              requiresEvidence: '',
              requiresInterview: '',
            ),
          ],
        );
        break;

      case 'james':
        _interviews[characterName] = CharacterInterviews(
          characterName: characterName,
          questions: [
            InterviewQuestion(
              id: 'whereabouts',
              question: 'Where were you during the storm last night?',
              response: 'In my room reading until about eleven. Then I stepped out for a cigarette on the covered terrace. The rain had slightly lessened. I... I may have walked past William\'s study. His door was closed. I heard him coughing inside but didn\'t disturb him.',
              requiresEvidence: '',
              requiresInterview: '',
            ),
            InterviewQuestion(
              id: 'disinheritance',
              question: 'I understand you\'ve recently been removed from your brother\'s will. How did you react to that news?',
              response: 'So you found that, did you? Yes, William decided I wasn\'t worthy of the family legacy. Called me in last week to tell me face to face—at least he granted me that courtesy. I was angry, I won\'t deny it. We argued. But I wouldn\'t kill my own brother over money, Detective.',
              requiresEvidence: 'will',
              requiresInterview: '',
            ),
            InterviewQuestion(
              id: 'study_visit',
              question: 'Did you enter your brother\'s study last night?',
              response: 'The housekeeper told you, did she? Yes, I went to speak with William. I was... intoxicated, I admit. I wanted to appeal to him one last time about the will. We argued, but he was alive when I left, Detective. On my honor, he was alive. He was drinking that blasted tea and sorting through papers. Said he had important work to finish and asked me to leave. That was around midnight.',
              requiresEvidence: '',
              requiresInterview: 'reynolds',
            ),
          ],
        );
        break;

      case 'dr_harlow':
        _interviews[characterName] = CharacterInterviews(
          characterName: characterName,
          questions: [
            InterviewQuestion(
              id: 'heart_condition',
              question: 'Please explain Lord William\'s heart condition and the medication he was taking.',
              response: 'William suffered from arrhythmia—irregular heartbeat—that occasionally developed into more serious episodes. The medication he took daily helps regulate his heart\'s rhythm. I\'ve treated him for over a decade, and while his condition was chronic, it was well-managed with proper care. The medication is digitalis, derived from foxglove. Quite effective, but very particular in its interactions.',
              requiresEvidence: '',
              requiresInterview: '',
            ),
            InterviewQuestion(
              id: 'research_funding',
              question: 'I understand Lord William recently reduced funding for your research. Can you tell me about that?',
              response: 'Yes, unfortunately. William informed me yesterday evening that he could no longer support my research into cardiac-affecting botanical compounds. Years of work, potentially lost due to his financial missteps. A devastating setback professionally, but I understood his position. These things happen in research.',
              requiresEvidence: 'will_or_ledger',
              requiresInterview: '',
            ),
            InterviewQuestion(
              id: 'chamomile_tea',
              question: 'What can you tell me about the chamomile tea William was drinking last night?',
              response: 'Chamomile? I recommended it to help with his stress and insomnia. Perfectly safe, normally. Though, now that you mention it, certain varieties of chamomile can have mild interactions with heart medications if consumed in large quantities. Nothing fatal on its own, certainly. Was he drinking chamomile last night? Interesting.',
              requiresEvidence: '',
              requiresInterview: '',
            ),
          ],
        );
        break;

      case 'mrs_reynolds':
        _interviews[characterName] = CharacterInterviews(
          characterName: characterName,
          questions: [
            InterviewQuestion(
              id: 'finding_body',
              question: 'Walk me through finding Lord William\'s body.',
              response: 'I couldn\'t sleep with the storm, so I thought I\'d check if Lord William needed anything. He often works late into the night. When I approached his study, I noticed the door was slightly ajar, which was unusual—he always closes it when working. I found him on the floor, clutching his chest. I tried to help him, but... it was too late. That\'s when I screamed.',
              requiresEvidence: '',
              requiresInterview: '',
            ),
            InterviewQuestion(
              id: 'tea_preparation',
              question: 'Did you bring Lord William any tea last night? If so, who prepared it?',
              response: 'Yes, I prepared chamomile tea as Lady Victoria suggested—said it might help him sleep better. I prepared it myself using our kitchen supply. Left it on his desk while he was reviewing some papers, around nine o\'clock. The tea was a gift from Dr. Thomas to Lady Victoria. She\'s had it for quite a while and says it tastes wonderful and helps her sleep. Now that I think about it, it was Dr. Thomas who specifically advised me to brew chamomile tea instead of the usual coffee Lord William preferred at night.',
              requiresEvidence: '',
              requiresInterview: '',
            ),
            InterviewQuestion(
              id: 'study_visitors',
              question: 'Did you see anyone enter Lord William\'s study last night?',
              response: 'I... I did see Mr. James enter the study late last night. He\'d been drinking heavily and seemed agitated. I heard raised voices shortly after—they were arguing about the inheritance, I believe. I didn\'t want to eavesdrop, so I continued with my duties. I didn\'t mention it earlier because... well, without any evidence, I feared it would seem like I was accusing Mr. James unfairly.',
              requiresEvidence: '',
              requiresInterview: '',
            ),
          ],
        );
        break;
    }
  }

  // Get available questions for a character based on current game state
  List<InterviewQuestion> getAvailableQuestions(String characterName, GameState gameState) {
    final characterInterviews = _interviews[characterName];
    if (characterInterviews == null) return [];

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
}