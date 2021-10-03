class Wind {
  Table windSpd, windDir;
  int placeInList;
  float previousWind, windStrength, windDirection, gainVal;
  AudioContext ac;
  SamplePlayer player;
  Gain g;
  Wind() {
    windStrength =0;
    windSpd = loadTable("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2021-03-01T00%3A00&rToDate=2021-04-01T00%3A00&rFamily=weather&rSensor=IWS", "csv");
    windDir = loadTable("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2021-03-01T00%3A00&rToDate=2021-04-01T00%3A00&rFamily=weather&rSensor=IWD", "csv");
    gainVal = 1;
    //ac = AudioContext.getDefaultContext();
    ac = new AudioContext();
    String audioFileName = sketchPath("") + "wind.mp3";
    Sample sample = SampleManager.sample(audioFileName); 
    SamplePlayer player = new SamplePlayer(sample);
    player.setToLoopStart();
    player.setKillOnEnd(false);
    g = new Gain(ac, 1, gainVal);
    g.addInput(player);
    ac.out.addInput(g);
  }

  void calculate() {
    if (frameCount % 60 == 0) {
      previousWind = windStrength;
      windStrength = windSpd.getFloat(placeInList, 1);
      windDirection = windDir.getFloat(placeInList, 1);
      if (ac.isRunning()) {
        updateGain();
      }
      placeInList++;
    }
  }

  void playSound() {
    ac.start();
  }

  void updateGain() {
    if (ac.isRunning()) {
      if (previousWind > windStrength) {
        if (g.getGain() > 1) {
          g.setGain(g.getGain() - 0.1);
        }
      }
      if (previousWind < windStrength) {
        if (g.getGain() < 2) {
          g.setGain(g.getGain() + 0.1);
        }
      }
    }
  }

  void stopSound() {
    if (ac.isRunning()) {
      ac.stop();
    }
  }

  float getWindCalc() {
    if (windDirection > 90 && windDirection < 270) {
      return -windStrength *2;
    }
    return windStrength * 2;
  }
}
