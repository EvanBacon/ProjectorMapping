class CropPoint {
  float x, y;
  CropPoint(float x, float y) {
    this.x = x;
    this.y = y;
    
  }
  
  void draw() {
      ellipse(x, y, 20, 20);
  }
  
  void connect(CropPoint p) {
      strokeWeight(3);
      stroke(255);   
      line(x, y, p.x, p.y); 
  }
}

int segIntersection(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
  float bx = x2 - x1;
  float by = y2 - y1;
  float dx = x4 - x3;
  float dy = y4 - y3;
  float b_dot_d_perp = bx * dy - by * dx;
  if (b_dot_d_perp == 0) {
    return 0;
  }
  float cx = x3 - x1;
  float cy = y3 - y1;
  float t = (cx * dy - cy * dx) / b_dot_d_perp;
  if (t < 0 || t > 1) {
    return 0;
  }
  float u = (cx * by - cy * bx) / b_dot_d_perp;
  if (u < 0 || u > 1) {
    return 0;
  }
  if (y4 > y3) {
    if (y2 == y4) {
      return 0;
    }
  }
  else {
    if (y2 == y3) {
      return 0;
    }
  }
  return 1;
}