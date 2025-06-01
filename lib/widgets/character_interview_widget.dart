import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game_state.dart';
import '../../services/interview_service.dart';

// Generic character interview widget that uses ONLY CSV data
class CharacterInterviewWidget extends StatelessWidget {
  final String characterKey; // Key used for interview service lookup
  final String characterDisplayName; // Display name for UI
  final String characterImagePath;
  final String characterIntro;
  final VoidCallback onInterviewComplete;

  const CharacterInterviewWidget({
    super.key,
    required this.characterKey,
    required this.characterDisplayName,
    required this.characterImagePath,
    required this.characterIntro,
    required this.onInterviewComplete,
  });

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final interviewService = Provider.of<InterviewService>(context, listen: false);

    // Check if this is a repeat interview
    final bool isRepeatInterview = gameState.characterInterviewed[characterKey] ?? false;

    // Check if CSV files loaded successfully
    if (!interviewService.isLoaded) {
      return _buildErrorDialog(context, 
        'CSV Files Not Loaded',
        'Interview data could not be loaded from CSV files.\n\nError: ${interviewService.loadError ?? "Unknown error"}\n\nPlease check that all CSV files are present and properly formatted.'
      );
    }

    // Get character interview data
    final characterInterviews = interviewService.getCharacterInterviews(characterKey);
    
    if (characterInterviews == null) {
      return _buildErrorDialog(context,
        'Character Data Not Found',
        'No interview data found for $characterDisplayName.\n\nPlease check that the CSV file for this character exists and is properly formatted.'
      );
    }

    if (characterInterviews.questions.isEmpty) {
      return _buildErrorDialog(context,
        'No Interview Questions',
        'No valid interview questions found for $characterDisplayName.\n\nPlease check the CSV file format and content.'
      );
    }

    // Mark character as interviewed in game state
    gameState.interviewCharacter(characterKey);

    // Special case for Mrs. Reynolds to unlock James's third question
    if (characterKey == 'Mrs. Reynolds') {
      gameState.completeReynoldsInterview();
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Colors.blueGrey[900],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.blueGrey.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueGrey[800],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isRepeatInterview 
                          ? 'Re-interviewing $characterDisplayName'
                          : 'Interview with $characterDisplayName',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Repeat interview indicator
                  if (isRepeatInterview)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange[700],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'REPEAT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  // CSV indicator
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[700],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'CSV',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onInterviewComplete();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Repeat interview notice
                    if (isRepeatInterview)
                      Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.orange[900]?.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.orange.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.refresh,
                              color: Colors.orange[300],
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'You are re-interviewing $characterDisplayName. You can review their previous responses.',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Character image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        characterImagePath,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey[700],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white54,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Character introduction
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[800]?.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        isRepeatInterview 
                            ? '$characterIntro\n\n"We\'ve spoken before, Detective. What else would you like to know?"'
                            : characterIntro,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Interview questions from CSV
                    ...characterInterviews.questions.map((question) {
                      bool isAvailable = question.isAvailable(gameState);
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isAvailable 
                                ? Colors.blueGrey[800]?.withOpacity(0.3)
                                : Colors.grey[800]?.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isAvailable 
                                  ? Colors.blueGrey.withOpacity(0.5)
                                  : Colors.grey.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent,
                            ),
                            child: ExpansionTile(
                              // Auto-expand questions on repeat interviews
                              initiallyExpanded: isRepeatInterview && isAvailable,
                              tilePadding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 5,
                              ),
                              childrenPadding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                              title: Text(
                                '${question.question}${_getRequirementString(question, gameState)}',
                                style: TextStyle(
                                  color: isAvailable ? Colors.white : Colors.grey[500],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              iconColor: isAvailable ? Colors.white : Colors.grey[500],
                              onExpansionChanged: (bool expanded) {
                                if (expanded && !isAvailable) {
                                  _showRequirementSnackbar(context, question);
                                }
                              },
                              children: [
                                if (isAvailable)
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey[700]?.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Character name
                                        Text(
                                          '$characterDisplayName:',
                                          style: TextStyle(
                                            color: Colors.amber[300],
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // Response text from CSV
                                        Text(
                                          '"${question.response}"',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            height: 1.6,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 20),

                    // Interview summary
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: isRepeatInterview 
                            ? Colors.orange[800]?.withOpacity(0.3)
                            : Colors.green[800]?.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isRepeatInterview 
                              ? Colors.orange.withOpacity(0.5)
                              : Colors.green.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isRepeatInterview 
                                ? Icons.refresh
                                : Icons.check_circle_outline,
                            color: isRepeatInterview ? Colors.orange : Colors.green,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              isRepeatInterview
                                  ? 'You have reviewed the interview with $characterDisplayName. You can revisit this interview anytime.'
                                  : 'Interview with $characterDisplayName completed. You may now continue your investigation.',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onInterviewComplete();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Return to Investigation',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build error dialog for CSV loading issues
  Widget _buildErrorDialog(BuildContext context, String title, String message) {
    return AlertDialog(
      backgroundColor: Colors.red[900],
      title: Row(
        children: [
          const Icon(Icons.error, color: Colors.white, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onInterviewComplete();
          },
          child: const Text(
            'Close',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  // Generate requirement string to display next to unavailable questions
  String _getRequirementString(InterviewQuestion question, GameState gameState) {
    if (question.requiresEvidence == 'will' && !gameState.evidenceList[3]) {
      return " (Need Will evidence)";
    }
    if (question.requiresEvidence == 'ledger' && !gameState.evidenceList[4]) {
      return " (Need Ledger evidence)";
    }
    if (question.requiresEvidence == 'will_or_ledger' &&
        !gameState.evidenceList[3] &&
        !gameState.evidenceList[4]) {
      return " (Need Will or Ledger evidence)";
    }
    if (question.requiresInterview == 'reynolds' && !gameState.reynoldsInterviewComplete) {
      return " (Need to interview Mrs. Reynolds first)";
    }
    return "";
  }

  // Show appropriate snackbar for unavailable questions
  void _showRequirementSnackbar(BuildContext context, InterviewQuestion question) {
    String message = 'You need to find more evidence first.';
    
    if (question.requiresEvidence == 'will') {
      message = 'You need to find the Modified Will first.';
    } else if (question.requiresEvidence == 'ledger') {
      message = 'You need to find the Business Ledger first.';
    } else if (question.requiresEvidence == 'will_or_ledger') {
      message = 'You need to find the Modified Will or Business Ledger first.';
    } else if (question.requiresInterview == 'reynolds') {
      message = 'You need to interview Mrs. Reynolds first.';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,  
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blueGrey[800],
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}