class Dot {
    PVector pos;
    PVector vel;
    PVector acc;
    Brain brain;
    int GoalsReached = 0;
    int GoalRequired = 1;

    boolean dead = false;
    boolean reachedGoal = false;
    boolean isBest = false; // true if this dot is the best dot from the previous generation
    float fitness = 0;

  
    float[] vision = new float[8];//the input array fed into the neuralNet 
    float[] decision = new float[4]; //the out put of the NN 
    float unadjustedFitness;
    int lifespan = 0;//how long the player lived for fitness
    int bestScore =0;//stores the score achieved used for replay

    int score;
    int gen = 0;
  
    int genomeInputs = 13;
    int genomeOutputs = 4;

    Dot() {
        brain = new Brain(1000); // new brain with 1000 instructions
        if(lvl.LevelNumber==1){
        pos = new PVector(200, 300);
        }
        else{
          pos = new PVector(350, 300);
        } 
        vel = new PVector(0, 0);
        acc = new PVector(0, 0);
    }

    // Draws the dot on the screen
    void show() {
      if(!dead){
        if (isBest) {
            noStroke();
            fill(0, 255, 0);
            rect(pos.x, pos.y, 35, 35);
        } else {
            noStroke();
            fill(0, 0, 255); 
            rect(pos.x, pos.y, 35, 35);
        
      }
      }
      }

    // Moves the dot according to the brain's directions
    void move() {
        if(!humanPlaying){
          if (brain.directions.length > brain.step) {
              acc = brain.directions[brain.step];
              brain.step++;
          } else {
              dead = true; // End of directions
          }
  
          // Apply the acceleration
          vel.add(acc);
          vel.limit(5); // Limit speed
          pos.add(vel);
        }
        else{
  
          pos.add(vel);
        }
      
      
       
    }

  
void update() {
    if(GoalsReached >= lvl.goals.size()){
      reachedGoal = true;
    }
 
    if (!dead && !reachedGoal) {
        move();
        

        // Check if the dot reaches the edges of the window
        if (pos.x < 2 || pos.y < 2 || pos.x > width - 2 || pos.y > height - 2) {
            dead = true; // Outside window bounds
        } 
    
        // Check for collisions with boundaries or enemies
        else if (lvl.checkCollision(pos) || lvl.checkCollisionWithEnemies(pos)) {
            dead = true; // Collision detected
        }
        
      
    }
    if(reachedGoal){
      fill(140, 140, 140);
      text("Goal Reached In  " +brain.step +" Moves", 1300, 130);
    }
}


 void calculateFitness(PVector goal) {
    if (reachedGoal) {//if the dot reached the goal then the fitness is based on the amount of steps it took to get there
      fitness = 1.0/16.0 + 10000.0/(float)(brain.step * brain.step);
    } else {//if the dot didn't reach the goal then the fitness is based on how close it is to the goal
      float distanceToGoal = dist(pos.x, pos.y, goal.x, goal.y);
      fitness = 1.0/(distanceToGoal * distanceToGoal);
    }
  }




    // Clone the dot
    Dot gimmeBaby() {
        Dot baby = new Dot();
        baby.brain = brain.clone();// Babies have the same brain as their parents
        return baby;
    }
}
