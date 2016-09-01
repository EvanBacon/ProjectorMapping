
import javax.swing.*;

import SimpleOpenNI.*;
import gab.opencv.*;
import controlP5.*;

// set resolution of your projector image/second monitor
// and name of your calibration file-to-be
int pWidth = 1600;
int pHeight = 900;
String calibFilename = "calib1.txt";

SimpleOpenNI kinect;
OpenCV opencv;
//ChessboardFrame frameBoard;
ChessboardApplet ca;
PVector[] depthMap;
ArrayList<PVector> projPoints = new ArrayList<PVector>();

ArrayList<PVector> foundPoints = new ArrayList<PVector>();
ArrayList<PVector> ptsK, ptsP;
PVector testPoint, testPointP;
boolean isSearchingBoard = false;
boolean calibrated = false;
boolean testingMode = false;
boolean viewRgb = true;
int cx, cy, cwidth;

void setup() 
{        
  size(1150, 620);
  surface.setResizable(true);
  surface.setSize(1150, 620);

  textFont(createFont("Courier", 24));
 
  ca = new ChessboardApplet();
  // set up kinect
  kinect = new SimpleOpenNI(this);
  kinect.setMirror(false);
  kinect.enableDepth();
  kinect.enableRGB();
  kinect.alternativeViewPointDepthToImage();
  opencv = new OpenCV(this, kinect.depthWidth(), kinect.depthHeight());

  // matching pairs
  ptsK = new ArrayList<PVector>();
  ptsP = new ArrayList<PVector>();
  testPoint = new PVector();
  testPointP = new PVector();

  cx = 20;
  cy = 20;
  cwidth = 200;
  setupGui();
}

void draw() 
{

  // draw Chessboard onto scene
  projPoints = ca.drawChessboard(cx, cy, cwidth);

  // update kinect and look for chessboard
  kinect.update();
  depthMap = kinect.depthMapRealWorld();
  opencv.loadImage(kinect.rgbImage());
  opencv.gray();

  if (isSearchingBoard)
    foundPoints = opencv.findChessboardCorners(4, 3);

  drawGui();
}

void drawGui() 
{
  background(0, 100, 0);

  // draw the RGB image
  pushMatrix();
  translate(10, 40);
  textSize(22);
  fill(255);
  text("Kinect Image", 5, -5);
  if (viewRgb)  image(kinect.rgbImage(),   0, 0);
  else          image(kinect.depthImage(), 0, 0);

  // draw chessboard corners, if found
  if (isSearchingBoard) {
    for (PVector p : foundPoints) {
      if (getDepthMapAt((int)p.x, (int)p.y).z > 0)
        fill(0, 255, 0);
      else  fill(255, 0, 0);
      ellipse(p.x, p.y, 4, 4);
    }
  }
  if (calibrated && testingMode) {
    fill(255, 0, 0);
    ellipse(testPoint.x, testPoint.y, 10, 10);
  }
  popMatrix();

  // draw GUI
  pushMatrix();
  pushStyle();
  translate(kinect.depthWidth()+40, 40);
  fill(0);
  rect(0, 0, 420, 560);
  fill(255);
  text("number of point pairs: " + ptsP.size(), 12, 24);
  popStyle();
  popMatrix();
}




void addPointPair() {
  if (projPoints.size() == foundPoints.size()) {
    for (int i=0; i<projPoints.size(); i++) {
      ptsP.add( projPoints.get(i) );
      ptsK.add( getDepthMapAt((int) foundPoints.get(i).x, (int) foundPoints.get(i).y) );
    }
  }
}

PVector getDepthMapAt(int x, int y) {
  PVector dm = depthMap[kinect.depthWidth() * y + x];
  return new PVector(dm.x, dm.y, dm.z);
}

void clearPoints() {
  ptsP.clear();
  ptsK.clear();
}

void saveC() {
  saveCalibration(calibFilename); 
}

void loadC() {
  loadCalibration(calibFilename);
}

void mousePressed() {
  if (calibrated && testingMode) {
    testPoint = new PVector(constrain(mouseX-10, 0, kinect.depthWidth()-1), 
                            constrain(mouseY-40, 0, kinect.depthHeight()-1));
    //println("=====0======");
    //println(testPoint);
    int idx = kinect.depthWidth() * (int) testPoint.y + (int) testPoint.x;
    testPointP = convertKinectToProjector(depthMap[idx]);
  }
}