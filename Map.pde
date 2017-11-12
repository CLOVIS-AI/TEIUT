import processing.core.*;


//**************************************************************************************************************************************************************************************



class Map {
  //Map & floors
  private ArrayList<Floors> map;
  class Floors{
    private Floor floor;
    private int[] link;
    private int lifeTime;
    Floors(int sizeX, int sizeY, Map map, int lvl){
      link = new int[]{(int)random(sizeX), (int)random(sizeY)};
      floor = new Floor(sizeX, sizeY, map, link, lvl);
    }
    Floor getFloor(){ return floor; }
    int[] getLink(){ return link; }
    void refresh(){ lifeTime++; }
  }
  private int currentFloor = 0;

  //Size
  private final int sizeX = 30;
  private final int sizeY = 30;

  Map() {
    map = new ArrayList<Floors>();
    newFloor();
    getAsString();
  }
  
  private void newFloor(){
    map.add(getNewFloor());
  }
  
  private Floors getNewFloor(){
    chat.msg("Generation of floor "+currentFloor);
    return new Floors(sizeX, sizeY, this, currentFloor);
  }
  
  Floor getPreviousFloor(Floor F) throws IndexOutOfBoundsException {
    return map.get(map.indexOf(F)-1).getFloor();
  }
  
  void sendPlayer(){
    currentFloor++;
    if(currentFloor >= map.size()){
      newFloor();
    }
  }
  
  void fallPlayer(){
    if(currentFloor == 0)
      return;
    currentFloor--;
    if(map.get(currentFloor) == null)
      map.set(currentFloor, getNewFloor());
  }
  
  String getAsString(){
    String result = "MAP : \n";
    for(int i = 0; i < map.size(); i++){
      result += "FLOOR #"+i+"\n"+map.get(i).getFloor().getAsString()+"\n";
    }
    println(result);
    return result;
  }
  
  void paint(float xMin, float yMin, float xMax, float yMax){
    textSize(20);
    fill(255);
    text(Trans.get("Floor")+" "+currentFloor, xMin, yMin);
    map.get(currentFloor).getFloor().paint(xMin, yMin, xMax, yMax);
  }
  
  void newMob(Mob mob, int x, int y){
    map.get(currentFloor).getFloor().newMob(mob, x, y);
  }
  
  void refresh(){
    map.get(currentFloor).getFloor().refresh();
    for(int i = 0; i < map.size(); i++){
      if(i != currentFloor)
        map.get(i).refresh();
    }
  }
  
  void moveLeft(){  map.get(currentFloor).getFloor().moveLeft();  }
  void moveRight(){  map.get(currentFloor).getFloor().moveRight();  }
  void moveUp(){  map.get(currentFloor).getFloor().moveUp();  }
  void moveDown(){  map.get(currentFloor).getFloor().moveDown();  }
  void attackLeft(){  map.get(currentFloor).getFloor().attackLeft();  }
  void attackRight(){  map.get(currentFloor).getFloor().attackRight();  }
}



//**************************************************************************************************************************************************************************************



class Floor{
  
  private Map map;
  
  private Terrain[][] floor;
  private int lastMove;
  private int[] link;
  private int level;
  private ArrayList<EntityM> entity;
  class EntityM{
    Mob entity;
    int x; int y; int lastMove;
    EntityM(Mob entity, int x, int y){
      this.entity = entity; this.x = x; this.y = y; lastMove = 0;
    }
  }
  private ArrayList<Chest> chests;
  class Chest{
    Inventory items; int x; int y;
    Chest(int level, int x, int y){
      items = new Inventory(level);
      this.x = x;
      this.y = y;
    }
  }
  
  private final int sizeX;
  private final int sizeY;
  
  Floor(int sizeX, int sizeY, Map map, int[] link, int level){
    this.level = level;
    lastMove = 0;
    this.sizeX = sizeX;
    this.sizeY = sizeY;
    this.map = map;
    entity = new ArrayList<EntityM>();
    chests = new ArrayList<Chest>();
    this.link = link;
    
    //Generating an empty floor
    floor = new Terrain[sizeX][sizeY];
    println("[Floor] Generating a new floor :");
    for(int i = 0; i < sizeX; i++){
      for(int j = 0; j < sizeY; j++){
        floor[i][j] = Terrain.EMPTY;
        //println("[Floor] [" + i + "] [" + j + "] "+floor[i][j]);
      }
    }
    //For now
    for(int i = 0; i < 20; i++){
      floor[(int)random(sizeX)][(int)random(sizeY)] = Terrain.WALL;
      floor[(int)random(sizeX)][(int)random(sizeY)] = Terrain.HOLE;
    }
    
    //map.getPreviousFloor(this);
    setWall(0, 0, sizeX-1, sizeY-1);
    //paint(0, 0, 100, 100);
    
    floor[link[0]][link[1]] = Terrain.TELEPORT;
    
    for(int i = 0; i < 20; i++){
      newMob(new Mob(100, 0, 5, 10, "A mob"+i, Classe.WIZARD, this), (int)random(sizeX), (int)random(sizeY));
      newChest((int)random(sizeX), (int)random(sizeY));
    }
  }
  
  String getAsString(){
    String result = "";
    for(int i = 0; i < sizeX; i++){
      for(int j = 0; j < sizeY; j++){
        //println("Case ["+i+"] ["+j+"] : "+this.floor[j][i]);
        Terrain current = floor[j][i];
        if(current == Terrain.WALL)    result += "X";
        if(current == Terrain.EMPTY)   result += ".";
        if(current == Terrain.HOLE)    result += " ";
        
        if(j == xPlayer && i == yPlayer){
          result += "O";
        } else{
          result += " ";
        }
      }
      result += "\n";
    }
    return result;
  }
  
  private void setWall(final int leftUpX, final int leftUpY, final int rightDownX, final int rightDownY){
    {  //Up line
      int y = leftUpY;
      for(int x = leftUpX; x <= rightDownX; x++){
        floor[x][y] = Terrain.WALL;
      }
    }
    {  //Right column
      int x = rightDownX;
      for(int y = leftUpY; y <= rightDownY; y++){
        floor[x][y] = Terrain.WALL;
      }
    }
    {  //Down line
      int y = rightDownY;
      for(int x = rightDownX; x >= leftUpX; x--){
        floor[x][y] = Terrain.WALL;
      }
    }
    {  //Left column
      int x = leftUpX;
      for(int y = rightDownY; y >= leftUpY; y--){
        floor[x][y] = Terrain.WALL;
      }
    }
  }
  
  void paint(float xMin, float yMin, float xMax, float yMax){
    //ArrayIndexOutOfBoundsException
    //println("Requested to paint");
    if(player == null)    return;
    
    float largeur = (xMax-xMin)/displayTilesSize;
    //println("Largeur : "+largeur);
    
    textSize(15);
    for(int i = -displayTilesSize/2; i < displayTilesSize/2+1; i++){
      for(int j = -displayTilesSize/2; j < displayTilesSize/2+1; j++){
        
        PImage currentPic = textures.getDefault();
        try{
          Terrain current = floor[xPlayer+j][yPlayer+i];
          if(current == Terrain.EMPTY)    currentPic = textures.getGround();
          if(current == Terrain.WALL)     currentPic = textures.getWall();
          if(current == Terrain.HOLE)     currentPic = textures.getHole();
          if(current == Terrain.TELEPORT) currentPic = textures.getTeleport();
          
          if(i == 0 && j == 0){
            currentPic = textures.getWarrior(lastMove);
          }
          
          image(currentPic, xMin+(largeur*(j+displayTilesSize/2)), yMin+(largeur*(i+displayTilesSize/2)), largeur, largeur);
          for(int k = 0; k < entity.size(); k++){
            if(entity.get(k).x == xPlayer+j && entity.get(k).y == yPlayer+i){
              int level = entity.get(k).entity.getLevel();
              int levelP = player.getLevel();
              fill(255);
              if(levelP > level)  fill(0, 255, 0);
              if(levelP < level)  fill(255, 0, 0);
              textSize(10);
              image(textures.getWarrior(entity.get(k).lastMove), xMin+(largeur*(j+displayTilesSize/2)), yMin+(largeur*(i+displayTilesSize/2)), largeur, largeur);
              text(level, xMin+(largeur*(j+displayTilesSize/2))+largeur/2, yMin+(largeur*(i+displayTilesSize/2))+largeur/2);
              break;
            }
          }
          for(int k = 0; k < chests.size(); k++){
            if(chests.get(k).x == xPlayer+j && chests.get(k).y == yPlayer+i){
              image(textures.getChest(), xMin+(largeur*(j+displayTilesSize/2)), yMin+(largeur*(i+displayTilesSize/2)), largeur, largeur);
            }
          }
        } catch(ArrayIndexOutOfBoundsException e){}
      }
    }
  }
  
  void newMob(Mob mob, int x, int y){
    entity.add(new EntityM(mob, x, y));
    lastHit = entity.get(0).entity;
  }
  
  void newChest(int x, int y){
    chests.add(new Chest(level, x, y));
    floor[x][y] = Terrain.WALL;
  }
  
  void refresh(){
    if(link[0] == xPlayer && link[1] == yPlayer)
      map.sendPlayer();
    if(floor[xPlayer][yPlayer] == Terrain.HOLE)
      map.fallPlayer();
    for(int i = 0; i < entity.size(); i++){
      if(!entity.get(i).entity.isDead()){
        entity.get(i).entity.move();
      } else{
        entity.remove(i);
        return;
      }
    }
  }
  
  private boolean canGoTo(int x, int y){
    if(xPlayer == x && yPlayer == y)
      return false;
    for(int i = 0; i < entity.size(); i++){
      if(entity.get(i).x == x && entity.get(i).y == y)
        return false;
    }
    return true;
  }
  
  void moveLeft(){   try{if(floor[xPlayer-1][yPlayer] != Terrain.WALL && canGoTo(xPlayer-1, yPlayer))  xPlayer--;  lastMove = 3;  } catch(ArrayIndexOutOfBoundsException e){}  }
  void moveRight(){  try{if(floor[xPlayer+1][yPlayer] != Terrain.WALL && canGoTo(xPlayer+1, yPlayer))  xPlayer++;  lastMove = 1;  } catch(ArrayIndexOutOfBoundsException e){}  }
  void moveUp(){     try{if(floor[xPlayer][yPlayer-1] != Terrain.WALL && canGoTo(xPlayer, yPlayer-1))  yPlayer--;  lastMove = 0;  } catch(ArrayIndexOutOfBoundsException e){}  }
  void moveDown(){   try{if(floor[xPlayer][yPlayer+1] != Terrain.WALL && canGoTo(xPlayer, yPlayer+1))  yPlayer++;  lastMove = 2;  } catch(ArrayIndexOutOfBoundsException e){}  }
  void attackLeft(){    int[] coords = getAttack(xPlayer, yPlayer, lastMove); damage(coords[0], coords[1], player.getDamageLeft(), player);}
  void attackRight(){   int[] coords = getAttack(xPlayer, yPlayer, lastMove); damage(coords[0], coords[1], player.getDamageRight(), player);}
  
  private void damage(int x, int y, int value, AliveEntity mob){
    println("Hit at : "+x+";"+y+" ... "+value);
    for(int i = 0; i < entity.size(); i++){
      if(entity.get(i).x == x && entity.get(i).y == y){
        entity.get(i).entity.damage(mob, value);
        lastHit = entity.get(i).entity;
        displayMob = true;
        println("Hit achieved ! "+value);
      }
    }
    for(int i = 0; i < chests.size(); i++){
      if(chests.get(i).x == x && chests.get(i).y == y){
        displayMob = false;
        lastChest = chests.get(i).items;
      }
    }
  }
  
  int[] getAttack(int x, int y, int lastMove){
    int[] coords;
    switch(lastMove){
      case 0:
        coords = new int[]{x, y-1};
        break;
      case 1:
        coords = new int[]{x+1, y};
        break;
      case 2:
        coords = new int[]{x, y+1};
        break;
      case 3:
        coords = new int[]{x-1, y};
        break;
      default:
        coords = new int[]{0, 0};
    }
    return coords;
  }
  
  int getPlayerX(){  return xPlayer; }
  int getPlayerY(){  return yPlayer; }
  
  void moveEntity(AliveEntity entity, int direction){
    for(int i = 0; i < this.entity.size(); i++){
      if(this.entity.get(i).entity == entity){
        EntityM current = this.entity.get(i);
        switch(direction){
          case 0:  try{if(floor[current.x][current.y-1] != Terrain.WALL && canGoTo(current.x, current.y-1))  current.y--;  current.lastMove = 0;  } catch(ArrayIndexOutOfBoundsException e){}       if(floor[current.x][current.y] == Terrain.HOLE) current.entity.damage(null, Integer.MAX_VALUE); break;
          case 1:  try{if(floor[current.x+1][current.y] != Terrain.WALL && canGoTo(current.x+1, current.y))  current.x++;  current.lastMove = 1;  } catch(ArrayIndexOutOfBoundsException e){}       if(floor[current.x][current.y] == Terrain.HOLE) current.entity.damage(null, Integer.MAX_VALUE); break;
          case 2:  try{if(floor[current.x][current.y+1] != Terrain.WALL && canGoTo(current.x, current.y+1))  current.y++;  current.lastMove = 2;  } catch(ArrayIndexOutOfBoundsException e){}       if(floor[current.x][current.y] == Terrain.HOLE) current.entity.damage(null, Integer.MAX_VALUE); break;
          case 3:  try{if(floor[current.x-1][current.y] != Terrain.WALL && canGoTo(current.x-1, current.y))  current.x--;  current.lastMove = 3;  } catch(ArrayIndexOutOfBoundsException e){}       if(floor[current.x][current.y] == Terrain.HOLE) current.entity.damage(null, Integer.MAX_VALUE); break;
          default: println("Floor.moveEntity() \t the parameter direction ("+direction+") should only be equal to : 0 | 1 | 2 | 3");
        }
        return;
      }
    }
  }
}






/*

Floors        Floor n
                        link 1
              Floor 1
                        link 0
              Floor 0








*/