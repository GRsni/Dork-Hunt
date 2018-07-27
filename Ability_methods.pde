void abilitiesAnim() {

  pushStyle();
  noStroke();
  fill(0, 180);
  for (int i=0; i<4; i++) {
    if (flags[i+2]) {

      QWER[i].resize(115, 90);
      image(QWER[i], 670+i*145, 615);
      if (shotIndex<15+i*5) {
        tint(50);
        image(QWER[i], 670+i*145, 615);
      }

      if (abilities[i]) {
        float phase=radians(360/(cooldowns[i]*60));
        remains[i]+=phase;
        arc(675+i*145+115/2, 657, 115, 115, -HALF_PI+remains[i], 3*HALF_PI, PIE);
        if (remains[i]>TWO_PI) {
          abilities[i]=false;
          remains[i]=0;
        }
      }
    }
  }
  popStyle();

  pushStyle();

  for (int i=0; i<4; i++) { 
    noFill();
    strokeWeight(35);
    stroke(#007F0E);
    rect(675+i*145, 600, 115, 115);
    stroke(50, 0, 0);
    strokeWeight(4);
    rect(690+i*145, 615, 85, 85, 4);
    if (flags[i+2]) {
      textFont(scoreFont);
      textAlign(CENTER);
      textSize(18);
      fill(0);
      text(15+i*5, 675+80+i*145, 635);
    }
  } 
  textSize(25);
  textAlign(CENTER);
  textFont(ammoFont);
  fill(#FFD800);
  if (flags[2]) {
    text("Q", 705, 695);
  }
  if (flags[3]) {
    text("W", 850, 695);
  }
  if (flags[4]) {
    text("E", 995, 695);
  }
  if (flags[5]) {
    text("R", 1140, 695);
  }
  popStyle();
}

void makeAbilityActive(int index, Ability ab) {
  activeAbilities[index]=ab;
  ab.recievePos(index);
}

void Q() {
  if (mouseY<height-250) {
    bullets.add(new Bullet(mouseX, mouseY, 0));
  }
  for (int i=0; i<20; i++) {
    float step=random(200);
    float x=mouseX+random(-step, step);
    float y=mouseY+random(-step, step);
    if (y>0&&y<height-250) {
      bullets.add(new Bullet(x, y, 0)); 
      if (levelType==3) {
        if (i==0) {
          if (boss.health1>0&&boss.items[0].click(mouseX, mouseY, false)) {
            boss.leftHit=true;
            boss.leftTime=millis();
            clicked=true;
            boss.health1-=10;
          }
          if (boss.health2>0&&boss.items[1].click(mouseX, mouseY, false)) {
            boss.rightHit=true;
            boss.rightTime=millis();
            clicked=true;
            boss.health2-=10;
          }
          if (boss.health1<1&&boss.items[3].click(mouseX, mouseY, false)) {
            boss.health2-=10;
            boss.bodyHit=true;
            boss.bodyTime=millis();
            clicked=true;
          } else if (boss.health2<1&&boss.items[3].click(mouseX, mouseY, false)) {
            boss.health1-=10;
            boss.bodyHit=true;
            boss.bodyTime=millis();
          } else {
            if (boss.items[3].click(mouseX, mouseY, false)) {
              if (random(1)<.5) {
                boss.health1-=5;
                boss.bodyHit=true;
                boss.bodyTime=millis();
              } else {
                boss.health2-=5;
                boss.bodyHit=true;
                boss.bodyTime=millis();
              }
            }
          }
          if (boss.health1<1&&boss.health2<1&&boss.health3>0&&boss.items[2].click(mouseX, mouseY, false)) {
            boss.headHit=true;
            boss.headTime=millis();
            clicked=true;
            boss.health3-=10;
          }
        }
        if (boss.health1>0&&boss.items[0].click(mouseX, mouseY, false)) {
          boss.leftHit=true;
          boss.leftTime=millis();
          clicked=true;
          boss.health1-=10;
        }
        if (boss.health2>0&&boss.items[1].click(mouseX, mouseY, false)) {
          boss.rightHit=true;
          boss.rightTime=millis();
          clicked=true;
          boss.health2-=10;
        }
        if (boss.health1<1&&boss.items[3].click(mouseX, mouseY, false)) {
          boss.health2-=10;
          boss.bodyHit=true;
          boss.bodyTime=millis();
          clicked=true;
        } else if (boss.health2<1&&boss.items[3].click(x, y, false)) {
          boss.health1-=10;
          boss.bodyHit=true;
          boss.bodyTime=millis();
        } else {
          if (boss.items[3].click(x, y, false)) {
            if (random(1)<.5) {
              boss.health1-=5;
              boss.bodyHit=true;
              boss.bodyTime=millis();
            } else {
              boss.health2-=5;
              boss.bodyHit=true;
              boss.bodyTime=millis();
            }
          }
        }
        if (boss.health1<1&&boss.health2<1&&boss.health3>0&&boss.items[2].click(x, y, false)) {
          boss.headHit=true;
          boss.headTime=millis();
          clicked=true;
          boss.health3-=10;
        }
      } else {
        for (int k=ducks.size()-1; k>=0; k--) {
          Duck duck=ducks.get(k);
          if (duck.click(false, x, y)&&duck.alive) {
            hitDork(duck);
          }
        }
        for (int a=planes.size()-1; a>=0; a--) {
          Plane p=planes.get(a);
          if (x>p.x&&x<(p.x+p.l)&&y>p.y&&y<(p.y+p.h)&&p.alive) {
            killPlane(p);
          }
        }
      }
    }
  }
}


void W() {
  if (millis()-wTime>10000) {
    wActivation=1;
  } else {
    strokeWeight(1);
    stroke(0);
    fill(255, 255, 0);
    textSize(25);
    textAlign(CENTER);
    text("W effect", 820+115/2, 560);
    noFill();
    rect(820, 580, 115, 15);
    noStroke();
    fill(0, 200, 50);
    rect(821, 581, map(millis()-wTime, 0, 10000, 115, 0), 14);
  }
}

void E() {
  if (millis()-eTime<6500) {
    if (!flags[0]&!eSound.isPlaying()) {
      eSound.loop();
    }
    strokeWeight(1);
    stroke(0);
    fill(255, 255, 0);
    textSize(25);
    textAlign(CENTER);
    text("E effect", 965+115/2, 560);
    noFill();
    rect(965, 580, 115, 15);
    noStroke();
    fill(0, 200, 50);
    rect(965, 581, map(millis()-eTime, 0, 6500, 115, 0), 14);
    if (frameCount%5==0) {
      if (mouseY<height-250) {
        bullets.add(new Bullet(mouseX, mouseY, 0));

        if (levelType!=3) {
          for (int k=ducks.size()-1; k>=0; k--) {
            Duck duck=ducks.get(k);
            if (duck.click(false, mouseX, mouseY)&&duck.alive) {
              hitDork(duck);
            }
          }
          for (int i=planes.size()-1; i>=0; i--) {
            Plane p=planes.get(i);
            if (mouseX>p.x&&mouseX<(p.x+p.l)&&mouseY>p.y&&mouseY<(p.y+p.h)) {
              killPlane(p);
            }
          }
        } else {
          if (levelType==3) {

            if (boss.health1>0&&boss.items[0].click(mouseX, mouseY, false)) {
              boss.health1-=10;
              boss.leftHit=true;
              boss.leftTime=millis();
            }
            if (boss.health2>0&&boss.items[1].click(mouseX, mouseY, false)) {
              boss.health2-=10;
              boss.rightHit=true;
              boss.rightTime=millis();
            }
            if (boss.health1<1&&boss.items[3].click(mouseX, mouseY, false)) {
              boss.health2-=10;
              boss.bodyHit=true;
              boss.bodyTime=millis();
            } else if (boss.health2<1&&boss.items[3].click(mouseX, mouseY, false)) {
              boss.health1-=10;
              boss.bodyHit=true;
              boss.bodyTime=millis();
            } else {
              if (boss.items[3].click(mouseX, mouseY, false)) {
                if (random(1)<.5) {
                  boss.health1-=5;
                  boss.bodyHit=true;
                  boss.bodyTime=millis();
                } else {
                  boss.health2-=5;
                  boss.bodyHit=true;
                  boss.bodyTime=millis();
                }
              }
            }
            if (boss.health1<1&&boss.health2<1&&boss.health3>0&&boss.items[2].click(mouseX, mouseY, false)) {
              boss.health3-=10;
              boss.headHit=true;
              boss.headTime=millis();
            }
          }
        }
      }
    }
  } else {
    eActivation=false;
    if (eSound.isPlaying()) {
      eSound.pause();

      eSound.rewind();
    }
  }
}

void R() {
  if (levelType!=3) {
    for (int i=ducks.size()-1; i>=0; i--) {
      Duck duck=ducks.get(i);
      points.add(new Score(duck.x, duck.y, 200, 0));
      ducks.remove(i);
      killCount++;
      score+=200;

      if (random(1)>0.5+log(level)*0.1) {
        chooseBonus();
      }
    }
    for (int i=planes.size()-1; i>=0; i--) {
      Plane p=planes.get(i);
      points.add(new Score(p.x, p.y, 1000, 0));
      planes.remove(i);
      if (!flags[0]) {
        UFOCrash.play(0);
      }
      score+=1000;
      killCount++;
      int reloadAmount;
      if (level%10==0) {
        reloadAmount=5;
        reloadBullets(reloadAmount);
      } else {
        reloadAmount=20;
        reloadBullets(reloadAmount);
      }
      points.add(new Score(235, height-84, reloadAmount, 1));
    }
  } else {

    if (bossSpawned) {
      if (boss.health1>0||boss.health2>0) {
        boss.health1-=100;
        boss.leftHit=true;
        boss.leftTime=millis();
        boss.rightHit=true;
        boss.rightTime=millis();
        boss.health2-=100;
        boss.bodyHit=true;
        boss.bodyTime=millis();
      } else {
        boss.health3-=80;
        boss.headHit=true;
        boss.headTime=millis();
      }
    }
  }
}
