class Ability {
  String name;
  int cost;
  boolean instant;
  float duration;
  float cooldown;
  PVector pos;
  PImage art;
  boolean inCD;

  Ability(String n, int c, boolean i, float dur, float cd, PImage img) {
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
    
    
  }
}
