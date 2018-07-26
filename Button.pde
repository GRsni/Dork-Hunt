class Button {//Asks whether changes color, for an X, Y, xlength, y length, corner radius, strokeWeight, inside fill, stroke color, text inside, text color 
  float x;
  float y;
  float Xl;
  float Yl;
  float corners;
  int rimWidth;
  color in;
  color out;
  color inside;
  color border;
  String content;
  color letter;
  boolean change;

  Button(boolean Ch, float x_, float y_, float Xlength, float Ylength, float c, int stroke, color inside, color rim) {
    x=x_;
    y=y_;
    Xl=Xlength;
    Yl=Ylength;
    corners=c;
    rimWidth=stroke;
    change=Ch;

    in=inside;
    out=rim;
    content="";
    letter=0;
  }
  Button(boolean Ch, float x_, float y_, float Xlength, float Ylength, float c, int stroke, color inside, color rim, String words, color l) {
    x=x_;
    y=y_;
    Xl=Xlength;
    Yl=Ylength;
    corners=c;
    change=Ch;
    rimWidth=stroke;
    in=inside;
    out=rim;
    content=words;
    letter=l;
  }


  void show() {
    pushStyle();
    stroke(out);
    if (rimWidth==0) {
      noStroke();
    } else {
      strokeWeight(rimWidth);
    }

    fill(in);
    if (change) {
      if (mouseX>x&&mouseX<x+Xl&&mouseY>y&&mouseY<y+Yl) {
        in=int(map(in, #000000, #FFFFFF, #C4C4C4, #FFFFFF));
        fill(in);
      }
    }
    rect(x, y, Xl, Yl, corners);
    if (content.length()>0) {
      fill(letter);
      textAlign(CENTER, CENTER);
      text(content, x, y, Xl, Yl);
    }

    popStyle();
  }

  boolean click(float X_, float Y_, boolean c) {
    if (!c) {
      if (X_>x&&X_<(x+Xl)) {
        if (Y_>y&&Y_<(y+Yl)) {
          return true;
        }
      } 
      return false;
    } else {
      if (X_>x&&X_<(x+Xl)) {
        if (Y_>y&&Y_<(y+Yl)) {
          if (mousePressed) {

            return true;
          }
        }
      } 
      return false;
    }
  }
}