import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../widgets/game_top_bar.dart';
import 'full_investigation/manor_entrance_hall.dart';
import 'limited_investigation/limited_investigation.dart';

class InspectorArrival extends StatefulWidget {
  const InspectorArrival({super.key});
  
  @override
  State<InspectorArrival> createState() => _InspectorArrivalState();
}

class _InspectorArrivalState extends State<InspectorArrival> {
  bool _showInspectorDialogue = false;
  bool _showDecision = false;
  
  @override
  void initState() {
    super.initState();
    // Show inspector dialogue after delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showInspectorDialogue = true;
        });
      }
    });
    
    // Show decision after inspector dialogue
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _showDecision = true;
        });
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final canProceedToFull = gameState.canProceedToFullInvestigation();
    
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
            locationName: 'Manor Entrance',
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
                    'Inspector Simmons Arrives',
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
                          // Scene description
                          const Text(
                            'Nearly an hour passes before Inspector Harold Simmons arrives, rain dripping from his coat as he enters the manor. His weathered face bears the expression of a man roused from sleep for what he presumes is a routine matter.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              height: 1.5,
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Inspector dialogue
                          if (_showInspectorDialogue) ...[
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.amber[900]!.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.amber[300]!.withOpacity(0.5)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.badge, color: Colors.amber[300], size: 20),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Inspector Simmons',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    canProceedToFull
                                        ? '"Detective Blackwood, I understand there\'s been a death. These... irregularities you\'ve found are concerning, I admit. Very well, you have my permission to conduct additional inquiries. But I expect this will lead back to natural causes in the end."'
                                        : '"Detective Blackwood, I understand there\'s been a death. Natural causes, I presume, given Lord Thornfield\'s known heart condition? I see no need for an extensive investigation - heart failure seems the obvious conclusion."',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                          
                          // Evidence summary
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
                                  'Evidence Collected:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (gameState.evidenceCount == 0)
                                  const Text(
                                    'No evidence collected - scene left undisturbed',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  )
                                else
                                  ...gameState.getCollectedEvidence().map((evidence) => Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Text(
                                      '• $evidence',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Investigation path explanation
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: (canProceedToFull ? Colors.green[900] : Colors.orange[900])!.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: (canProceedToFull ? Colors.green[300] : Colors.orange[300])!.withOpacity(0.5),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  canProceedToFull ? 'Full Investigation Authorized' : 'Limited Investigation',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  canProceedToFull
                                      ? 'Based on the evidence you\'ve found, Inspector Simmons reluctantly allows you to conduct a thorough investigation of the manor and interview all household members.'
                                      : 'With insufficient evidence to suggest foul play, Inspector Simmons limits your investigation to basic interviews. The case will likely be ruled as natural causes.',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Decision buttons
                  if (_showDecision) ...[
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _proceedToInvestigation(canProceedToFull),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: canProceedToFull ? Colors.green[700] : Colors.orange[700],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              canProceedToFull ? 'BEGIN FULL INVESTIGATION' : 'PROCEED WITH LIMITED INVESTIGATION',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
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
  
  void _proceedToInvestigation(bool fullInvestigation) {
    final gameState = Provider.of<GameState>(context, listen: false);
    
    if (fullInvestigation) {
      gameState.setInvestigationPhase('Full');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ManorEntranceHall()),
      );
    } else {
      gameState.setInvestigationPhase('Limited');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LimitedInvestigation()),
      );
    }
  }
}