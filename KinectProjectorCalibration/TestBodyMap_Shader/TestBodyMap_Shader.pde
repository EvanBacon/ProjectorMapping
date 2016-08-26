import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import SimpleOpenNI.*;

OpenCV opencv;
SimpleOpenNI kinect;
PGraphics pgKinect;
ArrayList<Contour> contours;
PVector[] depthMapRealWorld;
float[] projectorMatrix;
PGraphics pgGfx, pgMask, pgFinal;
PShader shade;

void setup() 
{
  //size(displayWidth, displayHeight, P2D);
  fullScreen(2);
  opencv = new OpenCV(this, 640, 480);
  projectorMatrix = loadCalibration("calib1.txt");

  // set kinect
  kinect = new SimpleOpenNI(this);   
  kinect.setMirror(false);
  kinect.enableDepth(); 
  kinect.alternativeViewPointDepthToImage();

  // initialize pgraphics objects
  pgKinect = createGraphics(kinect.depthWidth(), kinect.depthHeight());
  pgGfx = createGraphics(width, height, P2D);
  pgMask = createGraphics(width, height);
  pgFinal = createGraphics(width, height, P2D);

  shade = loadShader("sinewave.glsl");
  shade.set("resolution", float(width), float(height));
}

void draw() 
{
  float MIN_BB = map(mouseY, 0, height, 0, width*height/10);
  int KINECT_THRESH = (int) map(mouseX, 0, width, 0, 255);

  // get kinect contours
  kinect.update();
  depthMapRealWorld = kinect.depthMapRealWorld();
  pgKinect.beginDraw();
  pgKinect.image(kinect.depthImage(), 0, 0);
  pgKinect.endDraw();
  opencv.loadImage(pgKinect);
  opencv.threshold(KINECT_THRESH);
  contours = opencv.findContours();

  // draw mask  
  pgMask.beginDraw();
  pgMask.background(0);  
  for (Contour contour : contours) {
    Rectangle r = contour.getBoundingBox();
    if (r.width * r.height > MIN_BB) {
      ArrayList<PVector> pts = contour.getPoints();      
      pgMask.noStroke();
      pgMask.fill(255);      
      pgMask.beginShape();      
      for (PVector p : pts) {
        PVector pp = convertKinectToProjector(getDepthMapAt((int)p.x, (int)p.y));
        pgMask.vertex(pp.x, pp.y);
      }
      pgMask.endShape();
    }
  }
  pgMask.endDraw();
  
  // draw graphics
  shade.set("m", map(noise(0.01*frameCount+ 5), 0, 1, 0.1, 0.8), 
                 map(noise(0.01*frameCount+15), 0, 1, 0.1, 0.8), 
                 map(noise(0.01*frameCount+25), 0, 1, 0.1, 0.8));  
  shade.set("time", millis()/1000.0);
  pgGfx.beginDraw();
  pgGfx.shader(shade); 
  pgGfx.rect(0, 0, width, height);

  pgGfx.endDraw();  

  // apply mask
  pgFinal.beginDraw();
  pgFinal.image(pgGfx, 0, 0);
  pgFinal.endDraw();
  pgFinal.mask(pgMask);

  // final render
  background(0);
  image(pgFinal, 0, 0);
}

PVector getDepthMapAt(int x, int y) {
  PVector dm = depthMapRealWorld[kinect.depthWidth() * y + x];
  return new PVector(dm.x, dm.y, dm.z);
}

PVector convertKinectToProjector(PVector kp) {
  PVector pp = new PVector();
  float denom = projectorMatrix[8]*kp.x + projectorMatrix[9]*kp.y + projectorMatrix[10]*kp.z + 1.0;
  pp.x = width * (projectorMatrix[0]*kp.x + projectorMatrix[1]*kp.y + projectorMatrix[2]*kp.z + projectorMatrix[3]) / denom;
  pp.y = height * (projectorMatrix[4]*kp.x + projectorMatrix[5]*kp.y + projectorMatrix[6]*kp.z + projectorMatrix[7]) / denom;
  return pp;
}

float[] loadCalibration(String filename) {
  String[] s = loadStrings(dataPath(filename));
  float[] projectorMatrix = new float[s.length];
  for (int i=0; i<s.length; i++)
    projectorMatrix[i] = Float.parseFloat(s[i]);
  return projectorMatrix;
}