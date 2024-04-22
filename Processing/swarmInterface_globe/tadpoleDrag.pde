
AirResistance airResistance = new AirResistance(airFric);

class AirResistance {
  float c;
  
  AirResistance(float c_) {
    c = c_;
  }
  
  PVector calcDrag(Tadpole tadpole) {
    float speed = tadpole.velocity.mag();
    float dragMagnitude = c * speed * speed * tadpole.bodySize;
    PVector dragForce = tadpole.velocity.copy();
    dragForce.mult(-1);
    dragForce.normalize();
    dragForce.mult(dragMagnitude);
    
    return dragForce;
  }
  
}