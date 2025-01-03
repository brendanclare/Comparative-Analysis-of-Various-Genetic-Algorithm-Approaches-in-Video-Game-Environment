class Player {
  float NEATfitness;
  Genome Brain;
  float[] vision = new float[6];//the input array fed into the neuralNet 
  float[] decision = new float[4]; //the out put of the NN 
  float unadjustedFitness;
  int lifespan = 0;//how long the player lived for fitness
  int bestScore =0;//stores the score achieved used for replay
  boolean dead;
  int score;
  int gen = 0;
  int step= 0;
  
  int genomeInputs = 6;
  int genomeOutputs = 4;
  
  
  
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

  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  //constructor

  Player() {
    Brain = new Genome(genomeInputs,genomeOutputs);
    if(lvl.LevelNumber==1){
        pos = new PVector(200, 300);
        }
        else{
          pos = new PVector(350, 300);
        } 
        vel = new PVector(0, 0);
        acc = new PVector(0, 0);
  
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  void show() {
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<replace
    noStroke();
    fill(0, 0, 255); 
    rect(pos.x, pos.y, 35, 35);
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  void move() {
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<replace
    think();
    vel.add(acc);
    vel.limit(5); // Limit speed
    pos.add(vel);
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  void update() {
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<replace
      
      
      if (lvl.checkGoalCollision(pos, lvl.goals.get(lvl.currentGoalIndex))) {
        reachedGoal= true;
       }

    if(GoalsReached >= lvl.goals.size()){
      reachedGoal = true;
    }
    
     if (!dead){
       if(step>= 1000){
         dead= true;
       }}
    
    
    
    if (!dead && !reachedGoal) {
        step++;
        move();
        look();

        // Check if the dot reaches the edges of the window
        if (pos.x < 2 || pos.y < 2 || pos.x > width - 2 || pos.y > height - 2) {
            dead = true; 
        } 
        // Check for collisions with boundaries or enemies
        else if (lvl.checkCollision(pos) || lvl.checkCollisionWithEnemies(pos)){
            dead = true;
        }
        
         }
         
    //  if(reachedGoal){
    //  fill(140, 140, 140);
    //  text("Goal Reached In  " +step +" Moves", 1300, 130);
    //}
  }
  //----------------------------------------------------------------------------------------------------------------------------------------------------------

  void look() {
    vision[0] = pos.x;
    vision[1]= pos.y;
    
    PVector NearestEnemyPos =  lvl.FindNearestEnemy(pos);
    
    vision[2] = NearestEnemyPos.x;
    vision[3]= NearestEnemyPos.y;
    
    vision[4] = lvl.goal.x;
    vision[5]= lvl.goal.y;
  }




 

  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  //gets the output of the brain then converts them to actions
  void think() {

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
    
    switch(maxIndex){
      case 0:
          //vel.y = 0; // Reset vertical velocity
        vel.y -= 2; // Move up
        break;
    
    case 1:
        vel.y += 2; // Move down
        break;
    
    //p.vel.x = 0; // Reset horizontal velocity
    //if (left) {
      case 2:
        vel.x -= 2; // Move left
        break;
    
    case 3:
        vel.x += 2; // Move right
        break;
    
      
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
  void calculateFitness(PVector goal) {
    if (reachedGoal) {//if the dot reached the goal then the fitness is based on the amount of steps it took to get there
      fitness = 1.0/16.0 + 10000.0/(float)(step * step);
    } else {//if the dot didn't reach the goal then the fitness is based on how close it is to the goal
      float distanceToGoal = dist(pos.x, pos.y, goal.x, goal.y);
      fitness = 1.0/(distanceToGoal * distanceToGoal);
    }
  }

  
  
  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  Player crossover(Player parent2) {
    Player child = new Player();
    child.Brain = Brain.crossover(parent2.Brain);
    child.Brain.generateNetwork();
    return child;
  }
}
