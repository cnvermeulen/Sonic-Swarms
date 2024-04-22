//PATH
Path path;

class Path {

  ArrayList<PVector> points;
  float radius;

  Path() {
    radius = 20;
    points = new ArrayList<PVector>();
  }

  // Add a point to the path
  void addPoint(float x, float y) {
    PVector point = new PVector(x, y);
    points.add(point);
  }

  // Draw the path
  void display() {
    strokeJoin(ROUND);
    
    // Draw thick line for radius
    stroke(50);
    strokeWeight(radius*2);
    noFill();
    beginShape();
    for (PVector v : points) {
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
    // Draw thin line for center of path
    stroke(80);
    strokeWeight(1);
    noFill();
    beginShape();
    for (PVector v : points) {
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
  }
}

void newPath() {
  // A path is a series of connected points
  // A more sophisticated path might be a curve
  path = new Path();
  int offset = 200;
  //path.addPoint(systemWindowLeft + offset, systemWindowTop + offset);
  //path.addPoint(systemWindowRight - offset, systemWindowTop + offset);
  //path.addPoint(systemWindowRight - offset, systemWindowBottom - offset);
  //path.addPoint(systemWindowLeft + offset, systemWindowBottom - offset);
  for(int i = 0; i < 10; i++) {
    path.addPoint(sysCentre.x + cos(TWO_PI/10 * i) * (sysWinRadius - 100), sysCentre.y - sin(TWO_PI/10 * i) * (sysWinRadius - 100));
  }
}
