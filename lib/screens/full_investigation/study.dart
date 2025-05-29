import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game_state.dart';
import '../../widgets/game_top_bar.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});
  
  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  bool _examinedBody = false;
  bool _examinedDesk = false;
  bool _examinedBookshelf = false;
  bool _foundKey = false;
  bool _foundWill = false;
  bool _foundLedger = false;
  
  @override
  void initState() {
    super.initState();
    final gameState = Provider.of<GameState>(context, listen: false);
    gameState.visitLocation(1);
    gameState.setCurrentLocation('Study');
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
                      Colors.red[900]!,
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
                  // Title
                  const Text(
                    'The Study - Crime Scene',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Description
                  const Text(
                    'You stand in Lord William\'s private study, where his body was discovered. The room tells a story of a life interrupted - papers scattered, medication spilled, and secrets waiting to be uncovered.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Evidence summary
                  if (_foundKey || _foundWill || _foundLedger) ...[
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
                            'Evidence Found in Study:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (_foundKey)
                            const Text(
                              '• Ornate Key - Found in Lord William\'s inner pocket',
                              style: TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          if (_foundWill)
                            const Text(
                              '• Modified Will Document - Recent changes to inheritance',
                              style: TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          if (_foundLedger)
                            const Text(
                              '• Business Ledger - Shows significant financial troubles',
                              style: TextStyle(fontSize: 14, color: Colors.white),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  
                  // Investigation options
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Investigation Options:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Examine Body option
                          _buildInvestigationOption(
                            'Examine Lord William\'s Body',
                            'Search for clues on the victim himself',
                            Icons.person,
                            Colors.red[700]!,
                            _examinedBody,
                            !_examinedBody,
                            () => _examineBody(),
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Examine Desk option
                          _buildInvestigationOption(
                            'Examine the Desk',
                            _foundKey
                                ? 'Search the desk and locked drawer with the key'
                                : 'Search Lord William\'s desk',
                            Icons.desk,
                            Colors.brown[700]!,
                            _examinedDesk && _foundKey, // Only show as completed if we have key AND examined
                            !_examinedDesk || !_foundKey, // Enable if not examined OR don't have key yet
                            () => _examineDesk(),
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Examine Bookshelf option
                          _buildInvestigationOption(
                            'Examine the Bookshelf',
                            'Search among Lord William\'s collection of books',
                            Icons.menu_book,
                            Colors.green[700]!,
                            _examinedBookshelf,
                            !_examinedBookshelf,
                            () => _examineBookshelf(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Return button
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('RETURN TO ENTRANCE HALL'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey[800],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInvestigationOption(
    String title,
    String description,
    IconData icon,
    Color color,
    bool completed,
    bool enabled,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: completed 
              ? color.withOpacity(0.3)
              : enabled
                  ? color.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: completed 
                ? color
                : enabled
                    ? color.withOpacity(0.5)
                    : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: completed 
                      ? color
                      : enabled
                          ? color.withOpacity(0.7)
                          : Colors.grey.withOpacity(0.5),
                ),
                if (completed)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: enabled || completed ? Colors.white : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    completed ? '$description (Completed)' : description,
                    style: TextStyle(
                      fontSize: 14,
                      color: enabled || completed ? Colors.white70 : Colors.grey.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            if (enabled && !completed)
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white54,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
  
  void _examineBody() {
    final gameState = Provider.of<GameState>(context, listen: false);
    
    setState(() {
      _examinedBody = true;
      _foundKey = true;
    });
    
    gameState.findKey();
    
    _showEvidenceDialog(
      'Key Found!',
      'You approach Lord William\'s body with solemn respect. Examining his clothing, you notice a small bulge in his inner jacket pocket. Inside, you find an ornate key with an intricate design—different from the study door key already found in his pocket.',
      'This key appears to match the lock of the desk drawer.',
    );
  }
  
  void _examineDesk() {
    final gameState = Provider.of<GameState>(context, listen: false);
    
    if (_foundKey) {
      setState(() {
        _examinedDesk = true;
        _foundWill = true;
      });
      
      gameState.collectEvidence(3); // Modified Will Document
      
      _showEvidenceDialog(
        'Modified Will Found!',
        'Using the ornate key from William\'s pocket, you unlock the desk drawer. Inside is a modified will document dated two weeks ago, with significant changes to his inheritance plans.',
        'James is explicitly disinherited, with a note citing "continuous irresponsible behavior." More surprisingly, a substantial research grant previously allocated to Dr. Thomas has been revoked.',
      );
    } else {
      // Don't mark as examined if we don't have the key
      _showInfoDialog(
        'Locked Drawer',
        'Lord William\'s desk is meticulously organized despite the spilled medication. A leather-bound appointment book sits open to yesterday\'s date with several meetings crossed out. The top right drawer is locked and requires a key.',
      );
    }
  }
  
  void _examineBookshelf() {
    final gameState = Provider.of<GameState>(context, listen: false);
    
    setState(() {
      _examinedBookshelf = true;
      _foundLedger = true;
    });
    
    gameState.collectEvidence(4); // Business Ledger
    
    _showEvidenceDialog(
      'Business Ledger Found!',
      'The bookshelf contains volumes on business, law, and British history. One thick ledger catches your eye, appearing slightly out of place. Upon inspection, the business ledger reveals alarming financial troubles.',
      'Lord William\'s primary business ventures have suffered catastrophic losses in recent months. Notes in the margins show increasing desperation, with one entry dated just yesterday reading: "Must inform Thomas—no choice but to cancel funding. God help me."',
    );
  }
  
  void _showEvidenceDialog(String title, String description, String additionalInfo) {
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
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[900]!.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[300]!.withOpacity(0.5)),
                  ),
                  child: Text(
                    additionalInfo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
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
  
  void _showInfoDialog(String title, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[900],
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
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
                'Continue',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }
}