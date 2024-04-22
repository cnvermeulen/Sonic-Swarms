class Body {
  Tadpole brain;
  float brightness = 150;
  ArrayList<PVector> bodyList = new ArrayList<PVector>();
  PVector headLocation;
  Body(Tadpole tadpole) {
    brain = tadpole;
    headLocation = brain.location;
    bodyList.add(new PVector());
  }
  
  void addSegment() {
    bodyList.add(new PVector());
  }
  
  void displayBody() {
    dragSegment(0, headLocation.x, headLocation.y);
    for(int i = 1; i < bodyList.size(); i++) {
      dragSegment(i, bodyList.get(i-1).x, bodyList.get(i-1).y);
    }
  }
  void dragSegment(int i, float xin, float yin) {
    float dx = xin - bodyList.get(i).x;
    float dy = yin - bodyList.get(i).y;
    float angle = atan2(dy, dx);  
    bodyList.get(i).x = xin - cos(angle) * segLength;
    bodyList.get(i).y = yin - sin(angle) * segLength;
    segment(bodyList.get(i).x, bodyList.get(i).y, angle);
  }
  
  void segment(float x, float y, float a) {
    strokeWeight(4.0);
    stroke(200);
    pushMatrix();
    translate(x, y);
    rotate(a);
    line(0, 0, segLength, 0);
    popMatrix();
  }
}
