import controlP5.*;
import java.util.Collections;
import java.util.Arrays;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;



Population test;
PImage bg;

ArrayList<Population> ParallelPop = new  ArrayList<Population>();

ArrayList<Enemy> enemies;

int speed = 60;
int spawnTimer = 0;

int spawnInterval = 20;
int lastSpawnFrame = 0;

PImage playerImage;

int enemyIndex = 0; // Track which enemy to spawn next
float[] pattern = {50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000}; // Define the pattern of heights
ArrayList<Float> shuffledPattern = new ArrayList<>();


int nextConnectionNo = 1000;
PopulationNEAT pop;


boolean showBest = false;//true if only show the best of the previous generation
boolean runBest = false; //true if replaying the best ever game
boolean humanPlaying = false; //true if the user is playing

Player humanPlayer;

boolean runThroughSpecies = false;
int upToSpecies = 0;
Player speciesChamp;

boolean showBrain = true;

boolean showBestEachGen = false;
int upToGen = 0;
Player genPlayerTemp;

boolean showNothing = false;

boolean NEAT = false;
boolean genetic= true;
boolean Parallel = false;

int PopDeadCounter;

int Score;

float FrameRate = 60;
ControlP5 cp5;

int startTime = millis();




void setup() {
  size(1800, 1000); //size of the window
  //fullScreen();
  
  cp5 = new ControlP5(this);
  
  cp5.addSlider("FrameRate")  
     .setPosition(200, 20)     
     .setRange(1, 300)           
     .setValue(60)              
     .setSize(200, 20);
     
  frameRate(FrameRate);
  
  
  test = new Population(500);
  //bg = loadImage("Mountains2.jpg");
  //bg.resize(width,height);
  enemies = new ArrayList<Enemy>();
  
  for (float value : pattern) {
        shuffledPattern.add(value);
    }
   Collections.shuffle(shuffledPattern);
  
  
}


void draw() { 
  frameRate(FrameRate);
  //int elapsedTime = (millis() - startTime) / 1000;
  background(150 , 160, 190);
  //image(bg,0,0);
  Score++;
  fill(255,255,0);
  text("Score: " + Score, 700, 50);
  //text("Time (Seconds): " + elapsedTime,  1400, 50);
  
  
  
  
  
  
  if (frameCount - lastSpawnFrame >= spawnInterval) {
    spawnEnemy();// Call the function to spawn enemies
    lastSpawnFrame = frameCount;  // Update the last spawn frame
  }
  
  // Update and display each enemy
  for (int i = enemies.size() - 1; i >= 0; i--) {
    Enemy enemy = enemies.get(i);
    enemy.update();
    enemy.display();
    
    // Remove enemies that go off-screen to free up memory
    if (enemy.x < -50) { // If the enemy goes off the left side of the screen
      enemies.remove(i);  // Remove it from the list
    }
  }

if(genetic){
  fill(255,100,100);
  text("Genetic", 1000,50);
   //if(test.gen >= 101){
   //     test = new Population(1000);

   //   }
  if (test.allDotsDead()) {
    //genetic algorithm
    print("Get next generation");
    enemyIndex= 0;
    test.calculateFitness();
    test.naturalSelection();
    test.mutateDemBabies();
    Score= 0;
  } else {
    //if any of the dots are still alive then update and then show them
    startTime= 0;
    fill(166,100, 255);
    textSize(40);
    text("Gen: " + test.gen, 1150, 50);
    
    test.update();
    test.show();
  }
}
if(NEAT){
  fill(122,241, 123);
  text("NEAT", 1000, 50);
  text("Gen: " + pop.gen, 1150, 50);
  
    if (showBestEachGen) {//show the best of each gen
    if (!genPlayerTemp.dead) {//if current gen player is not dead then update it
      genPlayerTemp.look();
      genPlayerTemp.think();
      genPlayerTemp.update();
      genPlayerTemp.show();
    } else {//if dead move on to the next generation
      upToGen ++;
      if (upToGen >= pop.genPlayers.size()) {//if at the end then return to the start and stop doing it
        upToGen= 0;
        showBestEachGen = false;
      } else {//if not at the end then get the next generation
        genPlayerTemp = pop.genPlayers.get(upToGen).cloneForReplay();
      }
    }
  } else
    if (runThroughSpecies ) {//show all the species 
      if (!speciesChamp.dead) {//if best player is not dead
        speciesChamp.look();
        speciesChamp.think();
        speciesChamp.update();
        speciesChamp.show();
      } else {//once dead
        upToSpecies++;
        if (upToSpecies >= pop.species.size()) { 
          runThroughSpecies = false;
        } else {
          speciesChamp = pop.species.get(upToSpecies).champ.cloneForReplay();
        }
      }
    } else {
      if (humanPlaying) {//if the user is controling
        if (!humanPlayer.dead) {//if the player isnt dead then move and show the player based on input
          humanPlayer.look();
          humanPlayer.update();
          humanPlayer.show();
        } else {//once done return to ai
          humanPlaying = false;
        }
      } else 
      if (runBest) {// if replaying the best ever game
        if (!pop.bestPlayer.dead) {//if best player is not dead
          pop.bestPlayer.look();
          pop.bestPlayer.think();
          pop.bestPlayer.update();
          pop.bestPlayer.show();
        } else {//once dead
          runBest = false;//stop replaying it
          pop.bestPlayer = pop.bestPlayer.cloneForReplay();//reset the best player so it can play again
        }
      } else {//if just evolving normally
        if (!pop.done()) {//if any players are alive then update them
          pop.updateAlive();
        } else {//all dead
          //genetic algorithm 
          pop.naturalSelection();
          //Score= 0;
        }
      }
    }
  
}
  if(humanPlaying){
    fill(190,100,190);
    text("Human Playing (Use Arrow Keys to Move)", 1050,50);
    if (!humanPlayer.dead) {//if the player isnt dead then move and show the player based on input
          humanPlayer.look();
          humanPlayer.update();
          humanPlayer.show();}
      else{
        Score= 0;
         humanPlayer= new Player(); 
      }
  }
      
if (Parallel) {
   fill(190,100,190);
    text("Parallel", 1000,50);
    PopDeadCounter = 0;  // Reset the counter at the beginning of each cycle
    
    //if(ParallelPop.get(0).gen> 100){
        
    //    ParallelPop.clear();
    //    ParallelPop.add(new Population(200));
    //    ParallelPop.add(new Population(200));
    //    ParallelPop.add(new Population(200));
    //     ParallelPop.add(new Population(200));
    //     ParallelPop.add(new Population(200));
    //}
        

    // Check how many populations are dead
    for (int i = 0; i < ParallelPop.size(); i++) {
        if (ParallelPop.get(i).allDotsDead()) {
            PopDeadCounter += 1;
        }
    }

    // If all populations are dead, proceed with the next generation
    if (PopDeadCounter == ParallelPop.size()) {
        for (int i = 0; i < ParallelPop.size(); i++) {
          enemyIndex =0;
          Score= 0;
            ParallelPop.get(i).calculateFitness();
            ParallelPop.get(i).naturalSelection();
            ParallelPop.get(i).mutateDemBabies();
           
        }
        // Reset PopDeadCounter for the next generation
        PopDeadCounter = 0;
    } else {
        // Otherwise, update and show the populations
        for (int i = 0; i < ParallelPop.size(); i++) {
           text("Gen: " + ParallelPop.get(i).gen, 1150, 50);
            ParallelPop.get(i).update();
            ParallelPop.get(i).show();
        }
    }
}

    
   
}


void spawnEnemy() {
    float x = width; // Start enemies on the far right
    if(genetic || Parallel){//remove randomness for genetic
      float y = shuffledPattern.get(enemyIndex % shuffledPattern.size()); // Follow the shuffled pattern\
      enemies.add(new Enemy(x, y, speed));
    }
    else{
      float y = random(0, height);
      enemies.add(new Enemy(x, y, speed));
    }

    enemyIndex++; //move to the next position in the shuffled pattern
}



void keyPressed() {
  switch(key) {
    
    case'p':
    Score= 0;
    humanPlaying= false;
    Parallel= true;
    NEAT = false;
    genetic= false;
    ParallelPop.clear();
     ParallelPop.add(new Population(200));
     ParallelPop.add(new Population(200));
     ParallelPop.add(new Population(200));
     ParallelPop.add(new Population(200));
     ParallelPop.add(new Population(200));
     
     for (int i= 0; i< ParallelPop.size(); i++){
       ParallelPop.get(i).ParallelPopNumber = i +1;
    
   }
    
  case ' ':
    //toggle showBest
    showBest = !showBest;
    break;
  case '+'://speed up frame rate
    speed += 10;
    frameRate(speed);
    println(speed);
    break;
  case '-'://slow down frame rate
    if (speed > 10) {
      speed -= 10;
      frameRate(speed);
      println(speed);
    }
    break;
  case 'b'://run the best
    runBest = !runBest;
    break;
  case 's'://show species
    runThroughSpecies = !runThroughSpecies;
    upToSpecies = 0;
    speciesChamp = pop.species.get(upToSpecies).champ.cloneForReplay();
    break;
  case 'g'://show generations
    //showBestEachGen = !showBestEachGen;
    //upToGen = 0;
    //genPlayerTemp = pop.genPlayers.get(upToGen).clone
    Score= 0;
    genetic= true;
    NEAT= false;
    Parallel= false;
    humanPlaying=false;
    break;
  case 'n'://show absolutely nothing in order to speed up computation
    //showNothing = !showNothing;
    Score= 0;
    NEAT = true;
    humanPlaying= false;
    Parallel = false;
    genetic = false;
    pop = new PopulationNEAT(1000); 
    
    
    break;
  case 'h'://play
  Score= 0;
    humanPlaying = true;
    NEAT = false;
    genetic= false;
    Parallel = false;
    humanPlayer = new Player();
    break; 
  case CODED://any of the arrow keys
    switch(keyCode) {
    case UP://the only time up/ down / left is used is to control the player
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<replace
    if (humanPlayer.y < 0) {
        humanPlayer.y = 0;
      } else if (humanPlayer.y > height - 170) {
        humanPlayer.y = height - 170;
      }
  humanPlayer.y-=20;
      break;
    case DOWN:
        if (humanPlayer.y < 0) {
        humanPlayer.y = 0;
      } else if (humanPlayer.y > height - 170) {
        humanPlayer.y = height - 170;
      }
    humanPlayer.y+=20;//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<replace
      break;
    case LEFT:
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<replace
      break;
    case RIGHT://right is used to move through the generations
      if (runThroughSpecies) {//if showing the species in the current generation then move on to the next species
        upToSpecies++;
        if (upToSpecies >= pop.species.size()) {
          runThroughSpecies = false;
        } else {
          speciesChamp = pop.species.get(upToSpecies).champ.cloneForReplay();
        }
      } else 
      if (showBestEachGen) {//if showing the best player each generation then move on to the next generation
        upToGen++;
        if (upToGen >= pop.genPlayers.size()) {//if reached the current generation then exit out of the showing generations mode
          showBestEachGen = false;
        } else {
          genPlayerTemp = pop.genPlayers.get(upToGen).cloneForReplay();
        }
      } else if (humanPlaying) {//if the user is playing then move player right

        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<replace
      }
      break;
    }
    break;
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
