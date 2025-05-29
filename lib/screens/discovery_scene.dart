import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/audio_manager.dart';
import '../widgets/game_top_bar.dart';
import 'initial_examination.dart';

class DiscoveryScene extends StatefulWidget {
  const DiscoveryScene({super.key});
  
  @override
  State<DiscoveryScene> createState() => _DiscoverySceneState();
}

class _DiscoverySceneState extends State<DiscoveryScene> {
  int _currentDialogueIndex = 0;
  late AudioManager audioManager;
  
  final List<Map<String, String>> _dialogueSequence = [
    {
      'speaker': 'Narrator',
      'text': 'The piercing scream cuts through the stillness of the night, jolting you from sleep. Your detective instincts immediately take over as you throw on your dressing gown and rush toward the source of the disturbance.'
    },
    {
      'speaker': 'Narrator', 
      'text': 'In the dimly lit hallway outside Lord William\'s study, you find Mrs. Reynolds sitting on the floor, her face ashen, one trembling hand covering her mouth while the other points toward the open doorway. Her eyes are wide with shock.'
    },
    {
      'speaker': 'Detective Blackwood',
      'text': '"Mrs. Reynolds, what happened?"'
    },
    {
      'speaker': 'Mrs. Reynolds',
      'text': '"Lord William... I... I came to collect his evening tray and..." *She struggles to form words, unable to finish the sentence*'
    },
    {
      'speaker': 'Narrator',
      'text': 'The sound of hurried footsteps announces the arrival of the other household members, drawn by the commotion. Lady Victoria appears first, her hair hastily arranged, wrapped in a silk dressing gown.'
    },
    {
      'speaker': 'Lady Victoria',
      'text': '"What\'s going on? What\'s happened?" *She gasps as her eyes follow Mrs. Reynolds\' pointing finger* "William!" *she cries out, swaying dangerously*'
    },
    {
      'speaker': 'Detective Blackwood',
      'text': '"Please, Lady Victoria, stay back for now." *You catch her arm as she begins to collapse, steadying her against the wall*'
    },
    {
      'speaker': 'Narrator',
      'text': 'James Thornfield appears next, followed closely by Dr. Thomas Harlow. James\'s eyes are bloodshot, his movements unsteady—clearly still feeling the effects of alcohol. Dr. Harlow appears alert despite the late hour, his medical bag already in hand.'
    },
    {
      'speaker': 'James Thornfield',
      'text': '"What in God\'s name is all this racket?" *He demands, before noticing the open study door and the housekeeper\'s distress*'
    },
    {
      'speaker': 'Dr. Harlow',
      'text': '"Is someone injured?" *He steps forward, his expression shifting from confusion to professional concern*'
    },
    {
      'speaker': 'Detective Blackwood',
      'text': '"Everyone, please step back. Dr. Harlow, I need you to come with me to examine Lord William. The rest of you, please remain here."'
    },
    {
      'speaker': 'Narrator',
      'text': 'You guide the doctor into the study, closing the door partially behind you. The room is dimly lit by a dying fire and a single lamp on the desk. Lord William lies sprawled near his desk, one hand clutched to his chest, his face contorted in what must have been his final agony.'
    },
    {
      'speaker': 'Dr. Harlow',
      'text': '"He\'s gone, Detective. Judging by body temperature and rigor mortis, I\'d estimate he died several hours ago, perhaps shortly after midnight."'
    },
    {
      'speaker': 'Detective Blackwood',
      'text': '"Thank you, Doctor. Please join the others outside now. I need to secure the scene."'
    },
    {
      'speaker': 'Narrator',
      'text': 'As Dr. Harlow exits, you address the assembled household members. "I regret to inform you that Lord William has passed away. I must ask you all to proceed to the lobby while I examine the scene. Mrs. Reynolds, please send someone to notify the local police."'
    },
  ];
  
  @override
  void initState() {
    super.initState();
    audioManager = Provider.of<AudioManager>(context, listen: false);
    
    // Start rain ambience when scene begins
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Small delay before starting rain (after the scream)
      Future.delayed(const Duration(milliseconds: 1500), () {
        audioManager.fadeInMusic();
        audioManager.playRainAmbience();
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/images/manor_hallway.jpg',
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
            locationName: 'Manor Hallway',
            showEvidence: false,
          ),
          
          // Dialogue box
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              height: 280,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: _currentDialogueIndex < _dialogueSequence.length
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Speaker name
                        if (_dialogueSequence[_currentDialogueIndex]['speaker'] != 'Narrator')
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getSpeakerColor(_dialogueSequence[_currentDialogueIndex]['speaker']!),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _dialogueSequence[_currentDialogueIndex]['speaker']!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        
                        if (_dialogueSequence[_currentDialogueIndex]['speaker'] != 'Narrator')
                          const SizedBox(height: 12),
                        
                        // Dialogue text
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              _dialogueSequence[_currentDialogueIndex]['text']!,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                height: 1.4,
                                fontStyle: _dialogueSequence[_currentDialogueIndex]['speaker'] == 'Narrator' 
                                    ? FontStyle.italic 
                                    : FontStyle.normal,
                              ),
                            ),
                          ),
                        ),
                        
                        // Next button
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: _nextDialogue,
                              child: Text(_currentDialogueIndex < _dialogueSequence.length - 1 ? 'NEXT' : 'CONTINUE'),
                            ),
                          ],
                        ),
                      ],
                    )
                  : const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getSpeakerColor(String speaker) {
    switch (speaker) {
      case 'Detective Blackwood':
        return Colors.blue[700]!;
      case 'Mrs. Reynolds':
        return Colors.brown[600]!;
      case 'Lady Victoria':
        return Colors.purple[600]!;
      case 'James Thornfield':
        return Colors.red[700]!;
      case 'Dr. Harlow':
        return Colors.green[700]!;
      default:
        return Colors.grey[600]!;
    }
  }
  
  void _nextDialogue() {
    setState(() {
      if (_currentDialogueIndex < _dialogueSequence.length - 1) {
        _currentDialogueIndex++;
      } else {
        // All dialogue complete, proceed to initial examination
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const InitialExamination()),
        );
      }
    });
  }
}