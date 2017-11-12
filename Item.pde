import processing.core.*;


abstract class Item{
  private PImage texture;
  private int durability;
  private int maxDurability;
  private int level;
  private int manaCost;
  private String name = "";
  
  private int rarity;
  
  Item(PImage image, int durabilityMax, int level){
    texture = image;
    maxDurability = durabilityMax;
    durability = maxDurability;
    this.level = level;
    rarity = 0;
    name = "";
  }
  
  Item(int level){
    rarity = int(random(1, level+(5/100*level)));
    name = "";
  }
  
  void setLevel(int lvl){level = lvl;}
  void setDurability(int dur){durability = dur; if(durability < 1) durability = 1; if(durability > maxDurability) durability = maxDurability;}
  void setMaxDurability(int dur){maxDurability = dur; if(maxDurability < 1) maxDurability = 1;}
  void setTexture(PImage text){texture = text;}
  void setManaCost(int mana){manaCost = mana;}
  int getManaCost(){return manaCost;}
  int getRarity(){return rarity;}
  
  void paint(float x, float y, float largeur, int mana){
    fill(0);
    if(texture != null){
      image(texture, x, y, largeur, largeur);
    } else{rect(x, y, largeur, largeur);}
    textSize(12);
    
    //Durability bar
    float rapport = float(durability)/float(maxDurability);
    fill(270-rapport*500, rapport*500, rapport*255);
    rect(x, y+largeur-5, rapport*largeur, 5);
    String durabilite = str(durability);
    if(durability < 1000 && maxDurability < 1000) durabilite+=" / "+maxDurability;
    text(durabilite, x+5, y+largeur-5);
    
    //Level
    fill(255);
    text(level, x+5, y+12);
    
    //Mana
    if(mana < manaCost){
      fill(255, 0, 0);
    } else{
      fill(0, 255, 0);
    }
    text(manaCost, x+largeur-15, y+12);
    
    paint2(x, y, largeur);
  }
  abstract void paint2(float x, float y, float largeur);
  
  int getLevel(){  return level;  }
  
  boolean isDead(){  if(durability == 0) return true; return false;}
  void used(){ durability--; if(durability < 0) durability = 0;}
  
  void levelUp(){
    durability+=25.0/100.0*durability;
  }
  
  String getName(){  return name;  }
  void setName(String value){ name = value;  }
  
  int getValue(){
    return (int)((level*100)*(float(durability)/float(maxDurability)+maxDurability)/float(manaCost+1));
  }
}


/*
Calculation of rarity




*/






class Inventory implements Drawable{
  private Spell spell;            //1
  private Helmet head;            //2
  private Projectile projectile;  //3
  private Weapon mainWeapon;      //4
  private Chest chest;            //5
  private Weapon offWeapon;       //6
  private Hands hand;             //7
  private Legs legs;              //8
  private Foot foot;              //9
  
  private int defense;
  private int damageMain;
  private int damageOff;
  private int level;
  private float value;
  
  Inventory(int level){
    head = new Helmet(level);
    chest = new Chest(level);
    hand = new Hands(level);
    legs = new Legs(level);
    foot = new Foot(level);
    mainWeapon = new Rapier(level);
    offWeapon = new Sword(level);
    this.level = level;
  }
  
  void refresh(){
    defense = getLevel(head)+getLevel(chest)+getLevel(hand)+getLevel(legs)+getLevel(foot);
    damageMain = getLevel(mainWeapon)+25/100*getLevel(mainWeapon);
    damageOff = getLevel(offWeapon);
    value = (((spell == null)? 0 : spell.getValue()) +
            ((head == null)? 0 : head.getValue()) +
            ((projectile == null)? 0 : projectile.getValue()) +
            ((mainWeapon == null)? 0 : mainWeapon.getValue()) +
            ((chest == null)? 0 : chest.getValue()) +
            ((offWeapon == null)? 0 : offWeapon.getValue()*0.25) +
            ((hand == null)? 0 : hand.getValue()) +
            ((foot == null)? 0 : foot.getValue()) +
            ((legs == null)? 0 : legs.getValue())) / 1000000.0;
    level = getLevel(spell);
    if(getLevel(head) < level)  level = getLevel(head);
    if(getLevel(projectile) < level)  level = getLevel(projectile);
    if(getLevel(mainWeapon) < level)  level = getLevel(mainWeapon);
    if(getLevel(chest) < level)  level = getLevel(chest);
    if(getLevel(offWeapon) < level)  level = getLevel(offWeapon);
    if(getLevel(hand) < level)  level = getLevel(hand);
    if(getLevel(legs) < level)  level = getLevel(legs);
    if(getLevel(foot) < level)  level = getLevel(foot);
  }
  
  void paintStatus(int x1, int y1, int x2, int y2){
    paintStatus(x1, y1, x2, y2, 0);
    refresh();
  }
  
  void paintStatus(int x1, int y1, int x2, int y2, Inventory compare){
    paintStatus(x1, y1, x2, y2);
    textSize(35);
    x1+=45;
    float largeurCase = float((x2-x1)-50)/3;
    int test;
    int opac = 100;
    test = compareItems(compare.getSpell(), spell);            fill(test < 0 ? color(255, 0, 0, opac) : color(0, 255, 0, opac));  rect(x1, y2-3*largeurCase, largeurCase, largeurCase);
    test = compareItems(compare.getHelmet(), head);            fill(test < 0 ? color(255, 0, 0, opac) : color(0, 255, 0, opac));  rect(x1+largeurCase, y2-3*largeurCase, largeurCase, largeurCase);
    test = compareItems(compare.getProjectile(), projectile);  fill(test < 0 ? color(255, 0, 0, opac) : color(0, 255, 0, opac));  rect(x1+2*largeurCase, y2-3*largeurCase, largeurCase, largeurCase);
    test = compareItems(compare.getMainWeapon(), mainWeapon);  fill(test < 0 ? color(255, 0, 0, opac) : color(0, 255, 0, opac));  rect(x1, y2-2*largeurCase, largeurCase, largeurCase);
    test = compareItems(compare.getChest(), chest);            fill(test < 0 ? color(255, 0, 0, opac) : color(0, 255, 0, opac));  rect(x1+largeurCase, y2-2*largeurCase, largeurCase, largeurCase);
    test = compareItems(compare.getOffWeapon(), offWeapon);    fill(test < 0 ? color(255, 0, 0, opac) : color(0, 255, 0, opac));  rect(x1+2*largeurCase, y2-2*largeurCase, largeurCase, largeurCase);
    test = compareItems(compare.getHand(), hand);              fill(test < 0 ? color(255, 0, 0, opac) : color(0, 255, 0, opac));  rect(x1, y2-largeurCase, largeurCase, largeurCase);
    test = compareItems(compare.getLegs(), legs);              fill(test < 0 ? color(255, 0, 0, opac) : color(0, 255, 0, opac));  rect(x1+largeurCase, y2-largeurCase, largeurCase, largeurCase);
    test = compareItems(compare.getFoot(), foot);              fill(test < 0 ? color(255, 0, 0, opac) : color(0, 255, 0, opac));  rect(x1+2*largeurCase, y2-largeurCase, largeurCase, largeurCase);
  }
  
  private int compareItems(Item i, Item e){
    if(i == null && e == null)
      return 1;
    if(i == null)
      return 1;
    if(e == null)
      return -1;
    int result = i.getValue() - e.getValue();
    return result;
  }
  
  void paintStatus(int x1, int y1, int x2, int y2, int mana){
    if(checkIfDead(head))    head = null;
    if(checkIfDead(chest))   chest = null;
    if(checkIfDead(legs))    legs = null;
    if(checkIfDead(hand))    hand = null;
    if(checkIfDead(foot))    foot = null;
    if(checkIfDead(mainWeapon))    mainWeapon = null;
    if(checkIfDead(offWeapon))     offWeapon = null;
    if(checkIfDead(spell))   spell = null;
    if(checkIfDead(projectile))    projectile = null;
    
    int largeur = x2-x1;
    fill(10);
    rect(x1, y1+5, largeur, y2-y1);
    
    //Stats
    int cursor = y1+45;
    fill(255);
    text(Trans.get("Defense")+" : "+defense, x1+5, cursor+=15);
    text(Trans.get("Right hand")+" : "+damageMain, x1+5, cursor+=15);
    text(Trans.get("Estimated value")+" : "+value, x1+largeur/2, cursor);
    text(Trans.get("Left hand")+" : "+damageOff, x1+5, cursor+=15);
    
    //Name
    fill(255);
    textSize(35);
    text(Trans.get("Inventory")+" "+Trans.get("lvl")+" "+level, x1+10, y1+35);
    
    //All cases
    x1+=45;
    //x2-=25;
    float largeurCase = float((x2-x1)-50)/3;
    fill(20);
    paintItem(spell, x1, y2-3*largeurCase, largeurCase, mana);
    paintItem(head, x1+largeurCase, y2-3*largeurCase, largeurCase, mana);
    paintItem(projectile, x1+2*largeurCase, y2-3*largeurCase, largeurCase, mana);
    paintItem(mainWeapon, x1, y2-2*largeurCase, largeurCase, mana);
    paintItem(chest, x1+largeurCase, y2-2*largeurCase, largeurCase, mana);
    if((mainWeapon != null && mainWeapon.allowTwoWeapons()) || mainWeapon == null)
      paintItem(offWeapon, x1+2*largeurCase, y2-2*largeurCase, largeurCase, mana);
    paintItem(hand, x1, y2-largeurCase, largeurCase, mana);
    paintItem(legs, x1+largeurCase, y2-largeurCase, largeurCase, mana);
    paintItem(foot, x1+2*largeurCase, y2-largeurCase, largeurCase, mana);
  }
  
  private boolean checkIfDead(Item e){
    if(e != null && e.isDead()){
      chat.warn(e.getName()+" broke...");
      return true;
    }
    return false;
  }
  
  private void paintItem(Item item, float x, float y, float largeur, int mana){
    if(item == null){
      fill(255);
      rect(x, y, largeur, largeur);
    } else{
      item.paint(x, y, largeur, mana);
    }
  }
  
  private int getLevel(Item item){
    if(item != null) return item.getLevel();
    return 0;
  }
  
  int getDamageLeft(){
    if(mainWeapon != null){
      mainWeapon.used();
      int damage = (int)(mainWeapon.getLevel()*125.0/100.0);
      if(random(10)<1){ damage = mainWeapon.getCritical(); println(">CRITICAL !"); chat.err("Critical ! -"+damage);}
      return damage;
    } else{
      return 0;
    }
  }
  int getCostLeft(){
    if(mainWeapon != null)
      return mainWeapon.getManaCost();
    return 0;
  }
  
  int getDamageRight(){
    if(offWeapon != null && (mainWeapon != null && mainWeapon.allowTwoWeapons() || mainWeapon == null)){
      offWeapon.used();
      int damage = offWeapon.getLevel();
      if(random(10)<1){ damage = offWeapon.getCritical(); println(">CRITICAL !"); chat.err("Critical ! -"+damage);}
      return damage;
    } else{
      return 0;
    }
  }
  int getCostRight(){
    if(offWeapon != null && (mainWeapon != null && mainWeapon.allowTwoWeapons() || mainWeapon == null))
      return offWeapon.getManaCost();
    return 0;
  }
  
  void levelUp(){
    levelUp(chest);
    levelUp(head);
    levelUp(legs);
    levelUp(foot);
    levelUp(hand);
    levelUp(mainWeapon);
    levelUp(spell);
    levelUp(projectile);
  }
  
  private void levelUp(Item p){
    if(p != null)
      p.levelUp();
  }
  
  void useArmor(){
    chest.used();
    hand.used();
    legs.used();
    head.used();
    foot.used();
  }
  
  void swapItem(char a){
    switch(a){
      case '1': Hands i = player.getInventory().getHand();      player.getInventory().setHand(getHand());      setHand(i);      break;
      case '2': Legs i1 = player.getInventory().getLegs();       player.getInventory().setLegs(getLegs());      setLegs(i1);      break;
      case '3': Foot i2 = player.getInventory().getFoot();      player.getInventory().setFoot(getFoot());      setFoot(i2);      break;
      case '4': Weapon i3 = player.getInventory().getMainWeapon();      player.getInventory().setMainWeapon(getMainWeapon());      setMainWeapon(i3);      break;
      case '5': Chest i4 = player.getInventory().getChest();      player.getInventory().setChest(getChest());      setChest(i4);      break;
      case '6': Weapon i5 = player.getInventory().getOffWeapon();      player.getInventory().setOffWeapon(getOffWeapon());      setOffWeapon(i5);      break;
      case '7': Spell i6 = player.getInventory().getSpell();      player.getInventory().setSpell(getSpell());      setSpell(i6);      break;
      case '8': Helmet i7 = player.getInventory().getHelmet();      player.getInventory().setHelmet(getHelmet());      setHelmet(i7);      break;
      case '9': Projectile i8 = player.getInventory().getProjectile();      player.getInventory().setProjectile(getProjectile());      setProjectile(i8);      break;
    }
  }
  
  void swapHands(){
    if(mainWeapon != null && mainWeapon.allowTwoWeapons() || mainWeapon == null){
      Weapon i = mainWeapon;
      mainWeapon = offWeapon;
      offWeapon = i;
    }
  }
  
  int getDefense(){ return defense; }
  
  Hands getHand(){ return hand; }
  Legs getLegs(){ return legs; }
  Foot getFoot(){ return foot; }
  Weapon getMainWeapon(){ return mainWeapon; }
  Chest getChest(){ return chest; }
  Weapon getOffWeapon(){ return offWeapon; }
  Spell getSpell(){ return spell; }
  Helmet getHelmet(){ return head; }
  Projectile getProjectile(){ return projectile; }
  void setHand(Hands hand){ this.hand = hand; }
  void setLegs(Legs legs){ this.legs = legs; }
  void setFoot(Foot foot){ this.foot = foot; }
  void setMainWeapon(Weapon mainWeapon){ this.mainWeapon = mainWeapon; }
  void setChest(Chest chest){ this.chest = chest;}
  void setOffWeapon(Weapon offWeapon){ this.offWeapon = offWeapon; }
  void setSpell(Spell spell){ this.spell = spell;}
  void setHelmet(Helmet head){ this.head = head;}
  void setProjectile(Projectile projectile){ this.projectile = projectile;}
}




/*
FIELDS
  mana cost
  level
  durability/maxDurability

TYPE OF ITEMS

Armor
  Helmet
  Chest
  Legs
  Foot
  Hands

Projectile
  [stackable]
  Arrow
  Explosive
  LandMine
  Potion

Weapon                        MANA COST    LEVEL        HANDS NEEDED      RANGE
  Axe                         High         High         2                 Low
  Sword                       Medium       Medium       1                 Low
  Rapier                      Low          Low          1                 Low
  Bow                         Medium       Medium       2                 High
  Shield                      Low          Low          1                 Low

Spell


*/