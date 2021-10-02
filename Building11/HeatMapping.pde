
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
     people.add(new Person(origin.x + random(-200, 200), origin.y, 10));
   }else{
     people.add(new Person(origin.x + random(-200, 200), origin.y, heat));
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

     if(calculate() > 0 ){ //remove people
       while(calculate() != 0){
         Person temp = people.get(0);
         float amountLeft = calculate();
         if(temp.getHeat() > amountLeft){
          temp.setHeat(temp.getHeat() - amountLeft); 
         }
         if(temp.getHeat() <= amountLeft){
           temp.setHeat(0);
           if(temp.isDone()){
             people.remove(temp);
           }
         }
       }
     }
       
     if(calculate() < 0){ //adding people
       while(calculate() != 0){
         Person temp = people.get(people.size()-1);
         float amountLeft = calculate();
         float recentHeat = temp.getHeat();
         if(recentHeat < 10){
           if(-amountLeft + recentHeat < 10){
            temp.setHeat(temp.getHeat() - amountLeft); 
           }
           if(-amountLeft + recentHeat >= 10){
             temp.setHeat(10);
           }
         }
         if(recentHeat == 10){
           addPeople(-calculate());
         }
         if(recentHeat > 10){ //If this happens its broken!
          print("Please fix code!");
          temp.setHeat(10); 
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
 
 //if this returns negative value more people need to be added to the list
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
