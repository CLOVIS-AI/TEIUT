import processing.core.*;


abstract class Armor extends Item{
  
  Armor(int durability, int level){
    super(null, durability, level);
  }
  
  Armor(int lvl){
    super(lvl);
    int level = super.getRarity();
    super.setLevel(level);
    int durability = (int)random((level*100)-random(level/10))*100;
    super.setMaxDurability(durability);
    super.setDurability((int)(durability-random(durability)));
    super.setManaCost((int)(random(0, level/10)));
  }
  
  void setLevel(int lvl){super.setLevel(lvl);}
  void setDurability(int dur){super.setDurability(dur);}
  void setMaxDurability(int dur){super.setMaxDurability(dur);}
  void setTexture(PImage text){super.setTexture(text);}
  int getRarity(){return super.getRarity();}
  void setManaCost(int mana){super.setManaCost(mana);}
  
  void paint2(float x, float y, float largeur){
    
  }
}










class Helmet extends Armor{
  
  Helmet(int lvl){
    super(lvl);
    setName("Helmet");
  }
}






class Chest extends Armor{
  
  Chest(int lvl){
    super(lvl);
    setName("Chest");
  }
}






class Legs extends Armor{
  
  Legs(int lvl){
    super(lvl);
    setName("Legs");
  }
}





class Foot extends Armor{
  
  Foot(int lvl){
    super(lvl);
    setName("Foot");
  }
}



class Hands extends Armor{
  
  Hands(int lvl){
    super(lvl);
    setName("Hands");
  }
}