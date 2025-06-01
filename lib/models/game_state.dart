import 'package:flutter/foundation.dart';

// Game state management
class GameState extends ChangeNotifier {
  // Basic game state variables
  int evidenceCount = 0;
  List<bool> evidenceList = [false, false, false, false, false, false]; 
  List<bool> locationVisited = [false, false, false, false, false, false]; 
  Map<String, bool> characterInterviewed = {
    'Lady Victoria': false,
    'James': false,
    'Dr. Harlow': false,
    'Mrs. Reynolds': false,
  };
  
  bool reynoldsInterviewComplete = false;
  bool keyFound = false;
  String investigationPhase = 'Initial';
  String currentLocation = '';
  
  // Evidence names for reference
  static const evidenceNames = [
    '', 
    'Heart Medication Bottle',
    'Tea Cup with Residue', 
    'Modified Will Document',
    'Business Ledger',
    'Unusual Tea Canister'
  ];
  
  // Evidence collection methods
  void collectEvidence(int evidenceId) {
    if (evidenceId >= 1 && evidenceId <= 5 && !evidenceList[evidenceId]) {
      evidenceList[evidenceId] = true;
      evidenceCount++;
      notifyListeners();
    }
  }
  
  // Location tracking
  void visitLocation(int locationId) {
    if (locationId >= 1 && locationId <= 5) {
      locationVisited[locationId] = true;
      notifyListeners();
    }
  }
  
  // Character interview tracking
  void interviewCharacter(String character) {
    if (characterInterviewed.containsKey(character)) {
      characterInterviewed[character] = true;
      notifyListeners();
    }
  }
  
  void setInvestigationPhase(String phase) {
    investigationPhase = phase;
    notifyListeners();
  }
  
  void setCurrentLocation(String location) {
    currentLocation = location;
    notifyListeners();
  }
  
  void findKey() {
    keyFound = true;
    notifyListeners();
  }
  
  void completeReynoldsInterview() {
    reynoldsInterviewComplete = true;
    notifyListeners();
  }
  
  // Game state queries
  bool canProceedToFullInvestigation() {
    return evidenceList[1] && evidenceList[2]; // Both initial evidence pieces found
  }
  
  bool canOpenDesk() {
    return keyFound;
  }
  
  bool canAskJamesThirdQuestion() {
    return reynoldsInterviewComplete;
  }
  
  // Determine ending based on evidence count
  String determineEnding() {
    if (evidenceCount >= 5) {
      return 'DrThomasRevealed';
    } else if (evidenceCount >= 2) {
      return 'JamesAccused';
    } else {
      return 'NaturalCauses';
    }
  }
  
  // Get collected evidence list for display
  List<String> getCollectedEvidence() {
    List<String> evidence = [];
    for (int i = 1; i <= 5; i++) {
      if (evidenceList[i]) {
        evidence.add(evidenceNames[i]);
      }
    }
    return evidence;
  }
  
  // Reset game state
  void resetGame() {
    evidenceCount = 0;
    evidenceList = [false, false, false, false, false, false];
    locationVisited = [false, false, false, false, false, false];
    characterInterviewed = {
      'Lady Victoria': false,
      'James': false,
      'Dr. Harlow': false,
      'Mrs. Reynolds': false,
    };
    reynoldsInterviewComplete = false;
    keyFound = false;
    investigationPhase = 'Initial';
    currentLocation = '';
    notifyListeners();
  }
}