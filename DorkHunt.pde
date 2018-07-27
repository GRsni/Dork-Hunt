  import ddf.minim.*; //<>// //<>// //<>//


//Dork Hunt 
//Game by GRsni
//Version 1.2.5 for Processing 3.x
//---------------------------------------
//TO DO:
//Re-balance bullet usage(needs testing)
//---------------------------------------
//All audio files belong to their respective owners.
//---------------------------------------

Minim minim; 

AudioPlayer theme;
AudioPlayer loss;
AudioPlayer shot;
AudioPlayer splatter;
AudioPlayer reloadSound;
AudioPlayer levelUp;
AudioPlayer noAmmo;
AudioPlayer UFOCrash;
AudioPlayer qSound;
AudioPlayer eSound;
AudioPlayer rSound;
AudioPlayer pieceBoom;


PImage titlebaricon;
PImage desktop;
PImage bullet;
PImage scoreboard;
PImage dorkExp;
PImage plane;
PImage planeBoom;
PImage volume;
PImage mute;
PImage wrench;
PImage[] cursor=new PImage[6];
PImage[] whiteCursor=new PImage[6];
PImage[] QWER = new PImage[4];
PImage[] bossIm= new PImage[5];
PImage[] userHealth=new PImage[10];
PImage[] dorkFrameLeft=new PImage[4];
PImage[] dorkFrameRight=new PImage[4];

PFont scoreFont, ammoFont;
String[] highScoresEasy;
String[] highScoresHard;
String[] scoreList=new String[10];
int[] scoreNum=new int[10];
JSONObject flagsjson;
boolean[] flags;//0=mute, 1=difficulty 2=Q 3=W 4=E 5=R 6=kill dorks 7=cursor type
String name="";
float[] cooldowns=new float[4];
boolean[] abilities=new boolean[4];
float[] remains=new float[4];
int lastMillis;
int wTime, eTime, wRest, eRest;
int bonusTime;
float wActivation=1.0;
boolean eActivation=false;


ArrayList<Duck> ducks= new ArrayList<Duck>();
ArrayList<Bullet> bullets=new ArrayList<Bullet>();
ArrayList<Score> points=new ArrayList<Score>();
ArrayList<Plane> planes=new ArrayList<Plane>();
ArrayList<Ability> abilitiesList=new ArrayList<Ability>();
Ability[] activeAbilities=new Ability[4];
Boss boss;

int level=7001;
static int startAmmo;
int score=0;
float up=0.01;
final static float grav=.1;
float life=100;
int listPos=0;
int txtSize;
int cursorType;
boolean typing;
boolean newHigh=false;
boolean nameDone=false;
boolean[] cutScenes=new boolean[4];

int gameState=0;
int levelType=1;
boolean gameStart=false;
boolean clicked=false;
boolean threadDone=false;

boolean bossSpawned=false;

int killCount=0;
int killsSinceAmmo=0;
int simpleDorksKilled;

int shotIndex;
float angle=0;
int time2=0;


void setup() { 
  fullScreen();
  //size(1200, 600);

  titlebaricon=loadImage("data/art/dorkIcon.png");


  surface.setIcon(titlebaricon);
  surface.setTitle("Dork Hunt");
  minim =new Minim(this);
  noCursor();


  scoreFont=loadFont("info/OCRAExtended.vlw");
  ammoFont=loadFont("info/Power_Clear_Bold-40.vlw");
  textFont(scoreFont, 30);
  thread("loadStuff");
}

void draw() { 
  background(120);

  //println(abilitiesList.size());
  switch(gameState) {
  case 0:
    drawGameState0();//name selection
    break;
  case 1:
    drawGameState1();//actual game
    break;
  case 2:
    drawGameState2();//intro menu
    break;
  case 3:
    drawGameState3();//game info
    break;
  case 4:
    drawGameState4();//death screen
    break;
  case 5:
    drawGameState5();//pause screen
    break;
  case 6:
    drawGameState6();//settings
    break;
  }
  if (threadDone) {
    if (gameState==4||gameState==0||(gameState==1&&mousePressed)) {
      image(whiteCursor[cursorType], mouseX-10, mouseY-10);
    } else {
      image(cursor[cursorType], mouseX-10, mouseY-10);
    }
  }

  angle+=.1; 
  txtSize-=2;
}


void mousePressed() {
  if (gameState==1) {
    if (mouseY<height-250) {
      if (shotIndex>0) {
        if (!eActivation) {
          if (!flags[0]) {
            shot.play(0);
          }
          if (shot.position()==shot.length()) {
            shot.rewind();
          }
          bullets.add(new Bullet(mouseX, mouseY, 0)); 
          bulletRemove(); 

          shotIndex--;
        }
      }
    }

    if (mouseX>675&&mouseX<675+115&&mouseY>615&&mouseY<615+115) {
      if (shotIndex>15) {
        if (!abilities[0]&&flags[2]) {
          Q();
          points.add(new Score(235, height-86, -15, 1));
          if (!flags[0]) {
            qSound.play(0);
          }
          shotIndex-=15;
          abilities[0]=true;
        }
      } else {
        if (!flags[0]) {
          noAmmo.play(0);
        }
      }
    } else if (mouseX>675+145&&mouseX<675+115+145&&mouseY>615&&mouseY<615+115) {
      if (shotIndex>20) {
        if (!abilities[1]&&flags[3]) {
          points.add(new Score(235, height-86, -20, 1));
          shotIndex-=20;
          abilities[1]=true;
          wActivation=0.5;
          wTime=millis();
        }
      } else {
        if (!flags[0]) {
          noAmmo.play(0);
        }
      }
    } else if (mouseX>675+145*2&&mouseX<675+115+145*2&&mouseY>615&&mouseY<615+115) {
      if (shotIndex>25) {
        if (!abilities[2]&&flags[4]) {
          E();
          points.add(new Score(235, height-86, -25, 1));
          eTime=millis();
          shotIndex-=25;
          abilities[2]=true;
          eActivation=true;
        }
      } else {
        if (!flags[0]) {
          noAmmo.play(0);
        }
      }
    } else if (mouseX>675+145*3&&mouseX<675+115+145*3&&mouseY>615&&mouseY<615+115) {
      if (shotIndex>30) {
        if (!abilities[3]&&flags[5]) {
          if (!flags[0]) {
            rSound.play(0);
          }
          R();
          points.add(new Score(235, height-86, -30, 1));
          shotIndex-=30;
          abilities[3]=true;
        }
      } else {
        if (!flags[0]) {
          noAmmo.play(0);
        }
      }
    }
  }
}

void mouseReleased() {
  clicked=false;
}

void keyPressed() {
  if (!typing) {
    if (key==ESC&&key==SHIFT) {
      exit();
    }
    if (key==ESC) {

      key=0; 
      if (gameState==2) {
        saveFlags();
        exit();
      } else if (gameState==1) {
        if (eSound.isPlaying()) {
          eSound.pause();
          eSound.rewind();
        }
        gameState=5;
        eRest=eTime+6500-millis();
        wRest=wTime+10000-millis();
      } else if (gameState==5) {
        if (abilities[2]&&!flags[0]) {
          eSound.loop();
        }
        eTime=millis()-(6500-eRest);
        gameState=1;

        wTime=millis()+wRest-10000;
      } else {
        gameState=2; 
        time2=0;
      }
    }

    if (keyCode=='P'||keyCode=='p'||keyCode==' ') {
      if (gameState==1&&gameStart) {
        gameState=5;
      } else if (gameState==5) {
        gameState=1;
      }
    }
    if (key=='Q'||key=='q') {
      if (shotIndex>15) {
        if (!abilities[0]&&flags[2]) {
          Q();
          points.add(new Score(235, height-86, -15, 1));
          if (!flags[0]) {
            qSound.play(0);
          }
          shotIndex-=15;
          abilities[0]=true;
        }
      } else {
        if (!flags[0]) {
          noAmmo.play(0);
        }
      }
    } else if (key=='w'||key=='W') {
      if (shotIndex>20) {
        if (!abilities[1]&&flags[3]) {
          points.add(new Score(235, height-86, -20, 1));
          shotIndex-=20;
          abilities[1]=true;
          wActivation=0.5;
          wTime=millis();
        }
      } else {
        if (!flags[0]) {
          noAmmo.play(0);
        }
      }
    } else if (key=='E'||key=='e') {
      if (shotIndex>25) {
        if (!abilities[2]&&flags[4]) {
          E();
          points.add(new Score(235, height-86, -25, 1));
          eTime=millis();
          shotIndex-=25;
          abilities[2]=true;
          eActivation=true;
        }
      } else {
        if (!flags[0]) {
          noAmmo.play(0);
        }
      }
    } else if (key=='R'||key=='r') {
      if (shotIndex>30) {
        if (!abilities[3]&&flags[5]) {
          if (!flags[0]) {
            rSound.play(0);
          }
          R();
          points.add(new Score(235, height-86, -30, 1));
          shotIndex-=30;
          abilities[3]=true;
        }
      } else {
        if (!flags[0]) {
          noAmmo.play(0);
        }
      }
    }
  } else {
    if (keyCode==BACKSPACE) {
      if (name.length()>0) {
        name=name.substring(0, name.length()-1);
      }
    } else if (keyCode==DELETE) {
      name="";
    } else  if (keyCode!=SHIFT&&keyCode!=ENTER&&keyCode!=TAB&key!='\uFFFF') {
      name=name+key;
    } else if (keyCode==' ') {
      name=name.substring(0, name.length()-1); 
      name=name+' ';
    } else if (keyCode==ENTER) {
      if (gameState==0&&threadDone) {
        gameState=2;
        nameDone=true;
        typing=false;
      }
    }
  }
}




void dSpawn() {//spawns the dorks
  if (killCount==0&&!flags[6]) {
    ducks.add(new Duck(random(width), height-250, random(.5, 1), 1) );
  } else {
    ducks.add(new Duck(random(width), height-250, random(.5, 1)) );
  }

  //Duck duck= ducks.get(ducks.size()-1); 
  //if (wActivation==0.5) {
  //  duck.speed.y=random(-11, -13);
  //} else {
  //  duck.speed.y=random(-10, -13);
  //}
  //duck.chooseDir();
}



void pSpawn() {//spawns the UFOs
  if (random(1)>.5) {//planes towards the right
    planes.add(new Plane(-50, random(50, 250))); 
    Plane plane=planes.get(planes.size()-1); 
    plane.rightDir=true; 
    plane.speed.x=(10+level*.13)*wActivation; 
    plane.speed.y=(random(0, 2.5))*wActivation;
  } else {//planes towards the left
    planes.add(new Plane(width+50, random(75, 225))); 
    Plane plane=planes.get(planes.size()-1); 
    plane.rightDir=false; 
    plane.speed.x=-10-level*.13; 
    plane.speed.y=random(0, 2.5);
  }
}

//int dorkLives() {

//}

void killDork(Duck d) {
  int point=0;
  clicked=true;
  if (d.lives>1) {
    d.lives--;
  } else {

    d.alive=false;
    d.rotation=random(-PI, PI);
    d.speed.y=0;
    if (!flags[0]) {
      splatter.play(0);
    }
    killCount++;
    if (d.initLives==1) {
      point=200;
      simpleDorksKilled++;
    } else if (d.initLives==2) {
      point=400;
    } else {
      point=900;
    }
    score+=point;
    points.add(new Score(d.x, d.y, point, 0));

    if (!flags[1]) {//easy mode
      if (random(1)>0.3+log(level)*0.25||killsSinceAmmo>level/2&&d.initLives!=3) {
        chooseBonus();
        killsSinceAmmo=0;
      } else if (d.initLives==3) {
        killsSinceAmmo=0;
        int r=10+int(random(5));
        reloadBullets(r);
        points.add(new Score(235, height-84, r, 1));
      } else {
        killsSinceAmmo++;
      }
    } else {//hard mode
      if (random(1)>.4+log(level)*.24||killsSinceAmmo>(25+log(level)*2)&&d.initLives!=3) {
        chooseBonus();
        killsSinceAmmo=0;
      } else if (d.initLives==3) {
        killsSinceAmmo=0;
        int r=10+int(random(5));
        reloadBullets(r);
        points.add(new Score(235, height-84, r, 1));
      } else {
        killsSinceAmmo++;
      }
    }
  }
}

void killPlane(Plane p) {
  clicked=true;
  points.add(new Score(p.x, p.y, 1000, 0));
  p.alive=false;
  p.speed.y=0;
  if (!flags[0]) {
    UFOCrash.play(0);
  }
  score+=1000;
  killCount++;
  int reloadAmount;
  if (levelType==2) {
    reloadAmount=10;
    reloadBullets(reloadAmount);
  } else {
    reloadAmount=20;
    reloadBullets(reloadAmount);
  }
  points.add(new Score(235, height-84, reloadAmount, 1));
}


void levelType() {//spawn algorithm 

  if (levelType==2) {
    fill(120, 0, 0); 
    textAlign(CENTER); 
    if (txtSize>30) {
      textSize(txtSize);
    } else {
      textSize(30);
    }
    textAlign(LEFT, TOP ); 
    text("Bonus level", 0, 5);
    if (!abilities[1]) {
      if (frameCount%10==0) {
        pSpawn();
      }
    } else {
      if (frameCount%20==0) {
        pSpawn();
      }
    }
  } else if (levelType==1) {
    if (!flags[1]) {
      if (frameCount%ceil(100/(.1*level+1))==0) {
        if (ducks.size()<2) {
          dSpawn();
        }
      }
      if (frameCount%(400+level*30)==0) {
        pSpawn();
      }
    } else {
      if (frameCount%ceil(100/(.25*level+1))==0) {
        dSpawn();
      }
      if (frameCount%(1000+level*60)==0) {
        pSpawn();
      }
    }
  } else if (levelType==3) {
    fill(120, 0, 0);
    textAlign(LEFT, TOP);
    if (txtSize>40) {  
      textSize(txtSize);
      text("Boss fight", map(txtSize, 100, 40, width/2, 0), map(txtSize, 100, 40, height/2, 0));
    } else {
      textSize(30);
      text("Boss fight", 0, 5);
    }

    if (!bossSpawned) {
      PVector aux1=new PVector(random(240, 250), random(180, 300));
      PVector aux2=new PVector(width-random(240, 260), random(180, 300));
      PVector aux3=new PVector(random(width/2-95, width/2-55), random(50, 70));
      boss=new Boss(aux1, aux2, aux3);
      bossSpawned=true;
    }
  }
}



void levelChoose() {//level selection
  if (flags[1]) {//hard
    if (level%20==0&&level%15!=0) {
      for (int j=0; j<ducks.size(); j++) {
        ducks.remove(j);
      }
      levelType=2;
      bonusTime=millis();
      txtSize=70;
    } else if (level%15==0) {
      for (int i=0; i<ducks.size(); i++) {
        ducks.remove(i);
      }
      for (int j=0; j<planes.size(); j++) {
        planes.remove(j);
      }
      levelType=3;
      txtSize=100;
    } else {
      levelType=1;
      if (level-1%10==0) {
        for (int j=0; j<planes.size(); j++) {
          planes.remove(j);
        }
      }
    }
  } else {//easy 
    if (level%10==0&&level%15!=0) {
      for (int j=0; j<ducks.size(); j++) {
        ducks.remove(j);
      }
      levelType=2;
      txtSize=70;
      bonusTime=millis();
    } else if (level%15==0) {
      for (int i=0; i<ducks.size(); i++) {
        ducks.remove(i);
      }
      for (int j=0; j<planes.size(); j++) {
        planes.remove(j);
      }
      levelType=3;
      txtSize=100;
    } else {
      levelType=1;
      if (level-1%10==0) {
        for (int j=0; j<planes.size(); j++) {
          planes.remove(j);
        }
      }
    }
  }
}

void removeMissedDorks() {
  for (int i=ducks.size()-1; i>=0; i--) {//remove missed dorks
    Duck duck=ducks.get(i); 

    if (duck.y>height-200&&duck.alive) {
      points.add(new Score(width-150, 90, -1000, 0)); 
      score-=1000; 
      ducks.remove(i);
      life-=5;
    }
  }
}
void removeMissedPlanes() {
  for (int i=planes.size()-1; i>=0; i--) {//remove missed planes
    Plane p= planes.get(i); 
    if ((p.rightDir&&p.x>width)||(!p.rightDir&&p.x<0)||p.y>height-300) {

      planes.remove(i);
    }
  }
}


void levelUpCheck() {//check level up requirements

  if (levelType==1) {
    if (killCount>=getLevelUpThreshold(level)) {
      score+=2000*level; 
      points.add(new Score(width-175, 50, 1000*level, 0)); 
      levelUpMethod();
      if (level%15!=0) {
        points.add(new Score(width/2, height-500, 0, 2));
      }

      lastMillis=millis();
    }
  } else if (levelType==3) {
    if (boss.health3<1) {
      score+=1000*level;
      points.add(new Score(width-175, 50, 2250*level, 0));//score object 

      levelUpMethod();
      if (!flags[0]) {
        pieceBoom.play(0);
      }
      points.add(new Score(width/2, height-500, 0, 2));//floating text
    }
  } else if (levelType==2) {
    if (millis()-bonusTime>4500) {
      points.add(new Score(width/2, height-500, 0, 2));
      levelUpMethod();
    }
  }
}

int getLevelUpThreshold(int lev) {
  int threshold=0;
  if (lev<15) {
    threshold=int(3+sqrt(lev)*1.25);
  } else if (lev<25) {
    threshold=int(2/5*lev)+2;
  } else {
    threshold=12;
  }
  return threshold;
}


void levelUpMethod() {
  level++;
  levelChoose();
  killCount=0;
  if (!flags[0]) { 
    levelUp.play(0);
  }
}

void checkGameLoseCondition() {//lose condition when out of ammo
  if (shotIndex<1) {
    gameState=4; 
    highScoreLeaderBoard();
    if (!flags[0]) {
      loss.play(0);
    }
  }
}

void resetGame() {//resets all dorks, planes, and bullets and refills the ammo, sets temporal flags back to initial state
  level=1;
  levelType=1;
  score=0; 
  bossSpawned=false;
  killCount=0; 
  shotIndex=0;
  newHigh=false;
  gameStart=false;
  theme.rewind();

  if (!flags[1]) {
    reloadBullets(50);
  } else {
    reloadBullets(25);
  }
  ducks=new ArrayList<Duck>();
  points=new ArrayList<Score>();
  planes=new ArrayList<Plane>();
  bullets=new ArrayList<Bullet>();

  for (int i=0; i<abilities.length; i++) {
    abilities[i]=false;
    remains[i]=0;
  }
}

void reloadBullets(int num) {
  if (gameState==1) {
    if (!flags[0]) {
      reloadSound.play(0);
    }
  }
  for (int i=0; i<num; i++) {
    shotIndex++;
  }
}

void pauseAllMusic() {
  theme.pause();
  loss.pause();
  shot.pause();
  splatter.pause();
  reloadSound.pause();
  levelUp.pause();
  noAmmo.pause();
  UFOCrash.pause();
}

void createContourInDimmedScreen(PVector pos, float wid, float hei) {
  beginContour();
  vertex(pos.x, pos.y);
  vertex(pos.x, pos.y+hei);
  vertex(pos.x+wid, pos.y+hei);
  vertex(pos.x+wid, pos.y);
  endContour();
}


void cutscenes() {

  if (level==5) {//at level 5 you unlock the shotgun
    if (!flags[2]||cutScenes[0]) {
      if (millis()-lastMillis<2000) {
        cutScenes[0]=true;
        flags[2]=true;
        saveFlags();
        noStroke();
        fill(0, 100);
        beginShape(); 
        vertex(0, 0);
        vertex(width, 0);
        vertex(width, height);
        vertex(0, height);

        createContourInDimmedScreen(new PVector(685, 610), 95, 95);
        endShape(CLOSE);
        fill(255);
        textSize(30);
        textAlign(CENTER, CENTER);
        text("Press Q to use the shotugn", 600, height-50);
      } else {
        cutScenes[0]=false;
      }
    }
  }

  if (level==9) {//at level 9 you unlock the other three abilities
    if (!flags[3]||cutScenes[1]) {
      if (millis()-lastMillis<2000) {
        cutScenes[1]=true;
        flags[3]=true; 
        flags[4]=true;
        flags[5]=true;
        saveFlags();
        noStroke();
        fill(0, 100);
        beginShape();
        vertex(0, 0);
        vertex(width, 0);
        vertex(width, height);
        vertex(0, height);
        for ( int i=0; i<3; i++) {
          createContourInDimmedScreen(new PVector(830+145*i, 610), 95, 95);
        }
        endShape(CLOSE);
        fill(255);
        textSize(30);
        textAlign(CENTER, CENTER);
        text("Check your new abilitites", 650, height-50);
      } else {
        cutScenes[1]=true;
      }
    }
  }

  if (!flags[7]) {//kill the first dork of the game
    if (killCount<1) {
      wActivation=0.5;
      noStroke();

      fill(0, 120);
      beginShape();
      vertex(0, 0);
      vertex(width, 0);
      vertex(width, height);
      vertex(0, height);
      //rect(0, 0, width, height-250);
      if (ducks.size()>0&&ducks.get(0).y<height-300) {//if a dork has spawned
        pushStyle();
        fill(255);
        Duck first=ducks.get(0);
        if (first.x>width/2) {
          text("Click on the dork", 100, 200);
          stroke(0);
          strokeWeight(2);
          line( 300, 220, first.x-20, first.y+20);
        } else {
          text("Click on the dork", 900, 200);
          stroke(0);
          strokeWeight(2);
          line( 1100, 220, first.x+100, first.y+20);
        }
        popStyle();

        noStroke();
        //fill(255, 40);

        createContourInDimmedScreen(new PVector(first.x, first.y), first.w/first.d, first.w/first.d);
      }
      endShape(CLOSE);
    } else {
      flags[7]=true;
      saveFlags();
      wActivation=1;
    }
  }
}

void scoreBoardAnim() {//fades the scoreboard if a dork or plane gets behind
  for (int i=0; i<ducks.size(); i++) {
    Duck duck =ducks.get(i); 
    if (duck.x>width-350&&duck.y<100) {
      tint(255, 90);
    }
  }
  for (int i=0; i<planes.size(); i++) {
    Plane p=planes.get(i); 
    if (p.x>width-350&&p.x<width&&p.y<100) {
      tint(255, 90);
    }
  }

  if (bossSpawned) {
    if (boss.pos[2].x>width-350&&boss.pos[2].x<width&&boss.pos[2].y<100) {
      tint(255, 90);
    }
  }
}


void chooseBonus() {//randomly selects the amount of ammunition
  int R= (int)random(1, 15); 
  reloadBullets(R); 
  points.add(new Score(235, height-84, R, 1));
}

void bulletRemove() {//erases bullets that hit targets
  for (int i=0; i<ducks.size(); i++) {
    Duck duck=ducks.get(i); 
    for (int j=bullets.size()-1; j>=0; j--) {
      Bullet b=bullets.get(j);
      if (ducks.size()>0) {
        if (b.inside(duck)) {
          bullets.remove(j);
        }
      }
    }
  }
}
