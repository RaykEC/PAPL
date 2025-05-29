import 'package:flutter/material.dart';
import '../front_page.dart';

class JamesAccusedEnding extends StatefulWidget {
  const JamesAccusedEnding({super.key});

  @override
  State<JamesAccusedEnding> createState() => _JamesAccusedEndingState();
}

class _JamesAccusedEndingState extends State<JamesAccusedEnding>
    with TickerProviderStateMixin {
  late AnimationController _textController;
  late AnimationController _sceneController;
  late AnimationController _tapIndicatorController;
  late Animation<double> _textOpacity;
  late Animation<double> _sceneOpacity;
  late Animation<double> _tapIndicatorOpacity;
  
  int _currentTextIndex = 0;
  bool _showingArrest = false;
  bool _showingGala = false;
  bool _waitingForTap = false;
  
  final List<String> _narrativeTexts = [
    "Based on the evidence you've collected, suspicion falls heavily on James Thornfield.",
    "The modified will that disinherited him provides a clear motive.",
    "His documented argument with William shortly before the death, along with his proximity to the study during the estimated time of death, seals his fate.",
    "Inspector Simmons arrests James the following morning.",
    "As the officers lead him away, James looks back at you, his eyes filled not with guilt but with profound betrayal.",
    "\"I didn't do this,\" he insists. \"William was alive when I left him. Someone else wanted him dead!\"",
    "Six months later...",
    "You receive news that James has been convicted of his brother's murder.",
    "The prosecution argued that he tampered with William's medication in a rage over being disinherited.",
    "At a charity gala in London, you encounter Dr. Thomas Harlow, now heading a prestigious cardiac research institute funded by the late Lord William's estate.",
    "\"Such a tragedy about James,\" Dr. Harlow says, shaking his head.",
    "\"Who would have thought him capable of such a thing? William's last act was quite prescient—removing James from the will just before his betrayal.\"",
    "As you watch Dr. Harlow charming the other guests, a troubling thought crosses your mind.",
    "Did you miss something? The tea... there was something unusual about it.",
    "But the case is closed now, and an innocent man may be paying the price for your incomplete investigation."
  ];
  
  @override
  void initState() {
    super.initState();
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _sceneController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _tapIndicatorController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );
    
    _sceneOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sceneController, curve: Curves.easeInOut),
    );
    
    _tapIndicatorOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _tapIndicatorController, curve: Curves.easeInOut),
    );
    
    _textController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Show tap indicator after a brief pause
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted && _currentTextIndex < _narrativeTexts.length - 1) {
            setState(() {
              _waitingForTap = true;
            });
            _tapIndicatorController.forward();
          } else if (mounted && _currentTextIndex >= _narrativeTexts.length - 1) {
            // Last text, show for longer then return to title
            Future.delayed(const Duration(seconds: 5), () {
              _returnToTitle();
            });
          }
        });
      }
    });
    
    _startNarration();
  }
  
  void _startNarration() {
    _showNextText();
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
    
    // Handle scene changes
    _handleSceneChange();
    
    // Start text animation
    _textController.forward();
  }
  
  void _handleSceneChange() {
    if (_currentTextIndex == 3) { // "Inspector Simmons arrests James..."
      if (!_showingArrest) {
        setState(() => _showingArrest = true);
        _sceneController.reset();
        _sceneController.forward();
      }
    } else if (_currentTextIndex == 9) { // "At a charity gala..."
      if (!_showingGala) {
        setState(() {
          _showingArrest = false;
          _showingGala = true;
        });
        _sceneController.reset();
        _sceneController.forward();
      }
    }
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
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const FrontPage()),
      (route) => false,
    );
  }
  
  @override
  void dispose() {
    _textController.dispose();
    _sceneController.dispose();
    _tapIndicatorController.dispose();
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
            if (!_showingArrest && !_showingGala)
              Image.asset(
                'assets/images/manor_night.jpg',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            
            if (_showingArrest)
              FadeTransition(
                opacity: _sceneOpacity,
                child: Image.asset(
                  'assets/images/manor_interior.jpg',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            
            if (_showingGala)
              FadeTransition(
                opacity: _sceneOpacity,
                child: Image.asset(
                  'assets/images/london_gala.jpg',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            
            // Rain effect overlay (only when not at gala)
            if (!_showingGala)
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            
            // Dark overlay for gala scene
            if (_showingGala)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.4),
              ),
            
            // Lightning flash effect (more realistic timing)
            if (!_showingGala)
              _buildLightningEffect(),
            
            // Central text box
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
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
                    border: Border.all(color: Colors.grey[600]!, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _currentTextIndex < _narrativeTexts.length
                          ? _narrativeTexts[_currentTextIndex]
                          : '',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'Georgia',
                        height: 1.5,
                        fontStyle: _currentTextIndex == 5 || _currentTextIndex == 10 || _currentTextIndex == 11
                            ? FontStyle.italic 
                            : FontStyle.normal,
                        fontWeight: _currentTextIndex == _narrativeTexts.length - 1 
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            
            // Tap indicator with improved visibility
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
          ],
        ),
      ),
    );
  }
  
  Widget _buildLightningEffect() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        // Create a more realistic lightning effect
        final time = DateTime.now().millisecondsSinceEpoch;
        final lightningTrigger = (time ~/ 3000) % 7; // Lightning every ~7*3 seconds randomly
        final shouldFlash = lightningTrigger == 0 && (time % 300) < 150; // Flash for 150ms
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 50),
          width: double.infinity,
          height: double.infinity,
          color: shouldFlash 
              ? Colors.white.withOpacity(0.15) 
              : Colors.transparent,
        );
      },
    );
  }
}