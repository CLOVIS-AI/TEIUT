

interface Drawable{
  void paintStatus(int x1, int y1, int x2, int y2);
}



class AliveEntity implements Drawable{
  private int health;
  private int maxHealth;
  private int xp;
  private int xpNeed;
  private int defense;
  private int defenseBonus;
  private int strength;
  private int strengthBonus;
  private int mana;
  private int maxMana;
  private int level;
  private ArrayList<Effect> effects;
  private color colour;
  private String name;
  private Classe classe;
  private Inventory inventory;
  private AliveEntity lastHit;
  
  private Floor floor;
  
  AliveEntity(int maxHealth, int defense, int maxMana, int strength, String name, Classe classe){
    this.maxHealth = maxHealth;
    this.health = maxHealth;
    this.defense = defense;
    this.defenseBonus = 0;
    this.mana = maxMana;
    this.maxMana = maxMana;
    this.strength = strength;
    this.strengthBonus = 0;
    this.name = name;
    this.classe = classe;
    this.lastHit = null;
    effects = new ArrayList<Effect>(50);
    xp = 0;
    xpNeed = 1;
    level = 0;
    colour = color(int(random(0, 255)), int(random(0, 255)), int(random(0, 255)));
    inventory = new Inventory(level);
  }
  
  void paintStatus(int x1, int y1, int x2, int y2){
    if(health > maxHealth) health = maxHealth;
    if(health < 0) health = 0;
    if(mana > maxMana) mana = maxMana;
    if(mana < 0) mana = 0;
    
    int largeur = x2-x1;
    fill(10);
    rect(x1, y1+5, largeur, y2);
    
    image(textures.getWarrior(), x1, y1+5, largeur/3, largeur/3);
    
    fill(colour);
    textSize(35);
    text(name, x1+largeur/3+10, y1+35);
    fill(255);
    textSize(20);
    text(Trans.get(getClasseAsString(classe)) + " " + Trans.get("lvl") + " " + level, x1+largeur/3+10, y1+(largeur/3)/2+15);
    paintBar(x1+largeur/3, y1+largeur/3-5, 2*(largeur/3), xp, xpNeed, Trans.get("XP"), false);
    
    int cursor = y1+largeur/3;
    paintBar(x1, cursor+=30, largeur, health, maxHealth, Trans.get("Health"), true);
    paintBar(x1, cursor+=35, largeur, mana, maxMana, Trans.get("Mana"), true);
    
    fill(255);
    text(Trans.get("Strength")+" : "+strength+" "+strengthBonus, x1+5, cursor+=35);
    text(Trans.get("Defense")+" : "+defense+" "+defenseBonus, x1+5, cursor+=25);
  }
  
  void paintInventory(int x1, int y1, int x2, int y2){
    inventory.paintStatus(x1, y1, x2, y2, mana);
  }
  
  private void paintBar(int x1, int y1, int longueur, float value, float valueMax, String name, boolean is0){
    //Tests
    if(xp >= xpNeed)  levelUp();
    
    //Affichage
    fill(20);
    if(value <= 0){
      value = 0;
      if(random(5) < 1 && is0)  fill(200+random(50)-25, 0, 0);
      if(random(100) < 1 && is0)fill(random(255), random(255), random(255));
    }
    rect(x1, y1, longueur, 10);
    textSize(12);
    float rapport = value/valueMax;
    fill(270-rapport*500, rapport*500, rapport*255);
    rect(x1, y1, rapport*longueur, 10);
    
    fill(255);
    text(name+" : "+(int)value+" / "+(int)valueMax, x1+5, y1);
  }
  
  void paintEffects(int x1, int y1, int x2){
    textSize(12);
    fill(100);
    rect(x1, y1, 60, 40);
    fill(200);
    text(Trans.get("Effects")+" :", x1+8, y1+25);
    int cursor = x1+20;
    for(int i = 0; i < effects.size(); i++){
      effects.get(i).paint(cursor+=50, y1);
    }
  }
  
  void refresh(){
    if(random(50) < 1)
      xp++;
    mana++;
    if(defenseBonus > 0 && random(2) < 1) defenseBonus-=float(defenseBonus)/10;
    if(defenseBonus < 0 && random(2) < 1) defenseBonus+=float(defenseBonus)/10;
    if(strengthBonus > 0 && random(2) < 1) strengthBonus-=float(strengthBonus)/10;
    if(strengthBonus < 0 && random(2) < 1) strengthBonus+=float(strengthBonus)/10;
    if(mana >= maxMana)    health+=5;
    if(health >= maxHealth && random(10) < 1)  xp++;
    for(int i = 0; i < effects.size() && i < 8; i++){
      int power = effects.get(i).getPower();
      Effects effect = effects.get(i).getEffect();
      if(effect == Effects.POISON)          damage(power);
      if(effect == Effects.REGEN)           health+=power;
      if(effect == Effects.WEAKNESS)        strengthBonus-=power;
      if(effect == Effects.STRENGTH)        strengthBonus+=power;
      if(effect == Effects.DEF_LESS)        defenseBonus-=power;
      if(effect == Effects.DEF_MORE)        defenseBonus+=power;
      if(effect == Effects.EXHAUST)         mana-=power+1;
      if(effect == Effects.POWER)           mana+=power;
      
      if(!effects.get(i).refresh()){
        effects.remove(i);
        break;
      }
    }
    inventory.refresh();
  }
  
  void damage(int power){
    int degats = power-(defense+inventory.getDefense());
    inventory.useArmor();
    if(degats < 0){
      degats = 0;
      chat.warn("Attack blocked...");
    }
    health -= degats;
    if(health < 0)  health = 0;
    xp+=int(float(degats)/10.0);
  }
  
  void damage(AliveEntity entity, int power){
    damage(power);
    lastHit = entity;
  }
  
  void damage(AliveEntity entity, int power, Effect effect){
    damage(entity, power);
    effects.add(effect);
  }
  
  private void levelUp(){
    chat.levelUp("-"+name+" : LEVEL UP ! "+(level+1));
    //xp-=xpNeed;
    xpNeed+=pow(xpNeed, 2)+1;
    level++;
    if(classe == Classe.WARRIOR){  strength+=025.0/100.0*strength+1;      maxHealth+=110.0/100.0*maxHealth+1;      defense+=110.0/100.0*defense+1;      maxMana+=210.0/100.0*maxMana+1;}
    if(classe == Classe.TANK){     strength+=010.0/100.0*strength+1;      maxHealth+=120.0/100.0*maxHealth+1;      defense+=120.0/100.0*defense+1;      maxMana+=210.0/100.0*maxMana+1;}
    if(classe == Classe.WIZARD){   strength+=010.0/100.0*strength+1;      maxHealth+=110.0/100.0*maxHealth+1;      defense+=110.0/100.0*defense+1;      maxMana+=300.0/100.0*maxMana+1;}
    health+=25.0/100.0*maxHealth;
    mana = maxMana;
  }
  
  private boolean canLoose(int manaC){
    if(mana-manaC >= 0){
      mana-=manaC;
      return true;
    } else{
      chat.warn("Low on mana !");
      return false;
    }
  }
  
  void addXp(int value){
    xp+=value;
  }
  
  String getName(){  return name;  }
  color getColor(){  return colour;  }
  Floor getFloor(){  return floor;  }
  int getDamageLeft(){if(canLoose(inventory.getCostLeft()))  return inventory.getDamageLeft()+int(strength/10.0+1); return strength;}
  int getDamageRight(){if(canLoose(inventory.getCostRight()))  return inventory.getDamageRight()+int(strength/10.0+1); return strength;}
  boolean isDead(){if(lastHit == null && health <= 0){chat.msg(name+" ("+level+") died");} else{if(health <= 0){ lastHit.addXp(maxHealth*(level+1)); chat.msg(name+" ("+level+") was killed by "+lastHit.getName()+" ("+lastHit.getLevel()+")");}} return (health <= 0) ? true : false;}
  int getLevel(){return level; }
  Inventory getInventory(){ return inventory; }
}