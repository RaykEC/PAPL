import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../widgets/game_top_bar.dart';
import 'inspector_arrival.dart';

class InitialExamination extends StatefulWidget {
  const InitialExamination({super.key});
  
  @override
  State<InitialExamination> createState() => _InitialExaminationState();
}

class _InitialExaminationState extends State<InitialExamination> {
  bool _showOptions = false;
  bool _examinedRoom = false;
  bool _foundMedication = false;
  bool _examinedTeaCup = false;
  
  @override
  void initState() {
    super.initState();
    // Show options after brief delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showOptions = true;
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
            'assets/images/study_room.jpg',
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
            locationName: 'Lord William\'s Study',
          ),
          
          // Main content
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.75),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Scene description
                  const Text(
                    'Initial Examination',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'You stand alone in Lord William\'s study, the scene of his final moments. The room is undisturbed—no signs of struggle or forced entry. The windows remain locked from the inside, with iron bars preventing any external access.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              height: 1.5,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          const Text(
                            'Lord William lies near his desk, one hand clutched to his chest, his face showing signs of distress. The door key remains in his pocket, confirming the room was locked from within.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              height: 1.5,
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Evidence found section
                          if (_foundMedication || _examinedTeaCup) ...[
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue[900]!.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue[300]!.withOpacity(0.5)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Evidence Found:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (_foundMedication)
                                    const Text(
                                      '• Heart Medication Bottle - Prescription bottle lying on the desk, several pills spilled',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  if (_examinedTeaCup)
                                    const Text(
                                      '• Tea Cup with Unusual Residue - Half-empty cup with suspicious discoloration',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                          
                          // Current examination results
                          if (_examinedRoom && !_foundMedication)
                            const Text(
                              'Your attention is drawn to the desk where a prescription bottle lies on its side, several pills spilled across the polished wood surface. It appears William was attempting to take his medication but didn\'t manage in time.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                height: 1.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Options
                  if (_showOptions) ...[
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 16),
                    const Text(
                      'What do you choose to do?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Option buttons
                    if (!_examinedRoom) ...[
                      _buildOptionButton(
                        context,
                        'Option 1: Examine/Analyze the Room',
                        'Look for clues at the crime scene',
                        () => _examineRoom(),
                      ),
                      const SizedBox(height: 12),
                      _buildOptionButton(
                        context,
                        'Option 2: Proceed Directly to the Lobby',
                        'Leave the scene undisturbed for the authorities',
                        () => _proceedToLobby(),
                      ),
                    ] else if (_foundMedication && !_examinedTeaCup) ...[
                      _buildOptionButton(
                        context,
                        'Option 1A: Conclude Initial Examination',
                        'You\'ve seen enough evidence for now',
                        () => _concludeExamination(),
                      ),
                      const SizedBox(height: 12),
                      _buildOptionButton(
                        context,
                        'Option 1B: Further Examination',
                        'Look more carefully at the scene',
                        () => _furtherExamination(),
                      ),
                    ] else if (_examinedTeaCup || (_examinedRoom && !_foundMedication)) ...[
                      _buildOptionButton(
                        context,
                        'Continue to Inspector Arrival',
                        'You\'ve completed your examination',
                        () => _proceedToInspector(),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildOptionButton(BuildContext context, String title, String description, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey[800],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.white24),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _examineRoom() {
    final gameState = Provider.of<GameState>(context, listen: false);
    
    setState(() {
      _examinedRoom = true;
      _foundMedication = true;
    });
    
    // Collect first evidence
    gameState.collectEvidence(1);
    
    // Show message about finding medication
    _showEvidenceFoundDialog(
      'Heart Medication Bottle Found!',
      'You discover a prescription bottle labeled with heart medication. Several pills are spilled across the desk, suggesting Lord William was attempting to take his medication when he died.',
    );
  }
  
  void _furtherExamination() {
    final gameState = Provider.of<GameState>(context, listen: false);
    
    setState(() {
      _examinedTeaCup = true;
    });
    
    // Collect second evidence
    gameState.collectEvidence(2);
    
    // Show message about tea cup
    _showEvidenceFoundDialog(
      'Tea Cup with Residue Found!',
      'Examining the tea cup more closely, you notice unusual discoloration in the dried residue at the bottom. This wasn\'t ordinary tea - something else was mixed in.',
    );
  }
  
  void _concludeExamination() {
    // Go directly to inspector with only 1 evidence piece
    _proceedToInspector();
  }
  
  void _proceedToLobby() {
    // Go directly to inspector with 0 evidence pieces
    _proceedToInspector();
  }
  
  void _proceedToInspector() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const InspectorArrival()),
    );
  }
  
  void _showEvidenceFoundDialog(String title, String description) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[900],
          title: Row(
            children: [
              Icon(Icons.search, color: Colors.blue[300], size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Continue Investigation',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }
}