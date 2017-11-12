/*
  THE END IS UP THERE
 
 Project created by CLOVIS.
 Coded by CLOVIS.
 
 In a partnership with the FFFFF :
 CLOVIS [FFFFF #0]
 
 
 */

import processing.core.*;

/*
Idées :
 
 Map : 40x40
 On peut monter et descendre, les étages se génèrent aléatoirement
 
 
 */


final boolean isFullScreen = false;
int largeur = 1200;
int hauteur = 650;

//If you choose an EVEN number of tiles, it will display an ODD number, which is your_number+1
final int displayTilesSize = 10;
final int numberOfEffectsMax = 5;
int tickSpeed = 10;
int langue = 0; //See more about languages in the Trans class

final String version = "Alpha 0.4.0";


void settings() {
  if (isFullScreen) {
    fullScreen();
    largeur = width;
    hauteur = height;
  } else {
    size(largeur, hauteur);
  }
}


Map map;
char[] keys;

final String path = new File("Projects/TEIUT").getAbsolutePath();
final String dataPath = path + "/data";
int compteur = 0;
String pak = "/default_pak";

Player player;
int xPlayer;
int yPlayer;
AliveEntity lastHit;
Inventory lastChest;
boolean displayMob = true;
Textures textures;
Chat chat;

void setup() {
  surface.setTitle("The end is up there" + " \t | \t Version " + version + " \t | \t Created by CLOVIS");
  chat = new Chat();
  chat.msg("Loading game...");

  keys = new char[]{'e', 'd', 's', 'f', 'j', 'l'};
  
  Trans.generate(langue);
  textures = new Textures();
  
  map = new Map();
  player = new Player(100, 0, 2, 3, "CLOVIS", Classe.WARRIOR);
  xPlayer = 5;
  yPlayer = 5;
  //lastHit = player.lastHit;

  println("Loading in... \t" + dataPath + "\tSuccess : " + new File(dataPath).exists());
  //println(map.getAsString());
  
}


void draw() {
  background(0);
  textSize(12);
  fill(255);
  text(Trans.get("English"), 10, 15);
  textSize(56);
  text(Trans.get("The End is up There"), 100, 50);

  map.paint(largeur/2-(3*hauteur)/8, (24*hauteur)/175, largeur/2+(3*hauteur)/8-35, 0);
  player.paintEffects(largeur/2-(3*hauteur)/8, hauteur-(24*hauteur)/175/2-10, largeur/2+(3*hauteur)/8-35);
  player.paintStatus(25, 50, largeur/2-275, (hauteur-150)/2);
  player.paintInventory(25, hauteur/2, largeur/2-275, hauteur-10);
  if(displayMob){
    lastHit.paintStatus(largeur/2+275, 50, largeur-25, (hauteur-150)/2);
    chat.paint(largeur/2+275, hauteur/2);
  }
  if(!displayMob){
    lastChest.paintStatus(largeur/2+275, 50, largeur-25, (hauteur+100)/2, player.getInventory());
    chat.paint(largeur/2+275, (hauteur+150)/2);
  }
  
  compteur++;
  if(compteur >= tickSpeed){
    compteur-= tickSpeed;
    refresh();
  }
}


void refresh(){
  map.refresh();
  player.refresh();
}


void keyPressed() {
  if (key == keys[0])    map.moveUp();
  if (key == keys[1])    map.moveDown();
  if (key == keys[2])    map.moveLeft();
  if (key == keys[3])    map.moveRight();
  if (key == keys[4])    map.attackLeft();
  if (key == keys[5])    map.attackRight();
  if (key == '+')        Trans.swap();
  if (key == '-')        Trans.unswap();
  if (key == '1' || key == '2' || key == '3' || key == '4' || key == '5' || key == '6' || key == '7' || key == '8' || key == '9')  lastChest.swapItem(key);
  if (key == '0')        player.getInventory().swapHands();
}