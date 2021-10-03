class wind{
  Table windSpd, windDir;
  int placeInList;
  float windStrength, windDirection;
  wind(){
    windSpd = loadTable("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2021-03-01T00%3A00&rToDate=2021-04-01T00%3A00&rFamily=weather&rSensor=IWS", "csv");
    windDir = loadTable("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2021-03-01T00%3A00&rToDate=2021-04-01T00%3A00&rFamily=weather&rSensor=IWD", "csv");
  }
  
  void calculate(){
    if(frameCount % 60 == 0){
      windStrength = windSpd.getFloat(1, placeInList);
      windDirection = windDir.getFloat(1, placeInList);
      placeInList++;
    }
  }
  
  float getWindCalc(){
    if(windDirection > 90 || windDirection < 270){
     return -windStrength; 
    }
    return windStrength;
  }
}
