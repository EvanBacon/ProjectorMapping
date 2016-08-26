public class ChessboardApplet extends PApplet {

    ChessboardApplet() {
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
   }

 int x0 = 0;
  int y0 = 0;
  int cwidth = 0;
  public void settings() {
  fullScreen(2);
      //size(1600,900);

}

  public void setup() {
    //noLoop();
  }
  public void draw() {
    //background(255,0,0);
    
    
  int cheight = (int)(cwidth * 0.8);
  ca.background(255);
  ca.fill(0);
  for (int j=0; j<4; j++) {
    for (int i=0; i<5; i++) {
      int x = int(x0 + map(i, 0, 5, 0, cwidth));
      int y = int(y0 + map(j, 0, 4, 0, cheight));
      if ((i+j)%2==0)  ca.rect(x, y, cwidth/5, cheight/4);
    }
  }  
  ca.fill(0, 255, 0);
  if (calibrated)  
    ca.ellipse(testPointP.x, testPointP.y, 20, 20);  
  ca.redraw();
  
  
  }
  
 
  
  ArrayList<PVector> drawChessboard(int x0, int y0, int cwidth) {
  this.x0 = x0;
  this.y0 = y0;
  this.cwidth = cwidth;
  ArrayList<PVector> projPoints = new ArrayList<PVector>();
  int cheight = (int)(cwidth * 0.8);
  ca.background(255);
  ca.fill(0);
  for (int j=0; j<4; j++) {
    for (int i=0; i<5; i++) {
      int x = int(x0 + map(i, 0, 5, 0, cwidth));
      int y = int(y0 + map(j, 0, 4, 0, cheight));
      if (i>0 && j>0)  projPoints.add(new PVector((float)x/pWidth, (float)y/pHeight));
      if ((i+j)%2==0)  ca.rect(x, y, cwidth/5, cheight/4);
    }
  }  
  ca.fill(0, 255, 0);
  if (calibrated)  
    ca.ellipse(testPointP.x, testPointP.y, 20, 20);  
  ca.redraw();
  return projPoints;
}


}

void saveCalibration(String filename) {
  String[] coeffs = getCalibrationString();
  saveStrings(dataPath(filename), coeffs);
}

void loadCalibration(String filename) {
  String[] s = loadStrings(dataPath(filename));
  x = new Jama.Matrix(11, 1);
  for (int i=0; i<s.length; i++)
    x.set(i, 0, Float.parseFloat(s[i]));
  calibrated = true;
}