class Bullet {
  float x; 
  float y;
  float d;

  Bullet(float X, float Y, float D) {
    x=X;
    y=Y;
    d=D;
  }

  void show() {
    fill(#FF8D00);
    noStroke();
    quad(x, y-15+d, x-15+d, y, x, y+15-d, x+15-d, y);
  }

  boolean inside(Duck d) {
    if (x>d.x&&x<d.x+100/d.d&&y>d.y&&y<d.y+100/d.d) {
      return true;
    } else {
      return false;
    }
  }
}