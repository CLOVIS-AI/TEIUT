class Mob extends AliveEntity{
  
  
  private Floor floor;
  
  Mob(int maxHealth, int defense, int maxMana, int strength, String name, Classe classe, Floor floor){
    super(maxHealth, defense, maxMana, strength, name, classe);
    this.floor = floor;
  }
  
  void move(){
    floor.moveEntity(this, int(random(0, 3)));
  }
  
}