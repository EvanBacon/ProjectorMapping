class Point {
  float x, y, lx, ly,w, h, s, b;
  Point(float x, float y, float lx, float ly, float w, float h, float s, float b) {
    this.x = x;
    this.y = y;
    this.lx = lx;
    this.ly = ly;
    this.w = w;
    this.h = h;
    this.s = s;
    this.b = b;
  }
  
  void draw() {
      strokeWeight(5);
      stroke(h, s, b);   
      line(x, y, lx, ly); 
  }
}