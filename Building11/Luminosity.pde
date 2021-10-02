public class Luminosity {
  Table Waspmote, rangeTable; // eventually add all 12 sensors and average it
  int index;
  float y, low, high;



  Luminosity(ArrayList<Boundary> boundaries) {
    // march 1 12:00am - apr 1 12:00am
    Waspmote = loadTable("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2021-03-01T00%3A00&rToDate=2021-04-01T00%3A00&rFamily=wasp&rSensor=ES_C_13_302_C88E&rSubSensor=LUM", "csv");
    index = 0;
    y = 0;
    rangeTable = loadTable("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2021-03-01T00%3A00&rToDate=2021-04-01T00%3A00&rFamily=wasp&rSensor=ES_C_13_302_C88E&rSubSensor=LUM", "csv"); // table to find lowest/highest value of lux
    rangeTable.sort(1);
    low = rangeTable.getFloat(0, 1); // lowest value in the table
    high = rangeTable.getFloat(rangeTable.getRowCount()-1, 1); // highest value in the table
    //println(rangeTable.getRowCount());
    //println(low);
    //println(high);
  }

  void run() {
    if (index < Waspmote.getRowCount()) {
      y = Waspmote.getFloat(index, 1);
      index++;
    }
    else {
      index = 0; //reset
      println("reset");
    }
    fill(rangeConvert(y));
    rect(width/2, height, 900, 400);
    println(index);
    println(y);
    println(rangeConvert(y));
  }

  float rangeConvert(float y) { // converts a value in the table into a range from 0-255
    float OldRange = (high - low);
    
    if (OldRange == 0) // in case the range is 0, otherwise the next statement would divide by zero
      return 0;
    else
      return ((y - low) * 255) / OldRange;
  }
}
