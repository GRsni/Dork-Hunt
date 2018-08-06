void initializeRobot() {
  try {
    r=new Robot();
  }
  catch(AWTException a) {
    println(GraphicsEnvironment.isHeadless());
  }
}


void AI() {
  if (frameCount%2==0) {
    if (ducks.size()>0) {
      Duck d;
      try {
        d=ducks.get(0);
        println(d.x, d.y);
      }
      catch(NullPointerException nP) {
        d=null;
      }
      if (d!=null) {
        try {
          r.mouseMove(int(d.x)+10, int(d.y)+10);
        }
        catch(NullPointerException a) {
          println("couldnt click at: ", d.x+10, d.y+10);
        }
        //r.mousePress(Input);
        //r.mouseRelease(1);
      }
    }
  }
}
