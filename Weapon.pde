import processing.core.*;


abstract class Weapon extends Item{
  private int maxAttack;
  private boolean dualWielding;
  
  Weapon(int durability, int level){
    super(null, durability, level);
  }
  
  Weapon(int lvl){
    super(lvl);
  }
  
  void paint2(float x, float y, float largeur){
    fill(255);
    textSize(12);
    text(maxAttack, x+5, y+24);
  }
  
  void setLevel(int lvl){super.setLevel(lvl);}
  void setDurability(int dur){super.setDurability(dur);}
  void setMaxDurability(int dur){super.setMaxDurability(dur);}
  void setTexture(PImage text){super.setTexture(text);}
  int getRarity(){return super.getRarity();}
  void setManaCost(int mana){super.setManaCost(mana);}
  void setMaxAttack(int pow){maxAttack = pow;}
  int getCritical(){return maxAttack;}
  void setDualWielding(boolean d){dualWielding = d;}
  boolean allowTwoWeapons(){return dualWielding;}
}


class Axe extends Weapon{
  
  Axe(int lvl){
    super(lvl);
    int rarity = super.getRarity();
    int level = int(rarity*random(10, 50));
    super.setLevel(level);
    super.setManaCost(int(level/random(1, 5)));
    int durability = (int)random((rarity*100)-random(rarity/10));
    super.setMaxDurability(durability);
    super.setDurability((int)(durability-random(durability)));
    setMaxAttack(int(level*random(200)));
    setDualWielding(false);
    setName("Axe");
  }
  
}

class Sword extends Weapon{
  
  Sword(int lvl){
    super(lvl);
    int rarity = super.getRarity();
    int level = int(rarity*random(1, 20));
    super.setLevel(level);
    super.setManaCost(int(level/random(1, 2.5)));
    int durability = (int)random((rarity*100)-random(rarity/10));
    super.setMaxDurability(durability);
    super.setDurability((int)(durability-random(durability)));
    setMaxAttack(int(level*random(100)));
    setDualWielding(true);
    setName("Sword");
  }
  
}

class Rapier extends Weapon{
  
  Rapier(int lvl){
    super(lvl);
    int rarity = super.getRarity();
    int level = int(rarity*random(1, 2));
    super.setLevel(level);
    super.setManaCost(int(level/random(1, 1.25)));
    int durability = (int)random((rarity*100)-random(rarity/10));
    super.setMaxDurability(durability);
    super.setDurability((int)(durability-random(durability)));
    setMaxAttack(int(level*random(50)));
    setDualWielding(true);
    setName("Rapier");
  }
  
}









class Projectile extends Item{
  
  Projectile(int durability, int level){
    super(null, durability, level);
  }
  
  void paint2(float x, float y, float largeur){
    
  }
}














class Spell extends Item{
  
  Spell(int durability, int level){
    super(null, durability, level);
  }
  
  void paint2(float x, float y, float largeur){
    
  }
}