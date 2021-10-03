public class Luminosity {
  Table w, rangeTable;
  int index;
  float lux, low, high;


  Luminosity() {
    // march 1 12:00am - apr 1 12:00am
    index = 0;
    lux = 0;
    // table of the averaged values from all 12 sensors in an excel sheet
    w = loadTable ("AverageWaspmoteLuxValues.csv");
    low = min(w);
    high = max(w);
  }


  void calculate() {
    if (frameCount % 60 == 0) {
      if (index < w.getRowCount()) {
        lux = w.getFloat(index, 0);
        index++;
      }
    }
  }

  void display() {
    fill(rangeConvert(lux));
    rect(width/2, height - 325, 900, 450);
  }

  float rangeConvert(float y) { // converts a value in the table into a range from 0-255
    float OldRange = (high - low);

    if (OldRange == 0) // in case the range is 0, otherwise the next statement would divide by zero
      return 0;
    else
      return ((y - low) * 255) / OldRange;
  }


  float min(Table w) { // returns  minimum value in the averaged table
    rangeTable = loadTable("AverageWaspmoteLuxValues.csv");
    rangeTable.sort(0);
    return rangeTable.getFloat(0, 0);
  }

  float max(Table w) { // returns maximum value in the averaged table
    rangeTable = loadTable("AverageWaspmoteLuxValues.csv");
    rangeTable.sort(0);
    return rangeTable.getFloat(rangeTable.getRowCount()-1, 0);
  }
}
