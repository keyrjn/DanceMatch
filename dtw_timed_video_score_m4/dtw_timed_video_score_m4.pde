import processing.video.*;
Movie myMovie;
import oscP5.*;
OscP5 oscP5;

long timer = 0;
long lastReset = 0;
float lastTime = 0;

int currentPoints  = 0;
boolean gestureDetected = false;
int lastDetectedGesture = 0;

PImage[] banners = {
  null, null, null, null
};
PImage[] feedbacks = {
  null, null
};

boolean cover = false;

void setup() {
  oscP5 = new OscP5(this, 12000); //listen for OSC messages on port 12000 (Wekinator default)
  size(1280, 720);
  myMovie = new Movie(this, "dance0_150k.mp4");
  myMovie.noLoop();
  myMovie.pause();



  PImage success = loadImage("success.png");  
  PImage fail = loadImage("fail.png"); 
  PImage cover = loadImage("cover.png"); 
  PImage end = loadImage("end.png"); 

  PImage meh = loadImage("meh.png"); 
  PImage nice = loadImage("nice.png"); 


  banners[0] = success;
  banners[1] = fail;
  banners[2] = cover;
  banners[3] = end;

  feedbacks[0] = meh;
  feedbacks[1] = nice;
}

void draw() {
  background(0);
  image(banners[2], 0, 0);
  image(myMovie, 0, 0);
 
  timer = floor((millis() - lastReset) /1000);

  text("time elapsed: " + timer, 10, 20);


  // Live feed back
//  if ((timer > 10 && timer < 25) && lastDetectedGesture == 1) {    
//    image(feedbacks[1], 100, 300, 100, 100);
//  } else if (timer > 10 && timer < 25) {
//    image(feedbacks[0], 100, 300, 100, 100);
//  }

  if(gestureDetected) {
    if ((timer > 5 && timer < 35) && lastDetectedGesture == 1 && (millis()-lastTime < 2000)){    
      image(feedbacks[1], 640, 500, 100, 100);
    } else if (timer > 5 && timer < 35) {    
      image(feedbacks[0], 640, 500, 100, 100);
    }

    if ((timer > 35 && timer < 55) && lastDetectedGesture == 2) {    
      image(feedbacks[1],640, 500, 100, 100);
    } else if (timer > 35 && timer < 55){
      image(feedbacks[0], 640, 500, 100, 100);
    }
  
    if ((timer > 65 && timer < 85) && lastDetectedGesture == 3) {    
      image(feedbacks[1], 640, 500, 100, 100);
    } else if (timer > 65 && timer < 85){
      image(feedbacks[0], 640, 500, 100, 100);
    }
  }

  //Success or fail 
  if ((timer > 25 && timer < 30) || (timer > 55 && timer < 60) || (timer > 85 && timer < 110)) {
    int bannerIndex = gestureDetected ? 0 : 1;
    image(banners[bannerIndex], 0, 0, 1280, 720);
  }

  if (timer > 90) {
    image(banners[3], 0, 0, 1280, 720);
  }

  if (cover) {
    image(banners[2], 0, 0, 1280, 720);
  }

  if (timer==25 || timer == 60) {
    gestureDetected = false;
  }


}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}



void oscEvent(OscMessage theOscMessage) {

  
  
//  theOscMessage.print();

  if (theOscMessage.checkAddrPattern("/output_1") && timer < 25 && !gestureDetected) {

  println(gestureDetected);    
    gestureDetected = true;    
  } else if (theOscMessage.checkAddrPattern("/output_2") && timer > 30 && timer < 55 && !gestureDetected) {    
    gestureDetected = true;
  } else if (theOscMessage.checkAddrPattern("/output_3") && timer > 60 && timer < 85 && !gestureDetected) {    
    gestureDetected = true;
  }
  
  if (theOscMessage.checkAddrPattern("/output_1")) {    
    lastDetectedGesture = 1;
    lastTime = millis();
  } else if (theOscMessage.checkAddrPattern("/output_2")) {    
    lastDetectedGesture = 2;
    lastTime = millis();
  } else if (theOscMessage.checkAddrPattern("/output_3")) {    
    lastDetectedGesture = 3;
    lastTime = millis();
  }
  
  
}


void keyPressed() {
  if (key == ' ') {
    myMovie.jump(0);
    myMovie.play();
    lastReset = millis();
    cover = false;
    gestureDetected = false;
  }

  if (key == 's') {
    myMovie.stop();
    lastReset = millis();
    cover = true;
    timer = 0;
  }
}