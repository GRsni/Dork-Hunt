class Duck {
  float x;
  float y;
  float d;
  float w=100;
  int lives, initLives, selfScore;
  PVector speed;
  boolean alive=true;
  int fCount=0;
  int alpha=255;
  float dir;
  float rotation;

  Duck(float X, float Y, float D) {
    x=X;
    y=Y;
    d=D;
    lives=getLives();
    initLives=lives;
    if (initLives==1) selfScore=200;
    else if (initLives==2) selfScore=400;
    else selfScore=900;
    speed=chooseStartingSpeed();
  }

  Duck(float X, float Y, float D, int L) {
    x=X;
    y=Y;
    d=D;
    lives=L;
    initLives=lives;
    if (initLives==1) selfScore=200;
    else if (initLives==2) selfScore=400;
    else selfScore=900;
    speed=chooseStartingSpeed();
  }


  void show() {
    pushStyle();
    //if (y+(w*1/d)<height-250) {
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
        if (speed.x>0) {//left

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
    //}
    if (y+(w/d)<0) {
      stroke(255);
      strokeWeight(2);
      fill(#FF8D00);
      triangle(x+w/(d*2), 10, x+w/(d*2)-15, 35, x+w/(d*2)+15, 35);
    }
    popStyle();
  }

  void move() {
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

  PVector chooseStartingSpeed() {
    if (x>width/2) {
      float angle=random(225,250);
      return PVector.fromAngle(radians(angle)).setMag(10*wActivation);
    } else {
      float angle=random(290, 315);
      return PVector.fromAngle(radians(angle)).setMag(10*wActivation);
    }
  }

  int getLives() {
    float r=random(1);

    if (simpleDorksKilled>7||r<0.08) {
      simpleDorksKilled=0;
      return 3;
    } else if (r<0.2) { 
      return 2;
    } else return 1;
  }

  boolean click(boolean c, float X_, float Y_) {
    if (c) {
      return(inside(X_, Y_))&&mousePressed&&!clicked;
    } else {
      return(inside(X_, Y_));
    }
  }

  boolean inside(float X, float Y) {
    return X>x&&X<x+w/d&&Y>y&&Y<y+w/d;
  }

  void die() {
    alive=false;
    rotation=random(-PI, PI);
    speed.y=0;
    score+=selfScore;
    if (initLives==1) {
      simpleDorksKilled++;
    }
  }
}
