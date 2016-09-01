/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/123915*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
import de.voidplus.leapmotion.*;

ArrayList<Emitter> peep = new ArrayList();
LeapMotion leap;

Canvas canvas = new Canvas();
//SecondScreen ca = new SecondScreen();

void setup() {
  //size(2500, 500);
  fullScreen(P3D, 2);
  //surface.setResizable(true);
  //surface.setSize(1150, 620);

  noStroke(); 
  fill(50);
  smooth();
  ellipseMode(CENTER);


  leap = new LeapMotion(this).allowGestures("swipe");  // Leap detects only swipe gestures
}



float lx, ly;

ArrayList<CropPoint> cropPoints = new ArrayList();

void drawCropMode() {
  //background(128);

  fill(255, 255, 255, 50);

  for (int j=0; j<cropPoints.size(); j++)
  {
    CropPoint p = (CropPoint) cropPoints.get(j);

    p.draw();

    if (j + 1 < cropPoints.size()) {
      p.connect(cropPoints.get(j + 1));
    }
  }
}

void drawSketchMode() {
  background(0);

  //rotateY(45);
  canvas.draw();


  strokeWeight(2);
  int fps = leap.getFrameRate();


  this.drawHands();

  //for (int j=0; j<peep.size(); j++)
  //{
  //  Emitter e = (Emitter) peep.get(j);
  //  e.display();
  //  e.update();
  //}
}

void draw() {

  if (cropping) {
    drawCropMode();
  } else {
    drawSketchMode();
    drawCropMode();
  }

  // DEVICES
  // for(Device device : leap.getDevices()){
  //   float device_horizontal_view_angle = device.getHorizontalViewAngle();
  //   float device_verical_view_angle = device.getVerticalViewAngle();
  //   float device_range = device.getRange();
  // }
}


void drawTools(Hand hand) {
  // TOOLS
  for (Tool tool : hand.getTools()) {

    // Basics
    tool.draw();

    int     tool_id           = tool.getId();
    PVector tool_position     = tool.getPosition();
    PVector tool_stabilized   = tool.getStabilizedPosition();
    PVector tool_velocity     = tool.getVelocity();
    PVector tool_direction    = tool.getDirection();
    float   tool_time         = tool.getTimeVisible();

    // Touch Emulation
    int     touch_zone        = tool.getTouchZone();
    float   touch_distance    = tool.getTouchDistance();

    switch(touch_zone) {
    case -1: // None
      break;
    case 0: // Hovering
      // println("Hovering (#"+tool_id+"): "+touch_distance);
      break;
    case 1: // Touching
      // println("Touching (#"+tool_id+")");
      break;
    }
  }
}


// ======================================================
// 1. Swipe Gesture

void leapOnSwipeGesture(SwipeGesture g, int state) {
  int     id               = g.getId();
  Finger  finger           = g.getFinger();
  PVector position         = g.getPosition();
  PVector positionStart    = g.getStartPosition();
  PVector direction        = g.getDirection();
  float   speed            = g.getSpeed();
  long    duration         = g.getDuration();
  float   duration_seconds = g.getDurationInSeconds();



  switch(state) {
  case 1: // Start
    break;
  case 2: // Update
    break;
  case 3: // Stop
    println("SwipeGesture: " + id, direction);

    if (g.getHands().get(0).getPinchStrength() < 0.9 ) {
      canvas.clearPoints();
    }


    break;
  }
}

void drawHands() {
  // HANDS
  for (Hand hand : leap.getHands()) {
    float pinch = hand.getPinchStrength();

    //hand.draw();
    int     hand_id          = hand.getId();
    PVector hand_position    = hand.getPosition();
    PVector hand_stabilized  = hand.getStabilizedPosition();
    PVector hand_direction   = hand.getDirection();
    PVector hand_dynamics    = hand.getDynamics();
    float   hand_roll        = hand.getRoll();
    float   hand_pitch       = hand.getPitch();
    float   hand_yaw         = hand.getYaw();
    float   hand_time        = hand.getTimeVisible();
    PVector sphere_position  = hand.getSpherePosition();
    float   sphere_radius    = hand.getSphereRadius();

    int i = 0;
    // FINGERS
    for (Finger finger : hand.getFingers()) {

      // Basics
      //finger.draw();
      int     finger_id         = finger.getId();
      PVector finger_position   = finger.getPosition();
      PVector finger_stabilized = finger.getStabilizedPosition();
      PVector finger_velocity   = finger.getVelocity();
      PVector finger_direction  = finger.getDirection();
      float   finger_time       = finger.getTimeVisible();

      // Touch Emulation
      int     touch_zone        = finger.getTouchZone();
      float   touch_distance    = finger.getTouchDistance();



      if (pinch >= 0.9) { 
        drawCircle(true, finger_stabilized, i);
        Emitter e = new Emitter(finger_stabilized);
        peep.add(e);
      } else {
        drawCircle(false, finger_stabilized, i);
      }

      switch(touch_zone) {
      case -1: // None
        break;
      case 0: // Hovering
        // println("Hovering (#"+finger_id+"): "+touch_distance);
        break;
      case 1: // Touching
        // println("Touching (#"+finger_id+")");
        break;
      }
      i++;
    }

    Finger pointer = hand.getIndexFinger();
    PVector finger_stabilized = pointer.getStabilizedPosition();


    float grab = hand.getGrabStrength();
    if (pinch >= 0.9) { 

      float vx = finger_stabilized.x - lx;
      float vy = finger_stabilized.y - ly;
      float velocity = max(min(sqrt(pow(vx, 2) + pow(vy, 2)), 5), 1);

      int   numIntersections = 0;

      //for ( int k = 1; i < cropPoints.size(); i++ ) {
      //  numIntersections += segIntersection(finger_stabilized.x, finger_stabilized.y, width, finger_stabilized.x, cropPoints.get(i).x, cropPoints.get(i).y, cropPoints.get(i-1).x, cropPoints.get(i-1).y);
      //}
      //if ( numIntersections % 2 != 0 ) {
      //  println("INSIDE");
      //fill(255, 0, 0);
      canvas.addPoint(finger_stabilized.x, finger_stabilized.y, lx, ly, velocity);

      //  }
      //  else {
      //    println("OUTSIDE");
      //  }
      println(numIntersections + " " + mouseX + " " + mouseY);

      //Emitter E = new Emitter(new PVector(finger_stabilized.x, finger_stabilized.y));
      //peep.add(E);
    } 
    ly = finger_stabilized.y;
    lx = finger_stabilized.x;

    //drawTools(hand);
  }
}

Integer[] sizes = {35, 35, 40, 35, 30};
void drawCircle(boolean valid, PVector point, int index) {

  noFill();

  if (valid)
    stroke(0, 128, 50, 50);
  else 
  stroke(255);
  ellipse(point.x, point.y, sizes[index], sizes[index]);
}


void leapOnInit() {
  // println("Leap Motion Init");
}

void leapOnConnect() {
  // println("Leap Motion Connect");
}

void leapOnFrame() {
  // println("Leap Motion Frame");
}

void leapOnDisconnect() {
  // println("Leap Motion Disconnect");
}

void leapOnExit() {
  // println("Leap Motion Exit");
}



void mouseClicked() {
  if (cropping) {
    cropPoints.add(new CropPoint(mouseX, mouseY));
  }
}

boolean cropping = false;
//Keys
void keyPressed()
{
  // If the key is between 'A'(65) to 'Z' and 'a' to 'z'(122)
  if ((key >= 'A' && key <= 'Z') || (key >= 'a' && key <= 'z')) {
    cropping = !cropping;
  } else {
  }
}