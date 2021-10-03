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
  //constructor
  Person(float x, float y, float heat){ 
    this.x = x;
    this.y = y;
    this.heat = heat;
    r = 10;
    
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
    
    float m = map(heat, 0, 10, 0, 255);
    
    pushMatrix();
    rectMode(CENTER);
    stroke(0);
    strokeWeight(1);
    translate(pos.x, pos.y);
    rotate(-a);
    fill(m, 0, 255-m);
    ellipse(0, -15, 7.5, 7.5);
    rect(0, 0, 15, 22.5, 30);
    popMatrix();
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
    fd.friction = 0.1;
    fd.restitution = 0.6; //We bounce
    
    b.createFixture(fd);
    b.setAngularVelocity(random(-20,20));
  }
  
  //test fun
  float getHeat(){
  return heat;  
  }
  void setHeat(float newHeat){
     heat = newHeat;
  }
}
