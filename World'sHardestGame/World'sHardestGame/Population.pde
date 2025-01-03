class Population {
  Dot[] dots;
  
  int TestNumber = 1;

  float fitnessSum;
  int gen = 1;

  int bestDot = 0;//the index of the best dot in the dots[]

  int minStep = 1000;
  
  int ParallelPopNumber = 0;

  Population(int size) {
    dots = new Dot[size];
    for (int i = 0; i< size; i++) {
      dots[i] = new Dot();
    }
  }


  //------------------------------------------------------------------------------------------------------------------------------
  //show all dots
  void show() {
    for (int i = 1; i< dots.length; i++) {
      dots[i].show();
    }
    dots[0].show();
  }

  //-------------------------------------------------------------------------------------------------------------------------------
  //update all dots 
  void update() {
    for (int i = 0; i< dots.length; i++) {
      if (dots[i].brain.step > minStep) {//if the dot has already taken more steps than the best dot has taken to reach the goal
        dots[i].dead = true;//then it dead
      } else {
        dots[i].update();
      }
    }
  }

  //-----------------------------------------------------------------------------------------------------------------------------------
  //calculate all the fitnesses
  void calculateFitness() {
    for (int i = 0; i< dots.length; i++) {
      dots[i].calculateFitness(lvl.goals.get(lvl.currentGoalIndex));
    }
  }


  //------------------------------------------------------------------------------------------------------------------------------------
  //returns whether all the dots are either dead or have reached the goal
  boolean allDotsDead() {
    for (int i = 0; i< dots.length; i++) {
      if (!dots[i].dead && !dots[i].reachedGoal) { 
        return false;
      }
    }

    return true;
  }



  //-------------------------------------------------------------------------------------------------------------------------------------

  //gets the next generation of dots
  void naturalSelection() {
    Dot[] newDots = new Dot[dots.length];//next gen
    setBestDot();
    calculateFitnessSum();

    //the champion lives on 
    newDots[0] = dots[bestDot].gimmeBaby();
    newDots[0].isBest = true;
    for (int i = 1; i< newDots.length; i++) {
      //select parent based on fitness
      Dot parent = selectParent();

      //get baby from them
      newDots[i] = parent.gimmeBaby();
    }

    dots = newDots.clone();
    gen ++;
  }


  //--------------------------------------------------------------------------------------------------------------------------------------
  //you get it
  void calculateFitnessSum() {
    fitnessSum = 0;
    for (int i = 0; i< dots.length; i++) {
      fitnessSum += dots[i].fitness;
    }
  }

  //-------------------------------------------------------------------------------------------------------------------------------------

  //chooses dot from the population to return randomly(considering fitness)

  //this function works by randomly choosing a value between 0 and the sum of all the fitnesses
  //then go through all the dots and add their fitness to a running sum and if that sum is greater than the random value generated that dot is chosen
  //since dots with a higher fitness function add more to the running sum then they have a higher chance of being chosen
  Dot selectParent() {
    float rand = random(fitnessSum);
    float runningSum = 0;

    for (int i = 0; i< dots.length; i++) {
      runningSum+= dots[i].fitness;
      if (runningSum > rand) {
        return dots[i];
      }
    }

    //should never get to this point

    return null;
  }

  //------------------------------------------------------------------------------------------------------------------------------------------
  //mutates all the brains of the babies
  void mutateDemBabies() {
    for (int i = 1; i< dots.length; i++) {
      dots[i].brain.mutate();
    }
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------
  //finds the dot with the highest fitness and sets it as the best dot
  void setBestDot() {
    float max = 0;
    int maxIndex = 0;
    for (int i = 0; i< dots.length; i++) {
      if (dots[i].fitness > max) {
        max = dots[i].fitness;
        maxIndex = i;
      }
    }

    bestDot = maxIndex;
    
    JSONObject data = new JSONObject();
    data.setInt("value1", TestNumber); 
    if(genetic){
      data.setInt("value2", test.gen);
    }
    if(Parellel){
      data.setInt("value2", ParellelPop.get(0).gen);
      
    }
    data.setFloat("value3", dots[bestDot].fitness);
    data.setInt("value4", dots[bestDot].brain.step);
 
 
    

    //if this dot reached the goal then reset the minimum number of steps it takes to get to the goal
    if (dots[bestDot].reachedGoal) {
      minStep = dots[bestDot].brain.step;
      println("step:", minStep);
      data.setString("value5", "Yes");
    }
    else{
      data.setString("value5", "No");
  }
  
  if(Parellel){
      data.setInt("value6", ParallelPopNumber);
      
    }
  //sendDataToGoogleSheets(data);
  }
  
   // Migration method to transfer individuals to another population
    void migrate(Population otherPop, int migrationCount) {
        for (int i = 0; i < migrationCount; i++) {
            int randomIndex = (int) random(dots.length);
            Dot migratingDot = dots[randomIndex].gimmeBaby(); // Assuming clone() creates a deep copy of the Dot
            
            // Add migratingDot to the other population
            otherPop.addDot(migratingDot);
            
            // Optionally remove the migrated dot from this population
            removeDot(randomIndex);
        }
    }

    // Method to add a dot to the population
    void addDot(Dot dot) {
        // Resize array and add the dot (this is a simplified version)
        dots = Arrays.copyOf(dots, dots.length + 1);
        dots[dots.length - 1] = dot;
    }

    // Remove a dot from the population
    void removeDot(int index) {
        if (index < 0 || index >= dots.length) return; // Index out of bounds
        dots[index] = dots[dots.length - 1]; // Swap with the last dot
        dots = Arrays.copyOf(dots, dots.length - 1); // Reduce array size by 1
    }
}
