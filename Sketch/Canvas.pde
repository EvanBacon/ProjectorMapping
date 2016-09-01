class Canvas {

  float h=0;
  float s=100;
  float b=100;
  float dh=1;

  ArrayList<Point> lines = new ArrayList();
  
  Canvas() {
    
  }

  void draw() {
    colorMode(HSB, 100); 
    this.updatePoints();
    this.drawPoints();
  }

  void updatePoints() {
    if (mousePressed) {
      Point a = new Point(mouseX, mouseY, pmouseX, pmouseY, 1, h, s, b);
      lines.add(a);

      updateColor();
    }
  }

  void drawPoints() {
    for (Point a : lines) { 
      strokeWeight(a.w);
      stroke(a.h, a.s, a.b);   
      line(a.x, a.y, a.lx, a.ly);
    }
  }

  void updateColor() {
    h+=.5; //make rainbow colors change
    if (h>=100) {
      h=0;
    }
  }
}