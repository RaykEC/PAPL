import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game_state.dart';
import '../../widgets/game_top_bar.dart';
import '../../widgets/character_interview_widget.dart';

class KitchenScreen extends StatefulWidget {
  const KitchenScreen({super.key});
  
  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  bool _searchedTeaCabinet = false;
  bool _foundTeaCanister = false;
  
  @override
  void initState() {
    super.initState();
    final gameState = Provider.of<GameState>(context, listen: false);
    gameState.visitLocation(2);
    gameState.setCurrentLocation('Kitchen');
    
    // Check if evidence has been found
    _foundTeaCanister = gameState.evidenceList[5];
  }
  
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final hasInterviewedMrsReynolds = gameState.characterInterviewed['Mrs. Reynolds'] ?? false;
    _foundTeaCanister = gameState.evidenceList[5];
    
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/images/manor_kitchen.jpg',
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
                      Colors.brown[900]!,
                      Colors.black,
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Top bar
          const GameTopBar(
            locationName: 'Manor Kitchen',
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
                    'The Manor Kitchen',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Description
                  const Text(
                    'The large Victorian kitchen is warm despite the late hour, with embers still glowing in the cooking hearth. Mrs. Reynolds busies herself here, her hands slightly shaking from the night\'s events. This is where the fatal tea was prepared.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Evidence summary
                  if (_foundTeaCanister) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[900]!.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[300]!.withOpacity(0.5)),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Evidence Found in Kitchen:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '• Unusual Tea Canister - "Special Blend - Prepared by T.H."',
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
                          
                          // Interview Mrs. Reynolds option - Now always available
                          _buildInvestigationOption(
                            hasInterviewedMrsReynolds 
                                ? 'Re-interview Mrs. Reynolds'
                                : 'Interview Mrs. Reynolds',
                            hasInterviewedMrsReynolds
                                ? 'Review previous responses or ask additional questions'
                                : 'Question the housekeeper about the tea preparation',
                            hasInterviewedMrsReynolds ? Icons.refresh : Icons.person,
                            Colors.brown[700]!,
                            hasInterviewedMrsReynolds,
                            true, // Always enabled now
                            () => _interviewMrsReynolds(),
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Search Tea Cabinet option
                          _buildInvestigationOption(
                            'Search the Tea Cabinet',
                            'Examine where the tea supplies are stored',
                            Icons.kitchen,
                            Colors.green[700]!,
                            _searchedTeaCabinet,
                            !_searchedTeaCabinet,
                            () => _searchTeaCabinet(),
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
                    description,
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
  
  void _interviewMrsReynolds() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CharacterInterviewWidget(
          characterKey: 'Mrs. Reynolds',
          characterDisplayName: 'Mrs. Reynolds',
          characterImagePath: 'assets/images/characters/mrs_reynolds.jpg',
          characterIntro: 'Mrs. Reynolds looks up as you enter, her eyes red-rimmed from crying.',
          onInterviewComplete: () {
            setState(() {}); // Refresh the UI
          },
        );
      },
    );
  }
  
  void _searchTeaCabinet() {
    final gameState = Provider.of<GameState>(context, listen: false);
    
    setState(() {
      _searchedTeaCabinet = true;
      _foundTeaCanister = true;
    });
    
    gameState.collectEvidence(5); // Unusual Tea Canister
    
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
              const Expanded(
                child: Text(
                  'Unusual Tea Canister Found!',
                  style: TextStyle(
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
                const Text(
                  'You carefully examine the ornate tea cabinet. Inside, you find several labeled canisters—Earl Grey, English Breakfast, and a special tin labeled "Chamomile Blend."',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[900]!.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[300]!.withOpacity(0.5)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CRITICAL DISCOVERY:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Examining the chamomile canister more closely, you notice something unusual. The tea leaves don\'t match any chamomile you\'ve ever seen. While chamomile typically has small, daisy-like flower pieces with a golden hue, this blend contains unusual crystalline particles mixed with normal-looking herbs.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'The scent is similar to chamomile but has an underlying unfamiliar note. You examine the canister itself and notice a small label on the bottom: "Special Blend - Prepared by T.H."',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'The tea appears to be a custom mixture unlike any commercial chamomile available. This could be the key to understanding how Lord William was poisoned.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'This changes everything...',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }
}