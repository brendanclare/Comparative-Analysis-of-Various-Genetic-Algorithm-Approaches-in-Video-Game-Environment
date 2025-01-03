class Population { //<>//
  Dot[] dots;

  float fitnessSum;
  int gen =1;

  int bestDot = 0;//the index of the best dot in the dots[]

  int minStep = 100000;
  
  color populationColor;
  
  int ParallelPopNumber= 0;

 Population(int size) {
    dots = new Dot[size];
    
    // Assign a unique color for the whole population if Parallel is true
    if (Parallel) {
      populationColor = color(random(255), random(255), random(255));
    } else {
      populationColor = color(0, 255, 0);  // Default color when not in Parallel mode
    }

    for (int i = 0; i < size; i++) {
      dots[i] = new Dot();
      dots[i].DotColor = populationColor;  // Assign the population color to each dot
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
      dots[i].calculateFitness();
    }
  }


  //------------------------------------------------------------------------------------------------------------------------------------
  //returns whether all the dots are either dead or have reached the goal
  boolean allDotsDead() {
    for (int i = 0; i< dots.length; i++) {
      if (!dots[i].dead) { 
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
    data.setInt("value1", 2); 
    if(genetic){
      data.setInt("value2", test.gen);
    }
    if(Parallel){
      data.setInt("value2", ParallelPop.get(0).gen);
      data.setInt("value4", ParallelPopNumber);
      
    }
    data.setFloat("value3", dots[bestDot].fitness);
    
    
    
  //sendDataToGoogleSheets(data);
  }
  
}
