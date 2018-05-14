//A total of 196 auto-formated lines of code!

//This is to import the music player
import ddf.minim.*;
AudioPlayer player;
Minim minim;
//These are all of the images
PImage wood;
PImage bird;
PImage pig;
PImage Blank;
PImage bomb;
PImage background;
PImage slingshot;

int time; //Used for the pigs to detonate
int radius = 250; //Radius to control the sling shot stretching distance
int win = 0; //Counter to keep track of number of pigs destroyed

float startX = 150; //Used in the starting positions of the bird and sling shot
float startY = 340; //Used in the starting positions of the bird and sling shot
float xb = startX-50; //x-coordinate of the bird
float yb = startY; //y-coordinate of the bird
float xspeed = 0; //X speed of the bird
float yspeed = 0; //Y speed of the bird
float g = 0.7; //Gravity
float easingx = 0.0004*abs(mouseX-startX); //Easing is so that the bird does not follow the mouse precisely and takes time to reach the mouse
float easingy = 0.0004*abs(mouseY-startY);
float impact; //Impact keeps track of the x-coordinate of where the bird lands
float skidding; //Keeps track of how far the bird rolls

PVector circle = new PVector(startX+25, startY-100); //This is the circle that is used to restrict the stretchiness of the sling centered on the top of the sling shot

boolean shot = false; //Keeps track of if the mouse has been releasesd, thereby shooting the bird
boolean turning = false; //Determines when to display an image of the bird that rotates rather than one that is stationary
boolean landed = false; //Keeps track of if the bird has landed
boolean skid = false; //Essential so that impact only records the bird's x-coordinate once

pig p1 = new pig(850, 340);
pig p2 = new pig(400, 340);

void setup() {

  size(1000, 500); //Size of the screen

  bird = loadImage("Angry Bird.png");
  pig = loadImage("pig.png");
  Blank = loadImage("Blank.png");
  wood = loadImage("wood.png");
  bomb = loadImage("bomb.jpg");
  background = loadImage("background.jpg");
  background.resize(1000, 500);
  slingshot = loadImage("slingshot.png");
//The following are to play the music
  minim = new Minim(this);
  player = minim.loadFile("Theme Song.mp3", 2048);
  player.loop();
}

void draw() { //Loops eternally  

  background(background);
  image(slingshot, startX, startY-100, 50, 150);
//These are the pigs
  p1.update();
  p2.update();
//Makes the bird move
  xb += xspeed;
  yb += yspeed;
//Displays either the image of the bird rolling or it being stationary
  if (turning) {
    spin();
  } else {
    image(bird, xb, yb, 50, 50);
  }
//Ensures that the bird does indeed stop after rolling
  if (xspeed < 0.05 && shot == false) {
    xspeed = 0;
  }
//This is to reset the bird after it has been shot and has finished rolling on the ground
  if (xspeed == 0 && skid == true) {
    delay(1000);
    xb = startX-50;
    yb = startY;
    turning = false;
    shot = false;
    landed = false;
    skid = false;
  }
//This controls the bird's movement in relation to the sling
  if (mousePressed) {
    if (shot == false && skid == false) {
      PVector m = new PVector(mouseX, mouseY); //This keeps the bird within a circle   
      if (dist(m.x, m.y, circle.x, circle.y) > radius/2) {
        m.sub(circle);
        m.normalize();
        m.mult(radius/2);
        m.add(circle);
      }      
      if (abs(mouseX-xb) > 0.1) {
        xb = xb + (m.x - xb - 25) * easingx;
      }      
      if (abs(mouseY-yb) > 0.1) {
        yb = yb + (m.y - yb - 25) * easingy;
      }
      beginShape();
      vertex(xb, yb+20);
      vertex(xb, yb+30);
      vertex(startX+13, startY-73);
      vertex(startX+13, startY-83);
      stroke(48, 22, 8);
      endShape();
      fill(48, 22, 8);
//These two shapes are the actually sling arms
      beginShape();
      vertex(xb+50, yb+20);
      vertex(xb+50, yb+30);
      vertex(startX+43, startY-77);
      vertex(startX+43, startY-87);
      stroke(48, 22, 8);
      endShape();
      fill(48, 22, 8);
    }
  }
//This slows down the bird after landing
  if (yb > 340) {
    shot = false;
    yspeed = 0;
    xspeed *= 0.825;
    turning = true;
    landed = true;
  }
//Records the x-coordinate of where the bird landed
  if (landed && skid == false) {
    impact = xb;
    skid = true;
  }
//Gravity
  if (shot) {
    yspeed += g;
  }
//Win condition
  if (win == 2) {
    imageMode(CENTER); //Causes the following code to interpret the input values as the center of the image rather than the default top left corner
    textSize(50);
    text("YOU WIN!", 500, 250);
    imageMode(CORNER); //Returns the input values as the top left corner
  }
}
//This gives the bird speed in relation to its position to the sling
void mouseReleased() {
  if (shot == false && skid == false) {
    float xdis = xb-startX;
    float ydis = yb-startY+100;
    xspeed = -xdis/5;
    yspeed = -ydis/5;
    shot = true;
  }
}
//Spins the bird
void spin() {
  skidding = xb;
  imageMode(CENTER); //It is necessary to use imageMode(CENTER) here so that the bird rotates around its center rather than the top left hand corner
  pushMatrix(); //Overlays the image of the rolling bird where the bird would normally be
  translate(xb + 25, yb + 25);
  rotate((skidding - impact)*0.05); //Rotates in proportion to the distance rolled on the ground
  image(bird, 0, 0, 50, 50);
  popMatrix();
  imageMode(CORNER);
}
