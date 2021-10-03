import beads.*;
import controlP5.*;
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*; //Might change the import to directly later
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

Box2DProcessing box2d;
ControlP5 cp5;

PImage img;
PImage img2;
ArrayList<Boundary> boundaries;
HeatMapping heatMap; 
Luminosity luminosity;
ParticleSystem rain;
Wind wind;
//Additional global varriables
boolean People, Rain, Wind, Luminosity = false;
boolean lumPlayed = false;
boolean rainPlayed = false;

void setup() {
  size(900, 900);
  smooth();

  //Box2D setup
  box2d = new Box2DProcessing(this);
  box2d.createWorld();

  box2d.setGravity(0, -10);//Gravity for world

  //ControlP5 setup
  cp5 = new ControlP5(this);

  //Add buttons etc here
  cp5.addButton("Rain")
    .setSwitch(true)
    .setPosition(25, 50)
    .setSize(150, 19)
    ;

  cp5.addButton("Wind")
    .setSwitch(true)
    .setPosition(25, 75)
    .setSize(150, 19)
    ;

  cp5.addButton("People")
    .setSwitch(true)
    .setPosition(25, 100)
    .setSize(150, 19)
    ;

  cp5.addButton("Luminosity")
    .setSwitch(true)
    .setPosition(25, 125)
    .setSize(150, 19)
    ;
  imageMode(CENTER);
  img = loadImage("2Building11.png");
  img2 = loadImage("Building11.png");
  //ArrayLists here
  boundaries = new ArrayList<Boundary>();
  
  boundaries.add(new Boundary(width/2, 760, 900, 5, 0));
  boundaries.add(new Boundary(112, 650, 5, 3000, 0));
  boundaries.add(new Boundary(760, 650, 5, 3000, 0));

  PVector origin = new PVector(width/2, 450);
  heatMap = new HeatMapping(origin);
  luminosity = new Luminosity();
  wind = new Wind();
  rain = new ParticleSystem(origin);
}

void draw() {
  background(255);
  //calculate (Steps)
  heatMap.run();
  wind.calculate();
  luminosity.calculate();
  
  box2d.step();
  //Luminosity
  if(Luminosity == true) {
    luminosity.display();
  if(lumPlayed == false) {
    luminosity.play();
    lumPlayed = true;
   }
  }
  if(Luminosity == false) {
    lumPlayed = false;
    
    
  }
  //Images
  tint(255, 255);
  image(img2, width/2, 450);
  
  tint(255, map(125, 0, height, 0, 255));
  image(img, width/2, 450);
  
  //People heatmap
  if(People == true) {
    //Add sound in here!
    heatMap.display();

    int x = 650;
    int y = 825;
    int w = 200;
    int h = 50;
    color c1 = color(0, 0, 255);
    color c2 = color(255, 0, 0);
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }

    textSize(18);
    fill(0);
    text("0", 650, 885);
    text("10", 845, 885);
    text("Total People: " + heatMap.getTotal(), 200, 850);
  }
  if(People == false) {
    heatMap.restart();
  }
  
  //Wind
  if(Wind == true) {
    box2d.setGravity(wind.getWindCalc(), -10);
  }
  if(Wind == false) {
    box2d.setGravity(0, -10);
  }
  //Rain
  if(Rain == true){
   rain.calculate();
   rain.run();
  if(rainPlayed == false){
   rain.play();
   rainPlayed = true;
   }
  }

 // for (int i = 0; i < boundaries.size(); i++) {
  //  Boundary b = boundaries.get(i);
  //  b.display();
 // }
 
}
