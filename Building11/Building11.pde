
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

  PImage img;
  PImage img2;

// A reference to our box2d world
Box2DProcessing box2d;
ControlP5 cp5;

// A list we'll use to track fixed objects
ArrayList<Boundary> boundaries;
HeatMapping heatMap; 
Luminosity luminosity;

Wind wind;
//Additional global varriables
boolean People, Rain, Wind, Luminosity = false;

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
  //ArrayLists here
  boundaries = new ArrayList<Boundary>();

  boundaries.add(new Boundary(width/2, 800, 600, 5, 0));
  boundaries.add(new Boundary(width/2-300, 650, 5, 300, 0));
  boundaries.add(new Boundary(width/2+300, 650, 5, 300, 0));

  PVector origin = new PVector(width/2, 450);
  heatMap = new HeatMapping(origin);
  luminosity = new Luminosity();
  wind = new Wind();
  // We are setting a custom gravity
  box2d.setGravity(0, -10);

  // Create ArrayLists  
  systems = new ArrayList<ParticleSystem>();
  boundaries = new ArrayList<Boundary>();

  // Add a bunch of fixed boundaries
 boundaries.add(new Boundary(width/2, 805, 900, 100));
 boundaries.add(new Boundary(110, 800, 5, 1800));
boundaries.add(new Boundary(760, 800, 5, 1800));

 
  imageMode(CENTER);
  img = loadImage("Building11.jpg");
imageMode(CENTER);
  img2 = loadImage("Building11.png");
}

void draw() {
  background(255);
  fill(0);
  rect(width/2, height/2 - 300, 900, 400);

  box2d.step();
  
  wind.calculate();
  luminosity.calculate();  
  if (Luminosity == true) {
    luminosity.display();
  }
  heatMap.run();
  if (People == true) {
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
  if(People == false){
    heatMap.restart();
  }
  
  if(Wind == true){
    box2d.setGravity(wind.getWindCalc(), -10);
    print("setting gravity", wind.getWindCalc());
  }
  if(Wind == false){
   box2d.setGravity(0, -10); 
  }
  
  for (int i = 0; i < boundaries.size(); i++) {
    Boundary b = boundaries.get(i);
    b.display();
  }

}

void draw() {
  background(255);
  tint(255,255);
    image(img2 , width/2, 450);
   //lower the opacity of the rectangle to fraction based on mouseY
    
    tint( 255, map(125,0, height, 0, 255 ) );
    image(img, width/2, 450 );  





  // We must always step through time!
  box2d.step();

  // Run all the particle systems
  for (ParticleSystem system: systems) {
    system.run();

    int n = (int) random(0,2);
    system.addParticles(n);
    }
  

  // Display all the boundaries
  //for (Boundary wall: boundaries) {
  // wall.display();
 // }

  if (random(10) < 0.02) {
  systems.add(new ParticleSystem(0, new PVector(width/2, -200)));
  }}
