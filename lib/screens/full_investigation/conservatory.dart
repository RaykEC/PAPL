import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game_state.dart';
import '../../widgets/game_top_bar.dart';

class ConservatoryScreen extends StatefulWidget {
  const ConservatoryScreen({super.key});
  
  @override
  State<ConservatoryScreen> createState() => _ConservatoryScreenState();
}

class _ConservatoryScreenState extends State<ConservatoryScreen> {
  bool _interviewedLadyVictoria = false;
  
  @override
  void initState() {
    super.initState();
    final gameState = Provider.of<GameState>(context, listen: false);
    gameState.visitLocation(3);
    gameState.setCurrentLocation('Conservatory');
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/images/conservatory.jpg',
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
                      Colors.green[900]!,
                      Colors.black,
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Top bar
          const GameTopBar(
            locationName: 'The Conservatory',
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
                    'The Conservatory',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Description
                  const Text(
                    'The glass-walled conservatory is filled with exotic plants, their shadows dancing eerily in the storm\'s lightning. Lady Victoria sits rigidly in a wicker chair, staring out at the rain-lashed gardens with an expression of composed grief.',
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
                      color: Colors.purple[900]!.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.purple[300]!.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.purple,
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
                                'Lady Victoria Thornfield',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Lord William\'s wife, maintains composure despite the circumstances',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_interviewedLadyVictoria)
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
                          
                          // Interview Lady Victoria option
                          _buildInvestigationOption(
                            'Interview Lady Victoria',
                            'Question Lord William\'s wife about the events',
                            Icons.chat,
                            Colors.purple[700]!,
                            _interviewedLadyVictoria,
                            !_interviewedLadyVictoria,
                            () => _interviewLadyVictoria(),
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
  
  void _interviewLadyVictoria() {
    final gameState = Provider.of<GameState>(context, listen: false);
    
    setState(() {
      _interviewedLadyVictoria = true;
    });
    
    gameState.interviewCharacter('Lady Victoria');
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[900],
          title: Row(
            children: [
              Icon(Icons.person, color: Colors.purple[300], size: 24),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Lady Victoria Thornfield Interview',
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
                    color: Colors.purple[900]!.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.purple[300]!.withOpacity(0.5)),
                  ),
                  child: const Text(
                    'Lady Victoria turns as you approach, her composure maintained despite the late hour and tragic circumstances.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Question 1: Business difficulties
                const Text(
                  'About William\'s business difficulties:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '"William was always discreet about business matters, but yes, I knew something was troubling him. He hadn\'t been sleeping well for days. I suggested he speak with Dr. Harlow about it, but he insisted it would pass once a certain transaction was completed. I fear now it never will."',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Question 2: Changes to will (conditional)
                if (gameState.evidenceList[3]) ...[
                  const Text(
                    'About changes to William\'s will:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '"Yes, William informed me of the adjustments. He was concerned about James\'s drinking habits and wanted to ensure the estate would be properly managed. The changes regarding Dr. Harlow were recent—William was concerned about the direction of Thomas\'s research. He said he could no longer justify the expense given our financial situation."',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Question 3: Chamomile tea
                const Text(
                  'About the chamomile tea:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '"Yes, I did request it. William has been so tense lately, I thought it might help him relax. He usually takes his heart medication in the evening, and I know he prefers to have something warm to swallow the pills with rather than plain water. Mrs. Reynolds knows how to prepare it just as he likes."',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple[900]!.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.purple[300]!.withOpacity(0.5)),
                  ),
                  child: const Text(
                    '"Please find whoever did this to William, Detective. Despite what some might think of our marriage, I... cared for him deeply."',
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
                'Thank you for your time',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }
}