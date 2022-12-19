// Conway Game of Life with Evolution
// New cell randomly differ in their strategy of life, i.e. counts of neighbours leading to death/birth
// RGB  Green = strategy for high density of neighbours, Blue = strategy for low neighbours density
// By Jaroslav Trnka, 2021
// https://github.com/JaroslavTrnka1
// jaroslav_trnka@centrum.cz

import java.util.Arrays;

int xside;
int yside;
int deathindex; //How many neighbours densities lead to death

ArrayList <cell> field = new ArrayList <cell> ();

void setup() {
  size(800,800);
  deathindex = 4;
  xside = 40;
  yside = 40;
  for (int j = 0; j < (yside * xside); j++) {field.add(new cell(j));}
}

void draw () {
 background(255);
 for (cell c : field) {
  c.check();
  c.celldraw(); 
 }
}


class cell{
 ArrayList <Integer> birth;
 ArrayList <Integer> death;
 ArrayList <Integer> neighbours;
 boolean alife;
 PVector pos;
 int id;
 int count;
 int strategy;
 
 cell(int index) {
   neighbours = new ArrayList<Integer> ();
   birth = new ArrayList<Integer> ();
   death = new ArrayList<Integer> ();
   neighbours.addAll(Arrays.asList(index - xside - 1, index - xside, index - xside + 1, index - 1, index + 1, index + xside - 1, index + xside, index + xside + 1));
    if (index < xside) { //no up
      neighbours.remove(neighbours.indexOf(index - xside - 1));
      neighbours.remove(neighbours.indexOf(index - xside));
      neighbours.remove(neighbours.indexOf(index - xside + 1));
    }
    if (index >= (yside-1) * xside) { //no down
      neighbours.remove(neighbours.indexOf(index + xside - 1));
      neighbours.remove(neighbours.indexOf(index + xside));
      neighbours.remove(neighbours.indexOf(index + xside + 1));
    }
    if ((index % xside) == 0) { //no left
      neighbours.remove(neighbours.indexOf(index - 1));
      if (neighbours.contains(index - xside - 1)) {neighbours.remove(neighbours.indexOf(index - xside - 1));}
      if (neighbours.contains(index + xside - 1)) {neighbours.remove(neighbours.indexOf(index + xside - 1));}
    }
    if ((index % xside) == xside-1) { //no right
      neighbours.remove(neighbours.indexOf(index + 1));
      if (neighbours.contains(index - xside + 1)) {neighbours.remove(neighbours.indexOf(index - xside + 1));}
      if (neighbours.contains(index + xside + 1)) {neighbours.remove(neighbours.indexOf(index + xside + 1));}
    }
   pos = new PVector(index % xside, int (index / xside));
   id = index;
   alife = false;
   birth.addAll(Arrays.asList(0,1,2,3,4,5,6,7,8));
   for (int i  = 0; i < deathindex; i++) { // Transfer of life possibilities to death possibilities
     int x = int(random(birth.size()));
     death.add(birth.get(x));
     birth.remove(x);
   }
   strategy = 0;
   for (int i = 0; i < birth.size(); i++) {
     strategy += birth.get(i);
   }
 }
 
  void check() {
    count = 0;
    for (int i = 0; i < neighbours.size(); i++) {
      if (field.get(neighbours.get(i)).alife) {count++;}
    }
    if (!alife) {
      if (birth.contains(count)) {alife = true;}
    }
    if (alife) {
      if (death.contains(count)) {
        alife = false;
        int randomneighbour = int(random(neighbours.size()));
        birth = field.get(neighbours.get(randomneighbour)).birth;
        death = field.get(neighbours.get(randomneighbour)).death;
        strategy = 0;
        for (int i = 0; i < birth.size(); i++) {
          strategy += birth.get(i);
        }
      }
    }   
  }

 void celldraw() {
   strokeWeight(1);
   fill (255);
   if (alife) {fill(0,255 * strategy/36, 255 * (36 - strategy)/36);} //RGB  Green = strategy for high density of neighbours Blue = strategy for low neighbours density
   rect((id % xside) * (width/xside), int (id/xside) * (height/yside), ((id % xside) + 1) * (width/xside), (int (id/xside) + 1) * (height/yside));
 }

}
