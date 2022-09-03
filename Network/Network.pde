// Network: 
//     by Akira Kageyama
//     on 2022.09.03
// 

final int NUM_RESOURCE = 4;     
final int POPULATION = 1000;   // 100000;


Environment environment;

Human human;


// Variables for timer
int interval = 50; // 200;
int lastRecordedTime = 0;


// Pause
boolean pause = true;


int timeCounter = 0;


void asserting( boolean condition, String message )
{
  if ( !condition ) {
    println( message );
    exit();
  }
}




void setup() {
  size (800, 800);
  println("Space=>stop/start.");
 

  // For drawing
  smooth(8);
  stroke(0);

  environment = new Environment();
  human = new Human();

}





void draw() 
{
  background(255);
  
  human.draw();
  environment.draw();
  
  
  if (millis()-lastRecordedTime>interval) {
    if (!pause) {
      for ( int i=0; i<1; i++ ) {
        StepTime();
      }
      lastRecordedTime = millis();
    }
  }

}




void keyPressed() {

  if (key==' ') { // On/off of pause
    pause = !pause;
  }
  
  if (key=='\n') {
    StepTime();
  }
}
