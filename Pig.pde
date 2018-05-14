class pig {
  float x, y;
  boolean destroyed = false;
  boolean poofed = false;
  boolean vanish = false;
  pig (float xPos, float yPos) {
    x = xPos;
    y = yPos;
  }

  void update() {
    if (poofed == false) {
      image(pig, x, y, 50, 50);
    } else if (poofed == true && vanish == false) {
      image(bomb, x, y, 100, 100);
      int tick = abs(second()-time);
      if (tick >= 2) { //Allows the explosion to disappear after 2 seconds
        vanish = true;
        win++; //This is to keep track of how many pigs have died T_T
      }
    } else {
      image(Blank, x, y, 100, 100);
    }
    if (poofed == false && x-50 < xb && y-50 < yb && x+50 > xb && yb < y+50) { //For when the bird hits the pig in relation to the top left corner of the bird
      poofed = true;
      time = second(); //Calls on the current time from the clock
    }
  }
}
