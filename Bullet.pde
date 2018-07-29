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
    return x>d.x&&x<d.x+d.w/d.d&&y>d.y&&y<d.y+d.w/d.d;
  }
  
  boolean inside(Plane p){
    return x>p.x&&x<p.x+p.l&&y>p.y&&y<p.y+p.h;
  }
}
