class Player {
  float NEATfitness;
  Genome Brain;
  float[] vision = new float[16];//the input array fed into the neuralNet 
  float[] decision = new float[4]; //the out put of the NN 
  float unadjustedFitness;
  int lifespan = 0;//how long the player lived for fitness
  int bestScore =0;//stores the score achieved used for replay
  boolean dead;
  int score;
  int gen = 0;
  int step= 0;
  
  int genomeInputs = 16;
  int genomeOutputs = 4;
  int stepsSinceLastMoved= 0;
  
  
  
  PVector pos;
    PVector vel;
    PVector acc;
    Brain brain;
    int GoalsReached = 0;
    int GoalRequired = 1;

    boolean Playerdead = false;
    boolean reachedGoal = false;
    boolean isBest = false; // true if this dot is the best dot from the previous generation
    float fitness = 0;
    
    //PVector NearestEnemyPos;
    
     Tile[][] grid = new Tile[4][4];
    int tileSize = 200;

    
    boolean moved = false;

  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  //constructor

  Player() {
    Brain = new Genome(genomeInputs,genomeOutputs);
      grid = new Tile[4][4];
       for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
          grid[i][j] = new Tile(i, j, tileSize);
        }
      }
      addRandomTile();
      addRandomTile();
      }
  

  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  void show() {
      
      for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      //if (grid[i][j].value>0){
      grid[i][j].drawTile(300, 120);
    
  }
  }
      
      }
      
       // Method to increase score when tiles are combined
    void addScore(int tileValue) {
        score += tileValue; // Add the tile value to the current score
        stepsSinceLastMoved = 0;
    }

   

  
void update() {
  if(!dead){
  think();
  show();
  }
  
}

  //----------------------------------------------------------------------------------------------------------------------------------------------------------
void look() {
  int index = 0;
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      vision[index] = (grid[i][j].value);
      index++;
    }
  }
}








 

  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  //gets the output of the brain then converts them to actions
  void think() {
    step++;
    stepsSinceLastMoved++;
   
    
    if(isGameOver()){
        dead= true;
      }

    float max = 0;
    int maxIndex = 0;
    //get the output of the neural network
    decision = Brain.feedForward(vision);

    for (int i = 0; i < decision.length; i++) {
      if (decision[i] > max) {
        max = decision[i];
        maxIndex = i;
      }
    }
    
    boolean moved = false;
    switch(maxIndex){
      case 0:
        moved = moveUp();
        break;
    
    case 1:
   
        moved= moveDown();
        break;
   
      case 2:
        moved= moveRight();
        break;
    
    case 3:
        moved= moveLeft();
        break;
    }
    
    if(moved){
      addRandomTile();
    }
    
    if(stepsSinceLastMoved >= 100){
      dead = true;
    }
  
      
    
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<replace


  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  
  //returns a clone of this player with the same brian
  Player clone() {
    Player clone = new Player();
    clone.Brain = Brain.clone();
    clone.fitness = fitness;
    clone.Brain.generateNetwork(); 
    clone.gen = gen;
    clone.bestScore = score;
    return clone;
  }

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//since there is some randomness in games sometimes when we want to replay the game we need to remove that randomness
//this fuction does that

  Player cloneForReplay() {
    Player clone = new Player();
    clone.Brain = Brain.clone();
    clone.fitness = fitness;
    clone.Brain.generateNetwork();
    clone.gen = gen;
    clone.bestScore = score;
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<replace
    return clone;
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  void calculateFitness() {
    fitness= score;
  }

  
  
  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  Player crossover(Player parent2) {
    Player child = new Player();
    child.Brain = Brain.crossover(parent2.Brain);
    child.Brain.generateNetwork();
    return child;
  }
  
  boolean moveUp() {
  boolean moved = false;

  for (int i = 0; i < 4; i++) {
    int[] row = new int[4];
    for (int j = 0; j < 4; j++) {
      row[j] = grid[i][j].value;
    }

    int[] newRow = shiftRow(row);
    
    for (int j = 0; j < 4; j++) {
      if (grid[i][j].value != newRow[j]) {
        grid[i][j].setValue(newRow[j]);
        moved = true;
      }
    }
  }

  return moved;
}

boolean moveDown() {
  boolean moved = false;

  for (int i = 0; i < 4; i++) {
    int[] row = new int[4];
    for (int j = 0; j < 4; j++) {
      row[j] = grid[i][3 - j].value;
    }

    int[] newRow = shiftRow(row);

    for (int j = 0; j < 4; j++) {
      if (grid[i][3 - j].value != newRow[j]) {
        grid[i][3 - j].setValue(newRow[j]);
        moved = true;
      }
    }
  }

  return moved;
}

boolean moveLeft() {
  boolean moved = false;

  for (int j = 0; j < 4; j++) {
    int[] col = new int[4];
    for (int i = 0; i < 4; i++) {
      col[i] = grid[i][j].value;
    }

    int[] newCol = shiftRow(col);

    for (int i = 0; i < 4; i++) {
      if (grid[i][j].value != newCol[i]) {
        grid[i][j].setValue(newCol[i]);
        moved = true;
      }
    }
  }

  return moved;
}

boolean moveRight() {
  boolean moved = false;

  for (int j = 0; j < 4; j++) {
    int[] col = new int[4];
    for (int i = 0; i < 4; i++) {
      col[i] = grid[3 - i][j].value;
    }

    int[] newCol = shiftRow(col);

    for (int i = 0; i < 4; i++) {
      if (grid[3 - i][j].value != newCol[i]) {
        grid[3 - i][j].setValue(newCol[i]);
        moved = true;
      }
    }
  }

  return moved;
}


int[] shiftRow(int[] row) {
  int[] newRow = new int[4];
  int pos = 0;

  // Shift all non-zero tiles to the left
  for (int i = 0; i < 4; i++) {
    if (row[i] != 0) {
      newRow[pos] = row[i];
      pos++;
    }
  }

  // Now, merge adjacent tiles if they have the same value
  for (int i = 0; i < 3; i++) {
    if (newRow[i] != 0 && newRow[i] == newRow[i + 1]) {
      newRow[i] *= 2;  // Merge the tiles
      this.addScore(newRow[i]); // Add the merged tile value to the score
      newRow[i + 1] = 0; // Clear the next tile after merge
    }
  }

  // Shift again after merging to eliminate gaps
  int[] finalRow = new int[4];
  pos = 0;
  for (int i = 0; i < 4; i++) {
    if (newRow[i] != 0) {
      finalRow[pos] = newRow[i];
      pos++;
    }
  }

  return finalRow;
}

int tilePlacementCounter = 0; // Counter to track tile placements

// Function to add a random tile to an empty spot
void addRandomTile() {
  ArrayList<PVector> emptyTiles = new ArrayList<PVector>();
  
  // Find all empty tiles
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      if (grid[i][j].value == 0) {
        emptyTiles.add(new PVector(i, j));
      }
    }
  }

  // If there are empty tiles, place a new tile
  if (emptyTiles.size() > 0) {
    int fixedIndex = int(emptyTiles.size() - 1); // Fixed to always choose the last empty tile
    PVector fixedTile = emptyTiles.get(fixedIndex);
    
    // Determine the tile's value: 4 every 10th placement, otherwise 2
    int newValue = (tilePlacementCounter % 10 == 9) ? 4 : 2;
    
    grid[int(fixedTile.x)][int(fixedTile.y)].setValue(newValue);
    tilePlacementCounter++; // Increment the placement counter
  }
}


boolean isGameOver() {
  // Check if there are any empty tiles
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      if (grid[i][j].value == 0) {
        return false; // If any tile is empty, the game is not over
      }
    }
  }

  // Check for possible merges horizontally and vertically
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      // Check adjacent tiles horizontally
      if (j < 3 && grid[i][j].value == grid[i][j + 1].value) {
        return false;
      }
      // Check adjacent tiles vertically
      if (i < 3 && grid[i][j].value == grid[i + 1][j].value) {
        return false;
      }
    }
  }

  return true; // No empty spaces and no merges possible, game over
}
}
