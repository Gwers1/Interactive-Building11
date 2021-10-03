class Wind{
  Table windSpd, windDir;
  int placeInList;
  float windStrength, windDirection;
  Wind(){
    windSpd = loadTable("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2021-03-01T00%3A00&rToDate=2021-04-01T00%3A00&rFamily=weather&rSensor=IWS", "csv");
    windDir = loadTable("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2021-03-01T00%3A00&rToDate=2021-04-01T00%3A00&rFamily=weather&rSensor=IWD", "csv");
  }
  
  void calculate(){
    if(frameCount % 60 == 0){
      windStrength = windSpd.getFloat(placeInList, 1);
      windDirection = windDir.getFloat(placeInList, 1);
      placeInList++;
    }
  }
  
  float getWindCalc(){
    if(windDirection > 90 && windDirection < 270){
     return -windStrength *2; 
    }
    return windStrength * 2;
  }
}
