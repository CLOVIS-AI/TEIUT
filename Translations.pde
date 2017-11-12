import processing.core.*;


/*
LANGUAGES ID
  0  ENGLISH
  1  FRENCH
  2  SWEDISH
*/

static class Trans{
  static private HashMap<String, String[]> strings;
  static private int language;
  
  static void generate(int langue){
    language = langue;
    strings = new HashMap<String, String[]>();
    //           ENGLISH                                               FRENCH                               SWEDISH                              SPANISH
    strings.put("English",                            new String[]{    "Français",                          "Svenska",                           "Español"});                         //Current language
    
    strings.put("Defense",                            new String[]{    "Défense",                           "Försvar",                           "Defensa"});
    strings.put("Defenseless",                        new String[]{    "Sans défenses",                     "Försvarslös",                       "Indefenso"});
    strings.put("Defense Gain",                       new String[]{    "Augmentation de défense",           "Försvarsförstärkning",              "Defenderse de nuevo"});
    strings.put("Effects",                            new String[]{    "Effets",                            "?",                                 "Efectos"});
    strings.put("Exhaustion",                         new String[]{    "Fatigue",                           "Utmattning",                        "Agotamiento"});
    strings.put("Floor",                              new String[]{    "Etage",                             "Våning",                            "Piso"});
    strings.put("Game Over",                          new String[]{    "Partie terminée",                   "Game Over",                         "Fin del Juego"});
    strings.put("Health",                             new String[]{    "Santé",                             "Styrka",                            "Salud"});
    strings.put("Inventory",                          new String[]{    "Inventaire",                        "?",                                 "Inventorio"});
    strings.put("Language",                           new String[]{    "Langue",                            "Språk",                             "Idioma"});
    strings.put("Left hand",                          new String[]{    "Main gauche",                       "?",                                 "?"});
    strings.put("lvl",                                new String[]{    "niv",                               "nivå",                              "nivel"});
    strings.put("Mana",                               new String[]{    "Mana",                              "Uthållighet",                       "Mana"});
    strings.put("Poison",                             new String[]{    "Poison",                            "Gift",                              "Veneno"});
    strings.put("Power",                              new String[]{    "Puisssance",                        "Kraft",                             "Energía"});
    strings.put("Ranger",                             new String[]{    "Ranger",                            "Soldat",                            "Explorador"});
    strings.put("Regeneration",                       new String[]{    "Régénération",                      "Pånyttfödelse",                     "Regeneración"});
    strings.put("Right hand",                         new String[]{    "Main droite",                       "?",                                 "?"});
    strings.put("Strength",                           new String[]{    "Force",                             "Hälsa",                             "Fuerza"});
    strings.put("Tank",                               new String[]{    "Tank",                              "Tank",                              "Tanque"});
    strings.put("The End is up There",                new String[]{    "La Fin est là-haut",                "Slutet är nära",                    "El fin está ahí arriba"});
    strings.put("Translation by CLOVIS",              new String[]{    "Traduction par CLOVIS",             "Översättning av Saga",              "Traducción por Efrén Glez. (GreyFurryWolf)"});
    strings.put("Weakness",                           new String[]{    "Faiblesse",                         "Svaghet",                           "Debilidad"});
    strings.put("Wizard",                             new String[]{    "Sorcier",                           "Trollkarl",                         "Mago"});
    strings.put("XP",                                 new String[]{    "XP",                                "Erfarenhet",                        "PX"});
    
    strings.put("?",                                  new String[]{    "?",                                 "?",                                 "?"});
  }
  
  static String get(String string){
    //println("REQUESTING TRANSLATION FOR: "+string);
    if(language == 0){
      return string;
    }
    try{
      String value = strings.get(string)[language-1];
      return value;
    } catch(ArrayIndexOutOfBoundsException e){
      if(string != "English"){
        println("WARNING !              THE KEY    "+string+"    HASN'T BEEN TRANSLATED YET TO   "+Trans.get("English"));
      } else{
        string = "WARNING. THIS IS NOT SUPPOSED TO HAPPEN.";
      }
      return string;
    } catch(NullPointerException e){
      //println(e + " FOR STRING "+string);
      return string;
    }
  }
  
  static void swap(){
    language++;
  }
  
  static void unswap(){
    language--;
  }
}