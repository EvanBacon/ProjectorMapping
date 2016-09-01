class Emitter{
  PVector loc, acc;
  color c;
  float r;
  Emitter(PVector loc1) {
    loc = loc1;
    acc = new PVector(random(-1, 1), random(-1, 1));
    c = (color) random(#000000);
    r = random(20);
  }

  void display() {
    fill(c);
    noStroke();
    ellipse(loc.x, loc.y, r, r);
  }

  void update() {
    loc.add(acc);
  }
}