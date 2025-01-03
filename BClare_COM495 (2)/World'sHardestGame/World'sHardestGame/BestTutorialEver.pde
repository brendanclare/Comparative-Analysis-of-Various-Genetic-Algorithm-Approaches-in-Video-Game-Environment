import java.util.Arrays;
import controlP5.*;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;

Population test;

//PVector goal;
//= new PVector(400, 10);
level lvl;
boolean up = false;
boolean down = false;
boolean left = false;
boolean right = false;
boolean humanPlaying = false;
boolean NEAT = false;
boolean showNothing = false;
int nextConnectionNo = 1000;
PopulationNEAT pop;
boolean showBestEachGen = false;
int upToGen = 0;
boolean showBest = false;//true if only show the best of the previous generation
boolean runBest = false; //true if replaying the best ever game
Dot genPlayerTemp;
boolean runThroughSpecies = false;
Dot speciesChamp;
boolean Parellel = false;
boolean genetic = true;
ArrayList<Population> ParellelPop = new  ArrayList<Population>();
int PopDeadCounter;
float FrameRate = 60;
ControlP5 cp5;
int Attempts;
int TestNumb = 9;

Dot p;

void setup() {
  size(1800, 1000);
  //fullScreen();//size of the window
  cp5 = new ControlP5(this);
  
  cp5.addSlider("FrameRate")  
     .setPosition(40, 100)     
     .setRange(1, 300)           
     .setValue(60)              
     .setSize(200, 20);
     
  frameRate(FrameRate);

  frameRate(60);
  lvl= new level();
  //goal = new PVector(lvl.goalx, lvl.goaly);
  if(!humanPlaying){
  test = new Population(1000);//create a new population with 1000 members
  }
  else{
    p = new Dot();
  }
  if(NEAT){
    pop = new PopulationNEAT(1000);
  }

}


void draw() { 
  frameRate(FrameRate);
  background(255,200, 255);
  
  fill(200, 100, 100);
  
  //fill(255, 0, 255);
  text("Press H to play yourself", 1100, 40);
  
  text("Press L to go to next level", 1100, 70);
  
  text("Press N for NEAT", 1500,40);
  text("Press G for Genetic", 1500, 70);
  text("Press P for Parellel", 1500, 100);
  
  text("Level " +lvl.LevelNumber, 20, 80);
  
  
  lvl.drawLevel();
  if(genetic){
      textSize(30);
      fill(48, 115, 115);
      text("BClare World's Hardest Game Genetic Algorithm" , 400, 40);
      text("Generation "+ test.gen, 20,40);
      //test.TestNumber = TestNumb;
      //if(test.gen >= 1001){
      //  test = new Population(1000);
      //  TestNumb++;
      //}
      if (test.allDotsDead()) {
        //genetic algorithm
        lvl.ResetEnemy();
        test.calculateFitness();
        test.naturalSelection();
        test.mutateDemBabies();
      } else {
        //if any of the dots are still alive then update and then show them
      
        test.update();
        test.show();
    }
  }
   if(humanPlaying){
     text("Attempts: " + Attempts, 20, 40);
       if(p.dead){
         Attempts++;
        lvl.ResetEnemy();
        p = new Dot();
      }
      else{
        p.update();
        p.show();
      }
  }
if (Parellel & TestNumb < 12){
    textSize(30);
    fill(48, 115, 115);
    text("BClare World's Hardest Game Parallel Genetic Algorithm", 300, 40);
    text("Generation " + ParellelPop.get(0).gen, 20, 40);
    
    //for (int i= 0; i< ParellelPop.size(); i++){
    //        ParellelPop.get(i).TestNumber = TestNumb;
        
    //   }
    
    //  if(ParellelPop.get(0).gen > 1000){
    //    TestNumb++;
    //    ParellelPop.clear();
    //    ParellelPop.add(new Population(200));
    //    ParellelPop.add(new Population(200));
    //    ParellelPop.add(new Population(200));
    //     ParellelPop.add(new Population(200));
    //     ParellelPop.add(new Population(200));
         
    //     for (int i= 0; i< ParellelPop.size(); i++){
    //       ParellelPop.get(i).ParallelPopNumber = i +1;
    //        ParellelPop.get(i).TestNumber = TestNumb;
        
    //   }
        
        
    //  }
    
    int PopDeadCounter = 0; // Count of dead populations
    for (int i = 0; i < ParellelPop.size(); i++) {
        if (ParellelPop.get(i).allDotsDead()) {
            PopDeadCounter += 1;
        }
    }

    // If all populations are dead
    if (PopDeadCounter == ParellelPop.size()) {
        for (int i = 0; i < ParellelPop.size(); i++) {
            lvl.ResetEnemy(); // Reset enemies
            ParellelPop.get(i).calculateFitness(); // Calculate fitness for each population
            ParellelPop.get(i).naturalSelection(); // Prepare the next generation
            ParellelPop.get(i).mutateDemBabies(); // Mutate the new generation
        }

        // Perform migration between populations (10% of each population)
        int migrationCount = Math.max(1, ParellelPop.get(0).dots.length / 10);
        for (int i = 0; i < ParellelPop.size(); i++) {
            int nextPopIndex = (i + 1) % ParellelPop.size(); // Circular migration
            ParellelPop.get(i).migrate(ParellelPop.get(nextPopIndex), migrationCount); // Migrate individuals
        }
    } else {
        // If not all populations are dead, update and show them
        for (int i = 0; i < ParellelPop.size(); i++) {
            ParellelPop.get(i).update();
            ParellelPop.get(i).show();
        }
    }
}




 
   if (NEAT){
     textSize(30);
      fill(48, 115, 115);
      text("BClare World's Hardest Game NEAT Algorithm" , 400, 40);
      text("Generation "+ pop.gen, 20,40);
      //pop.TestNumber = TestNumb;
      //if(pop.gen >= 1001){
      //  pop = new PopulationNEAT(1000);
      //  TestNumb++;
        
      //}
        if (!pop.done()) {//if any players are alive then update them
          text("Generation "+ pop.gen, 20,40);
          pop.updateAlive();
        } else {//all dead
          //genetic algorithm 
          lvl.ResetEnemy();
          pop.naturalSelection();
        }
      }
  }
  
  // }
  //}
void keyPressed() {
  if (key == 'N' || key == 'n') {
    if(lvl.LevelNumber==1){
      lvl.setupLevel1(); 
    }else{
       lvl.setupLevel2();
     }
    pop = new PopulationNEAT(1000);
    ParellelPop.clear();
    humanPlaying= false;
    NEAT = true;
    Parellel = false;
    genetic= false;
   
    
    
  }
  
  if(key=='P'||key == 'p'){
    ParellelPop.clear();
     if(lvl.LevelNumber==1){
      lvl.setupLevel1(); 
    }else{
       lvl.setupLevel2();
     }
     Parellel= true;
     NEAT = false;
     genetic = false;
     humanPlaying= false;
     
     
     ParellelPop.add(new Population(200));
     ParellelPop.add(new Population(200));
     ParellelPop.add(new Population(200));
     ParellelPop.add(new Population(200));
     ParellelPop.add(new Population(200));
     
     for (int i= 0; i< ParellelPop.size(); i++){
       ParellelPop.get(i).ParallelPopNumber = i +1;
    
   }
  }
    
    
  
  if (key == 'G' || key == 'g') {
    if(lvl.LevelNumber==1){
      lvl.setupLevel1(); 
    }else{
       lvl.setupLevel2();
     }
    ParellelPop.clear();
    test = new Population(1000);
    NEAT = false;
    genetic = true;
    Parellel = false;
    humanPlaying= false;
    
    
  }
  
  if (key == 'H' || key == 'h') { 
        Attempts = 0;
        humanPlaying = true;
        NEAT = false;
        genetic= false;
        Parellel = false;
        p = new Dot(); 
        
  }
  
  if (key == 'L' || key == 'l') {
    ParellelPop.clear();
    if(lvl.LevelNumber==1){
      lvl.setupLevel2(); 
    }else{
       lvl.setupLevel1();
     }
    if (humanPlaying) {
            p = new Dot();
        } 
        if(genetic){
            test = new Population(1000);
        }
       if(NEAT){
         pop= new PopulationNEAT(1000);
         
       }
         
       if(Parellel){
         ParellelPop.add(new Population(200));
         ParellelPop.add(new Population(200));
         ParellelPop.add(new Population(200));
         ParellelPop.add(new Population(200));
         ParellelPop.add(new Population(200));
         
         for (int i= 0; i< ParellelPop.size(); i++){
           ParellelPop.get(i).ParallelPopNumber = i +1;
           
        
       }
      }
  
  }
    if (humanPlaying) {
        switch (keyCode) {
            case UP:
                up = true;
                break;
            case DOWN:
                down = true;
                break;
            case RIGHT:
                right = true;
                break;
            case LEFT:
                left = true;
                break;
        }
        
        switch (key) {
            case 'W':
                up = true;
                break;
            case 'S':
                down = true;
                break;
            case 'D':
                right = true;
                break;
            case 'A':
                left = true;
                break;
        }
        setPlayerVelocity();
    }
}

void keyReleased() {
 
    if (humanPlaying) {
        switch (keyCode) {
            case UP:
                up = false;
                break;
            case DOWN:
                down = false;
                break;
            case RIGHT:
                right = false;
                break;
            case LEFT:
                left = false;
                break;
        }
        
        switch (key) {
            case 'W':
                up = false;
                break;
            case 'S':
                down = false;
                break;
            case 'D':
                right = false;
                break;
            case 'A':
                left = false;
                break;
        }
        setPlayerVelocity();
    }
}

void setPlayerVelocity() {
    p.vel.y = 0; // Reset vertical velocity
    if (up) { 
        p.vel.y -= 4; // Move up
    }
    if (down) {
        p.vel.y += 4; // Move down
    }
    p.vel.x = 0; // Reset horizontal velocity
    if (left) {
        p.vel.x -= 4; // Move left
    }
    if (right) {
        p.vel.x += 4; // Move right
    }
}

void sendDataToGoogleSheets(JSONObject data) {
  String urlString = "https://script.google.com/macros/s/AKfycbzVY4xdNUF8KiQN-VdoS9K66I23x8V9zJN25jvAXY699lVW17F_lcaLRuPQZEnMtijd/exec";
  try {
    URL url = new URL(urlString);
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    
    conn.setRequestMethod("POST");
    conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
    conn.setDoOutput(true);
    
    // Send the JSON data
    OutputStreamWriter out = new OutputStreamWriter(conn.getOutputStream());
    out.write(data.toString());
    out.close();
    
    // Get the response
    int responseCode = conn.getResponseCode();
    if (responseCode == HttpURLConnection.HTTP_OK) {
      println("Data sent successfully!");
    } else {
      println("Failed to send data. Response code: " + responseCode);
    }
    
    conn.disconnect();
  } catch (IOException e) {
    e.printStackTrace();
  }
}
