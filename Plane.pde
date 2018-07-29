class Plane {
  float x;
  float y;
  PVector speed;
  int l=75;
  int h=40;
  boolean rightDir;
  boolean alive=true;
  int alpha=255;
  int bullets;

  Plane(float X, float Y) {
    x=X;
    y=Y;
    setDirection();
    speed=getSpeed();
    bullets=getBullets();
  }

  void show() {
    pushStyle();
    if (alive) {
      image(plane, x, y+3*sin(angle*2), map(y, 50, height-250, 75, 50), map(y, 50, height-250, 40, 26.6));
    } else {
      tint(255, alpha);
      image(planeBoom, x, y, map(y, 50, height-250, 100, 50), map(y, 50, height-250, 60, 30));
    }
    popStyle();
  }

  void move() {
    if (alive) {
      x+=speed.x*wActivation;
      y+=speed.y*wActivation;
    } else {
      speed.y+=grav*2;
      y+=speed.y;
      x+=speed.x*wActivation/2;
    }
  }

  boolean inside(float X, float Y) {
    return X>x&&X<x+l&&Y>y&&Y<y+h;
  }

  boolean outOfTheBorders() {
    boolean out=false;
    if (rightDir&&x>width) {
      out=true;
    }
    if (!rightDir&&x+l<0) {
      out =true;
    }
    if (y>height-300) { 
      out=true;
    }
    return out;
  }

  void setDirection() {
    if (x<0) { 
      rightDir=true;
    } else { 
      rightDir=false;
    }
  }

  int getBullets() {
    if (levelType==1) return 20;
    else return 10;
  }


  PVector getSpeed() {
    float angle;
    if (rightDir) {
      //float angle=random(5, 15);
      angle=map(y, 50, 450, 15, -10);
    } else {
      angle=map(y, 75, 450, 165, 195);
    }
    return PVector.fromAngle(radians(angle)).setMag((9+level*.15)*wActivation);
  }

  void die() {
    points.add(new Score(x, y, 1000, 0));
    alive=false;
    speed.y=0;
    score+=1000;
    killCount++;
  }
}
