class Dot {
 
  Brain brain;

  boolean dead = false;
  boolean reachedGoal = false;
  boolean isBest = false;//true if this dot is the best dot from the previous generation

  float fitness = 0;
  int score;
  
  float y= height/2;

  float x= 50;
  
  color DotColor;
  
  int start = millis();
  

  Dot() {
    brain = new Brain(100000);//new brain with 1000 instructions
    //draws the dot on the screen
  
      
    

}
  


  //-----------------------------------------------------------------------------------------------------------------
  //draws the dot on the screen
  void show() {
    if(!dead){
      fill(DotColor);
    rect(x, y, 50, 100);
    }
 
  }

  //-----------------------------------------------------------------------------------------------------------------------
  //moves the dot according to the brains directions
  void move() {
    if(!dead){
    if (brain.directions.length > brain.step) {//if there are still directions left then set the acceleration as the next PVector in the direcitons array
      //acc = brain.directions[brain.step];
      float direction = brain.directions[brain.step];
      //print(direction);

        if (direction < 1) {
            //move up
            y += 10;
        } else if (direction < 2) {
            //move down
            y -= 10;
        } else if (direction < 3) {
            // other case, no movement
        }

        brain.step++;

    } else {//if at the end of the directions array then the dot is dead
      dead = true;
    }
    
    }

    ////apply the acceleration and move the dot
    //vel.add(acc);
    //vel.limit(5);//not too fast
    //pos.add(vel);
  }

  //-------------------------------------------------------------------------------------------------------------------
  //calls the move function and check for collisions and stuff
  void update() {
    if(!dead){
    //score = (millis() - start) / 1000;
    score ++;
    for (Enemy enemy : enemies) {
      if (enemy.collided(50, y, 60, 100)) {
        dead = true;
      }
    }
     if (y < 0) {
      y = 0;
    } else if (y > height - 120) {
      y = height - 120;
    }
    move();
  }
  }


  //--------------------------------------------------------------------------------------------------------------------------------------
  //calculates the fitness
  void calculateFitness() {
    fitness= score;
  }

  //---------------------------------------------------------------------------------------------------------------------------------------
  //clone it 
  Dot gimmeBaby() {
    Dot baby = new Dot();
    baby.brain = brain.clone();//babies have the same brain as their parents
    baby.DotColor= this.DotColor;
    return baby;
  }
}
