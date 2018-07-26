class Duck {
  float x;
  float y;
  float d;
  float w=100;
  int lives, initLives;
  PVector speed= new PVector(0, 0);
  boolean alive=true;
  boolean flapA=true;
  boolean turned=false;
  int fCount=0;
  int alpha=255;
  float dir;
  float rotation;

  Duck(float X, float Y, float D, int L) {
    x=X;
    y=Y;
    d=D;
    lives=L;
    initLives=L;
  }


  void show() {
    pushStyle();
    if (y+(w*1/d)<height-250) {
      if (frameCount%15==0) { 
        fCount++;
      }
      if (!alive) {
        pushMatrix();

        translate(x+w/d/2, y+w/d/2);
        tint(255, alpha);
        alpha-=int(255/35);
        rotate(rotation);


        image(dorkExp, -w/d/2, -w/d/2, w/d, w/d);
        popMatrix();
      } else {
        if (dir>0) {//left

          int frameIndex=fCount%4;
          if (lives==1) {
            image(dorkFrameLeft[frameIndex], x, y, w/d, w/d);
          } else {
            tint(map(lives, 2, 3, 200, 150), map(lives, 2, 3, 80, 108), 0);
            image(dorkFrameLeft[frameIndex], x, y, w/d, w/d);
          }
          
        } else {//right
          int frameIndex=fCount%4;
          //println(frameIndex);
          if (lives==1) {
            image(dorkFrameRight[frameIndex], x, y, w/d, w/d);
          } else {
            tint(map(lives, 2, 3, 200, 150), map(lives, 2, 3, 80, 108), 0);
            image(dorkFrameRight[frameIndex], x, y, w/d, w/d);
          }
        }
      }
    }
    if (y+(w/d)<0) {
      stroke(255);
      strokeWeight(2);
      fill(#FF8D00);
      triangle(x+w/(d*2), 10, x+w/(d*2)-15, 35, x+w/(d*2)+15, 35);
    }
    popStyle();
  }

  void move() {
    if (fCount%20==0) {
      flapA=!flapA;
    }
    if (alive) {
      x+=speed.x*wActivation;
      speed.y+=grav*wActivation;
      y+=speed.y*wActivation;

      d+=.01*wActivation;
    } else {
      speed.y+=grav;
      y+=speed.y;
    }
  }


  void edges() {
    if (x<0||x+w/d>width) {
      speed.x*=-1;
      println("edge");
    }
  }


  void chooseDir() {
    if (x>width/2) {
      dir=random(-4, -2);
      speed.x=dir;
    } else {
      dir=random(2, 4);
      speed.x=dir;
    }
  }

  boolean click(boolean c, float X_, float Y_) {
    if (c) {
      return(X_>=x&&X_<x+(w/d)&&Y_>=y&&Y_<y+(w/d))&&mousePressed&&!clicked;
    } else {
      return(X_>=x&&X_<x+(w/d)&&Y_>=y&&Y_<y+(w/d));
    }
  }
}
