import 'package:flutter/material.dart';
import '../front_page.dart';

class NaturalCausesEnding extends StatefulWidget {
  const NaturalCausesEnding({super.key});
  
  @override
  State<NaturalCausesEnding> createState() => _NaturalCausesEndingState();
}

class _NaturalCausesEndingState extends State<NaturalCausesEnding>
    with TickerProviderStateMixin {
  late AnimationController _textController;
  late AnimationController _tapIndicatorController;
  late AnimationController _lightningController;
  late Animation<double> _textOpacity;
  late Animation<double> _tapIndicatorOpacity;
  
  int _currentTextIndex = 0;
  bool _waitingForTap = false;
  bool _lightningEffect = false;
  
  final List<String> _narrativeTexts = [
    'Inspector Simmons files his report: death by natural causes due to heart failure. The case is closed without further investigation.',
    
    'Three days later, you attend Lord William\'s funeral. The rain has cleared, but a somber mood hangs over the cemetery.',
    
    'Lady Victoria stands stoically beside the grave, her face hidden behind a black veil. James keeps his distance, his expression unreadable.',
    
    'Dr. Thomas Harlow approaches you after the ceremony, his manner professional but warm.',
    
    '"A tragic loss," he says. "William was always concerned about his heart condition. I did everything I could to help him manage it over the years."',
    
    'He pauses. "I\'ve been approved for a new research grant—cardiac medicine. William would have been pleased to know his condition might help others someday."',
    
    'As you watch Dr. Harlow walk away, a nagging doubt lingers in your mind. Was there something you missed? Something in the tea cup, perhaps?',
    
    'But the case is closed, the evidence buried with Lord William Thornfield.',
    
    'The perfect murder remains perfect when it goes undetected.',
  ];
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    
    // Rain continues throughout this ending (no audio changes needed)
    _startLightningEffects();
    _showNextText();
  }

  void _initializeAnimations() {
    _textController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _tapIndicatorController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _lightningController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );

    _tapIndicatorOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _tapIndicatorController, curve: Curves.easeInOut),
    );

    _textController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted && _currentTextIndex < _narrativeTexts.length - 1) {
            setState(() {
              _waitingForTap = true;
            });
            _tapIndicatorController.forward();
          } else if (mounted && _currentTextIndex >= _narrativeTexts.length - 1) {
            // Last text, show for longer then return to title
            Future.delayed(const Duration(seconds: 6), () {
              _returnToTitle();
            });
          }
        });
      }
    });
  }
  
  void _startLightningEffects() {
    // Random lightning flashes
    void scheduleLightning() {
      int delay = 3000 + (DateTime.now().millisecond % 5000);
      Future.delayed(Duration(milliseconds: delay), () {
        if (mounted) {
          setState(() {
            _lightningEffect = true;
          });
          _lightningController.forward().then((_) {
            _lightningController.reverse().then((_) {
              setState(() {
                _lightningEffect = false;
              });
            });
          });
          scheduleLightning();
        }
      });
    }
    scheduleLightning();
  }

  void _showNextText() {
    if (_currentTextIndex >= _narrativeTexts.length) {
      _returnToTitle();
      return;
    }

    setState(() {
      _waitingForTap = false;
    });

    _textController.reset();
    _tapIndicatorController.reset();
    _textController.forward();
  }

  void _onTap() {
    if (_waitingForTap && _currentTextIndex < _narrativeTexts.length - 1) {
      setState(() => _currentTextIndex++);
      _showNextText();
    } else if (_currentTextIndex >= _narrativeTexts.length - 1) {
      // Last text was reached, skip to return
      _returnToTitle();
    }
  }
  
  void _returnToTitle() {
    // Rain ambience continues to play
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const FrontPage()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _tapIndicatorController.dispose();
    _lightningController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
        onTap: _onTap,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            // Background image
            Image.asset(
              _currentTextIndex < 2 
                  ? 'assets/images/manor_night.jpg'
                  : 'assets/images/cemetery.jpg',
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
                        Colors.grey[900]!,
                        Colors.black,
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Background Image',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
            
            // Lightning effect overlay
            if (_lightningEffect)
              AnimatedBuilder(
                animation: _lightningController,
                builder: (context, child) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.white.withOpacity(0.3 * _lightningController.value),
                  );
                },
              ),
            
            // Rain effect overlay
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.blue.withOpacity(0.1),
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
            
            // Central text box
            Positioned(
              bottom: screenSize.height * 0.15,
              left: screenSize.width * 0.08,
              right: screenSize.width * 0.08,
              child: FadeTransition(
                opacity: _textOpacity,
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _currentTextIndex >= _narrativeTexts.length - 1
                          ? Colors.red.withOpacity(0.6)
                          : Colors.grey[600]!,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title for final message
                      if (_currentTextIndex >= _narrativeTexts.length - 1)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.red[900]!.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.red[300]!.withOpacity(0.5)),
                            ),
                            child: const Text(
                              'CASE UNSOLVED',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                      
                      // Narrative text
                      Text(
                        _narrativeTexts[_currentTextIndex],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          height: 1.6,
                          fontStyle: _currentTextIndex == 4 || _currentTextIndex == 5
                              ? FontStyle.italic
                              : FontStyle.normal,
                          fontWeight: _currentTextIndex >= _narrativeTexts.length - 1
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      // Hint for final message
                      if (_currentTextIndex >= _narrativeTexts.length - 1) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[800]!.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'A thorough examination of the crime scene might have revealed crucial evidence...',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ],
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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.touch_app,
                          color: Colors.white70,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'TAP TO CONTINUE',
                          style: TextStyle(
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
                  '${_currentTextIndex + 1}/${_narrativeTexts.length}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            
            // Title bar
            Positioned(
              top: 60,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red[900]!.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red[300]!.withOpacity(0.3)),
                ),
                child: const Text(
                  'NATURAL CAUSES',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}