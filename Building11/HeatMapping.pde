
class HeatMapping {
 Table BroadwayIn, BroadwayOut;
 int placeInList, totalPeople;
 ArrayList<Person> people;
 PVector origin;
 
 HeatMapping(PVector origin){
   placeInList = 0;
   totalPeople = 0;
   //Timeperiod: 01/03/2021 12AM - 01/04/2021 12AM
   BroadwayIn = loadTable("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2021-03-01T00%3A00&rToDate=2021-04-01T00%3A00&rFamily=people_sh&rSensor=CB11.PC02.14.Broadway&rSubSensor=CB11.02.Broadway.East+In", "csv");
   BroadwayOut = loadTable("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2021-03-01T00%3A00&rToDate=2021-04-01T00%3A00&rFamily=people_sh&rSensor=CB11.PC02.14.Broadway&rSubSensor=CB11.02.Broadway.East+Out", "csv");
   people = new ArrayList<Person>();
   this.origin = origin; 
 }
 
 void addPeople(float heat){ //returns left over
   if(heat > 10){
     print(" Adding people > ");
     people.add(new Person(origin.x, origin.y, 10));
     print(people.size());
   }else{
     print(" Adding people with heat: ", heat);
     people.add(new Person(origin.x, origin.y, heat));
     print(" This is size: ", people.size());
   }
   
 }
 
 void run(){
   //print(frameCount % frameRate);
   
   if((frameCount % 60) == 0){ //Ticks approximately every 60 frames
     totalPeople += BroadwayIn.getFloat(placeInList, 1) - BroadwayOut.getFloat(placeInList, 1);
     if(people.size() == 0){ //inital case
       if((totalPeople > 0 && totalPeople <= 10)){
         //print(" people.size() if: ", people.size());
         addPeople(totalPeople);
       }
     }
     print(" This is calculate: ", calculate());
     print(" This is total people: ", totalPeople);
     if(calculate() > 0 ){ //add people
       while(calculate() != 0){
         Person temp = people.get(people.size()-1);
         float amountLeft = calculate();
         float recentHeat = temp.getHeat();
         if(recentHeat < 10){
           if(10 - recentHeat < amountLeft){
            temp.setHeat(temp.getHeat() + amountLeft); 
           }
           if(10 - recentHeat > amountLeft){
             temp.setHeat(10);
           }
         }
         if(recentHeat == 10){
           addPeople(calculate());
         }
       }
     }
       
     if(calculate() < 0){ //destroy people
       while(calculate() != 0){
         Person temp = people.get(people.size()-1);
         float amountLeft = calculate();
         print(" This is amount left: ", -amountLeft);
         print(" This is temp get heat: ", temp.getHeat());
         if(temp.getHeat() > -amountLeft){
          temp.setHeat(temp.getHeat() + amountLeft); 
          print(temp.getHeat());
         }
         if(temp.getHeat() <= -amountLeft){
           temp.setHeat(0);
           if(temp.isDone()){
             print("removing");
             people.remove(temp);
           }
         }
       }
     }
     //print(totalPeople, " ");

     placeInList++;
   }
   for(Person p: people) {
     p.display();
   }
 }
 
 //if this returns positve value more people need to be added to the list
 float calculate(){
   float count = 0;
   if(people.size() != 0){
     for(int i = 0; i < people.size(); i++){
       Person p = people.get(i);
       count += p.getHeat();
     }
     return count = count - totalPeople;
   }
   return 0;
 }
}
