
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

  PImage img;
  PImage img2;

// A reference to our box2d world
Box2DProcessing box2d;

// A list we'll use to track fixed objects
ArrayList<Boundary> boundaries;

// A list for all particle systems
ArrayList<ParticleSystem> systems;

void setup() {
  size(900, 800);
  smooth();

  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();

  // We are setting a custom gravity
  box2d.setGravity(0, -20);

  // Create ArrayLists  
  systems = new ArrayList<ParticleSystem>();
  boundaries = new ArrayList<Boundary>();

  // Add a bunch of fixed boundaries
 boundaries.add(new Boundary(width/2, 800, 900, 100));
 boundaries.add(new Boundary(110, 800, 5, 800));
boundaries.add(new Boundary(770, 800, 5, 800));

  imageMode(CENTER);
  img = loadImage("Building11.jpg");
imageMode(CENTER);
  img2 = loadImage("Building11.png");
}




void draw() {
  background(255);
  tint(255,255);
    image(img2 , width/2, 450);
    
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
  for (Boundary wall: boundaries) {
    wall.display();
  }


for (int i = 0; i < 1; i++){
  // Add a new Particle System whenever the mouse is clicked
  systems.add(new ParticleSystem(0, new PVector(width/2, 1)));

}}
