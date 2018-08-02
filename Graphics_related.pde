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


void createContourInDimmedScreen(PVector pos, float wid, float hei) {
  beginContour();
  vertex(pos.x, pos.y);
  vertex(pos.x, pos.y+hei);
  vertex(pos.x+wid, pos.y+hei);
  vertex(pos.x+wid, pos.y);
  endContour();
}
void startBackgroundColorChange() {
  actualBackground=backgrounds[levelType-1];
  steps=getChangingColorSteps(actualBackground);
  changingBackground=true;
}

color getBackgroundColor() {
  if (!changingBackground) { 
    return backgrounds[levelType-1];
  } else {
    return graduallyChangeBackground();
  }
}


boolean colorEquals(color a, color b) {
  int R=(a>>16&0xFF)-(b>>16&0xFF);
  int G=(a>>8&0xFF)-(b>>8&0xFF);
  int B=(a&0xFF)-(b&0xFF);
  if (R==0&&G==0&&B==0) return true;
  else return false;
}

color graduallyChangeBackground() {
  int cArray[]=new int[3];
  for (int i=0; i<cArray.length; i++) {
    int shift=16-i*8;
    cArray[i]=actualBackground>>shift&0xFF;
    cArray[i]+=steps[i];
  }
  actualBackground=color(cArray[0], cArray[1], cArray[2]);
  return actualBackground;
}


float[] getChangingColorSteps(color col) {
  float[] steps=new float[3];
  for (int i=0; i<steps.length; i++) {
    int shift=16-i*8;
    steps[i]=((backgrounds[0]>>shift&0xFF)-(col>>shift&0xFF))/60.0;
  }
  return steps;
}
