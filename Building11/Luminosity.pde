public class Luminosity {
  Table Waspmote, w1, w2, w5, w52, w6, w7, w8, w9, w11, w12, w13, rangeTable; // add all 12 sensors and average it
  int index;
  float y, low, high;


  Luminosity() {
    // march 1 12:00am - apr 1 12:00am
    Waspmote = loadTable("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2021-03-01T00%3A00&rToDate=2021-04-01T00%3A00&rFamily=wasp&rSensor=ES_C_13_302_C88E&rSubSensor=LUM", "csv");
    index = 0;
    y = 0;
    
    w1 = loadTable ("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2021-03-01T00%3A00&rToDate=2021-04-01T00%3A00&rFamily=wasp&rSensor=ES_B_01_411_7E39&rSubSensor=LUM", "csv");
    w2 = loadTable ("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2021-03-01T00%3A00&rToDate=2021-04-01T00%3A00&rFamily=wasp&rSensor=ES_B_02_412_3E68&rSubSensor=LUM", "csv");
    w5 = loadTable ("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2021-03-01T00%3A00&rToDate=2021-04-01T00%3A00&rFamily=wasp&rSensor=ES_B_05_417_7C13&rSubSensor=LUM", "csv")
    //two sensors on level 5, second one is named w52
    w52 = loadTable ("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2021-03-01T00%3A00&rToDate=2021-04-01T00%3A00&rFamily=wasp&rSensor=ES_B_05_416_7C15&rSubSensor=LUM", "csv");
    w6 = loadTable ("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2021-03-01T00%3A00&rToDate=2021-04-01T00%3A00&rFamily=wasp&rSensor=ES_B_06_418_7BED&rSubSensor=LUM", "csv");
    w7 = loadTable ("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2021-03-01T00%3A00&rToDate=2021-04-01T00%3A00&rFamily=wasp&rSensor=ES_B_07_420_7E1D&rSubSensor=LUM", "csv");
    w8 = loadTable ("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2021-03-01T00%3A00&rToDate=2021-04-01T00%3A00&rFamily=wasp&rSensor=ES_B_08_422_7BDC&rSubSensor=LUM", "csv");
    w9 = loadTable ("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2021-03-01T00%3A00&rToDate=2021-04-01T00%3A00&rFamily=wasp&rSensor=ES_B_09_425_3E8D&rSubSensor=LUM", "csv");
    w11 = loadTable ("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2021-03-01T00%3A00&rToDate=2021-04-01T00%3A00&rFamily=wasp&rSensor=ES_B_11_428_3EA4&rSubSensor=LUM", "csv");
    w12= loadTable ("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2021-03-01T00%3A00&rToDate=2021-04-01T00%3A00&rFamily=wasp&rSensor=ES_B_12_431_7BC2&rSubSensor=LUM", "csv");
    w13 = loadTable ("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2021-03-01T00%3A00&rToDate=2021-04-01T00%3A00&rFamily=wasp&rSensor=ES_C_13_302_C88E&rSubSensor=LUM", "csv");

    // table to find lowest/highest value of lux
    rangeTable = loadTable("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2021-03-01T00%3A00&rToDate=2021-04-01T00%3A00&rFamily=wasp&rSensor=ES_C_13_302_C88E&rSubSensor=LUM", "csv"); 
    //rangeTable = Waspmote;
    // for some reason using rangeTable = Waspmote edited Waspmote when sorting rangeTable

    rangeTable.sort(1);
    low = rangeTable.getFloat(0, 1); // lowest value in the table
    high = rangeTable.getFloat(rangeTable.getRowCount()-1, 1); // highest value in the table
  }


  void calculate() {
    if (frameCount % 60 == 0) {
      if (index < Waspmote.getRowCount()) {
        y = Waspmote.getFloat(index, 1);
        index++;
      }
    }
  }


  void display() {
    fill(rangeConvert(y));
    rect(width/2, height - 325, 900, 450);
  }

  float rangeConvert(float y) { // converts a value in the table into a range from 0-255
    float OldRange = (high - low);

    if (OldRange == 0) // in case the range is 0, otherwise the next statement would divide by zero
      return 0;
    else
      return ((y - low) * 255) / OldRange;
  }
}
