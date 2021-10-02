
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


class ParticleSystem  {

  ArrayList<Particle> particles;    // An ArrayList for all the particles
  PVector origin;         // An origin point for where particles are birthed

  ParticleSystem(int num, PVector v) {
    particles = new ArrayList<Particle>();             // Initialize the ArrayList
    origin = v.get();                        // Store the origin point

      for (int i = 0; i < num; i++) {
      particles.add(new Particle(origin.x,origin.y));    // Add "num" amount of particles to the ArrayList
    }
  }

  void run() {
    // Display all the particles
    for (Particle p: particles) {
      p.display();
    }

    // Particles that leave the screen, we delete them
    // (note they have to be deleted from both the box2d world and our list
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      if (p.done()) {
        particles.remove(i);
      }
    }
  }

  void addParticles(int n) {
    for (int i = 0; i < n; i++) {
      particles.add(new Particle(origin.x,origin.y));
    }
  }

  // A method to test if the particle system still has particles
  boolean dead() {
    if (particles.isEmpty()) {
      return true;
    } 
    else {
      return false;
    }
  }
}

class Particle {

  // We need to keep track of a Body
  Body body;

  PVector[] trail;

  // Constructor
  Particle(float x_, float y_) {
    float x = x_;
    float y = y_;
    trail = new PVector[5];
    for (int i = 0; i < trail.length; i++) {
      trail[i] = new PVector(x,y);
    }

    // Add the box to the box2d world
    // Here's a little trick, let's make a tiny tiny radius
    // This way we have collisions, but they don't overwhelm the system
    makeBody(new Vec2(x,y),5f);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height) {
      killBody();
      return true;
    }
    return false;
  }

  // Drawing the box
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);

    // Keep track of a history of screen positions in an array
    for (int i = 0; i < trail.length-1; i++) {
      trail[i] = trail[i+1];
    }
    trail[trail.length-1] = new PVector(pos.x,pos.y);

    // Draw particle as a trail
    beginShape();
    noFill();
    strokeWeight(10);
   
    stroke(0,0,255);
    for (int i = 0; i < trail.length; i++) {
      vertex(trail[i].x,trail[i].y);
    }
    endShape();
  }

  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 center, float r) {
    // Define and create the body
    BodyDef bd = new BodyDef();
        bd.type = BodyType.DYNAMIC;

    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);

    // Give it some initial random velocity
    body.setLinearVelocity(new Vec2(random(-1,1),random(-1,1)));

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
  
    fd.density = 1;
    fd.friction = 0.1;// Slippery when wet!
    fd.restitution = 0.5;

    // We could use this if we want to turn collisions off
    //cs.filter.groupIndex = -10;

    // Attach fixture to body
    body.createFixture(fd);

  }

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
