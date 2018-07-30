void dSpawn() {//spawns the dorks
  if (killCount==0&&!flags[6]) {
    ducks.add(new Duck(random(width), height-250, random(.5, 1), 1) );
  } else {
    ducks.add(new Duck(random(width), height-250, random(.5, 1)) );
  }
}

void removeMissedDorks() {
  for (int i=ducks.size()-1; i>=0; i--) {
    Duck duck=ducks.get(i); 
    if (duck.y>height-200&&duck.alive) {
      points.add(new Score(width-150, 90, -1000, 0)); 
      score-=1000; 
      ducks.remove(i);
      //life-=5;
    }
  }
}

void hitDork(Duck d) {
  clicked=true;
  if (d.lives>1) {
    d.lives--;
  } else {
    killDork(d);
  }
}


void killDork(Duck d) {
  d.die();
  if (!flags[0]) {
    splatter.play(0);
  }

  if (!flags[1]) {//easy mode
    //if (random(1)>0.3+log(level)*0.25||killsSinceAmmo>level/2&&d.initLives!=3) {
      if(d.initLives==3){
      chooseAmountOfBullets(10, 100);
    //} else if (d.initLives==3) {
    }else if(random(1)>.3+log(level)*.25||killsSinceAmmo>level/2){
      chooseAmountOfBullets();
    } else {
      killsSinceAmmo++;
    }
  } else {//hard mode
  if(d.initLives==3){
    //if (random(1)>.4+log(level)*.24||killsSinceAmmo>(25+log(level)*2)&&d.initLives!=3) {
      chooseAmountOfBullets(10, 5);
    } else if (random(1)>.4+log(level)*.24||killsSinceAmmo>(20+log(level)*2)) {
      chooseAmountOfBullets();
    } else {
      killsSinceAmmo++;
    }
  }
}


void pSpawn() {//spawns the UFOs
  if (random(1)>.5) {//planes towards the right
    planes.add(new Plane(-50, random(50, 450)));
  } else {//planes towards the left
    planes.add(new Plane(width+50, random(75, 450)));
  }
}

void removeMissedPlanes() {
  for (int i=planes.size()-1; i>=0; i--) {//remove missed planes
    Plane p= planes.get(i); 
    if (p.outOfTheBorders()) {
      planes.remove(i);
    }
  }
}


void killPlane(Plane p) {
  clicked=true;
  p.die();
  reloadBullets(p.bullets);
  points.add(new Score(235, height-84, p.bullets, 1));
  if (!flags[0]) {
    UFOCrash.play(0);
  }
}
