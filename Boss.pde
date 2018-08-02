class Boss {
  PVector[] pos=new PVector[4];
  PVector[] acc=new PVector[4];
  PVector[] vel=new PVector[4];
  int bossType=1;
  float health1, health2, health3;
  float invulTime=200;
  int leftPieceNum=15;
  int rightPieceNum=15;
  int leftTime, rightTime, headTime, bodyTime;
  boolean leftD, rightD;
  boolean leftHit=false;
  boolean rightHit=false;
  boolean headHit=false;
  boolean bodyHit=false;


  Button[] items=new Button[4];

  Boss(PVector a, PVector b, PVector H) {
    leftD=false;
    rightD=false;
    pos[0]=a;
    pos[1]=b;
    pos[2]=H;
    pos[3]=new PVector(width/2-150, 150);
    for (int i=0; i < 4; i++) {
      acc[i]=new PVector(0, 0);
      vel[i]=new PVector(0, 0);
    }

    items[0]=new Button(false, pos[0].x, pos[0].y, 90, 150, 0, 0, #000000, #FFFFFF);//left
    items[1]=new Button(false, pos[1].x, pos[1].y, 90, 150, 0, 0, #000000, #FFFFFF);//right
    items[2]=new Button(false, pos[2].x, pos[2].y, 150, 100, 0, 0, #000000, #FFFFFF);//head
    items[3]=new Button(false, width/2-150, 250, 300, 600, 0, 0, #000000, #FFFFFF);//body
    health1=100+1.5*level;
    health2=100+1.5*level;
    health3=150+2*level;
  }

  void show() {
    if (leftPieceNum>0||rightPieceNum>0) {
      if (!bodyHit) {
        image(bossIm[4], pos[3].x, pos[3].y+5*sin(angle));
      } else {
        pushStyle();
        tint(220, 0, 0);
        image(bossIm[4], pos[3].x, pos[3].y+5*sin(angle));
        popStyle();
      }
    }
    if (health3>0) {

      if (headHit) {
        pushStyle() ;
        tint(255, 0, 0);
        image(bossIm[0], items[2].x, items[2].y);
        popStyle();
      } else {
        image(bossIm[0], items[2].x, items[2].y);
      }
    }
    if (health1>0||leftPieceNum>0) {
      PVector auxS=new PVector(width/2-85, 300);
      PVector auxE=new PVector(items[0].x+50, items[0].y+50);
      PVector leftArm[]=arms(auxS, auxE, leftPieceNum);
      pushMatrix();
      for (int i=0; i<leftArm.length-1; i++) {
        pushMatrix();
        translate(leftArm[i].x, leftArm[i].y);
        rotate(map(pos[0].y, 30, height-400, 2*PI/3, PI/3));
        image(bossIm[3], 0, 0);
        popMatrix();
      }
      popMatrix();
      if (health1>0) {
        if (leftHit) {
          pushStyle();
          tint(255, 0, 0);
          image(bossIm[1], items[0].x, items[0].y);
          popStyle();
        } else {
          image(bossIm[1], items[0].x, items[0].y);
        }
      }
    }
    if (health2>0||rightPieceNum>0) {
      PVector auxS=new PVector(width/2+75, 330);
      PVector auxE=new PVector(items[1].x+20, items[1].y+75);
      PVector rightArm[]=arms(auxS, auxE, rightPieceNum);
      for (int i=0; i<rightArm.length; i++) {

        pushMatrix();
        translate(rightArm[i].x, rightArm[i].y);
        rotate(map(pos[1].y, 150, height-400, -radians(100), -PI/3));
        image(bossIm[3], 0, 0);
        popMatrix();
      }
      if (health2>0) {
        if (rightHit) {
          pushStyle();
          tint(255, 0, 0);
          image(bossIm[2], items[1].x, items[1].y);
          popStyle();
        } else {
          image(bossIm[2], items[1].x, items[1].y);
        }
      }
    }
  }

  void update() {

    if (leftHit&&millis()-leftTime>invulTime) {
      leftHit=false;
    }
    if (rightHit&&millis()-rightTime>invulTime) {
      rightHit=false;
    }
    if (headHit&&millis()-headTime>invulTime) {
      headHit=false;
    }
    if (bodyHit&&millis()-bodyTime>invulTime) {
      bodyHit=false;
    }
    if (health1<1&&!leftD) {
      leftD=true;
      score+=1500*level;
      points.add(new Score(pos[0].x, pos[0].y, 1500*level, 0));
    }
    if (health2<1&&!rightD) {
      rightD=true;
      score+=1500*level;
      points.add(new Score(pos[1].x, pos[1].y, 1500*level, 0));
    }
    if (health3<1) {
      if (!flags[0]) {
        splatter.play(0);
      }
      bossSpawned=false;
    }
    if (health1>0) {
      partUpdater(0);
    }
    if (health2>0) {
      partUpdater(1);
    }
    if (leftPieceNum>0&&health1<1) {
      vel[0].y+=grav;
      items[0].y+=vel[0].y;
      if (frameCount%10==0) {
        leftPieceNum--;

        if (!flags[0]) {
          pieceBoom.play(0);
        }
      }
    }
    if (rightPieceNum>0&&health2<1) {
      vel[1].y+=grav;
      items[1].y+=vel[1].y;
      if (frameCount%10==0) {
        rightPieceNum--;
        items[1].y+=grav*2;
        if (!flags[0]) {
          pieceBoom.play(0);
        }
      }
    }
    partUpdater(2);
  }

  void hit() {
    if (health1>0||health2>0) {
      if (items[0].click(mouseX, mouseY, true)&&!clicked&&!leftHit) {//damage left arm
        leftHit=true;
        leftTime=millis();
        clicked=true;
        health1-=10;
      }
      if (items[1].click(mouseX, mouseY, true)&&!clicked&&!rightHit) {//damage right arm
        rightHit=true;
        rightTime=millis();
        clicked=true;
        health2-=10;
      }
      if (items[3].click(mouseX, mouseY, true)&&!clicked&&!bodyHit) {//damage arms when hitting body
        bodyHit=true;
        bodyTime=millis();
        clicked=true;
        if (health1<1) {
          health2-=10;
        } else if (health2<1) {
          health1-=10;
        } else {
          if (random(1)<.5) {
            health1-=5;
          } else {
            health2-=5;
          }
        }
      }
    } else if (leftPieceNum<1&&rightPieceNum<1) {//damage head
      if (items[2].click(mouseX, mouseY, true)&&!clicked&&!headHit) {
        headHit=true;
        headTime=millis();
        clicked=true;
        health3-=10;
      }
    }
  }


  PVector[] arms(PVector s, PVector e, int num) {
    PVector dir=new PVector(e.x-s.x, e.y-s.y);
    pushMatrix();
    rotate(-dir.heading());
    PVector[] pos=new PVector[num];
    for (int i=0; i<num; i++) {
      PVector aux= PVector.fromAngle(dir.heading());
      aux.setMag(dir.mag()/15*i);
      pos[i]=aux;
      pos[i].x=s.x+aux.x;
      pos[i].y+=s.y+5*sin(angle+i*.5);
    }
    popMatrix();

    return pos;
  }


  void partUpdater(int selector) {
    if (bossType==1) {
      if (selector!=2) {
        if (frameCount%45==0) {
          acc[selector].add(PVector.random2D());
          acc[selector].setMag(10);
        } else {
          acc[selector].add(PVector.random2D());
        }
        vel[selector].add(acc[selector]);
        vel[selector].mult(.9);
        pos[selector].add(vel[selector]);
        pos[selector].x=constrain(pos[selector].x, 
              80+selector*(width/2+50-80), 
              200+selector*(width/2+200-150));
        //if (pos[selector].x>width/2-200+selector*(width/2+200-150)) {
        //  pos[selector].x=width/2-200+selector*(width/2+200-150);
        //} else if (pos[selector].x<80+selector*(-80+width/2+50)) {
        //  pos[selector].x=80+selector*(width/2+50-80);
        //}
        if (pos[selector].y<30+selector*100) {
          pos[selector].y=30+selector*100;
        } else if (pos[selector].y>height-400) {
          pos[selector].y=height-400;
        }
        items[selector].x=pos[selector].x;
        items[selector].y=pos[selector].y;
        acc[selector].mult(0);
      } else {
        if (health1<1&&health2<1) {
          if (frameCount%45==0) {
            acc[selector].add(PVector.random2D());
            acc[selector].setMag(12);
          } else {
            acc[selector].add(PVector.random2D());
          }
        } else {
          acc[selector].add(PVector.random2D());
          acc[selector].limit(.75);
          PVector move=PVector.random2D();
          move.mult(.4);
          acc[selector].add(move);
          vel[selector].add(acc[selector]);
          vel[selector].mult(.8);
          pos[selector].add(vel[selector]);
          acc[selector].mult(0);
        }
        vel[selector].add(acc[selector]);
        vel[selector].mult(0.95);
        pos[selector].add(vel[selector]);
        if (health1>0||health2>0) {
          if (pos[selector].x>width/2-50) {
            pos[selector].x=width/2-50;
          } else if (pos[selector].x<width/2-100) {
            pos[selector].x=width/2-100;
          }
          if (pos[selector].y<100) {
            pos[selector].y=100;
          } else if (pos[selector].y>150) {
            pos[selector].y=150;
          }
        } else {
          if (pos[selector].y<0) {
            pos[selector].y=0;
          } else if (pos[selector].y>height-350) {
            pos[selector].y=height-350;
          }
          if (pos[selector].x<0) {
            pos[selector].x=0;
          } else if (pos[selector].x>width-300) {
            pos[selector].x=width-300;
          }
        }

        items[selector].x=pos[selector].x;
        items[selector].y=pos[selector].y;
        acc[selector].mult(0);
      }
    }
  }
}
