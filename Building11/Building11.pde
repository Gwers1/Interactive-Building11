import beads.*;
import controlP5.*;
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*; //Might change the import to directly later
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

Box2DProcessing box2d;
ControlP5 cp5;

ArrayList<Boundary> boundaries;
HeatMapping heatMap; 

//Additional global varriables
boolean People, Rain, Wind, Luminosity = false;

void setup(){
 size(900, 900);
 smooth();

 //Box2D setup
 box2d = new Box2DProcessing(this);
 box2d.createWorld();
 
 box2d.setGravity(0 , -10);//Gravity for world
 
 //ControlP5 setup
 cp5 = new ControlP5(this);
 
 //Add buttons etc here
 cp5.addButton("Rain")
    .setSwitch(true)
    .setPosition(25, 50)
    .setSize(150,19)
    ;
 
 cp5.addButton("Wind")
    .setSwitch(true)
    .setPosition(25, 75)
    .setSize(150,19)
    ;
    
 cp5.addButton("People")
    .setSwitch(true)
    .setPosition(25, 100)
    .setSize(150,19)
    ;
    
 cp5.addButton("Luminosity")
    .setSwitch(true)
    .setPosition(25, 125)
    .setSize(150,19)
    ;
 //ArrayLists here
 boundaries = new ArrayList<Boundary>();
 
 boundaries.add(new Boundary(width/2, 800, 600, 5, 0));
 boundaries.add(new Boundary(width/2-300, 650, 5, 300, 0));
 boundaries.add(new Boundary(width/2+300, 650, 5, 300, 0));
 
 PVector origin = new PVector(width/2, 450);
 heatMap = new HeatMapping(origin);
}

void draw(){
  background(255);
  
  box2d.step();
  if(People == true){
    //Add sound in here!
    heatMap.run();
  }
  
  for(int i = 0; i < boundaries.size(); i++){
      Boundary b = boundaries.get(i);
      b.display();
  }
}
