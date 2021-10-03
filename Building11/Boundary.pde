class Boundary {
 //Translation of the boundary 
 float x;
 float y;
 float w;
 float h;
 
 Body b; 
 
 Boundary(float xVal, float yVal, float wVal, float hVal, float angle){
   
   x = xVal;
   y = yVal;
   w = wVal;
   h = hVal;
   
   PolygonShape sd = new PolygonShape();
   //Box2d coordinates
   float box2dW = box2d.scalarPixelsToWorld(w/2);
   float box2dH = box2d.scalarPixelsToWorld(h/2);
   //Tells box2d what the height and width of the box is
   sd.setAsBox(box2dW, box2dH);
   //BodyDef
   BodyDef bd =  new BodyDef();
   bd.type = BodyType.STATIC;
   bd.angle = angle;
   bd.position.set(box2d.coordPixelsToWorld(x,y));
   b = box2d.createBody(bd);
   //Fixture
   b.createFixture(sd, 1);
   
   b.setUserData(this);
 }
 void display() {
    fill(255);
    stroke(255);
    rectMode(CENTER);
    rect(x,y,w,h);
  }
}
