import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game_state.dart';
import '../../widgets/game_top_bar.dart';

class GuestRoomScreen extends StatefulWidget {
  const GuestRoomScreen({super.key});
  
  @override
  State<GuestRoomScreen> createState() => _GuestRoomScreenState();
}

class _GuestRoomScreenState extends State<GuestRoomScreen> {
  bool _interviewedDrHarlow = false;
  
  @override
  void initState() {
    super.initState();
    final gameState = Provider.of<GameState>(context, listen: false);
    gameState.visitLocation(5);
    gameState.setCurrentLocation('Guest Room');
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/images/guest_room.jpg',
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
                      Colors.cyan[900]!,
                      Colors.black,
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Top bar
          const GameTopBar(
            locationName: 'The Guest Room',
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
                    'The Guest Room',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Description
                  const Text(
                    'The guest room has been partially converted into a temporary medical office. Dr. Thomas Harlow sits at a small desk, reviewing notes by lamplight. Medical equipment and research papers are scattered around the room, suggesting he\'s been working on something important.',
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
                      color: Colors.cyan[900]!.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.cyan[300]!.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.cyan,
                          child: Icon(
                            Icons.medical_services,
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
                                'Dr. Thomas Harlow',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Family physician and researcher, recently had funding cut by Lord William',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_interviewedDrHarlow)
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
                          
                          // Interview Dr. Harlow option
                          _buildInvestigationOption(
                            'Interview Dr. Thomas Harlow',
                            'Question the family physician about Lord William\'s health',
                            Icons.chat,
                            Colors.cyan[700]!,
                            _interviewedDrHarlow,
                            !_interviewedDrHarlow,
                            () => _interviewDrHarlow(),
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
  
  void _interviewDrHarlow() {
    final gameState = Provider.of<GameState>(context, listen: false);
    
    setState(() {
      _interviewedDrHarlow = true;
    });
    
    gameState.interviewCharacter('Dr. Harlow');
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[900],
          title: Row(
            children: [
              Icon(Icons.medical_services, color: Colors.cyan[300], size: 24),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Dr. Thomas Harlow Interview',
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
                    color: Colors.cyan[900]!.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.cyan[300]!.withOpacity(0.5)),
                  ),
                  child: const Text(
                    'Dr. Harlow sets aside his papers as you enter, offering a professional but solemn greeting.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Question 1: Heart condition and medication
                const Text(
                  'About Lord William\'s heart condition and medication:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '"William suffered from arrhythmia—irregular heartbeat—that occasionally developed into more serious episodes. The medication he took daily helps regulate his heart\'s rhythm. I\'ve treated him for over a decade, and while his condition was chronic, it was well-managed with proper care. The medication is digitalis, derived from foxglove. Quite effective, but very particular in its interactions. There are several substances that should never be combined with it, which I\'ve always made clear to William."',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Question 2: Research funding (conditional)
                if (gameState.evidenceList[3] || gameState.evidenceList[4]) ...[
                  const Text(
                    'About the research funding that was cut:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[900]!.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[300]!.withOpacity(0.5)),
                    ),
                    child: const Text(
                      '"Yes, unfortunately. William informed me yesterday evening that he could no longer support my research into cardiac-affecting botanical compounds. Years of work, potentially lost due to his financial missteps." *He adjusts his glasses and quickly composes himself* "A devastating setback professionally, but I understood his position. These things happen in research."',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Question 3: Chamomile tea
                const Text(
                  'About the chamomile tea William was drinking:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.yellow[900]!.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.yellow[300]!.withOpacity(0.5)),
                  ),
                  child: const Text(
                    '"Chamomile? I recommended it to help with his stress and insomnia. Perfectly safe, normally. Though, now that you mention it, certain varieties of chamomile can have mild interactions with heart medications if consumed in large quantities. Nothing fatal on its own, certainly." *His clinical tone remains steady* "Was he drinking chamomile last night? Interesting."',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.cyan[900]!.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.cyan[300]!.withOpacity(0.5)),
                  ),
                  child: const Text(
                    '"I\'m at your disposal, Detective. William was not just my patron but my friend. I want to see this resolved as much as anyone."',
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
                'Thank you, Doctor',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }
}