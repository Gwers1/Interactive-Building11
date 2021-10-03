class ParticleSystem {




  ArrayList<Particle> particles;    // An ArrayList for all the particles
  PVector origin;         // An origin point for where particles are birthed
  float rainVal;

  int index =0;

  Table rainData = loadTable("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2021-03-01T00%3A00&rToDate=2021-04-01T00%3A00&rFamily=weather&rSensor=RG", "csv");
AudioContext ac;
  SamplePlayer player;

  ParticleSystem(PVector v) {
    particles = new ArrayList<Particle>();             // Initialize the ArrayList
    origin = v.get();                        // Store the origin point
    
     ac = new AudioContext();
    String audioFileName = sketchPath("") + "rainfallingsound.mp3";
    player = new SamplePlayer(ac, SampleManager.sample(audioFileName));
    player.setKillOnEnd(false);
    Gain g = new Gain(ac,1,0.2);
    g.addInput(player);
    
    ac.out.addInput(g);
  }

    

  boolean isRaining() {
    boolean answer = rainData.getFloat(index, 1) > 0;
    
    return answer;
  }


  void calculate() {
    if (frameCount % 1 == 0) {
      rainVal = rainData.getFloat(index, 1);
      index++;
      
    }
  }


  float getRainVal() {
    return rainVal;
  }


  void run() {
    // Display all the particles
    for (Particle p : particles) {
      p.display();
    }

    if (isRaining()) {
      addParticles((int) (rainVal*40));
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
      particles.add(new Particle(origin.x + random(-300, 300), origin.y));
    
    }
  }

  // A method to test if the particle system still has particles
  boolean dead() {
    if (particles.isEmpty()) {
      return true;
    } else {
      return false;
    }
  }
  
  void play() {
    ac.start();
    player.start();
    player.setToLoopStart();
  }
}
