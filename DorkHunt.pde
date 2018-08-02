import ddf.minim.*;  //<>//
import java.awt.*;


//Dork Hunt 
//Game by GRsni
//Version 1.X.X for Processing 3.x
//---------------------------------------
//TO DO:
//Reformat the whole code
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

Robot r;

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
PImage[] cursor=new PImage[7];
PImage[] whiteCursor=new PImage[7];
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
int bonusTime, bonusLevelDuration=4500;//duration in milliseconds
float wActivation=1.0;
boolean eActivation=false;


ArrayList<Duck> ducks= new ArrayList<Duck>();
ArrayList<Bullet> bullets=new ArrayList<Bullet>();
ArrayList<Score> points=new ArrayList<Score>();
ArrayList<Plane> planes=new ArrayList<Plane>();
ArrayList<Ability> abilitiesList=new ArrayList<Ability>();
Ability[] activeAbilities=new Ability[4];
Boss boss;

int level=1;
static int startAmmo;
int score=0;
final static float grav=.1;
float life=100;
int listPos=0;
int txtSize;
int cursorType;
boolean typing;
boolean newHigh;
boolean nameDone;
boolean[] cutScenes=new boolean[4];

int gameState=0;
int levelType=1;
boolean gameStart;
boolean clicked;
boolean threadDone;
boolean changingBackground;
color lastBackground, actualBackground;
float[] steps;
color[] backgrounds=new color[3];
boolean bossSpawned;

int killCount, killsSinceAmmo, simpleDorksKilled;

int shotIndex;
float angle=0;
int time2=0;


void setup() {

  fullScreen();
  //size(1200, 600);

  titlebaricon=loadImage("data/art/dorkIcon.png");
  frameRate(120);

  surface.setIcon(titlebaricon);
  surface.setTitle("Dork Hunt");
  minim =new Minim(this);
  noCursor();
  print(colorEquals(color(1, 10, 1), color(1, 9, 1)));


  scoreFont=loadFont("info/OCRAExtended.vlw");
  ammoFont=loadFont("info/Power_Clear_Bold-40.vlw");
  textFont(scoreFont, 30);
  thread("loadStuff");
}

void draw() { 
  background(120);

  //println(actualBackground>>16&0xFF, actualBackground>>8&0xFF, actualBackground&0xFF, changingBackground);
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
          //bulletRemove(); 

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
    if (key=='a') {
      level++;
      startBackgroundColorChange();
      levelChoose();
      controlSpawns();
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








void controlSpawns() {//spawn algorithm 

  if (levelType==2) {//bonus level
    pushStyle();
    colorMode(HSB, 360, 1, 1);
    fill(angle*10, 1, 1); 
    if (angle*10>360) angle=0;
    textAlign(CENTER); 
    if (txtSize>30) {
      textSize(txtSize);
    } else {
      textSize(30);
    }
    textAlign(LEFT, TOP ); 
    text("Bonus level", 0, 5);
    popStyle();
    //if (!abilities[1]) {
    if (frameCount%10==0) {
      pSpawn();
    }
    //} else {
    //if (frameCount%20==0) {
    //  pSpawn();
    //  //}
    //}
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
      spawnBoss();
    }
  }
}






void levelChoose() {//level selection
  if (flags[1]) {//hard
    if (level%20==0&&level%15!=0) {//ufo level
      ducks.clear();
      levelType=2;
      bonusTime=millis();
      txtSize=70;
    } else if (level%15==0) {//boss level
      ducks.clear();
      planes.clear();
      levelType=3;
      txtSize=100;
    } else {//dork level
      levelType=1;
    }
  } else {//easy 
    if (level%10==0&&level%15!=0) {//ufo level
      ducks.clear();
      levelType=2;
      txtSize=70;
      bonusTime=millis();
    } else if (level%15==0) {//boss level
      ducks.clear();
      planes.clear();
      levelType=3;
      txtSize=100;
    } else {//dork level
      levelType=1;
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
    if (millis()-bonusTime>bonusLevelDuration) {
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
  startBackgroundColorChange();
  levelChoose();
  killCount=0;
  if (!flags[0]) { 
    levelUp.play(0);
  }
}

void checkGameLoseCondition() {//lose condition is when out of ammo
  if (shotIndex<1) {
    gameState=4; 
    updateScoreLeaderBoard();
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
  ducks.clear();
  points.clear();
  planes.clear();
  bullets=new ArrayList<Bullet>();

  for (int i=0; i<abilities.length; i++) {
    abilities[i]=false;
    remains[i]=0;
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










void reloadBullets(int num) {
  if (gameState==1) {
    if (!flags[0]) {
      reloadSound.play(0);
    }
  }
  shotIndex+=num;
  killsSinceAmmo=0;
  points.add(new Score(235, height-84, num, 1));
}



void chooseAmountOfBullets() {//selects and reloads the ammo
  int R= (int)random(1, 15); 
  reloadBullets(R);
}


void chooseAmountOfBullets(int base, int rand) {//selects and reloads the ammo
  int R= base+int(random(rand)); 
  reloadBullets(R);
}

//void bulletRemove() {//erases bullets that hit targets
//  for (int i=bullets.size()-1; i>=0; i--) {
//    Bullet b=bullets.get(i);
//    for (int j=0; j<ducks.size(); j++) {
//      if (b.inside(ducks.get(i))) {
//        bullets.remove(i);
//      }
//    }
//    for (int j=0; j<planes.size(); j++) {
//      if (b.inside(planes.get(j))) {
//        bullets.remove(i);
//      }
//    }
//  }
//}
