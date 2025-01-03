class Player {
  float fitness;
  Genome brain;
  int genomeInputs = 2;
  int genomeOutputs = 3;
  float[] vision = new float[genomeInputs];//the input array fed into the neuralNet
  float[] decision = new float[genomeOutputs]; //the out put of the NN
  float unadjustedFitness;
  int lifespan = 0;//how long the player lived for fitness
  int bestScore =0;//stores the score achieved used for replay
  boolean dead;
  int score;
  int gen = 0;
  int runCount = -5;
  boolean replay = false;

  float y= height/2;

  float x= 50;
  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  //constructor

  Player() {
    brain = new Genome(genomeInputs, genomeOutputs);
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  void show() {
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<replace
    fill(0, 255, 0);  // Green color
    rect(x, y, 50, 100);

    runCount++;
    if (runCount > 5) {
      runCount = -5;
    }
  }

  void incrementCounters() {
    score+=1;
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  void move() {
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  void update() {
    incrementCounters();
    think();
   
    
  }
  //----------------------------------------------------------------------------------------------------------------------------------------------------------

void look() {
  if (!replay) {
    float minDistance = Float.MAX_VALUE;
    int minIndex = -1;

    for (int i = 0; i < enemies.size(); i++) {
      float distance = enemies.get(i).x + 50 - (x - 25); 
      if (distance < minDistance && distance > 0) {
        minDistance = distance;
        minIndex = i;
      }
    }

    if (minIndex == -1) { // If there are no enemies
      vision[0] = 0; //set to 0 if no enemy is found
    } else {
      vision[0] = enemies.get(minIndex).y; // Set to Y coordinate of the nearest enemy
    }
    vision[1]= y;
  }
}


  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  //gets the output of the brain then converts them to actions
  void think() {

    for (Enemy enemy : enemies) {
      if (enemy.collided(50, y, 60, 100)) {
        dead = true;
      }
    }
    
    
    if(NEAT){
    float max = 0;
    int maxIndex = 0;
    //get the output of the neural network
    decision = brain.feedForward(vision);

    for (int i = 0; i < decision.length; i++) {
      if (decision[i] > max) {
        max = decision[i];
        maxIndex = i;
      }
    }
    
    

    switch(maxIndex) {
    case 0:
      //moveup
      y+=10;
      break;
    case 1:
      //movedown
      y-=10;
      break;
     case 2:
       break;
    }
    }
    
    if (y < 0) {
      y = 0;
    } else if (y > height - 100) {
      y = height - 100;
    }

    
  }

  //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<replace



  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  //returns a clone of this player with the same brian
  Player clone() {
    Player clone = new Player();
    clone.brain = brain.clone();
    clone.fitness = fitness;
    clone.brain.generateNetwork();
    clone.gen = gen;
    clone.bestScore = score;
    return clone;
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //since there is some randomness in games sometimes when we want to replay the game we need to remove that randomness
  //this fuction does that

  Player cloneForReplay() {
    Player clone = new Player();
    clone.brain = brain.clone();
    clone.fitness = fitness;
    clone.brain.generateNetwork();
    clone.gen = gen;
    clone.bestScore = score;
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<replace
    return clone;
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  //fot Genetic algorithm
  void calculateFitness() {
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<replace
    fitness = score;
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  Player crossover(Player parent2) {
    Player child = new Player();
    child.brain = brain.crossover(parent2.brain);
    child.brain.generateNetwork();
    return child;
  }
}
