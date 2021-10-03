
class HeatMapping {
  Table totalPeopleCount;
  int placeInList, totalPeople;
  ArrayList<Person> people;
  PVector origin;
  AudioContext ac;
  SamplePlayer player;
  Gain g;
  float gainValue;

  HeatMapping(PVector origin) {
    placeInList = 0;
    totalPeople = 0;
    //Timeperiod: 01/03/2021 12AM - 01/04/2021 12AM
    totalPeopleCount = loadTable("TotalPeopleCount.csv");
    people = new ArrayList<Person>();
    this.origin = origin; 

    ac = new AudioContext();
    String audioFileName = sketchPath("") + "peopletalkingsound.mp3";
    player = new SamplePlayer(ac, SampleManager.sample(audioFileName));
    player.setKillOnEnd(false);
    g = new Gain(ac, 1, 0.5);
    g.addInput(player);
    gainValue = 0.0;
    ac.out.addInput(g);
  }

  void addPeople(float heat) { //returns left over
    if (heat > 10) {
      people.add(new Person(origin.x + random(-200, 200), origin.y, 10));
    } else {
      people.add(new Person(origin.x + random(-200, 200), origin.y, heat));
    }
  }

  void run() {
    //print(frameCount % frameRate);

    if ((frameCount % 60) == 0) { //Ticks approximately every 60 frames
     totalPeople += totalPeopleCount.getInt(placeInList, 2);
      //print("This is in: ", BroadwayIn.getString(placeInList, 0), " ");
      //print("This is out: ", BroadwayOut.getString(placeInList, 0) ," ");
      if (people.size() == 0) { //inital case
        //print(" people.size() if: ", people.size());
        addPeople(totalPeople);
      }

      if (calculate() > 0 ) { //remove people
        while (calculate() != 0) {
          Person temp = people.get(0);
          float amountLeft = calculate();
          if (temp.getHeat() > amountLeft) {
            temp.setHeat(temp.getHeat() - amountLeft);
          }
          if (temp.getHeat() <= amountLeft) {
            temp.setHeat(0);
            if (temp.isDone()) {
              people.remove(temp);
            }
          }
        }
        gainValue -= 0.05;
      }

      if (calculate() < 0) { //adding people
        while (calculate() != 0) {
          Person temp = people.get(people.size()-1);
          float amountLeft = calculate();
          float recentHeat = temp.getHeat();
          if (recentHeat < 10) {
            if (-amountLeft + recentHeat < 10) {
              temp.setHeat(temp.getHeat() - amountLeft);
            }
            if (-amountLeft + recentHeat >= 10) {
              temp.setHeat(10);
            }
          }
          if (recentHeat == 10) {
            addPeople(-calculate());
          }
          if (recentHeat > 10) { //If this happens its broken!
            print("Please fix code!");
            temp.setHeat(10);
          }
        }
        gainValue += 0.05;
      }
      //print(totalPeople, " ");
      g.setGain(gainValue);
      placeInList++;
    }
  }

  void display() {
    for (Person p : people) {
      p.display();
    }
  }

  void restart() {
    for (Person p : people) {
      p.killBody();
    }
    people.clear();
  }

  int getTotal() { 
    return totalPeople;
  }
  //if this returns negative value more people need to be added to the list
  float calculate() {
    float count = 0;
    if (people.size() != 0) {
      for (int i = 0; i < people.size(); i++) {
        Person p = people.get(i);
        count += p.getHeat();
      }
      return count = count - totalPeople;
    }
    return 0;
  }

  void play() {
    ac.start();
    player.start();
    player.setToLoopStart();
  }
  
  void stop() {
   ac.stop();
  }
  
}
