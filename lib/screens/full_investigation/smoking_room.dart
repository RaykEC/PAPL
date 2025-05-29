import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game_state.dart';
import '../../widgets/game_top_bar.dart';

class SmokingRoomScreen extends StatefulWidget {
  const SmokingRoomScreen({super.key});
  
  @override
  State<SmokingRoomScreen> createState() => _SmokingRoomScreenState();
}

class _SmokingRoomScreenState extends State<SmokingRoomScreen> {
  bool _interviewedJames = false;
  
  @override
  void initState() {
    super.initState();
    final gameState = Provider.of<GameState>(context, listen: false);
    gameState.visitLocation(4);
    gameState.setCurrentLocation('Smoking Room');
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/images/smoking_room.jpg',
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
                      Colors.orange[900]!,
                      Colors.black,
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Top bar
          const GameTopBar(
            locationName: 'The Smoking Room',
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
                    'The Smoking Room',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Description
                  const Text(
                    'Tobacco smoke hangs in the air of this wood-paneled room, creating a hazy atmosphere despite the late hour. James Thornfield stands by the window, drinking from a crystal tumbler, watching the rain streak down the glass. His demeanor suggests he\'s already had quite a bit to drink.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Character information
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange[900]!.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange[300]!.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.orange,
                          child: Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'James Thornfield',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Lord William\'s younger brother, recently disinherited due to alcohol problems',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_interviewedJames)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
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
                          
                          // Interview James option
                          _buildInvestigationOption(
                            'Interview James Thornfield',
                            'Question Lord William\'s brother about the inheritance',
                            Icons.chat,
                            Colors.orange[700]!,
                            _interviewedJames,
                            !_interviewedJames,
                            () => _interviewJames(),
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
  
  void _interviewJames() {
    final gameState = Provider.of<GameState>(context, listen: false);
    
    setState(() {
      _interviewedJames = true;
    });
    
    gameState.interviewCharacter('James');
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[900],
          title: Row(
            children: [
              Icon(Icons.person, color: Colors.orange[300], size: 24),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'James Thornfield Interview',
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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[900]!.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange[300]!.withOpacity(0.5)),
                  ),
                  child: const Text(
                    'James turns to face you, his expression a mixture of grief and defiance. His eyes are bloodshot and his movements slightly unsteady.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Question 1: Disinheritance (conditional)
                if (gameState.evidenceList[3]) ...[
                  const Text(
                    'About being removed from William\'s will:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '"So you found that, did you? Yes, William decided I wasn\'t worthy of the family legacy. Called me in last week to tell me face to face—at least he granted me that courtesy. I was angry, I won\'t deny it. We argued. But I wouldn\'t kill my own brother over money, Detective."',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Question 2: Whereabouts during storm
                const Text(
                  'About his whereabouts during the storm:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '"In my room reading until about eleven. Then I stepped out for a cigarette on the covered terrace. The rain had slightly lessened. I... I may have walked past William\'s study. His door was closed. I heard him coughing inside but didn\'t disturb him."',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Question 3: Entering study (conditional)
                if (gameState.reynoldsInterviewComplete) ...[
                  const Text(
                    'About entering William\'s study:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '"The housekeeper told you, did she? Yes, I went to speak with William. I was... intoxicated, I admit. I wanted to appeal to him one last time about the will. We argued, but he was alive when I left, Detective. On my honor, he was alive. He was drinking that blasted tea and sorting through papers. Said he had important work to finish and asked me to leave. That was around midnight."',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[800]!.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[500]!.withOpacity(0.5)),
                    ),
                    child: const Text(
                      'James seems hesitant to reveal more about his movements that night. Perhaps someone else can corroborate his story...',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[900]!.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange[300]!.withOpacity(0.5)),
                  ),
                  child: const Text(
                    '"Find who did this, Detective. Despite our differences, he was my brother."',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
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
                'Thank you for your honesty',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }
}