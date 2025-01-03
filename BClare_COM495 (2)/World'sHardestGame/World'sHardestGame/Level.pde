
class level {
  //int goalx;
  //int goaly;
  int LevelNumber = 1;
  int GoalsRequired;
  int currentGoalIndex =0;
  PVector goal;
  int GoalNeeded= 1;
  
  float nearestDistance =0;
  Enemy nearestEnemy;
  float distance;


  // List of boundary lines, each represented as [x1, y1, x2, y2]
  ArrayList<float[]> boundaries = new ArrayList<float[]>();
  ArrayList<Enemy> enemies = new ArrayList<Enemy>();
  ArrayList<PVector> goals = new ArrayList<PVector>();

  level() {
    setupLevel1();
 
  }

  void setupLevel1() {
    goals.clear();
    LevelNumber = 1;
    
    //goalx = 1300;
    //goaly = 500;
    goals.add(new PVector (1300, 500));
    goal = goals.get(currentGoalIndex);

    boundaries.clear();
    enemies.clear();

    //DotPos= new PVector(200, 300);

    boundaries.add(new float[]{300, 100, 1200, 100});
    boundaries.add(new float[]{1200, 100, 1200, 400});
    boundaries.add(new float[]{1200, 400, 1400, 400});
    boundaries.add(new float[]{1400, 400, 1400, 600});
    boundaries.add(new float[]{1400, 600, 1200, 600});
    boundaries.add(new float[]{1200, 600, 1200, 800});
    boundaries.add(new float[]{1200, 800, 300, 800});
    boundaries.add(new float[]{300, 800, 300, 400});
    boundaries.add(new float[]{300, 400, 100, 400});
    boundaries.add(new float[]{100, 400, 100, 400});
    boundaries.add(new float[]{100, 400, 100, 200});
    boundaries.add(new float[]{100, 200, 300, 200 });
    boundaries.add(new float[]{300, 200, 300, 100});

    for (int i = 0, x = 325; x <= 1200; i++, x += 75) {
    if (i % 2 == 0) {
        enemies.add(new Enemy(x, 400, -14, 100, 800));
    } else {
        enemies.add(new Enemy(x, 400, 14, 100, 800));  
    }
}


  }

  void setupLevel2() {
    goals.clear();
    
    LevelNumber = 2;
    boundaries.clear();
    enemies.clear();
    goals.add(new PVector (700, 200));
    goals.add(new PVector(900, 200));
    goals.add(new PVector(1100, 750));
    goals.add(new PVector(300, 775));
    
 
    goal = goals.get(currentGoalIndex);
    

    if (!humanPlaying) {
      for (int i = 1; i < test.dots.length; i++) {
        test.dots[i].pos = new PVector(250, 350);
      }
    } else {
      p.pos = new PVector(250, 350);
    }

    boundaries.add(new float[]{750, 50, 1050, 200});    
    boundaries.add(new float[]{1050, 200, 1450, 200});  
    boundaries.add(new float[]{1450, 200, 1200, 700});  
    boundaries.add(new float[]{1200, 700, 1300, 850}); 
    boundaries.add(new float[]{1300, 850, 750, 750});   
    boundaries.add(new float[]{750, 750, 200, 850});    // Center bottom to bottom left
    boundaries.add(new float[]{200, 850, 300, 700});    // Bottom left to left
    boundaries.add(new float[]{300, 700, 50, 200});     // Left to left upper
    boundaries.add(new float[]{50, 200, 450, 200});     // Left upper to right upper
    boundaries.add(new float[]{450, 200, 750, 50});     // Right upper to top (closing the star)

 
    boundaries.add(new float[]{750, 250, 850, 300});    // Top point to right upper
    boundaries.add(new float[]{850, 300, 1050, 300});   // Right upper to right
    boundaries.add(new float[]{1050, 300, 950, 550});   // Right to bottom right
    boundaries.add(new float[]{950, 550, 1000, 650});   // Bottom right to bottom
    boundaries.add(new float[]{1000, 650, 750, 600});   // Bottom to center bottom
    boundaries.add(new float[]{750, 600, 500, 650});    // Center bottom to bottom left
    boundaries.add(new float[]{500, 650, 550, 550});    // Bottom left to left
    boundaries.add(new float[]{550, 550, 450, 300});    // Left to left upper
    boundaries.add(new float[]{450, 300, 650, 300});    // Left upper to right upper
    boundaries.add(new float[]{650, 300, 750, 250});    // Right upper to top (closing the star)

    boundaries.add(new float[]{500, 650, 300, 700});

  
    enemies.add(new Enemy(750, 250, 14, 100, 600));   
    enemies.add(new Enemy(1050, 525, 12, 100, 750));  
    enemies.add(new Enemy(900, 750, 10, 100, 850));   
    enemies.add(new Enemy(600, 750, -8, 100, 850));    
    enemies.add(new Enemy(450, 525, -12, 100, 750));
  }

void drawLevel() {
    int maxGoalsReached = 0;
    GoalsRequired= goals.size();
    
    if(humanPlaying){
     if(checkGoalCollision(p.pos, goals.get(currentGoalIndex))){
       p.GoalsReached++;
      
     }
      
    }
    if(genetic){
    
       for (int i = 0; i < test.dots.length; i++) {
        if (checkGoalCollision(test.dots[i].pos, goals.get(currentGoalIndex))){
            // Increment goals reached if the dot hasn't counted this goal yet

                test.dots[i].GoalsReached++;
           
        }

        if (test.dots[i].GoalsReached > maxGoalsReached) {
            maxGoalsReached = test.dots[i].GoalsReached;
        }
    }
    }
    
    if(Parellel){
       for (int i= 0; i< ParellelPop.size(); i++){
         for (int j = 0; j < ParellelPop.get(i).dots.length; j++) {
          if (checkGoalCollision(ParellelPop.get(i).dots[j].pos, goals.get(currentGoalIndex))){
              // Increment goals reached if the dot hasn't counted this goal yet
    
                  ParellelPop.get(i).dots[j].GoalsReached++;
             
          }
    
          if (ParellelPop.get(i).dots[j].GoalsReached > maxGoalsReached) {
              maxGoalsReached = ParellelPop.get(i).dots[j].GoalsReached;
          }
      }
      }}
    
    
//   if (NEAT) {
//    for (int i = 0; i < pop.pop.size(); i++) {
//        Player player = pop.pop.get(i); 
//        if (checkGoalCollision(player.pos, goals.get(currentGoalIndex))) {
//            player.GoalsReached++;
//        }

//        if (player.GoalsReached > maxGoalsReached) {
//            maxGoalsReached = player.GoalsReached;
//        }
//    }
//}

if(humanPlaying){
  if (checkGoalCollision(p.pos, goals.get(currentGoalIndex))){
    p.GoalsReached++;
    maxGoalsReached= p.GoalsReached;
}
  
}

      

    // Update the current goal index only after checking all dots
    currentGoalIndex = Math.min(maxGoalsReached, goals.size() - 1);
    
    // Draw the current goal
    PVector goal = goals.get(currentGoalIndex);
    
    
    fill(0, 255, 0);
    ellipse(goal.x, goal.y, 20, 20);  // Goal as a green circle

    // Draw all goals with different colors for visited/unvisited
    for (int i = 0; i < goals.size(); i++) {
        PVector goa = goals.get(i);

        if (i == currentGoalIndex) {
            fill(0, 255, 0);  // Green for the current goal
        } else {
            fill(255, 255, 0);  // Yellow for other goals
        }

        ellipse(goa.x, goa.y, 20, 20);  // Draw goal
    }

    // Draw boundaries and enemies
    stroke(0);
    strokeWeight(4);
    for (float[] boundary : boundaries) {
        line(boundary[0], boundary[1], boundary[2], boundary[3]);
    }

    for (Enemy enemy : enemies) {
        enemy.update();
        enemy.display();
    }
}

boolean checkGoalCollision(PVector pos, PVector currentGoal) {
    float dotSize = 35; // Size of the dot (30x30)
    float halfSize = dotSize / 2;
    float goalSize = 25; // Diameter of the goal
    float goalRadius = goalSize / 2;

    // Calculate the distance between the dot's center and the current goal's center
    float distance = dist(pos.x + halfSize, pos.y + halfSize, currentGoal.x, currentGoal.y);

    // Check for collision using the radius of both shapes
    return distance < halfSize + goalRadius; // Return true if collision detected
}



  
  
  boolean checkCollision(PVector dotPos) {
    float rectWidth = 35;
    float rectHeight = 35;

    // Define the four corners of the rectangle
    PVector topLeft = new PVector(dotPos.x, dotPos.y);
    PVector topRight = new PVector(dotPos.x + rectWidth, dotPos.y);
    PVector bottomLeft = new PVector(dotPos.x, dotPos.y + rectHeight);
    PVector bottomRight = new PVector(dotPos.x + rectWidth, dotPos.y + rectHeight);

    // Loop through all boundaries (lines)
    for (float[] boundary : boundaries) {
        PVector lineStart = new PVector(boundary[0], boundary[1]);
        PVector lineEnd = new PVector(boundary[2], boundary[3]);

        // Check if any of the four edges of the rectangle intersect with the boundary
        if (lineIntersectsLine(topLeft, topRight, lineStart, lineEnd) ||
            lineIntersectsLine(topRight, bottomRight, lineStart, lineEnd) ||
            lineIntersectsLine(bottomRight, bottomLeft, lineStart, lineEnd) ||
            lineIntersectsLine(bottomLeft, topLeft, lineStart, lineEnd)) {
            return true; // Collision detected
        }
    }

    return false; // No collision
}

// Function to check if two line segments intersect
boolean lineIntersectsLine(PVector p1, PVector p2, PVector p3, PVector p4) {
    float denom = (p4.y - p3.y) * (p2.x - p1.x) - (p4.x - p3.x) * (p2.y - p1.y);

    // If denom is zero, lines are parallel
    if (denom == 0) {
        return false;
    }

    float ua = ((p4.x - p3.x) * (p1.y - p3.y) - (p4.y - p3.y) * (p1.x - p3.x)) / denom;
    float ub = ((p2.x - p1.x) * (p1.y - p3.y) - (p2.y - p1.y) * (p1.x - p3.x)) / denom;

    // If ua and ub are between 0 and 1, the lines intersect
    if (ua >= 0 && ua <= 1 && ub >= 0 && ub <= 1) {
        return true;
    }

    return false;
}

  
  boolean checkCollisionWithEnemies(PVector pos) {
    float dotSize = 30; 
    float halfSize = dotSize / 2;

    for (Enemy enemy : enemies) {
      PVector enemyPos = enemy.position; // Get enemy position
      float enemySize = 35; // Diameter of the enemy circle
      float enemyRadius = enemySize / 2;

      // Calculate the distance between the dot's center and the enemy's center
      float distance = dist(pos.x + halfSize, pos.y + halfSize, enemyPos.x, enemyPos.y);

      // Check for collision using the radius of both shapes
      if (distance < halfSize + enemyRadius) {
        return true; // Collision detected
      }
    }
    return false; // No collision
  }
  
PVector FindNearestEnemy(PVector pos) {
    if (pos == null || enemies == null || enemies.isEmpty()) {
        return null; // Handle null cases
    }

    PVector nearestEnemyPos = null;
    float nearestDistance = Float.MAX_VALUE; // Set to max float initially
    float dotSize = 35;
    float halfSize = dotSize / 2;

    for (Enemy enemy : enemies) {
        if (enemy == null || enemy.position == null) {
            continue; // Skip null enemies
        }

        PVector enemyPos = enemy.position;
        //float enemySize = 25;
        //float enemyRadius = enemySize / 2;

        // Calculate the distance between the dot's center and the enemy's center
        float distance = dist(pos.x + halfSize, pos.y + halfSize, enemyPos.x, enemyPos.y);

        // Check if this enemy is closer than the current nearest
        if (distance < nearestDistance) {
            nearestDistance = distance;
            nearestEnemyPos = enemyPos;
        }
    }

    return nearestEnemyPos; // Return the position of the nearest enemy
}

  
  void ResetEnemy() {
    for (Enemy enemy : enemies) {
      enemy.reset();
    }
  }
}
