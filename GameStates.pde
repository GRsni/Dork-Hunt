void drawGameState0() {

  pushStyle();
  fill(0);
  stroke(0);
  textFont(ammoFont);
  if (!nameDone) {
    if (!focused) {
      pushStyle();
      colorMode(HSB);
      fill(angle, 255, 255);

      textAlign(CENTER);
      textSize(25+abs(20*sin(angle/10)));
      if (angle>255) {
        angle=0;
      }
      text("Click anywhere on the screen!", width/2, height-200);
      popStyle();
    } else {
      if (sin(angle)>0) {
        String aux="Enter your name"+name;
        stroke(0);
        strokeWeight(4);
        strokeCap(SQUARE);
        line(width/2+aux.length()*20.75/2, 170, width/2+aux.length()*20.75/2, 210);
      }
    }
    typing=true;
    textAlign(CENTER);
    text("Enter your name:"+name, width/2, 200);

    text("Press ENTER when you're done.", width/2, 300);
  } else {
    typing=false;
  }
  popStyle();
}


void drawGameState1() {//actual game
  pushStyle();
  rectMode(CORNER);
  background(#54C0FF);

  textFont(scoreFont);
  textAlign(BOTTOM, BOTTOM);
  textSize(35);
  if (gameStart) {
    if (!theme.isPlaying()&&!flags[0]) {
      theme.loop();
    }

    for (int i=ducks.size()-1; i>=0; i--) {//dork handling code
      Duck duck= ducks.get(i);
      if (duck.alpha<3) {
        ducks.remove(i);
      }
      duck.show(); 
      duck.move();
      if (duck.click(true, mouseX, mouseY)&&duck.alive) {
        killDork(duck);
      }
    }

    for (int i=planes.size()-1; i>=0; i--) {//UFO handling code
      Plane plane=planes.get(i);
      if (plane.alpha<3) {
        planes.remove(i);
      }
      plane.move();
      plane.show(); 
      //if (mouseX>plane.x&&mouseX<(plane.x+plane.l)&&mouseY>plane.y&&mouseY<(plane.y+plane.h)&&mousePressed&&!clicked&&shotIndex>0&&plane.alive) {
      if (plane.inside(mouseX, mouseY)&&mousePressed&&!clicked&&shotIndex>0&&plane.alive) {
        killPlane(plane);
      }
    }
    if (bossSpawned) {
      boss.update();
      boss.hit();
      boss.show();
    }

    image(desktop, 0, height-250);
    textSize(20);
    text(int(frameRate), 0, 20);

    noFill();
    rectMode(CORNER);
    stroke(25, 0, 0);
    strokeWeight(4);
    rect(40, 550, 130+21*name.length(), 50, 4);
    int addition=0;
    if (level<10) {
      addition=0;
    } else if (level>9&&level<100) {
      addition=20;
    } else if (level>99) {
      addition=40;
    }
    rect(40, 615, 180+addition, 50, 4);
    rect(40, 680, 300, 50, 4);

    textSize(35);
    fill(#FFD800);
    text("User:"+name, 50, height-180);
    text("Level:"+level, 50, height-110);
    text("Ammo:"+shotIndex, 50, height-45);
    //image(bullet, 200+shotIndex%10
    if (shotIndex<10) {
      image(bullet, 200, height-83);
    } else if (shotIndex>9&&shotIndex<100) {
      image(bullet, 220, height-83);
    } else if (shotIndex>99&&shotIndex<1000) {
      image(bullet, 240, height-83);
    } else {
      image(bullet, 260, height-83);
    }
    if (shotIndex<10) {
      textFont(ammoFont, 40);
      fill(50, 20, 0, sin(angle)*255);
      text("Low Ammo", 350, height-45);
      textFont(scoreFont, 30);
    }

    scoreBoardAnim(); 
    image(scoreboard, width-300, 0); 
    textSize(35); 
    fill(#FFD800); 
    textAlign(BOTTOM, BOTTOM); 
    text("Score:", width-270, 70); 
    textAlign(LEFT); 
    if (score>999999||score<-99999) {
      textSize(25);
    }
    text(score, width-150, 65); 
    noTint(); 

    if (shotIndex<0) {//if no ammo 
      fill(#502626, map(sin(angle), -1, 1, 0, 255)); 
      textSize(50); 
      text("NO AMMO", 150, height-65);
    }
    for (int i=points.size()-1; i>=0; i--) {
      Score scr=points.get(i); 
      scr.show(); 
      if (scr.up>4) {
        points.remove(i);
      }
    }
    for (int i = bullets.size() - 1; i >= 0; i--) {
      Bullet bullet = bullets.get(i); 
      bullet.show(); 
      bullet.d+=.65; 

      if (bullet.d>10) {
        bullets.remove(i);
      }
    }
    levelUpCheck(); 
    checkGameLoseCondition(); 

    levelType();
    removeMissedDorks();
    removeMissedPlanes();
    abilitiesAnim();
    cutscenes();
    if (wActivation==0.5&&flags[7]) {
      W();
    }
    if (abilities[2]) {
      E();
    }
  }//end gameStart
  popStyle();
} //end gameState1



void drawGameState2() {

  pushStyle();
  rectMode(CORNER);
  background(84, 192, 255);

  textFont(scoreFont);
  textAlign(BOTTOM, BOTTOM);
  textSize(35);
  if (theme.isLooping()) {
    theme.pause();
  }
  fill(0);
  String s="User:"+name;
  text(s, 30, 60);
  //for (Ability a:activeAbilities) {
    activeAbilities[0].display();
    //image(dorkFrameLeft[i], i*100, 100);
  //}


  Button w=new Button(true, 20+s.length()*23.5, 25, 36, 36, 4, 4, #000000, #484848);
  w.show();

  if (w.click(mouseX, mouseY, false)) {
    textSize(20);
    text("Change name", s.length()*23.5-20, 95);
  }
  if (w.click(mouseX, mouseY, true)) {
    gameState=0;
    nameDone=false;
  }
  stroke(50);
  noFill();
  strokeWeight(4);

  image(wrench, s.length()*23.5+20, 25 );
  rect(20+s.length()*23.5, 25, 36, 36, 4);

  Button vol=new Button(false, width-70, 25, 35, 35, 2, 4, #000000, #484848);
  vol.show();
  if (vol.click(mouseX, mouseY, true)&&!clicked) {
    clicked=true;
    flags[0]=!flags[0];
    if (flags[0]) {
      pauseAllMusic();
    }
    saveFlags();
  }
  if (!flags[0]) {
    image(volume, width-70, 25);
  } else {
    image(mute, width-70, 25);
  }
  noFill();
  stroke(50);
  rect(width-70, 25, 36, 36, 2);

  if (vol.click( mouseX, mouseY, false)) {
    pushStyle();
    textSize(20);
    textAlign(CENTER);
    fill(0);
    if (!flags[0]) {
      text("Mute", width-48, 95);
    } else {
      text("Unmute", width-48, 95  );
    }
    popStyle();
  }


  time2++;
  textSize(100+int(10*sin(angle))); 

  fill(#FFD800); 
  textAlign(CENTER);

  pushMatrix();
  if (time2>6000) {

    translate(width/2, 200);
    rotate(angle/2);
    text("Dork Hunt!", 0, 0);
  } else {
    text("Dork Hunt!", width/2, 200);
  }

  popMatrix();
  fill(#FFD800); 
  if (!flags[1]) {
    textFont(ammoFont);
    textSize(35);
    fill(#FFFF00);
    text("Highscores-Easy Mode", 1100, 300);
    text("------------", 1100, 330);
  } else {
    textFont(ammoFont);
    textSize(35);
    fill(#FFFF00);
    text("Highscores-Hard Mode", 1100, 300);
    text("------------", 1100, 330);
  }

  drawHighScores(20, 1100, 350);


  textFont(scoreFont);
  fill(#FF8705); 
  strokeWeight(4); 
  stroke(200); 

  rect(width/2-150, height/2+150, 300, 75, 5); 
  rect(width/2-150, height/2+250, 300, 75, 5); 
  fill(255); 

  if (!gameStart) { 
    textSize(75); 
    Button play=new Button(true, width/2-150, height/2-50, 300, 150, 10, 4, #FF8705, #C8C8C8, "Play", #FFFFFF);
    play.show();
    if (play.click(mouseX, mouseY, true)) {
      gameStart=true;
      gameState=1;
    }
  } else {
    Button newGame=new Button(true, width/2-275, height/2-50, 250, 150, 5, 4, #FF8705, #C8C8C8, "New Game", #FFFFFF);
    Button Continue=new Button(true, width/2+25, height/2-50, 250, 150, 5, 4, #FF8705, #C8C8C8, "Continue", #FFFFFF);
    newGame.show();
    Continue.show();
    if (newGame.click(mouseX, mouseY, true)) {
      resetGame();
      gameState=1;
      gameStart=true;
      theme.rewind();
    }
    if (Continue.click(mouseX, mouseY, true)) {
      gameState=1;
    }
  }

  textSize(40); 

  Button gameInfo=new Button(true, width/2-150, height/2+150, 300, 75, 5, 4, #FF8705, #C8C8C8, "Game Info", #FFFFFF);
  gameInfo.show();
  if (gameInfo.click(mouseX, mouseY, true)) {
    gameState=3;
    ducks.add(new Duck(550, 420, 2, 1));
    planes.add(new Plane(490, 490));
  }

  Button controls=new Button(true, width/2-150, height/2+250, 300, 75, 5, 4, #FF8705, #C8C8C8, "Settings", #FFFFFF);
  controls.show();
  if (controls.click(mouseX, mouseY, true)) {
    gameState=6;
  }
  Button quit=new Button(true, 50, height-125, 150, 75, 0, 4, #969696, #C8C8C8, "Quit", #320000);
  quit.show();
  if (quit.click(mouseX, mouseY, true)&&!clicked) {
    saveFlags();
    exit();
  }
  popStyle();
}



void drawGameState3() {
  pushStyle();
  rectMode(CORNER);
  background(84, 192, 255);

  textFont(scoreFont);
  textAlign(BOTTOM, BOTTOM);
  textSize(35);
  fill(84, 192, 255); 
  rect(0, 0, width, height); 

  fill(#FFD800); 
  textSize(75); 
  textAlign(CENTER); 
  text("Game Info", width/2, 150); 

  textSize(35); 
  text("-Get as many points as you can.", width/2, 250); 
  textSize(20); 
  textAlign(LEFT); 
  text("-Shoot the dorks to earn points.", 150, 450); 
  text("-Try and get the UFOs.", 150, 520); 
  textSize(30); 
  fill(#712323); 
  textAlign(CENTER); 
  text("-If you run out of bullets you lose.", width/2, 330);

  ducks.get(ducks.size()-1).show();


  planes.get(planes.size()-1).show();

  textSize(35); 
  Button menu=new Button(true, width-250, height-150, 200, 100, 0, 4, #969696, #C8C8C8, "Back to menu", #320000);
  menu.show();
  if (menu.click(mouseX, mouseY, true)) {
    gameState=2; 
    ducks.remove(ducks.size()-1);
  }
  popStyle();
}



void drawGameState4() {
  angle+=1;
  if (angle>255) {
    angle=0;
  }
  pushStyle();
  if (theme.isLooping()) {
    theme.pause();
  }
  background(0); 

  fill(255); 
  textAlign(CENTER); 
  textSize(75  );
  text("You lost", width/2, height/2-200);
  textSize(50);
  text("Level:" + level+"    Score:"+score, width/2, height/2-100);
  if (newHigh) {
    if (!flags[1]) {
      pushStyle();
      colorMode(HSB);
      fill(angle, 255, 255);
      text("New highscore(Easy)!", width/2, height/2+50);
      text("------------", width/2, height/2+75);
      popStyle();
    } else {
      pushStyle();
      colorMode(HSB);
      fill(angle, 255, 255);
      text("New highscore(Hard)!", width/2, height/2+50);
      text("------------", width/2, height/2+75);
      popStyle();
    }
  } else {
    if (!flags[1]) {
      fill(255);
      text("Highscores(Easy)", width/2, height/2+25);
      text("------------", width/2, height/2+75);
    } else {
      fill(255);
      text("Highscores(Hard)", width/2, height/2+25);
      text("------------", width/2, height/2+75);
    }
  }

  fill(255);


  drawHighScores(16, width/2, height/2+100);

  Button menu=new Button(true, 50, height-150, 250, 100, 0, 10, #C8C8C8, #646464, "Menu", #320000);
  Button retry=new Button(true, width-300, height-150, 250, 100, 0, 10, #C8C8C8, #646464, "Retry", #320000);
  menu.show();
  if (menu.click(mouseX, mouseY, true)&&!clicked) {
    clicked=true;
    gameState=2;
    resetGame();
    gameStart=false;
    time2=0;
  }
  retry.show();
  if (retry.click(mouseX, mouseY, true)) {
    resetGame();
    gameState=1; 
    gameStart=true;
  }
}



void drawGameState5() {
  pushStyle();
  background(84, 192, 255);
  image(desktop, 0, height-250);

  noFill();
  rectMode(CORNER);
  textAlign(BOTTOM, BOTTOM);
  strokeWeight(4);
  stroke(25, 0, 0);
  rect(40, 550, 130+21*name.length(), 50, 4);
  int addition=0;
  if (level<10) {
    addition=0;
  } else if (level>9&&level<100) {
    addition=20;
  } else if (level>99) {
    addition=40;
  }
  rect(40, 615, 180+addition, 50, 4);
  rect(40, 680, 300, 50, 4);

  textSize(35);

  fill(#FFD800);
  text("User:"+name, 50, height-180);
  text("Level:"+level, 50, height-110);

  text("Ammo:"+shotIndex, 50, height-45);

  if (shotIndex<10) {
    image(bullet, 200, height-83);
  } else if (shotIndex>9&&shotIndex<100) {
    image(bullet, 220, height-83);
  } else if (shotIndex>99&&shotIndex<1000) {
    image(bullet, 240, height-83);
  } else {
    image(bullet, 260, height-83);
  }
  if (shotIndex<10) {
    textFont(ammoFont, 40);
    fill(50, 20, 0, sin(angle)*255);
    text("Low Ammo", 350, height-45);
    textFont(scoreFont, 30);
  }
  for (Duck duck : ducks) {
    duck.show();
  }
  for (Plane plane : planes) {
    plane.show();
  }
  image(scoreboard, width-300, 0); //scoreboard
  textSize(35); 
  fill(#FFD800); 
  textAlign(BOTTOM, BOTTOM); 
  text("Score:", width-270, 70); 
  textAlign(LEFT); 
  if (score>999999) {
    textSize(25);
  }
  text(score, width-150, 65); //end scoreboard

  if (shotIndex<0) {//if no ammo 
    fill(#502626, map(sin(angle), -1, 1, 0, 255)); 
    textSize(50); 
    text("NO AMMO", 150, height-65);
  }
  for (int i=points.size()-1; i>=0; i--) {
    Score scr=points.get(i); 
    scr.show(); 

    if (scr.up>4) {
      points.remove(i);
    }
  }

  fill(120, 180); 
  textSize(30); 
  noStroke();
  rect(0, 0, width, height); 
  Button vol=new Button(false, width-70, 25, 35, 35, 2, 4, #000000, #484848);
  vol.show();
  if (vol.click(mouseX, mouseY, true)&&!clicked) {
    clicked=true;
    flags[0]=!flags[0];
    if (flags[0]) {
      pauseAllMusic();
    }
    saveFlags();
  }
  if (!flags[0]) {
    image(volume, width-70, 25);
  } else {
    image(mute, width-70, 25);
  }
  noFill();
  stroke(50);
  rect(width-70, 25, 36, 36, 2);
  if (vol.click(mouseX, mouseY, false)) {
    pushStyle();
    textSize(20);
    fill(0);
    textAlign(CENTER);
    if (!flags[0]) {
      text("Mute", width-48, 100);
    } else {
      text("Unmute", width-48, 100);
    }
    popStyle();
  } 
  textSize(75);
  Button paused=new Button(true, width/2-200, height/2-200, 400, 300, 10, 4, #FF8705, #C8C8C8, "Game paused", #FFFFFF);

  if (paused.click(mouseX, mouseY, false)) {
    paused.content="Unpause the game?";
  }
  paused.show();
  if (paused.click(mouseX, mouseY, true)) {
    if (abilities[2]&&!flags[0]) {
      eSound.loop();
    }
    eTime=millis()-(6500-eRest);
    gameState=1;

    wTime=millis()+wRest-10000;
  }
  textSize(40);
  Button menu=new Button(true, width-250, height-150, 200, 100, 0, 4, #969696, #C8C8C8, "Back to menu", #320000);
  menu.show();
  if (menu.click(mouseX, mouseY, true)) {
    gameState=2;
    time2=0;
  }
  popStyle();
}



void drawGameState6() {
  background(#54C0FF);
  pushStyle();
  if (theme.isLooping()) {
    theme.pause();
  }

  textSize(40);
  textFont(ammoFont);
  textAlign(LEFT);
  fill(0);
  text("Game settings", 50, 75);

  textSize(25);

  text("-Choose the difficulty:", 50, 200 );
  noFill();
  rectMode(CORNER);
  rect(310, 170, 80, 40);
  pushStyle();
  if (flags[1]) {
    text("Hard", 400, 200);
    Button diff=new Button(false, 351, 171, 39, 39, 0, 0, #C80000, #000000);
    diff.show();
    if (diff.click(mouseX, mouseY, true)&&!clicked) {
      shotIndex=0;
      reloadBullets(25);
      flags[1]=!flags[1];
      resetGame();
      loadHighScores();
      saveFlags();
    }
  } else {
    text("Easy", 400, 200);
    Button diff=new Button(false, 311, 171, 39, 39, 0, 0, #09C600, #000000);
    diff.show();
    if (diff.click(mouseX, mouseY, true)&&!clicked) {
      clicked=true;
      shotIndex=0;
      reloadBullets(50);
      flags[1]=!flags[1];
      resetGame();
      loadHighScores();
      saveFlags();
    }
  }
  popStyle();
  fill(0);
  text("-Reticle selection:", 50, 300);



  Button cursorRect=new Button(false, 300, 275, 40, 40, 4, 3, #54C0FF, #1E1E1E);
  cursorRect.show();
  if (cursorRect.click(mouseX, mouseY, true)&&!clicked) {
    clicked=true;
    cursorType++;
    if (cursorType>cursor.length-1) {
      cursorType=0;
    }
  }
  if (!cursorRect.click(mouseX, mouseY, false)) {
    text("Click on the reticle to change it.", 360, 300);
  }

  image(cursor[cursorType], cursorRect.x+10, cursorRect.y+10);

  text("Game made by GRsni", width-220, 50+10*sin(angle));
  text("-Reset all saved game data:", 50, height-140);
  textSize(35);
  Button reset=new Button(true, 400, height-190, 150, 80, 4, 4, #969696, #C8C8C8, "Reset data", #320000); 
  reset.show();
  if (mouseX>reset.x&&mouseX<reset.x+reset.Xl&&mouseY>reset.y&&mouseY<reset.x+reset.Yl) {
    fill(255, 0, 0);
    textSize(10);
    text("This will delete all data. Are you sure you want to proceed?", 600, height-200, 500, 300);
  }
  if (reset.click(mouseX, mouseY, true)) {
    resetFlags();
    loadFlags();

    resetScoresEasy();
    resetScoresHard();
    loadHighScores();
    resetGame();
    gameStart=false;
  }
  textFont(scoreFont);
  textSize(35); 
  Button menu=new Button(true, width-250, height-150, 200, 100, 0, 4, #969696, #C8C8C8, "Back to menu", #320000);
  menu.show();
  if (menu.click(mouseX, mouseY, true)) {
    gameState=2;
    time2=0;
  }


  popStyle();
}
