class Score {//Needs x pos, y pos, score ammount and type
  float x;
  float y;
  float up=0;
  int points;
  boolean alive=false;
  int type;

  Score(float X, float Y, int Scr, int S) {
    x=X;
    y=Y;
    points=Scr;
    type=S;
  }

  void show() {
    if (type==0) {//score points
      if (points>0) {
        fill(0, 255, 0);
        textSize(int(map(points, 0, 2000000, 25, 35)));
        textAlign(TOP, TOP);

        text("+"+ points, x+15, y+20-up);
      } else {
        fill(50, 0, 0);
        textSize(30);
        textAlign(LEFT);
        text( points, x, y+up);
      }
    } else if (type==1) {//ammo reloaded
      if (points>0) {
        fill(0, 255, 0);
        textSize(30);
        textAlign(TOP, TOP);

        text("+"+ points, x+15, y+20-up);
        if (points>9) {
          image(bullet, x+75, y+3-up);
        } else {
          image(bullet, x+60, y+3-up);
        }
      } else {
        fill(50, 0, 0);
        textSize(30);
        textAlign(TOP, TOP);

        text(points, x+15, y+20+up);
        if (points<9) {
          image(bullet, x+75, y+3+up);
        } else {
          image(bullet, x+60, y+3+up);
        }
      }
    } else if (type==2) {//next level banner
      textSize(35+up*3);
      fill(120, 0, 0);
      textAlign(CENTER);
      text("Next level", x, y);
    }
    up+=.1;
  }
}
