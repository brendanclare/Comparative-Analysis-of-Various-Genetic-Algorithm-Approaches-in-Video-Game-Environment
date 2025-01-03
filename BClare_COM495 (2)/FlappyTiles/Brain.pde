class Brain {
  float[] directions;//series of vectors which get the dot to the goal (hopefully)
  int step = 0;


  Brain(int size) {
    directions = new float[size];
    randomize();
  }

  //--------------------------------------------------------------------------------------------------------------------------------
  //sets all the vectors in directions to a random vector with length 1
  void randomize() {
    for (int i = 0; i< directions.length; i++) {
      float randomNumber = random(0,2);
      directions[i] = randomNumber;
    }
  }

  //-------------------------------------------------------------------------------------------------------------------------------------
  //returns a perfect copy of this brain object
  Brain clone() {
    Brain clone = new Brain(directions.length);
    for (int i = 0; i < directions.length; i++) {
      clone.directions[i] = directions[i]; // Directly copy the float value
    }

    return clone;

  }

  //----------------------------------------------------------------------------------------------------------------------------------------

  //mutates the brain by setting some of the directions to random vectors
  void mutate() {
    float mutationRate = 0.01;//chance that any vector in directions gets changed
    for (int i =0; i< directions.length; i++) {
      float rand = random(1);
      if (rand < mutationRate) {
        float randomNumber = random(0,2);
        directions[i] = randomNumber;
      }
    }
  }
}
