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
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    
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
          
          // Main content using responsive layout
          SafeArea(
            child: Column(
              children: [
                // Top bar
                const GameTopBar(
                  locationName: 'Manor Entrance Hall',
                ),
                
                // Main scrollable content area
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            'Investigation Hub',
                            style: TextStyle(
                              fontSize: screenWidth * 0.065,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          
                          SizedBox(height: screenHeight * 0.015),
                          
                          // Compact description
                          Text(
                            'From the manor\'s entrance hall, access all investigation areas. The storm ensures no one can leave.',
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              color: Colors.white,
                              height: 1.3,
                            ),
                          ),
                          
                          SizedBox(height: screenHeight * 0.02),
                          
                          // Compact investigation status
                          Container(
                            padding: EdgeInsets.all(screenWidth * 0.03),
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
                                    Icon(Icons.assignment, color: Colors.blue[300], size: screenWidth * 0.045),
                                    SizedBox(width: screenWidth * 0.02),
                                    Text(
                                      'Progress',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                Row(
                                  children: [
                                    Text(
                                      'Evidence: ${gameState.evidenceCount}/5',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.035,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'Interviews: ${gameState.characterInterviewed.values.where((interviewed) => interviewed).length}/4',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.035,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                if (gameState.evidenceCount > 0) ...[
                                  SizedBox(height: screenHeight * 0.008),
                                  Text(
                                    'Evidence: ${gameState.getCollectedEvidence().join(", ")}',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.03,
                                      color: Colors.white60,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          
                          SizedBox(height: screenHeight * 0.025),
                          
                          // Compact room buttons
                          _buildCompactLocationButton(
                            context,
                            'The Study',
                            'Lord William\'s office',
                            Icons.book,
                            Colors.red[700]!,
                            gameState.locationVisited[1],
                            _getLocationEvidenceCount(gameState, 1),
                            screenWidth,
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const StudyScreen()),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.008),
                          _buildCompactLocationButton(
                            context,
                            'The Kitchen',
                            'Where tea was prepared',
                            Icons.kitchen,
                            Colors.brown[700]!,
                            gameState.locationVisited[2],
                            _getLocationEvidenceCount(gameState, 2),
                            screenWidth,
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const KitchenScreen()),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.008),
                          _buildCompactLocationButton(
                            context,
                            'The Conservatory',
                            'Lady Victoria\'s retreat',
                            Icons.local_florist,
                            Colors.green[700]!,
                            gameState.locationVisited[3],
                            0,
                            screenWidth,
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ConservatoryScreen()),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.008),
                          _buildCompactLocationButton(
                            context,
                            'Smoking Room',
                            'James\'s sanctuary',
                            Icons.smoking_rooms,
                            Colors.orange[700]!,
                            gameState.locationVisited[4],
                            0,
                            screenWidth,
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SmokingRoomScreen()),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.008),
                          _buildCompactLocationButton(
                            context,
                            'Guest Room',
                            'Dr. Harlow\'s office',
                            Icons.medical_services,
                            Colors.cyan[700]!,
                            gameState.locationVisited[5],
                            0,
                            screenWidth,
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const GuestRoomScreen()),
                            ),
                          ),
                          
                          SizedBox(height: screenHeight * 0.025),
                          
                          // Conclusion button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ConclusionPhase()),
                              ),
                              icon: Icon(Icons.gavel, size: screenWidth * 0.045),
                              label: Text(
                                'CONCLUDE INVESTIGATION',
                                style: TextStyle(fontSize: screenWidth * 0.037),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple[700],
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                                textStyle: TextStyle(
                                  fontSize: screenWidth * 0.037,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          
                          // Extra bottom padding for safe scrolling
                          SizedBox(height: screenHeight * 0.02),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
    double screenWidth,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,
          vertical: screenWidth * 0.025,
        ),
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
                  size: screenWidth * 0.055,
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
                      child: Icon(
                        Icons.check,
                        size: screenWidth * 0.02,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: screenWidth * 0.025),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: screenWidth * 0.038,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: screenWidth * 0.028,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            if (evidenceCount > 0)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.015,
                  vertical: screenWidth * 0.008,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$evidenceCount',
                  style: TextStyle(
                    fontSize: screenWidth * 0.025,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            SizedBox(width: screenWidth * 0.015),
            Icon(
              Icons.arrow_forward_ios,
              size: screenWidth * 0.035,
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