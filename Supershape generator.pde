import peasy.*;
import controlP5.*;

PeasyCam cam;
Table table;

PVector[][] globe;
int total = 75;

float n1;
float n2;
float n3;
float m;

float n12;
float n22;
float n32;
float m2;
float mchange;

int offset = 0;
int i=0;
int n=0;



void setup() {
  size(600, 600, P3D);
  smooth(6);
  cam = new PeasyCam(this, 500);
  globe = new PVector[total+1][total+1];
  colorMode(HSB);
  csv_read(0);
}

float supershape(float theta, float n1, float n2, float n3, float m) {
  int a=1;
  int b=1;
  float t1= abs((1/a)*cos(m*theta/4));
  t1= pow(t1, n2);
  float t2 = abs((1/b)*sin(m*theta/4));
  t2 = pow(t2, n3);
  float t3 = t1+t2;
  float r= pow(t3, -1/n1);
  return r;
}

void framerate() {
  //Display FrameRate
  if (i%2==0) { 
    String title= "Anupam's Supershape Generator FPS:" + str(round(frameRate));
    surface.setTitle(title);
  } else {
  }
  i++;
}

void csv_read(int n) {
  table = loadTable("supershapes.csv", "header");

  TableRow row = table.getRow(n); 

  n1 = row.getFloat("n1");
  n2 = row.getFloat("n2");
  n3 = row.getFloat("n3");
  m = row.getFloat("m");

  n12 = row.getFloat("n12");
  n22 = row.getFloat("n22");
  n32 = row.getFloat("n32");
  m2 = row.getFloat("m2");

  //String species = row.getString("species");
}


void keyPressed() {
  if (key>0) {
    n+=1;
    if (n>6) {
      n=0;
    }
    csv_read(n);
  }
}


void draw() {
  framerate();
  background(0);
  lights();
  //stroke(255);
  noStroke();
  m = map(sin(mchange), -1, 1, 0, 7);
  mchange+=0.05;

  int r = 150;
  for (int i=0; i<total+1; i++) {
    float lat = map(i, 0, total, -HALF_PI, HALF_PI);
    float r2 = supershape(lat, n12, n22, n32, m2);


    for (int j=0; j<total+1; j++)
    {
      float lon = map(j, 0, total, -PI, PI);
      float r1 = supershape(lon, n1, n2, n3, m);
      float x = r * r1 * cos(lon) * r2 * cos(lat);
      float y = r * r1 * sin(lon) * r2 * cos(lat);
      float z = r * r2 * sin(lat);

      globe[i][j]= new PVector(x, y, z);
      //PVector v2 = PVector.random3D();
      //v2.mult(5);
      //globe[i][j].add(v2);
    }
  }

  offset+=2;
  for (int i=0; i<total; i++) {
    //float hu = map(i, 0, total, 0, 255);
    //fill((hu+offset)%255, 255, 255);
    beginShape(TRIANGLE_STRIP);
    for (int j=0; j<=total; j++)
    { 
      float hu = map(j, 0, total, 0, 255);
      fill(hu, 255, 255);
      PVector v1 = globe[i][j];
      vertex(v1.x, v1.y, v1.z);
      PVector v2 = globe[i+1][j];
      vertex(v2.x, v2.y, v2.z);
    }
    endShape();
  }
}
