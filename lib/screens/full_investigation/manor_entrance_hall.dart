import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game_state.dart';
import '../../widgets/game_top_bar.dart';
import '../conclusion_phase.dart';
import 'study.dart';
import 'conservatory.dart';
import 'smoking_room.dart';
import 'guest_room.dart';
import 'kitchen.dart';

class ManorEntranceHall extends StatelessWidget {
  const ManorEntranceHall({super.key});
  
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    
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
            locationName: 'Manor Entrance Hall',
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
                    'Investigation Hub',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Description
                  const Text(
                    'The grand entrance hall serves as the heart of Thornfield Manor. From here, you can access all areas of the house to continue your investigation. The storm continues to rage outside, ensuring no one can leave.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Investigation status
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
                            Icon(Icons.assignment, color: Colors.blue[300], size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'Investigation Progress',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              'Evidence Found: ${gameState.evidenceCount}/5',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Interviews: ${gameState.characterInterviewed.values.where((interviewed) => interviewed).length}/4',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        if (gameState.evidenceCount > 0) ...[
                          const SizedBox(height: 8),
                          const Text(
                            'Collected Evidence:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                            ),
                          ),
                          ...gameState.getCollectedEvidence().map((evidence) => Padding(
                            padding: const EdgeInsets.only(left: 16, top: 2),
                            child: Text(
                              '• $evidence',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white60,
                              ),
                            ),
                          )),
                        ],
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Locations - Compact vertical list
                  Column(
                    children: [
                      _buildCompactLocationButton(
                        context,
                        'The Study',
                        'Lord William\'s private office',
                        Icons.book,
                        Colors.red[700]!,
                        gameState.locationVisited[1],
                        _getLocationEvidenceCount(gameState, 1),
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const StudyScreen()),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildCompactLocationButton(
                        context,
                        'The Kitchen',
                        'Where the fatal tea was prepared',
                        Icons.kitchen,
                        Colors.brown[700]!,
                        gameState.locationVisited[2],
                        _getLocationEvidenceCount(gameState, 2),
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const KitchenScreen()),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildCompactLocationButton(
                        context,
                        'The Conservatory',
                        'Lady Victoria\'s retreat',
                        Icons.local_florist,
                        Colors.green[700]!,
                        gameState.locationVisited[3],
                        0,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ConservatoryScreen()),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildCompactLocationButton(
                        context,
                        'Smoking Room',
                        'James\'s preferred sanctuary',
                        Icons.smoking_rooms,
                        Colors.orange[700]!,
                        gameState.locationVisited[4],
                        0,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SmokingRoomScreen()),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildCompactLocationButton(
                        context,
                        'Guest Room',
                        'Dr. Harlow\'s temporary office',
                        Icons.medical_services,
                        Colors.cyan[700]!,
                        gameState.locationVisited[5],
                        0,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const GuestRoomScreen()),
                        ),
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ConclusionPhase()),
                          ),
                          icon: const Icon(Icons.gavel),
                          label: const Text('CONCLUDE INVESTIGATION'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
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
  
  Widget _buildCompactLocationButton(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    bool visited,
    int evidenceCount,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: visited ? color : color.withOpacity(0.3),
            width: visited ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: color,
                ),
                if (visited)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 8,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            if (evidenceCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$evidenceCount Evidence',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.white54,
            ),
          ],
        ),
      ),
    );
  }
  
  int _getLocationEvidenceCount(GameState gameState, int locationId) {
    switch (locationId) {
      case 1: // Study - Evidence 3 and 4
        int count = 0;
        if (gameState.evidenceList[3]) count++; // Modified Will
        if (gameState.evidenceList[4]) count++; // Business Ledger
        return count;
      case 2: // Kitchen - Evidence 5
        return gameState.evidenceList[5] ? 1 : 0; // Tea Canister
      default:
        return 0;
    }
  }
}