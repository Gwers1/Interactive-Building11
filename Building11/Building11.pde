
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*; //Might change the import to directly later
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

Box2DProcessing box2d;

ArrayList<Boundary> boundaries;

void setup(){
 size(900, 900);
 smooth();
 //Box2D setup
 box2d = new Box2DProcessing(this);
 box2d.createWorld();
 
 box2d.setGravity(0 , -10);//Gravity for world
 
 //Add buttons etc here
 
 //ArrayLists here
 boundaries = new ArrayList<Boundary>();
 
 boundaries.add(new Boundary(width/2, 800, 600, 5, 0));
 boundaries.add(new Boundary(width/2-300, 650, 5, 300, 0));
 boundaries.add(new Boundary(width/2+300, 650, 5, 300, 0));
 
}

void draw(){
  background(255);
  
  box2d.step();
  //displays Boundary
  
  for(int i = 0; i < boundaries.size(); i++){
      Boundary b = boundaries.get(i);
      b.display();
  }
}
