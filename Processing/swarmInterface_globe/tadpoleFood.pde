ArrayList<Food> food = new ArrayList<Food>();

class Food {
  float x, y;
  Food(float x_, float y_) {
    x = x_;
    y = y_;
  }
  
  PVector location() {
     return new PVector(x,y);
  }
  
  void eaten() {
     x = sysCentre.x + cos(random(0, 2*PI)) * random(0, sysWinRadius-200); 
     y = sysCentre.y - sin(random(0, 2*PI)) * random(0, sysWinRadius-200);
     //x = random(sysCentre.x - 200, sysCentre.x + 200);
     //y = random(sysCentre.y + 200, sysCentre.y + 100);
  }
  
  void display() {
    stroke(0);
    fill(230, 0, 100);
    rect(x, y, 10, 10);
  }
  
}