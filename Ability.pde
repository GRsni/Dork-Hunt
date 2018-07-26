class Ability {
  String name;
  char letter;
  int cost;
  boolean instant;
  float duration;
  float cooldown;
  PVector pos=new PVector(0,0);
  PImage art;
  boolean inCD;

  Ability(String n, int c, float dur, float cd, PImage img) {
    name=n; 
    cost=c; 
    if (dur==0) {
      instant=true;
    }
    duration=dur;
    cooldown=cd;
    art=img;
  }
  
  void display(){
    fill(100, 100);
    rect(pos.x, pos.y, 115, 115);
    image(art, pos.x, pos.y);
    
  }
  
  void recievePos(int index){
   pos=new PVector(690+index*145, 615);
  }
}
