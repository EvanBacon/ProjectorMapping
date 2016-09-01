class Canvas {

  float h=0;
  float s=100;
  float b=100;
  float dh=1;

  ArrayList<Point> lines = new ArrayList();
  
  Canvas() {
    
  }

  void draw() {
    //colorMode(R); 
    this.updatePoints();
    this.drawPoints();
  }

void clearPoints() {
 lines = new ArrayList(); 
}
void addPoint(float x,float y, float lx, float ly, float w) {
  Point a = new Point(x,y, lx, ly, w, 255, 0, 0);
      lines.add(a);
}
  void updatePoints() {
    //if (mousePressed) {
    //  Point a = new Point(mouseX, mouseY, pmouseX, pmouseY, 1, h, s, b);
    //  lines.add(a);

    //  //updateColor();
    //}
  }

  void drawPoints() {
    for (Point a : lines) { 
   a.draw();
      //pattern4(a);
    }
  }
  
  void pattern4(Point a){
  noStroke();
  fill(a.h, a.s, a.b ,10);
  // alter the width size
  //float widthDistance = abs(width/2 - mouseX);
  ellipse(a.x, a.y, width/2,width/2); 
}


  //void updateColor() {
  //  h+=.5; //make rainbow colors change
  //  if (h>=100) {
  //    h=0;
  //  }
  //}
}