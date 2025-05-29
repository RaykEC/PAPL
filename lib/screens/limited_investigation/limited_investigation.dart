import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game_state.dart';
import '../../widgets/game_top_bar.dart';
import '../endings/natural_causes_ending.dart';

class LimitedInvestigation extends StatefulWidget {
  const LimitedInvestigation({super.key});
  
  @override
  State<LimitedInvestigation> createState() => _LimitedInvestigationState();
}

class _LimitedInvestigationState extends State<LimitedInvestigation> {
  int _currentInterviewIndex = 0;
  bool _showConcludeButton = false;
  
  final List<Map<String, dynamic>> _limitedInterviews = [
    {
      'character': 'Lady Victoria',
      'title': 'Brief Interview with Lady Victoria',
      'content': 'Lady Victoria maintains her composure as she speaks.\n\n"William had been under considerable stress lately due to business matters. He\'s had heart problems for years - Dr. Harlow has been treating him. I\'m not surprised this happened, though it\'s still a terrible shock."\n\nShe dabs her eyes with a handkerchief and looks away.',
      'icon': Icons.person,
      'color': Colors.purple,
    },
    {
      'character': 'James',
      'title': 'Brief Interview with James Thornfield',
      'content': 'James speaks with obvious grief, though you detect undertones of bitterness.\n\n"My brother was always the responsible one. Worked too hard, stressed too much. His heart couldn\'t take it anymore. We... we had our differences, but I never wanted this."\n\nHe takes a long drink from his glass before continuing to stare out the window.',
      'icon': Icons.person,
      'color': Colors.orange,
    },
    {
      'character': 'Dr. Harlow',
      'title': 'Brief Interview with Dr. Harlow',
      'content': 'Dr. Harlow speaks with professional authority.\n\n"Lord William\'s heart condition was serious. I\'ve been treating him for years with digitalis medication. Given the stress he\'s been under recently, heart failure was unfortunately a possibility I had discussed with him."\n\nHe adjusts his glasses and closes his medical bag with finality.',
      'icon': Icons.medical_services,
      'color': Colors.cyan,
    },
    {
      'character': 'Mrs. Reynolds',
      'title': 'Brief Interview with Mrs. Reynolds',
      'content': 'Mrs. Reynolds speaks through her tears.\n\n"I found him at his desk, clutching his chest. Poor Lord William, he worked so hard. Always staying up late with his papers and business matters. I knew the stress was bad for his heart."\n\nShe shakes her head sadly and wipes her eyes.',
      'icon': Icons.person,
      'color': Colors.brown,
    },
  ];
  
  @override
  void initState() {
    super.initState();
    // Show conclude button after all interviews
    Future.delayed(Duration(seconds: (_limitedInterviews.length + 1)), () {
      if (mounted) {
        setState(() {
          _showConcludeButton = true;
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
            'assets/images/manor_interior.jpg',
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
            locationName: 'Limited Investigation',
            showEvidence: false,
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
                    'Limited Investigation',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Description
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange[900]!.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange[300]!.withOpacity(0.5)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Inspector\'s Limitation:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Based on insufficient evidence to suggest foul play, Inspector Simmons has limited your investigation to brief interviews only. You cannot examine locations thoroughly or conduct detailed searches.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Current interview or summary
                  Expanded(
                    child: _currentInterviewIndex < _limitedInterviews.length
                        ? _buildCurrentInterview()
                        : _buildInvestigationSummary(),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Action buttons
                  if (_currentInterviewIndex < _limitedInterviews.length) ...[
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _nextInterview,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey[800],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              _currentInterviewIndex < _limitedInterviews.length - 1
                                  ? 'NEXT INTERVIEW'
                                  : 'COMPLETE INTERVIEWS'
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else if (_showConcludeButton) ...[
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _concludeInvestigation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[700],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Text('CONCLUDE INVESTIGATION'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCurrentInterview() {
    final interview = _limitedInterviews[_currentInterviewIndex];
    
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: (interview['color'] as Color).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: (interview['color'] as Color).withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  interview['icon'] as IconData,
                  color: interview['color'] as Color,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    interview['title'] as String,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              interview['content'] as String,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[800]!.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.yellow[300],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Limited investigation: Cannot ask follow-up questions or examine evidence',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
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
  
  Widget _buildInvestigationSummary() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Investigation Summary',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red[900]!.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red[300]!.withOpacity(0.5)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Conclusion: Natural Causes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Based on the limited interviews conducted, Inspector Simmons concludes that Lord William died of natural causes - heart failure brought on by stress. All witnesses confirm his known heart condition and recent business pressures.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'The case will be ruled as death by natural causes. No further investigation deemed necessary.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[800]!.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[500]!.withOpacity(0.5)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.warning,
                      color: Colors.yellow,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Missed Opportunities',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'With more thorough initial examination of the scene, you might have found additional evidence that could have led to a more comprehensive investigation...',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  void _nextInterview() {
    final gameState = Provider.of<GameState>(context, listen: false);
    
    // Mark character as interviewed
    final characterName = _limitedInterviews[_currentInterviewIndex]['character'] as String;
    gameState.interviewCharacter(characterName);
    
    setState(() {
      _currentInterviewIndex++;
    });
  }
  
  void _concludeInvestigation() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NaturalCausesEnding()),
    );
  }
}