import java.util.Arrays;
import controlP5.*;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;

Population test;

//PVector goal;
//= new PVector(400, 10);
//level lvl;
boolean up = false;
boolean down = false;
boolean left = false;
boolean right = false;
boolean humanPlaying = true;
boolean NEAT = false;
boolean showNothing = false;
int nextConnectionNo = 1000;
PopulationNEAT pop;
boolean showBestEachGen = false;
int upToGen = 0;
boolean showBest = false;//true if only show the best of the previous generation
boolean runBest = false; //true if replaying the best ever game
//Dot genPlayerTemp;
boolean runThroughSpecies = false;
//Dot speciesChamp;
boolean Parellel = false;
boolean genetic = false;
ArrayList<Population> ParellelPop = new  ArrayList<Population>();
int PopDeadCounter;
float FrameRate = 60;
ControlP5 cp5;
int Attempts;
 int overallBestPlayerIndex;
int BestPlayerParellelPop;
int TestNumb = 10;


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
  //lvl= new level();
  //goal = new PVector(lvl.goalx, lvl.goaly);
  
  
    p = new Dot();
  
  //if(NEAT){
  //  pop = new PopulationNEAT(1000);
  //}
  
  //JSONObject data = new JSONObject();
  //data.setInt("value1", 100); 
  //data.setInt("value2", 500);
  //data.setInt("value3", 1000);
 
 
  //sendDataToGoogleSheets(data);
   //NewGame();
}


void draw() { 
  frameRate(FrameRate);
  background(160, 215, 160);
  fill(200, 100, 100);
 
  text("Press H to play yourself", 1100, 40);
  text("Press N for NEAT", 1500,40);
  text("Press G for Genetic", 1500, 70);
  text("Press P for Parallel", 1500, 100);
  
  if(genetic){
    textSize(30);
    fill(48, 115, 115);
    text("BClare 2048 Genetic Algorithm" ,400, 40);
    text("Generation "+ test.gen, 20,40);
    text("Score "+ test.dots[test.bestDot].score , 20, 70);
    text("Showing Player Index: "+ test.bestDot, 1200, 200); 
    //test.TestNumber = TestNumb;
    //  if(test.gen >= 101){
    //    test = new Population(10);
    //    TestNumb++;
    //  }
    if (test.allDotsDead()) {
      //genetic algorithm
      test.calculateFitness();
      test.naturalSelection();
      test.mutateDemBabies();
      
      
    } else {
      //if any of the dots are still alive then update and then show them
    
      test.update();
      test.show();
  }
}

  if (NEAT){
      textSize(30);
      fill(48, 115, 115);
      text("BClare 2048 NEAT Algorithm" , 400, 40);
      text("Generation "+ pop.gen, 20,40);
     
      //text("Showing Player Index: "+ pop.BestPlayer, 1200, 200); 
      //pop.TestNumber = TestNumb;
      //if(pop.gen >= 101){
      //   pop = new PopulationNEAT(100);
      //  TestNumb++;
      //}
    
        if (!pop.done()) {//if any players are alive then update them
          pop.updateAlive();
          fill(0, 0, 0);
           text("Score "+ pop.BestPlayer.score , 20, 300);
           text("Step " + pop.BestPlayer.step, 20, 400);
         
          
        } else {//all dead
          //genetic algorithm 
          
          pop.naturalSelection();
        }
      }
  
  
  if(humanPlaying){
    textSize(30);
      fill(48, 115, 115);
      text("BClare 2048" , 400, 40);
      text("Score: " + p.score, 100, 40);
      
      if(!p.dead){
        p.update();
        
      }
      else{
        p= new Dot();
      }
      
    //   DrawGame();
    //if (isGameOver()) {
    //  println("Game Over!");
    //  NewGame();
    //}
    
    
  }
  
  if (Parellel) {
    textSize(30);
    fill(48, 115, 115);
    text("BClare 2048 Parallel Genetic Algorithm", 300, 40);
    text("Generation " + ParellelPop.get(0).gen, 20, 40);
    
    //if(ParellelPop.get(0).gen> 100){
        
    //    ParellelPop.clear();
    //    ParellelPop.add(new Population(5));
    //    ParellelPop.add(new Population(5));
    //    ParellelPop.add(new Population(5));
    //     ParellelPop.add(new Population(5));
    //     ParellelPop.add(new Population(5));
    //}
    
     Dot overallBestPlayer = null;
    
    int PopDeadCounter = 0; // Count of dead populations
    for (int i = 0; i < ParellelPop.size(); i++) {
        if (ParellelPop.get(i).allDotsDead()) {
            PopDeadCounter += 1;
        }
    }

    // If all populations are dead
    if (PopDeadCounter == ParellelPop.size()) {
        for (int i = 0; i < ParellelPop.size(); i++) {
          
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
            //ParellelPop.get(i).show();
             // Find the best player in the current population during the update
            Dot bestInCurrentPop = ParellelPop.get(i).dots[ParellelPop.get(i).bestDot];
            if (overallBestPlayer == null || bestInCurrentPop.fitness > overallBestPlayer.fitness) {
                overallBestPlayer = bestInCurrentPop; // Update the overall best player if this one is better
                overallBestPlayerIndex = ParellelPop.get(i).bestDot;
                BestPlayerParellelPop = ParellelPop.get(i).ParallelPopNumber;
            }
        }
      
        // Display the information of the overall best player
        if (overallBestPlayer != null) {
            //println("Overall Best Player Fitness: " + overallBestPlayer.fitness);
            overallBestPlayer.show();
            fill(22, 23, 65);
            
            text("Showing Best Player Index " + overallBestPlayerIndex + " In Population " + BestPlayerParellelPop, 1150,200);  
          }
        }
    }


  
  }
 
  
  

  
  //text("Level " +lvl.LevelNumber, 20, 80);
  

 
  
//  lvl.drawLevel();
//  if(genetic){
//      textSize(30);
//      fill(48, 115, 115);
//      text("BClare World's Hardest Game Genetic Algorithm" , 400, 40);
//      text("Generation "+ test.gen, 20,40);
//      if (test.allDotsDead()) {
//        //genetic algorithm
//        lvl.ResetEnemy();
//        test.calculateFitness();
//        test.naturalSelection();
//        test.mutateDemBabies();
        
        
//      } else {
//        //if any of the dots are still alive then update and then show them
      
//        test.update();
//        test.show();
//    }
//  }
//   if(humanPlaying){
//     text("Attempts: " + Attempts, 20, 40);
//       if(p.dead){
//         Attempts++;
//        lvl.ResetEnemy();
//        p = new Dot();
//      }
//      else{
//        p.update();
//        p.show();
//      }
//  }





   
  



  
//void NewGame(){
//   for (int i = 0; i < 4; i++) {
//    for (int j = 0; j < 4; j++) {
//      grid[i][j] = new Tile(i, j, tileSize);
//    }
//  }
  
//  addRandomTile();
//  addRandomTile();
//}

//void DrawGame(){
//  for (int i = 0; i < 4; i++) {
//    for (int j = 0; j < 4; j++) {
//      //if (grid[i][j].value>0){
//      grid[i][j].drawTile(300, 120);
    
//  }
//  }
  
//}


 
// Key press handler for movement
void keyPressed() {
  if (key == 'N' || key == 'n') {
    
    pop = new PopulationNEAT(100);
    ParellelPop.clear();
    humanPlaying= false;
    NEAT = true;
    Parellel = false;
    genetic= false;
   
    
    
  }
  
  
    if (humanPlaying) {
    boolean moved = false;


      if (keyCode == UP) {
        moved = p.moveUp();
      } else if (keyCode == DOWN) {
        moved = p.moveDown();
      } else if (keyCode == LEFT) {
        moved = p.moveLeft();
      } else if (keyCode == RIGHT) {
        moved = p.moveRight();
      }

      if (moved) {
        p.addRandomTile();
    }
    }
  
  if(key=='P'||key == 'p'){
    ParellelPop.clear();
     Parellel= true;
     NEAT = false;
     genetic = false;
     humanPlaying= false;
     
     
     ParellelPop.add(new Population(5));
     ParellelPop.add(new Population(5));
     ParellelPop.add(new Population(5));
     ParellelPop.add(new Population(5));
     ParellelPop.add(new Population(5));
     
     for (int i= 0; i< ParellelPop.size(); i++){
       ParellelPop.get(i).ParallelPopNumber = i +1;
    
   }
  }
    
    
  
  if (key == 'G' || key == 'g') {
    ParellelPop.clear();
    test = new Population(10);
    NEAT = false;
    genetic = true;
    Parellel = false;
    humanPlaying= false;
    
    
  }
  
  if (key == 'H' || key == 'h') { 
        //Attempts = 1;
            ParellelPop.clear();
        humanPlaying = true;
        NEAT = false;
        genetic= false;
        Parellel = false;
        p = new Dot(); 
        
  }
    }
  
  //if (key == 'L' || key == 'l') {
  //  ParellelPop.clear();
  //  if(lvl.LevelNumber==1){
  //    lvl.setupLevel2(); 
  //  }else{
  //     lvl.setupLevel1();
  //   }
  //  if (humanPlaying) {
  //          p = new Dot();
  //      } 
  //      if(genetic){
  //          test = new Population(1000);
  //      }
  //     if(NEAT){
  //       pop= new PopulationNEAT(1000);
         
  //     }
         
  //     if(Parellel){
  //       ParellelPop.add(new Population(200));
  //       ParellelPop.add(new Population(200));
  //       ParellelPop.add(new Population(200));
  //       ParellelPop.add(new Population(200));
  //       ParellelPop.add(new Population(200));
         
  //       for (int i= 0; i< ParellelPop.size(); i++){
  //         ParellelPop.get(i).ParallelPopNumber = i +1;
        
  //     }
  //    }
  
  

  

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
