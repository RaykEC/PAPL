import 'game_state.dart';

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
  
  // Get requirement string for display
  String getRequirementString(GameState gameState) {
    if (requiresEvidence == 'will' && !gameState.evidenceList[3]) {
      return " (Need Will evidence)";
    }
    if (requiresEvidence == 'ledger' && !gameState.evidenceList[4]) {
      return " (Need Ledger evidence)";
    }
    if (requiresEvidence == 'will_or_ledger' &&
        !gameState.evidenceList[3] &&
        !gameState.evidenceList[4]) {
      return " (Need Will or Ledger evidence)";
    }
    if (requiresInterview == 'reynolds' && !gameState.reynoldsInterviewComplete) {
      return " (Need to interview Mrs. Reynolds first)";
    }
    return "";
  }
  
  // Get requirement message for snackbar
  String getRequirementMessage() {
    if (requiresEvidence == 'will') {
      return 'You need to find the Modified Will first.';
    } else if (requiresEvidence == 'ledger') {
      return 'You need to find the Business Ledger first.';
    } else if (requiresEvidence == 'will_or_ledger') {
      return 'You need to find the Modified Will or Business Ledger first.';
    } else if (requiresInterview == 'reynolds') {
      return 'You need to interview Mrs. Reynolds first.';
    }
    return 'You need to find more evidence first.';
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