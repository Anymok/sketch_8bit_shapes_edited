import processing.svg.*;

String[] quantumCorpusLoad;
String[] finalQuantumArray;
int canvasWidth = 1000;
int canvasHeight = 1000;
int startingX;
int startingY;
int shots = 8192; //max is 8192
int lineSize = 1;
Boolean simulate = true; // true for simulated data. false for real data

int shapeSize = 80;
int startingPosition = 700; //there are 8000 shots and this piece only uses 36. This shifts the starting point to use those other shots to make new compositions
int bitstringLength = 9;

color black = color(0);
color white = color(255);
color red = color(255, 0, 0); // Red
color blue = color(0, 0, 255);   // Blue

void setup() {
  frameRate(120);
  size(1000,1000);
  loadPixels();
  pixelDensity(2);
  if (simulate) {
    createReadings();
  }
  ;
  background(black);
  noFill();
  shapeMode(CENTER);
  
  startingX = canvasWidth/2;
  startingX = shapeSize*2;
  startingY = canvasHeight/2;
  startingY = shapeSize*2;

  //render it all at once
  for (int i = 0+startingPosition; i < 36+startingPosition; i++) { //normally i < shots
    float t = map(i, startingPosition, 36 + startingPosition - 1, 0, 1); // interpolation entre 0 et 1
    color shapeColor = lerpColor(red, blue, t);
    stroke(shapeColor);
    drawLine(finalQuantumArray[i]);
  }
}
 //<>//
void createReadings() {
  Simulator simulator = new Simulator(0.1);
  
  QuantumCircuit phiPlus = new QuantumCircuit(bitstringLength, bitstringLength);
  
  for (int i = 0; i < bitstringLength; i++) {
    phiPlus.h(i);
    phiPlus.measure(i, i);
  }
  phiPlus.cx(0, 1);

  List<String> measurements = new ArrayList();
  for (int i = 0; i < shots; i++) {
    Map<String,Integer> counts = (Map)simulator.simulate(phiPlus, 1, "counts");
    String firstKey = counts.keySet().iterator().next();
    measurements.add(firstKey);
  }
  finalQuantumArray = measurements.toArray(new String[0]);
} //<>//

void drawLine(String n) {
  
  char qb[] = new char[bitstringLength];
  
  //println(n.charAt(0));
  if (!simulate) {
    for (int i = 0; i < qb.length; i ++) {
      qb[i] = n.charAt(i+1); //there is an extra character in the real data 
      //println(qb[i]);
    }
  } else {
    for (int i = 0; i < qb.length; i ++) {
      qb[i] = n.charAt(i);
    }
  }
  
  
  int binary1='1';
  char c = (char)binary1; 
  

  if (qb[0] == c) {
    pushMatrix();
    translate(startingX, startingY);      // se place à la position
    rotate(radians(random(360)));         // rotation aléatoire
    ellipse(0, 0, shapeSize+10, shapeSize+10);  // centre en (0,0) après translation
    popMatrix();
  } 
  if (qb[1] == c) {
    pushMatrix();
    translate(startingX, startingY);
    scale(random(0.5, 1.5)); // réduit ou agrandit
    square(-shapeSize/2, -shapeSize/2, shapeSize); // centré
    popMatrix();
  } 
  if (qb[2] == c) {
    star(startingX, startingY, shapeSize-10, shapeSize-10, 3); //hexagon
  } 
  if (qb[3] == c) {
    star(startingX, startingY, shapeSize-20, shapeSize, 2); //diamond long
  } 
  if (qb[4] == c) {
    star(startingX, startingY, shapeSize, shapeSize-20, 2); //diamond tall
  } 
  if (qb[5] == c) {
    line(startingX, startingY-(shapeSize/2)+10, startingX, startingY+(shapeSize/2)-10); //vertical line
  } 
  if (qb[6] == c) {
    line(startingX-(shapeSize/2)+10, startingY, startingX+(shapeSize/2)-10, startingY); //horizontal line
  } 
  if (qb[7] == c) {
    triangle(startingX, startingY-30, startingX-30, startingY+20, startingX+30, startingY+20);
  }
  if (qb[8] == c) {
    polygon(startingX, startingY, shapeSize/2, 5); // pentagon
  }
  
  if (startingX < canvasWidth-(shapeSize*3)) { //if starting x hasn't reached the right of the page yet
    startingX += (shapeSize*3);
  } else {
    startingX = shapeSize*2;
    startingY += (shapeSize*3); //go down on the starting Y
  }
  
}

void star(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

void polygon(float x, float y, float radius, int npoints) {
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}
