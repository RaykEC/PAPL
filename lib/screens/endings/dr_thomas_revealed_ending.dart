import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/game_state.dart';
import '../../../services/audio_manager.dart';
import '../front_page.dart';

class DrThomasRevealedEnding extends StatefulWidget {
  const DrThomasRevealedEnding({super.key});

  @override
  State<DrThomasRevealedEnding> createState() => _DrThomasRevealedEndingState();
}

class _DrThomasRevealedEndingState extends State<DrThomasRevealedEnding>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _textController;
  late AnimationController _lightController;
  late AnimationController _tapIndicatorController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _lightTransition;
  late Animation<double> _tapIndicatorOpacity;
  
  int _currentTextIndex = 0;
  bool _waitingForTap = false;
  bool _showFinalReflection = false;
  bool _isConfessionPhase = false;
  bool _audioTransitioned = false;

  final List<String> _revelationTexts = [
    "You gather everyone in the study at dawn, the scene of the crime now illuminated by morning light.",
    "Inspector Simmons stands by impatiently as you begin to explain your findings.",
    "\"Lord William Thornfield did not die of natural causes,\" you announce.",
    "\"Nor was he killed in a fit of rage by his brother.\"",
    "\"He was murdered through a carefully calculated poisoning—a chemical interaction between his heart medication and a compound added to his tea.\"",
    "You produce the unusual tea canister found in the kitchen.",
    "\"This special blend was provided by someone with intimate knowledge of William's medication.\"",
    "\"When combined with digitalis, it creates a deadly toxin that mimics the symptoms of heart failure.\"",
    "You turn to Dr. Thomas Harlow, whose face has grown increasingly pale.",
    "\"Only someone with medical knowledge could have planned this—someone who knew that William's funding for their research was about to be cut.\"",
  ];

  final List<String> _confessionTexts = [
    "Dr. Harlow's composed façade finally cracks.",
    "\"He was going to ruin everything!\" he shouts, his professional demeanor dissolving.",
    "\"Years of research, on the verge of a breakthrough that would have made medical history!\"",
    "\"And he decided to cancel it all because of some temporary financial setback.\"",
    "As Inspector Simmons arrests the doctor, Lady Victoria approaches you.",
    "\"Thank you for discovering the truth,\" she says quietly. \"William deserved justice.\"",
    "James, now exonerated from suspicion, nods solemnly from across the room.",
  ];

  final String _finalReflection = 
    "Standing by the study window, you observe that the storm has finally subsided. "
    "Golden morning light filters through the glass, illuminating the now-quiet room where tragedy unfolded just hours before. "
    "\n\nAs a detective, you've solved many impossible cases, but few have carried the personal weight of this one. "
    "William was not merely a victim, but an old friend. "
    "\n\nYou cast a methodical glance around the manor—the evidence collected, the interviews conducted, the connections made. "
    "There's a quiet satisfaction in having prevented two injustices: a murderer walking free and an innocent man condemned. "
    "\n\nYour vacation has transformed into something else entirely, but your purpose here is now complete. "
    "It's time to continue your journey home, where your parents still await your visit. "
    "\n\nJustice, at least, has been served.";

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startRevelation();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _lightController = AnimationController(
      duration: const Duration(seconds: 15), // Slower transition for full experience
      vsync: this,
    );

    _tapIndicatorController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );

    _lightTransition = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _lightController, curve: Curves.easeInOut),
    );

    _tapIndicatorOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _tapIndicatorController, curve: Curves.easeInOut),
    );

    _textController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted && !_showFinalReflection) {
            setState(() {
              _waitingForTap = true;
            });
            _tapIndicatorController.forward();
          } else if (mounted && _showFinalReflection) {
            // Final reflection, auto-proceed after longer pause
            Future.delayed(const Duration(seconds: 8), () {
              _fadeToTitle();
            });
          }
        });
      }
    });
  }

  void _startRevelation() {
    _fadeController.forward();
    _lightController.forward(); // Start gradual lighting change
    _showNextText();
  }

  void _showNextText() {
    if (_showFinalReflection) return;

    // Check if we need to transition audio (during revelation phase)
    if (!_audioTransitioned && _currentTextIndex == 5) {
      _transitionAudio();
      _audioTransitioned = true;
    }

    // Check if we've finished revelation texts
    if (!_isConfessionPhase && _currentTextIndex >= _revelationTexts.length) {
      _startConfession();
      return;
    }

    // Check if we've finished confession texts
    if (_isConfessionPhase && _currentTextIndex >= _confessionTexts.length) {
      _showFinalSequence();
      return;
    }

    setState(() {
      _waitingForTap = false;
    });

    _textController.reset();
    _tapIndicatorController.reset();
    _textController.forward();
  }

  void _transitionAudio() {
    // Start the audio transition from rain to morning clarity
    try {
      final audioManager = Provider.of<AudioManager>(context, listen: false);
      audioManager.fadeOutCurrentMusic().then((_) {
        audioManager.playMorningClarity();
      });
    } catch (e) {
      // Handle audio manager not being available
      print('Audio transition failed: $e');
    }
  }

  void _startConfession() {
    setState(() {
      _isConfessionPhase = true;
      _currentTextIndex = 0;
    });
    _showNextText();
  }

  void _showFinalSequence() {
    setState(() {
      _showFinalReflection = true;
      _waitingForTap = false;
    });
    _textController.reset();
    _tapIndicatorController.reset();
    _textController.forward();
  }

  void _onTap() {
    if (!_waitingForTap) return;

    if (!_showFinalReflection) {
      setState(() => _currentTextIndex++);
      _showNextText();
    } else {
      _fadeToTitle();
    }
  }

  void _fadeToTitle() {
    _fadeController.reverse().then((_) {
      Provider.of<GameState>(context, listen: false).resetGame();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const FrontPage()),
        (route) => false,
      );
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _textController.dispose();
    _lightController.dispose();
    _tapIndicatorController.dispose();
    super.dispose();
  }

  Widget _buildBackground() {
    return AnimatedBuilder(
      animation: _lightTransition,
      builder: (context, child) {
        return Stack(
          children: [
            // Base study image (morning version)
            Image.asset(
              'assets/images/study_room_morning.jpg',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[800],
                  child: const Center(
                    child: Text('Study Room Morning', style: TextStyle(color: Colors.white)),
                  ),
                );
              },
            ),
            
            // Lighting transition overlay
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.black.withOpacity(0.7 - (_lightTransition.value * 0.5)),
                    Colors.orange.withOpacity(_lightTransition.value * 0.3),
                    Colors.amber.withOpacity(_lightTransition.value * 0.2),
                  ],
                ),
              ),
            ),
            
            // Golden sunlight effect
            if (_lightTransition.value > 0.5)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topRight,
                      radius: 1.5,
                      colors: [
                        Colors.amber.withOpacity((_lightTransition.value - 0.5) * 0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  String _getCurrentText() {
    if (_showFinalReflection) {
      return _finalReflection;
    } else if (_isConfessionPhase) {
      return _confessionTexts[_currentTextIndex];
    } else {
      return _revelationTexts[_currentTextIndex];
    }
  }

  Color _getCurrentTextColor() {
    if (_isConfessionPhase && _currentTextIndex <= 3) {
      return Colors.red.shade200; // Dr. Harlow's confession in red
    }
    return Colors.white;
  }

  int _getTotalTexts() {
    return _revelationTexts.length + _confessionTexts.length + 1; // +1 for final reflection
  }

  int _getCurrentProgress() {
    if (!_isConfessionPhase) {
      return _currentTextIndex + 1;
    } else if (!_showFinalReflection) {
      return _revelationTexts.length + _currentTextIndex + 1;
    } else {
      return _getTotalTexts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
        onTap: _onTap,
        behavior: HitTestBehavior.opaque,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Stack(
            children: [
              // Background
              _buildBackground(),
              
              // Main content
              Positioned(
                bottom: screenSize.height * 0.15,
                left: screenSize.width * 0.08,
                right: screenSize.width * 0.08,
                child: FadeTransition(
                  opacity: _textAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _showFinalReflection 
                            ? Colors.amber.withOpacity(0.6)
                            : Colors.grey[600]!,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _showFinalReflection 
                              ? Colors.amber.withOpacity(0.2)
                              : Colors.black.withOpacity(0.6),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Phase indicator
                          if (_isConfessionPhase && !_showFinalReflection)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Text(
                                'DR. HARLOW CONFESSES',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[300],
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          
                          if (_showFinalReflection)
                            const Padding(
                              padding: EdgeInsets.only(bottom: 15),
                              child: Text(
                                'CASE CLOSED',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          
                          // Narrative text
                          Text(
                            _getCurrentText(),
                            style: TextStyle(
                              fontSize: 16,
                              color: _getCurrentTextColor(),
                              height: 1.6,
                              fontWeight: _isConfessionPhase && _currentTextIndex <= 3 
                                  ? FontWeight.w600 
                                  : FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              // Tap indicator
              if (_waitingForTap)
                Positioned(
                  bottom: screenSize.height * 0.05,
                  left: screenSize.width * 0.3,
                  right: screenSize.width * 0.3,
                  child: FadeTransition(
                    opacity: _tapIndicatorOpacity,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.touch_app,
                            color: Colors.white70,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _showFinalReflection ? 'TAP TO FINISH' : 'TAP TO CONTINUE',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              
              // Progress indicator
              Positioned(
                top: 50,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_getCurrentProgress()}/${_getTotalTexts()}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}