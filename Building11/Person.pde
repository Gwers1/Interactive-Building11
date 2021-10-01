//Create actual person in world
class Person{
  //coord
  float x;
  float y;
  //radius
  float r;
  //heat value
  float heat; 
  Body b;
  PShape person, head, body, leftArm, leftLeg, rightLeg;
  //constructor
  Person(float x, float y, float heat){ 
    this.x = x;
    this.y = y;
    this.heat = heat;
    r = 5;
    
    makeBody(new Vec2(x,y), r);
  }
  
  //removes box2d body
  void killBody(){ 
    box2d.destroyBody(b); 
  }
  
  //Will delete body if internal heat count is 0
  boolean isDone(){ 
   if(heat == 0){
     killBody();
    return true; 
   }else{
    return false; 
   }
  }
  
  //Visual component of the object
  void display(){
    Vec2 pos = box2d.getBodyPixelCoord(b);
    float a = b.getAngle();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    fill(255);
    ellipse(0, -10, 5, 5);
    rect(0, 0, 10, 15, 30);
    popMatrix();
  }
  
  //Might not need this
  float getHeat(){
  return heat;  
  }
  
  //creates object in box2d world
  void makeBody(Vec2 location, float radius){
    //Creates body definition
    BodyDef bd = new BodyDef();
    bd.position = box2d.coordPixelsToWorld(location);
    bd.type = BodyType.DYNAMIC;
    b = box2d.createBody(bd);
    //Specify shape
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(radius);
    //Attaches physics to the shape
    FixtureDef fd = new FixtureDef();
    //Characteristics
    fd.shape = cs;
    fd.density = 1;
    fd.friction = 0.5;
    fd.restitution = 0.3; //We bounce
    
    b.createFixture(fd);
    b.setAngularVelocity(random(-10,10));
  }
}
