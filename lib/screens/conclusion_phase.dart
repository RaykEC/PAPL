import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../widgets/game_top_bar.dart';
import 'endings/natural_causes_ending.dart';
import 'endings/james_accused_ending.dart';
import 'endings/dr_thomas_revealed_ending.dart';

class ConclusionPhase extends StatefulWidget {
  const ConclusionPhase({super.key});
  
  @override
  State<ConclusionPhase> createState() => _ConclusionPhaseState();
}

class _ConclusionPhaseState extends State<ConclusionPhase> {
  bool _showConclusionOptions = false;
  String? _selectedEnding;
  
  @override
  void initState() {
    super.initState();
    // Show conclusion options after delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showConclusionOptions = true;
        });
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final int evidenceCount = gameState.evidenceCount;
    final List<String> availableEndings = _getAvailableEndings(evidenceCount);
    
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
            locationName: 'Conclusion Phase',
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
                    'Present Your Findings',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Investigation summary
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'You stand before Inspector Simmons and the assembled household members in Lord William\'s study. Based on your investigation, you must now present your conclusions about what really happened on this stormy night.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              height: 1.5,
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
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
                                Row(
                                  children: [
                                    Icon(Icons.search, color: Colors.blue[300], size: 20),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Evidence Collected',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Total Evidence Found: $evidenceCount/5',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (evidenceCount > 0) ...[
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
                                ] else ...[
                                  const Text(
                                    'No evidence was collected during the investigation.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Interviews summary
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.purple[900]!.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.purple[300]!.withOpacity(0.5)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.chat, color: Colors.purple[300], size: 20),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Interviews Conducted',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ...gameState.characterInterviewed.entries.map((entry) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    children: [
                                      Icon(
                                        entry.value ? Icons.check_circle : Icons.radio_button_unchecked,
                                        color: entry.value ? Colors.green : Colors.grey,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        entry.key,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: entry.value ? Colors.white : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Available conclusions
                          if (_showConclusionOptions) ...[
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
                                      Icon(Icons.gavel, color: Colors.amber[300], size: 20),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Choose Your Conclusion',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Based on the evidence you\'ve collected, the following conclusions are possible:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // Conclusion options
                                  ...availableEndings.map((ending) => _buildConclusionOption(ending)),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Present conclusion button
                  if (_showConclusionOptions && _selectedEnding != null) ...[
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _presentConclusion,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _getEndingColor(_selectedEnding!),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: Text('PRESENT CONCLUSION: ${_getEndingTitle(_selectedEnding!).toUpperCase()}'),
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
  
  List<String> _getAvailableEndings(int evidenceCount) {
    if (evidenceCount == 5) {
      return ['NaturalCauses', 'JamesAccused', 'DrThomasRevealed'];
    } else {
      return ['NaturalCauses', 'JamesAccused'];
    }

  }
  
  Widget _buildConclusionOption(String ending) {
    final bool isSelected = _selectedEnding == ending;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedEnding = ending;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? _getEndingColor(ending).withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected 
                ? _getEndingColor(ending)
                : Colors.white24,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? _getEndingColor(ending) : Colors.transparent,
                border: Border.all(
                  color: isSelected ? _getEndingColor(ending) : Colors.white54,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Icon(
              _getEndingIcon(ending),
              color: _getEndingColor(ending),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getEndingTitle(ending),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getEndingDescription(ending),
                    style: TextStyle(
                      fontSize: 13,
                      color: isSelected ? Colors.white70 : Colors.white60,
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
  
  String _getEndingTitle(String ending) {
    switch (ending) {
      case 'DrThomasRevealed':
        return 'Dr. Thomas Harlow is the Murderer';
      case 'JamesAccused':
        return 'James Thornfield is Guilty';
      case 'NaturalCauses':
      default:
        return 'Death by Natural Causes';
    }
  }
  
  String _getEndingDescription(String ending) {
    switch (ending) {
      case 'DrThomasRevealed':
        return 'Accuse Dr. Harlow of orchestrating a chemical poisoning using his medical knowledge.';
      case 'JamesAccused':
        return 'Accuse James Thornfield based on his motive and opportunity.';
      case 'NaturalCauses':
      default:
        return 'Conclude that Lord William died of natural heart failure.';
    }
  }
  
  Color _getEndingColor(String ending) {
    switch (ending) {
      case 'DrThomasRevealed':
        return Colors.green;
      case 'JamesAccused':
        return Colors.orange;
      case 'NaturalCauses':
      default:
        return Colors.red;
    }
  }
  
  IconData _getEndingIcon(String ending) {
    switch (ending) {
      case 'DrThomasRevealed':
        return Icons.visibility;
      case 'JamesAccused':
        return Icons.warning;
      case 'NaturalCauses':
      default:
        return Icons.close;
    }
  }
  
  void _presentConclusion() {
    if (_selectedEnding == null) return;
    
    switch (_selectedEnding!) {
      case 'NaturalCauses':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NaturalCausesEnding()),
        );
        break;
      case 'JamesAccused':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const JamesAccusedEnding()),
        );
        break;
      case 'DrThomasRevealed':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DrThomasRevealedEnding()),
        );
        break;
    }
  }
}