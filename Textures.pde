class Textures{
  
  private PImage defaultP;
  private PImage wall;
  private PImage ground;
  private PImage hole;
  private PImage chest;
  private PImage teleport;
  private PImage warrior;
  private PImage warrior0;
  private PImage warrior1;
  private PImage warrior2;
  private PImage warrior3;
  private PImage poison;
  private PImage regen;
  private PImage weakness;
  private PImage strength;
  private PImage exhaust;
  private PImage power;
  private PImage defLess;
  private PImage defMore;
  
  private PFont font;
  
  Textures(){
    String path = dataPath+"/paks"+pak+"/";
    //Font
    font =         loadFont(path+ "/font.vlw");
    textFont(font, 100);
    
    //Default
    defaultP =     loadImage(path+  "default.png"      );
    
    //Sprites Map
    wall =         loadImage(path+  "map/wall.png"         );
    ground =       loadImage(path+  "map/ground.png"       );
    hole =         loadImage(path+  "map/hole.png"         );
    chest =        loadImage(path+  "map/chest.png"        );
    teleport =     loadImage(path+  "map/teleport.png"     );
    
    //Sprites Entities
    warrior0 =     loadImage(path+  "entities/warrior_0.png"    );
    warrior1 =     loadImage(path+  "entities/warrior_1.png"    );
    warrior2 =     loadImage(path+  "entities/warrior_2.png"    );
    warrior3 =     loadImage(path+  "entities/warrior_3.png"    );
    
    //Avatars
    warrior =      loadImage(path+  "avatars/warrior.png"       );
    
    //Effects
    poison =       loadImage(path+  "effects/poison.png"        );
    regen =        loadImage(path+  "effects/regen.png"         );
    exhaust =      loadImage(path+  "effects/exhaust.png"       );
    power =        loadImage(path+  "effects/power.png"         );
    weakness =     loadImage(path+  "effects/weakness.png"      );
    strength =     loadImage(path+  "effects/strength.png"      );
    defLess =      loadImage(path+  "effects/defLess.png"       );
    defMore =      loadImage(path+  "effects/defMore.png"       );
  }
  
  PImage getDefault(){  return defaultP;  }
  PImage getWall(){     return wall;  }
  PImage getGround(){   return ground;  }
  PImage getHole(){     return hole;  }
  PImage getChest(){    return chest;  }
  PImage getTeleport(){ return teleport;  }
  PImage getWarrior(){  return warrior;  }
  
  PImage getWarrior(int orientation){
    switch(orientation){
      case 0:
        return warrior0;
      case 1:
        return warrior1;
      case 2:
        return warrior2;
      case 3:
        return warrior3;
      default:
        return defaultP;
    }
  }
  
  PImage getEffect(Effects effect){
    if(effect == Effects.POISON){ return poison; }
    else if(effect == Effects.REGEN){  return regen; }
    else if(effect == Effects.EXHAUST){  return exhaust;  }
    else if(effect == Effects.POWER){  return power;  }
    else if(effect == Effects.WEAKNESS){  return weakness;  }
    else if(effect == Effects.STRENGTH){  return strength;  }
    else if(effect == Effects.DEF_LESS){  return defLess;  }
    else if(effect == Effects.DEF_MORE){  return defMore;  }
    else{ return defaultP;  } 
  }
}