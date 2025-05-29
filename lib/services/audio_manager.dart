import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();
  
  final AudioPlayer _musicPlayer = AudioPlayer();
  bool _isMusicEnabled = true;
  double _musicVolume = 0.7;
  bool _isInitialized = false; // Track initialization status
  
  // Audio states
  bool get isMusicEnabled => _isMusicEnabled;
  double get musicVolume => _musicVolume;
  bool get isInitialized => _isInitialized; // Getter for initialization status
  
  Future<void> initialize() async {
    try {
      // Set up audio player configurations
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      _isInitialized = true;
      print('AudioManager initialized successfully');
    } catch (e) {
      print('Error initializing AudioManager: $e');
      _isInitialized = false;
    }
  }
  
  // Play dark ambience on front page (no loop)
  Future<void> playDarkAmbience() async {
    if (!_isMusicEnabled || !_isInitialized) {
      print('Cannot play dark ambience - Music enabled: $_isMusicEnabled, Initialized: $_isInitialized');
      return;
    }
    
    try {
      await _musicPlayer.stop();
      await _musicPlayer.setSource(AssetSource('audio/dark_ambience.mp3'));
      await _musicPlayer.setReleaseMode(ReleaseMode.stop);
      await _musicPlayer.setVolume(_musicVolume);
      await _musicPlayer.resume();
      print('Dark ambience started successfully');
    } catch (e) {
      print('Error playing dark ambience: $e');
    }
  }
  
  // Play rain ambience (loops continuously)
  Future<void> playRainAmbience() async {
    if (!_isMusicEnabled || !_isInitialized) {
      print('Cannot play rain ambience - Music enabled: $_isMusicEnabled, Initialized: $_isInitialized');
      return;
    }
    
    try {
      await _musicPlayer.stop();
      await _musicPlayer.setSource(AssetSource('audio/rain_ambience.mp3'));
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.setVolume(_musicVolume);
      await _musicPlayer.resume();
      print('Rain ambience started successfully');
    } catch (e) {
      print('Error playing rain ambience: $e');
    }
  }
  
  // Play morning clarity (for true ending)
  Future<void> playMorningClarity() async {
    if (!_isMusicEnabled || !_isInitialized) {
      print('Cannot play morning clarity - Music enabled: $_isMusicEnabled, Initialized: $_isInitialized');
      return;
    }
    
    try {
      // Fade out rain ambience and fade in morning clarity
      await fadeOutCurrentMusic();
      await _musicPlayer.setSource(AssetSource('audio/morning_clarity.mp3'));
      await _musicPlayer.setReleaseMode(ReleaseMode.stop);
      await fadeInMusic();
      print('Morning clarity started successfully');
    } catch (e) {
      print('Error playing morning clarity: $e');
    }
  }
  
  // Stop all music
  Future<void> stopMusic() async {
    try {
      await _musicPlayer.stop();
      print('Music stopped successfully');
    } catch (e) {
      print('Error stopping music: $e');
    }
  }
  
  // Fade in music
  Future<void> fadeInMusic() async {
    if (!_isMusicEnabled || !_isInitialized) return;
    
    try {
      await _musicPlayer.setVolume(0.0);
      await _musicPlayer.resume();
      
      // Gradual fade in over 2 seconds
      for (int i = 0; i <= 20; i++) {
        await Future.delayed(const Duration(milliseconds: 100));
        double volume = (i / 20) * _musicVolume;
        await _musicPlayer.setVolume(volume);
      }
    } catch (e) {
      print('Error fading in music: $e');
    }
  }
  
  // Fade out current music
  Future<void> fadeOutCurrentMusic() async {
    try {
      double currentVolume = _musicVolume;
      
      // Gradual fade out over 2 seconds
      for (int i = 20; i >= 0; i--) {
        await Future.delayed(const Duration(milliseconds: 100));
        double volume = (i / 20) * currentVolume;
        await _musicPlayer.setVolume(volume);
      }
      
      await _musicPlayer.stop();
    } catch (e) {
      print('Error fading out music: $e');
    }
  }
  
  // Toggle music on/off
  void toggleMusic() {
    _isMusicEnabled = !_isMusicEnabled;
    if (!_isMusicEnabled) {
      stopMusic();
    }
  }
  
  // Set music volume
  void setMusicVolume(double volume) {
    _musicVolume = volume.clamp(0.0, 1.0);
    if (_isInitialized) {
      _musicPlayer.setVolume(_musicVolume);
    }
  }
  
  // Slightly reduce volume during dialogues
  Future<void> reducedVolumeForDialogue() async {
    if (!_isMusicEnabled || !_isInitialized) return;
    await _musicPlayer.setVolume(_musicVolume * 0.7);
  }
  
  // Restore normal volume after dialogue
  Future<void> restoreNormalVolume() async {
    if (!_isMusicEnabled || !_isInitialized) return;
    await _musicPlayer.setVolume(_musicVolume);
  }
  
  // Dispose resources
  void dispose() {
    _musicPlayer.dispose();
  }
}